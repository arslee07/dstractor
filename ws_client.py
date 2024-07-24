# конвертер изображения из симулятора в rtsp поток
# для кодирования используется ffmpeg
# медиа-сервер mediamtx

import cv2 as cv
import websockets.sync.client
import numpy as np
import subprocess

ffmpeg_cmd = [
    "ffmpeg",
    "-hwaccel", "qsv",
    "-f", "rawvideo",
    "-pix_fmt", "bgr24",
    "-s", "640x480",
    "-r", "30",
    "-i", "-",
    "-c:v", "h264_qsv",
    "-preset", "veryfast",
    # "-tune", "zerolatency",
    # "-crf", "10",
    "-b:v", "2000k",
    "-g", "1",
    "-fflags", "nobuffer",
    "-flags", "low_delay",
    "-rtbufsize", "100M",
    "-f", "rtsp",
    "rtsp://localhost:7040/cam"
]

ffmpeg_process = subprocess.Popen(ffmpeg_cmd, stdin=subprocess.PIPE)

ws = websockets.sync.client.connect("ws://localhost:9080", max_size=8*1024*1024)
print("connected")

try:
    for msg in ws:
        data = bytes(msg)
        frame_data = np.frombuffer(data[8:], np.uint8).reshape(480, 640, 3)
        frame_data = cv.cvtColor(frame_data, cv.COLOR_RGB2BGR)

        ffmpeg_process.stdin.write(frame_data.tobytes())
except KeyboardInterrupt:
    pass
finally:
    ws.close()
    ffmpeg_process.stdin.close()
    ffmpeg_process.wait()

