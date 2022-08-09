import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:table_calendar/table_calendar.dart';

import 'bloc/animationSwitch_bloc/animationSwitch_bloc.dart';
import 'bloc/incident_bloc/bloc.dart';
import 'bloc/incident_bloc/simple_bloc_delegate.dart';
import 'repository/data_base_incidents.dart';
import 'ui/calendario.dart';
import 'ui/homeScreen.dart';

import 'ui/isPhotoPlayer.dart';
import 'ui/isVideoPlayer.dart';
import 'ui/loading.dart';
import 'ui/mapScreenEstado.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  final DataBaseIncident databaseIncidentes = DataBaseIncident();
  if (Platform.isWindows) {
    setWindowMaxSize(const Size(1700, 1100));

    setWindowMinSize(const Size(900, 800));
  }
  initializeDateFormatting().then((_) => runApp((MultiBlocProvider(
        providers: [
          BlocProvider<IncidenciasBloc>(
            create: (BuildContext context) =>
                IncidenciasBloc(dataBaseIncident: databaseIncidentes)
                  ..add(BuscarIncidentesEvent()),
          ),
          BlocProvider<AnimationSwitchBloc>(
            create: (BuildContext context) => AnimationSwitchBloc(),
          ),
        ],
        child: App(
          databaseIncidentes: databaseIncidentes,
          key: null,
        ),
      ))));
}

class App extends StatelessWidget {
  final DataBaseIncident _databaseIncidentes;

  int _anterior = 0;
  App({Key? key, required DataBaseIncident databaseIncidentes})
      : _databaseIncidentes = databaseIncidentes,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocConsumer<IncidenciasBloc, IncidentViewState>(
        listener: (context, state) {
          bool refres = (_anterior < state.incidentesPendientes!.length &&
              state.isNewIncident);
          if (refres) {
            FlutterPlatformAlert.playAlertSound();
            ScaffoldMessenger.of(context)
              // ignore: deprecated_member_use
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Incidentes nuevos: ${state.incidentesPendientes!.length}"),
                      Icon(Icons.error)
                    ],
                  ),
                  backgroundColor: Colors.green,
                ),
              );
          }
          _anterior = state.incidentesPendientes!.length;
        },
        builder: (context, state) {
          if (state.isInitial) {
            return HomeScreen();
          } else if (state.isUnitIncident) {
            return MapScreen(
              incidenteElegido: state.incidenteElegido,
              usuarioDenunciante: state.usuarioDenunciante,
            );
          } else if (state.isVideoVer) {
            return videoView(
              incidenteElegido: state.incidenteElegido,
            );
          } else if (state.isLoading) {
            return Loading();
          } else if (state.isPhotoVer) {
            var url = '';
            if (state.incidenteElegido.fotos!.isNotEmpty) {
              url = state.incidenteElegido.fotos![state.indexPhoto];
            }
            return photoView(
              urlFoto: url,
            );
          } else if (state.isCalendar) {
            return calendarioVer();
          }
          return Container(color: Colors.white);
        },
      ),
    );
  }
}
