import 'package:dstractor_panel/dashboard/dashboard.dart';
import 'package:dstractor_panel/setup/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetupView extends StatelessWidget {
  SetupView({super.key});

  final videoController =
      TextEditingController(text: "rtsp://192.168.1.102:7040/h264_ulaw.sdp");
  final telemetryController =
      TextEditingController(text: "ws://192.168.1.103:7041");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Настройка",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                BlocBuilder<SetupCubit, SetupState>(
                  builder: (context, state) {
                    final cubit = context.read<SetupCubit>();
                    return TextField(
                      controller: videoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "URL видеопотока",
                      ),
                      onChanged: cubit.setCameraAddress,
                    );
                  },
                ),
                const SizedBox(height: 8),
                BlocBuilder<SetupCubit, SetupState>(
                  builder: (context, state) {
                    final cubit = context.read<SetupCubit>();
                    return TextField(
                      controller: telemetryController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "URL телеметрии",
                      ),
                      onChanged: cubit.setTelemetryAddress,
                    );
                  },
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: context.read<SetupCubit>(),
                          child: const DashboardView(),
                        ),
                      ),
                    );
                  },
                  child: const Text("Продолжить"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
