







import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';


class AnimationSwitchBloc extends Bloc<AnimationSwitchEvent,AnimationSwitchState>{
  AnimationSwitchBloc(): super(AnimationSwitchState.Pendiente());
  @override
  AnimationSwitchState get  initialState => AnimationSwitchState.Pendiente();

  @override
  Stream<AnimationSwitchState> mapEventToState(AnimationSwitchEvent event) async*{
    if(event is reportarPage){
      yield AnimationSwitchState.Pendiente();
    }
    if(event is BuscarChat){
      yield AnimationSwitchState.Camino();
    }if(event is BuscarPerfil){
      yield AnimationSwitchState.Realizado();
    }
  }
}