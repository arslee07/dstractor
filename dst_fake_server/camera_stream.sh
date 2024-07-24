gst-launch-1.0 \
    videotestsrc \
    ! videoconvert \
    ! videoscale \
    ! videorate \
    ! video/x-raw,width=640,height=480,framerate=30/1 \
    ! x264enc speed-preset=ultrafast tune=zerolatency key-int-max=10 bitrate=800 \
    ! rtspclientsink location=rtsp://localhost:7040/cam
