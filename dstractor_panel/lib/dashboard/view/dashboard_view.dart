import 'package:dstractor_panel/actions/actions.dart';
import 'package:dstractor_panel/telemetry/telemetry.dart';
import 'package:dstractor_panel/video/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: Card.filled(
                    child: BlocProvider(
                      create: (context) => TelemetryBloc(),
                      child: const TelemetryView(),
                    ),
                  ),
                ),
                const Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Card.filled(
                    child: ActionsView(),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 7,
            child: Card.filled(
              clipBehavior: Clip.hardEdge,
              child: VideoView(),
            ),
          ),
        ],
      ),
    );
  }
}
