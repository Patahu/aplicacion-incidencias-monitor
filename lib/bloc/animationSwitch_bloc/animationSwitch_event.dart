import 'package:equatable/equatable.dart';

abstract class AnimationSwitchEvent extends Equatable {
  const AnimationSwitchEvent();
  @override
  List<Object> get props => [];
}

// - Cambiar a buscar Tiendas
class reportarPage extends AnimationSwitchEvent {}

// - Cambiar a localizar tiendas
class BuscarChat extends AnimationSwitchEvent {}

// - Cambiar a localizar tiendas
class BuscarPerfil extends AnimationSwitchEvent {}


