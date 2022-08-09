import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_map_windows/google_map_windows.dart';

import '../../repository/data_base_incidents.dart';
import '../../ui/mapScreenEstado.dart';
import '../../util/incident.dart';
import 'bloc.dart';

class IncidenciasBloc extends Bloc<incidentViewEvent, IncidentViewState> {
  final DataBaseIncident _dataBaseIncident;
  StreamSubscription? _incidentSubscripcion1 = null;
  StreamSubscription? _incidentSubscripcion2 = null;
  StreamSubscription? _incidentSubscripcion3 = null;
  StreamSubscription? _incidentSubscripcion4 = null;
  StreamSubscription? _incidentSubscripcion5 = null;
  DateTime _fechaBuscar = DateTime.now();
  int _contadorFotos = 0;
  IncidenciasBloc({required DataBaseIncident dataBaseIncident})
      : _dataBaseIncident = dataBaseIncident,
        super(IncidentViewState.empty());

  IncidentViewState get initialState => IncidentViewState.empty();
  @override
  void dispose() {
    if (_incidentSubscripcion1 != null) {
      _incidentSubscripcion1!.cancel();
    }
    if (_incidentSubscripcion2 != null) {
      _incidentSubscripcion1!.cancel();
    }
    if (_incidentSubscripcion3 != null) {
      _incidentSubscripcion1!.cancel();
    }
  }

  @override
  Stream<IncidentViewState> mapEventToState(incidentViewEvent event) async* {
    if (event is BuscarIncidentesEvent) {
      if (_incidentSubscripcion1 != null) {
        _incidentSubscripcion1!.cancel();
      }

      _incidentSubscripcion1 =
          _dataBaseIncident.datosIncidentesPendientes().listen((incidentes) {
        add(updateIncidentesEventPendiente(incidentes));
      });

      if (_incidentSubscripcion2 != null) {
        _incidentSubscripcion2!.cancel();
      }
      _incidentSubscripcion2 =
          _dataBaseIncident.datosIncidentesEnCamino().listen((incidentes) {
        add(updateIncidentesEventEnCamino(incidentes));
      });

      if (_incidentSubscripcion3 != null) {
        _incidentSubscripcion3!.cancel();
      }
      _incidentSubscripcion3 =
          _dataBaseIncident.datosIncidentesRealizados().listen((incidentes) {
        add(
          updateIncidentesEventRealizados(incidentes),
        );
      });
    } else if (event is updateIncidentesEventPendiente) {
      yield state.update(
          isNewIncident: true, incidentesPendientes: event.incidentes);
    } else if (event is updateIncidentesEventEnCamino) {
      yield state.update(
          isNewIncident: true, incidentesEnCamino: event.incidentes);
    } else if (event is updateIncidentesEventRealizados) {
      yield state.update(
          isNewIncident: true, incidentesRealizados: event.incidentes);
    } else if (event is changeIncidentViewUnit) {
      final usuarioDenunci =
          await _dataBaseIncident.consultaUsuario(event.incidente.idUsuario!);

      yield state.update(
        isNewIncident: false,
        isInitial: false,
        isUnitIncident: true,
        incidenteElegido: event.incidente,
        usuarioDenunciante: usuarioDenunci,
      );
      add(cargarMapa(event.incidente));
      if (_incidentSubscripcion5 != null) {
        _incidentSubscripcion5!.cancel();
      }
      _incidentSubscripcion5 = _dataBaseIncident
          .consultaIncidente(event.incidente.idIncidente!)
          .listen((Incidencia) {
        print(
            'aqui--------------------------*******************************************');
        add(cambioIncidente(Incidencia));
      });
    } else if (event is changeRestartViewUnit) {
      yield state.update(
        isNewIncident: true,
        isInitial: true,
        isUnitIncident: false,
        incidenteElegido: Incidentes(),
      );
    } else if (event is changeRestartTwoViewUnit) {
      yield state.update(
        isVideoVer: false,
        isUnitIncident: true,
        isPhotoVer: false,
      );
      add(cargarMapa(state.incidenteElegido));
    } else if (event is changeStateIncidentViewUnit) {
      final kos = state.incidenteElegido;
      kos.seEstado = event.estado;
      state.copyWith(incidenteElegido: kos);
      _dataBaseIncident.cambiarEstadoIncidente(
          state.incidenteElegido, event.estado, event.now);
    } else if (event is changeVideoViewUnit) {
      yield state.update(isVideoVer: true, isUnitIncident: false);
    } else if (event is changePhotosViewUnit) {
      yield state.update(
          isPhotoVer: true,
          isUnitIncident: false,
          isVideoVer: false,
          indexPhoto: _contadorFotos);
    } else if (event is nextPhotoViewUnit) {
      if (_contadorFotos + 1 < state.incidenteElegido.fotos!.length) {
        _contadorFotos++;
        yield state.copyWith(isLoading: true, isPhotoVer: false);
        await Future.delayed(Duration(seconds: 1));
        yield state.copyWith(
            isLoading: false, isPhotoVer: true, indexPhoto: _contadorFotos);
      }
    } else if (event is backPhotoViewUnit) {
      if ((_contadorFotos - 1) >= 0) {
        _contadorFotos--;
        yield state.copyWith(isLoading: true, isPhotoVer: false);
        await Future.delayed(const Duration(seconds: 1));
        yield state.copyWith(
            isLoading: false, isPhotoVer: true, indexPhoto: _contadorFotos);
      }
    } else if (event is cargarMapa) {
      final kGoogleApiKey = "AIzaSyC8AGcAapuVKTzwJiyrfP1G2-c_xRbzbCQ";
      yield state.copyWith(isLoadingMapa: true);
      final al_QudsLocation;
      final WindowsMapController mapController;
      al_QudsLocation = LatLng(
          lat: event.incidente.locationData!.latitude,
          lng: event.incidente.locationData!.longitude);

      mapController = WindowsMapController();
      mapController.initMap();
      mapController.apiKey = kGoogleApiKey;
      TextEditingController latController = TextEditingController(),
          lngController = TextEditingController(),
          estadoIncidente = TextEditingController();
      mapController.onCenterChanged = (LatLng center) {
        latController.text = center.lat.toString();
        lngController.text = center.lng.toString();
      };

      estadoIncidente.text = event.incidente.estado.toString();
      mapController.onMapInitialed = () {
        Marker marker =
            Marker(position: al_QudsLocation, title: 'lugar del incidente');
        mapController.addMarker(marker);
      };
      final ww = WindowsMap(
          controller: mapController, zoom: 20, center: al_QudsLocation);

      yield state.update(windowsMap: ww, isLoadingMapa: false);
    } else if (event is verCalendario) {
      yield state.update(
        isCalendar: true,
        isInitial: false,
      );
    } else if (event is ingresarDiaCalendario) {
      _fechaBuscar = event.tiempo1;
      yield state.update(tiempoBusqueda: event.tiempo1);
    } else if (event is buscarPorFecha) {
      if (_incidentSubscripcion4 != null) {
        _incidentSubscripcion4!.cancel();
      }
      _incidentSubscripcion4 = _dataBaseIncident
          .datosComandasFecha(_fechaBuscar)
          .listen((incidentes) {
        add(updateComandasFechas(incidentes));
      });
    } else if (event is updateComandasFechas) {
      yield state.update(
          fechaComandas: event.incidentes,
          isViewFechas: true,
          isInitial: true,
          isCalendar: false);
    } else if (event is volverAnteriorCalendario) {
      yield state.update(isInitial: true, isCalendar: false);
    } else if (event is insertTipoBusqueda) {
      if (event.tipo == 'Fecha') {
        yield state.update(isViewFechas: true);
      } else {
        yield state.update(isViewFechas: false);
      }
    } else if (event is cambioIncidente) {
      yield state.update(
          isNewIncident: false,
          isInitial: false,
          isUnitIncident: true,
          incidenteElegido: event.incidente);
    }
  }
}
