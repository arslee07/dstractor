import 'package:dstractor_panel/setup/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();

    final native = player.platform as NativePlayer;
    native
      ..setProperty('profile', 'low-latency')
      ..setProperty('video-latency-hacks', 'yes')
      ..setProperty('audio-buffer', '0')
      ..setProperty('untimed', '')
      ..setProperty('audio', 'no'); // зависает после первого кадра если с аудио :)

    final url = context.read<SetupCubit>().state.cameraAddress;
    player.open(Media(url));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Video(
      controller: controller,
      controls: null,
    );
  }
}
