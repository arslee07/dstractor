part of 'telemetry_bloc.dart';

@immutable
sealed class TelemetryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class TelemetryConnect extends TelemetryEvent {
  final String address;

  TelemetryConnect({required this.address});

  @override
  List<Object?> get props => [address];
}

final class TelemetrySend extends TelemetryEvent {
  final int left;
  final int right;

  TelemetrySend({required this.left, required this.right});

  @override
  List<Object?> get props => [left, right];
}