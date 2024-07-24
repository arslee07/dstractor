part of 'gamepad_bloc.dart';

sealed class GamepadState extends Equatable {
  const GamepadState();
  
  @override
  List<Object> get props => [];
}

final class GamepadInitial extends GamepadState {}
