import 'package:dstractor_panel/intents.dart';
import 'package:dstractor_panel/setup/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:xinput_gamepad/xinput_gamepad.dart';

void main() {
  XInputManager.enableXInput();
  MediaKit.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetupCubit(),
      child: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.keyW): ForwardIntent(),
          SingleActivator(LogicalKeyboardKey.keyA): LeftIntent(),
          SingleActivator(LogicalKeyboardKey.keyS): BackIntent(),
          SingleActivator(LogicalKeyboardKey.keyD): RightIntent(),
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SetupView(),
        ),
      ),
    );
  }
}
