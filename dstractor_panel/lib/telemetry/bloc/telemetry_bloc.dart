import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'telemetry_event.dart';
part 'telemetry_state.dart';

class TelemetryBloc extends Bloc<TelemetryEvent, TelemetryState> {
  late WebSocketChannel chan;

  TelemetryBloc() : super(TelemetryInitial()) {
    on<TelemetryConnect>(onConnect);
    on<TelemetrySend>(onSend);
  }

  Future<void> onSend(TelemetrySend event, Emitter<TelemetryState> emit) async {
    if (state is! TelemetryData) return;

    final json = jsonEncode({"left": event.left, "right": event.right});
    print(json);
    chan.sink.add(json);
  }

  Future<void> onConnect(
      TelemetryConnect event, Emitter<TelemetryState> emit) async {
    while (true) {
      emit(TelemetryLoading());

      chan = WebSocketChannel.connect(Uri.parse(event.address));

      try {
        await chan.ready;
      } on WebSocketChannelException {
        await Future.delayed(const Duration(seconds: 2));
        continue;
      }

      await chan.stream.listen((data) {
        final value = jsonDecode(data);
        final state = TelemetryData(
          internalTemperature: 0.0 + value["internal_temperature"],
          externalTemperature: 0.0 + value["external_temperature"],
          voltage: 0.0 + value["voltage"],
          lat: 0.0 + value["lat"],
          lon: 0.0 + value["lon"],
        );

        emit(state);
      }).asFuture();
    }
  }
}
