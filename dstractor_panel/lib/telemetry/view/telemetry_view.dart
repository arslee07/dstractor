import 'dart:async';
import 'dart:math';

import 'package:dstractor_panel/setup/setup.dart';
import 'package:dstractor_panel/telemetry/telemetry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:xinput_gamepad/xinput_gamepad.dart';

class TelemetryView extends StatefulWidget {
  const TelemetryView({
    super.key,
  });

  @override
  State<TelemetryView> createState() => _TelemetryViewState();
}

class _TelemetryViewState extends State<TelemetryView> {
  late final StreamSubscription gamepadsSub;

  int w = 0, a = 0, s = 0, d = 0;

  @override
  void initState() {
    final address = context.read<SetupCubit>().state.telemetryAddress;

    final bloc = context.read<TelemetryBloc>();
    bloc.add(TelemetryConnect(address: address));

    HardwareKeyboard.instance.addHandler((event) {
      if (event is KeyUpEvent) {
        switch (event.logicalKey) {
          case LogicalKeyboardKey.keyW:
            w = 0;
            break;
          case LogicalKeyboardKey.keyA:
            a = 0;
            break;
          case LogicalKeyboardKey.keyS:
            s = 0;
            break;
          case LogicalKeyboardKey.keyD:
            d = 0;
            break;
        }
      }

      if (event is KeyDownEvent) {
        switch (event.logicalKey) {
          case LogicalKeyboardKey.keyW:
            w = 1;
            break;
          case LogicalKeyboardKey.keyA:
            a = 1;
            break;
          case LogicalKeyboardKey.keyS:
            s = 1;
            break;
          case LogicalKeyboardKey.keyD:
            d = 1;
            break;
        }
      }

      if ([
            LogicalKeyboardKey.keyA,
            LogicalKeyboardKey.keyS,
            LogicalKeyboardKey.keyD,
            LogicalKeyboardKey.keyW
          ].contains(event.logicalKey) &&
          (event is KeyUpEvent || event is KeyDownEvent)) {
        int x = d - a;
        int y = w - s;

        int left = y + x;
        int right = y - x;

        left = max(-1, min(1, left));
        right = max(-1, min(1, right));

        left *= 64;
        right *= 64;

        bloc.add(TelemetrySend(left: left, right: right));
      }

      return true;
    });

    super.initState();
  }

  @override
  void dispose() {
    gamepadsSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Телеметрия",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        BlocBuilder<TelemetryBloc, TelemetryState>(
          builder: (context, state) {
            return switch (state) {
              TelemetryInitial() => const SizedBox(),
              TelemetryLoading() =>
                const Center(child: CircularProgressIndicator()),
              TelemetryData(
                internalTemperature: var internalTemperature,
                externalTemperature: var externalTemperature,
                voltage: var voltage,
                lat: var lat,
                lon: var lon,
              ) =>
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.device_thermostat),
                      title: const Text("Внешняя температура"),
                      subtitle: Text("$externalTemperature °C"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.device_thermostat),
                      title: const Text("Внутренняя температура"),
                      subtitle: Text("$internalTemperature °C"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.bolt),
                      title: const Text("Выходное напряжение"),
                      subtitle: Text("$voltage В"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.gps_fixed),
                      title: const Text("Широта"),
                      subtitle: Text("$lat°"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.gps_fixed),
                      title: const Text("Долгота"),
                      subtitle: Text("$lon°"),
                    ),
                  ],
                ),
            };
          },
        ),
      ],
    );
  }
}
