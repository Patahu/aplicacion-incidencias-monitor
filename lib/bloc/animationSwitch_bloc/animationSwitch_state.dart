import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AnimationSwitchState {
  final bool isPendiente;
  final bool isCamino;
  final bool isRealizado;
  AnimationSwitchState( {required this.isPendiente, required this.isCamino,required this.isRealizado});

  // - Pagina de buscar tiendas
  factory AnimationSwitchState.Pendiente() {
    return AnimationSwitchState(isRealizado:false,isPendiente: true, isCamino: false);
  }

  // -Pagina de buscar tiendas en el mapa
  factory AnimationSwitchState.Camino() {
    return AnimationSwitchState(isRealizado:false,isPendiente: false, isCamino: true);
  }


  // -Pagina de buscar tiendas en el mapa
  factory AnimationSwitchState.Realizado() {
    return AnimationSwitchState(isRealizado:true,isPendiente: false, isCamino: false);
  }

  @override
  String toString() {
    return '''
      isRealizado: $isRealizado,
      isCamino: $isCamino,
      isRealizado: $isRealizado,
    ''';
  }
}
