part of 'telemetry_bloc.dart';

@immutable
sealed class TelemetryState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class TelemetryInitial extends TelemetryState {}

final class TelemetryLoading extends TelemetryState {}

final class TelemetryData extends TelemetryState {
  final double internalTemperature;
  final double externalTemperature;
  final double voltage;
  final double lat;
  final double lon;

  TelemetryData({
    required this.internalTemperature,
    required this.externalTemperature,
    required this.voltage,
    required this.lat,
    required this.lon,
  });

  @override
  List<Object?> get props => [internalTemperature, externalTemperature, voltage, lat, lon];
}
