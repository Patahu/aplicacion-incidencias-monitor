import 'package:equatable/equatable.dart';

import '../../util/incident.dart';

abstract class incidentViewEvent extends Equatable {
  const incidentViewEvent();
  @override
  List<Object> get props => [];
}

class BuscarIncidentesEvent extends incidentViewEvent {}

class updateIncidentesEventPendiente extends incidentViewEvent {
  final List<Incidentes> incidentes;
  const updateIncidentesEventPendiente(this.incidentes);
  @override
  List<Object> get props => [incidentes];
}

class updateIncidentesEventEnCamino extends incidentViewEvent {
  final List<Incidentes> incidentes;
  const updateIncidentesEventEnCamino(this.incidentes);
  @override
  List<Object> get props => [incidentes];
}

class updateIncidentesEventRealizados extends incidentViewEvent {
  final List<Incidentes> incidentes;
  const updateIncidentesEventRealizados(this.incidentes);
  @override
  List<Object> get props => [incidentes];
}

class changeIncidentViewUnit extends incidentViewEvent {
  final Incidentes incidente;
  changeIncidentViewUnit(this.incidente);
  @override
  List<Object> get props => [incidente];
}

class nextPhotoViewUnit extends incidentViewEvent {}

class backPhotoViewUnit extends incidentViewEvent {}

class changeRestartViewUnit extends incidentViewEvent {}

class changeRestartTwoViewUnit extends incidentViewEvent {}

class changeVideoViewUnit extends incidentViewEvent {}

class changePhotosViewUnit extends incidentViewEvent {}

class cargarMapa extends incidentViewEvent {
  final Incidentes incidente;
  cargarMapa(this.incidente);
  @override
  List<Object> get props => [incidente];
}

class cambioIncidente extends incidentViewEvent {
  final Incidentes incidente;
  cambioIncidente(this.incidente);
  @override
  List<Object> get props => [incidente];
}

class updateComandasFechas extends incidentViewEvent {
  final List<Incidentes> incidentes;
  const updateComandasFechas(this.incidentes);
  @override
  List<Object> get props => [incidentes];
}

class buscarPorFecha extends incidentViewEvent {}

class verCalendario extends incidentViewEvent {}

class volverAnteriorCalendario extends incidentViewEvent {}

class insertTipoBusqueda extends incidentViewEvent {
  final String tipo;

  insertTipoBusqueda(this.tipo);
  @override
  List<Object> get props => [tipo];
  @override
  String toString() => 'tipoBusqueda {Busqueda: $tipo}';
}

class changeStateIncidentViewUnit extends incidentViewEvent {
  final String estado;
  final DateTime now;
  changeStateIncidentViewUnit(this.estado, this.now);
  @override
  List<Object> get props => [estado, now];
}

class ingresarDiaCalendario extends incidentViewEvent {
  final DateTime tiempo1;
  final DateTime tiempo2;
  ingresarDiaCalendario(this.tiempo1, this.tiempo2);
  @override
  List<Object> get props => [tiempo1, tiempo2];
  @override
  String toString() => 'tiempo {tiempo: ${tiempo1},${tiempo2}';
}
