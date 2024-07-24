import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'setup_state.dart';

class SetupCubit extends Cubit<SetupState> {
  SetupCubit()
      : super(const SetupState(
            cameraAddress: "rtsp://192.168.1.102:7040/h264_ulaw.sdp",
            telemetryAddress: "ws://192.168.1.103:7041"));

  void setCameraAddress(String newCameraAddress) {
    emit(SetupState(
      cameraAddress: newCameraAddress,
      telemetryAddress: state.telemetryAddress,
    ));
  }

  void setTelemetryAddress(String newTelemetryAddress) {
    emit(SetupState(
      cameraAddress: state.cameraAddress,
      telemetryAddress: newTelemetryAddress,
    ));
  }
}
