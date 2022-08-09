import 'package:aplicacion_inicidentes_monitor/util/usuarioDenunciante.dart';
import 'package:equatable/equatable.dart';
import 'package:google_map_windows/google_map_windows.dart';

import '../../util/incident.dart';

class IncidentViewState extends Equatable {
  final bool isNewIncident;
  final bool isInitial;
  final bool isUnitIncident;
  final List<Incidentes>? incidentesPendientes;
  final List<Incidentes>? incidentesEnCamino;
  final List<Incidentes>? incidentesRealizados;
  final List<Incidentes>? fechaComandas;
  final Incidentes incidenteElegido;
  final UsuarioDenunciante usuarioDenunciante;
  final bool isVideoVer;
  final bool isPhotoVer;
  final int indexPhoto;
  final bool isLoading;
  final bool isLoadingMapa;
  WindowsMap? windowsMap;
  final bool isCalendar;
  final bool isViewFechas;
  final DateTime tiempoBusqueda;
  IncidentViewState(
      {required this.isNewIncident,
      required this.incidentesPendientes,
      required this.isInitial,
      required this.isUnitIncident,
      required this.isVideoVer,
      required this.isPhotoVer,
      required this.incidenteElegido,
      required this.usuarioDenunciante,
      required this.incidentesEnCamino,
      required this.incidentesRealizados,
      required this.indexPhoto,
      required this.isLoading,
      required this.isCalendar,
      required this.isLoadingMapa,
      required this.windowsMap,
      required this.isViewFechas,
      required this.tiempoBusqueda,
      this.fechaComandas});

  factory IncidentViewState.empty() {
    return IncidentViewState(
      isNewIncident: false,
      incidentesPendientes: [],
      isInitial: true,
      isUnitIncident: false,
      isPhotoVer: false,
      isVideoVer: false,
      incidenteElegido: Incidentes(),
      incidentesEnCamino: [],
      incidentesRealizados: [],
      usuarioDenunciante: UsuarioDenunciante(),
      indexPhoto: 0,
      isLoading: false,
      isLoadingMapa: true,
      windowsMap: null,
      isViewFechas: false,
      isCalendar: false,
      tiempoBusqueda: DateTime.now(),
      fechaComandas: [],
    );
  }
  IncidentViewState UnitIncident() {
    return copyWith(
      isNewIncident: false,
      isInitial: false,
      isUnitIncident: true,
    );
  }

  IncidentViewState copyWith({
    bool? isNewIncident,
    bool? isInitial,
    bool? isUnitIncident,
    List<Incidentes>? incidentesPendientes,
    List<Incidentes>? incidentesEnCamino,
    List<Incidentes>? incidentesRealizados,
    Incidentes? incidenteElegido,
    UsuarioDenunciante? usuarioDenunciante,
    bool? isPhotoVer,
    bool? isVideoVer,
    int? indexPhoto,
    bool? isLoading,
    bool? isLoadingMapa,
    bool? isCalendar,
    WindowsMap? windowsMap,
    bool? isViewFechas,
    DateTime? tiempoBusqueda,
    List<Incidentes>? fechaComandas,
  }) {
    return IncidentViewState(
      isNewIncident: isNewIncident ?? this.isNewIncident,
      incidentesPendientes: incidentesPendientes ?? this.incidentesPendientes,
      incidentesEnCamino: incidentesEnCamino ?? this.incidentesEnCamino,
      incidentesRealizados: incidentesRealizados ?? this.incidentesRealizados,
      isInitial: isInitial ?? this.isInitial,
      isUnitIncident: isUnitIncident ?? this.isUnitIncident,
      incidenteElegido: incidenteElegido ?? this.incidenteElegido,
      usuarioDenunciante: usuarioDenunciante ?? this.usuarioDenunciante,
      isPhotoVer: isPhotoVer ?? this.isPhotoVer,
      isVideoVer: isVideoVer ?? this.isVideoVer,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMapa: isLoadingMapa ?? this.isLoadingMapa,
      indexPhoto: indexPhoto ?? this.indexPhoto,
      windowsMap: windowsMap ?? this.windowsMap,
      isCalendar: isCalendar ?? this.isCalendar,
      isViewFechas: isViewFechas ?? this.isViewFechas,
      tiempoBusqueda: tiempoBusqueda ?? this.tiempoBusqueda,
      fechaComandas: fechaComandas ?? this.fechaComandas,
    );
  }

  IncidentViewState update({
    bool? isNewIncident,
    List<Incidentes>? incidentesPendientes,
    List<Incidentes>? incidentesEnCamino,
    List<Incidentes>? incidentesRealizados,
    bool? isInitial,
    bool? isUnitIncident,
    Incidentes? incidenteElegido,
    UsuarioDenunciante? usuarioDenunciante,
    bool? isPhotoVer,
    bool? isVideoVer,
    bool? isLoading,
    bool? isLoadingMapa,
    int? indexPhoto,
    WindowsMap? windowsMap,
    bool? isCalendar,
    bool? isViewFechas,
    DateTime? tiempoBusqueda,
    List<Incidentes>? fechaComandas,
  }) {
    return copyWith(
      isNewIncident: isNewIncident,
      incidentesPendientes: incidentesPendientes,
      isInitial: isInitial,
      isUnitIncident: isUnitIncident,
      incidentesEnCamino: incidentesEnCamino,
      incidentesRealizados: incidentesRealizados,
      incidenteElegido: incidenteElegido,
      usuarioDenunciante: usuarioDenunciante,
      isPhotoVer: isPhotoVer,
      isVideoVer: isVideoVer,
      isLoadingMapa: isLoadingMapa ?? this.isLoadingMapa,
      isLoading: isLoading ?? this.isLoading,
      indexPhoto: indexPhoto ?? this.indexPhoto,
      windowsMap: windowsMap ?? this.windowsMap,
      isCalendar: isCalendar ?? this.isCalendar,
      isViewFechas: isViewFechas ?? this.isViewFechas,
      tiempoBusqueda: tiempoBusqueda ?? this.tiempoBusqueda,
      fechaComandas: fechaComandas ?? this.fechaComandas,
    );
  }

  @override
  String toString() {
    return '''
            isNewMesssaging ,$isNewIncident,
            isInitial ,$isInitial,
            isPhotoVer ,$isPhotoVer,
            isVideoVer ,$isVideoVer,
            isUnitIncident: ,$isUnitIncident,
            lista Incidentes Pendientes: ${incidentesPendientes?.length},
            lista Incidentes enCamino: ${incidentesEnCamino?.length},
            lista Incidentes Realizados: ${incidentesRealizados?.length},
            lista Incidentes Realizados fechas: ${fechaComandas?.length},
            incidenteElegido:${incidenteElegido.idIncidente},
            
            usuarioDenunciante:${usuarioDenunciante.nombre}
             indexPhoto:${indexPhoto},
             isLoading:${isLoading}
             isLoadingMapa:${isLoadingMapa}
             isCalendar:${isCalendar},
             isViewFechas:${isViewFechas},
             fecha:${tiempoBusqueda}

''';
  }

  @override
  List<Object?> get props => [
        incidentesPendientes?.length,
        incidentesEnCamino?.length,
        incidentesRealizados?.length,
        fechaComandas?.length,
        isNewIncident,
        isInitial,
        isPhotoVer,
        isVideoVer,
        isUnitIncident,
        isLoading,
        indexPhoto,
        incidenteElegido.idIncidente,
        usuarioDenunciante.nombre,
        isLoadingMapa,
        isCalendar,
        isViewFechas,
        tiempoBusqueda
      ];
}
