part of 'setup_cubit.dart';

final class SetupState extends Equatable {
  final String cameraAddress;
  final String telemetryAddress;

  const SetupState({
    required this.cameraAddress,
    required this.telemetryAddress,
  });

  @override
  List<Object> get props => [cameraAddress, telemetryAddress];
}
