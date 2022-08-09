import 'dart:async';

import 'package:aplicacion_inicidentes_monitor/util/usuarioDenunciante.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_map_windows/google_map_windows.dart';

import '../bloc/incident_bloc/bloc.dart';
import '../util/incident.dart';
import 'themas.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MapScreen extends StatefulWidget {
  final Incidentes incidenteElegido;
  final UsuarioDenunciante usuarioDenunciante;
  MapScreen(
      {Key? key,
      required this.incidenteElegido,
      required this.usuarioDenunciante})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MapScreen> {
  Incidentes _cindenteElegido = Incidentes();
  Incidentes get incidenteEx => widget.incidenteElegido;
  UsuarioDenunciante get _UsuarioDenun => widget.usuarioDenunciante;

  TextEditingController estadoIncidente = TextEditingController();
  @override
  void initState() {
    _cindenteElegido = incidenteEx;
    estadoIncidente.text = widget.incidenteElegido.estado!;

    super.initState();
  }

  Future<TimeOfDay?> _verTiempo(BuildContext context) async {
    TimeOfDay? ltTimePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        helpText: 'Calendario',
        cancelText: 'Cancelar',
        confirmText: 'INGRESAR',
        hourLabelText: 'Hora',
        minuteLabelText: 'Minuto');
    return ltTimePicked;
  }

  Future<void> _verFecha(BuildContext context) async {
    final ldDatePicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      helpText: 'Calendario',
      cancelText: 'Cancelar',
      confirmText: 'SIGUIENTE',
      fieldLabelText: 'Fecha',
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendar,
    );
    TimeOfDay? horas;
    if (ldDatePicked != null) {
      horas = await _verTiempo(context);
    }

    if (ldDatePicked != null && horas != null) {
      final DataFinal = DateTime(ldDatePicked.year, ldDatePicked.month,
          ldDatePicked.day, horas.hour, horas.minute, horas.minute);
      _cindenteElegido.seFechaR = DataFinal;
      BlocProvider.of<IncidenciasBloc>(context)
          .add(changeStateIncidentViewUnit('Realizado', DataFinal));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3B324E),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.95,
          constraints: const BoxConstraints(
              maxWidth: 1300, maxHeight: 950, minHeight: 300),
          child: Wrap(
            direction: Axis.horizontal,
            children: [
              BlocBuilder<IncidenciasBloc, IncidentViewState>(
                  builder: (context, state) {
                if (state.isLoadingMapa) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 520,
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return _mapa(state.windowsMap!);
              }),
              const SizedBox(width: 2),
              BlocConsumer<IncidenciasBloc, IncidentViewState>(
                listener: (context, state) {
                  if (state.incidenteElegido.idIncidente != null) {
                    print(state.incidenteElegido);
                    _cindenteElegido = state.incidenteElegido;
                    estadoIncidente.text = _cindenteElegido.estado!;
                  }
                },
                builder: (context, state) {
                  if (state.incidenteElegido.estado != null) {
                    return _resto();
                  }
                  return Container(
                      height: MediaQuery.of(context).size.height * .95,
                      width: MediaQuery.of(context).size.width * .3,
                      constraints:
                          const BoxConstraints(maxWidth: 600, minWidth: 70),
                      child: Center(child: CircularProgressIndicator()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mapa(WindowsMap ww) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.95,
        width: MediaQuery.of(context).size.width * .5,
        constraints: const BoxConstraints(
            maxWidth: 750, minWidth: 500, minHeight: 500, maxHeight: 900),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              offset: const Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 20.0,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  width: MediaQuery.of(context).size.width * .4,
                  constraints: const BoxConstraints(
                      maxWidth: 900,
                      minWidth: 500,
                      minHeight: 400,
                      maxHeight: 650),
                  child: ww,
                ),
                Container(
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff14DAE2), // background

                        // foreground
                      ),
                      onPressed: () {
                        BlocProvider.of<IncidenciasBloc>(context)
                            .add(changeRestartViewUnit());
                      },
                      child: const Text(
                        'Volver',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 0.27,
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resto() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * .95,
        width: MediaQuery.of(context).size.width > 980
            ? MediaQuery.of(context).size.width * .4
            : MediaQuery.of(context).size.width * .33,
        constraints: const BoxConstraints(maxWidth: 500, minWidth: 50),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color.fromARGB(66, 23, 21, 21),
                    offset: const Offset(0.0, 0.0),
                  ),
                ],
              ),
              child: Column(children: [
                Container(
                  child: const Text(
                    "DETALLES",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff14DAE2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Ingresado: ',
                        style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          color: Color(0xff14DAE2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${_cindenteElegido.fecha!.year}-${_cindenteElegido.fecha!.month}-${_cindenteElegido.fecha!.day}',
                          style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Estado: ',
                        style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          color: Color(0xff14DAE2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: estadoIncidente,
                          style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Wrap(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(10))),
                      onPressed: () {
                        final tiempo = DateTime.now();
                        BlocProvider.of<IncidenciasBloc>(context).add(
                            changeStateIncidentViewUnit('Pendiente', tiempo));
                      },
                      child: Column(
                        children: [
                          Text('Pendiente'),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Color.fromARGB(255, 2, 177, 8)
                                      .withOpacity(0.9),
                                  offset: const Offset(0.0, 0.0),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
                              child: AspectRatio(
                                aspectRatio: 1.28,
                                child: Image.asset('assets/Pendiente.png'),
                              ),
                            ),
                          ),
                          Text(
                            'Fecha: ${_cindenteElegido.fecha!.year}/${_cindenteElegido.fecha!.month}/${_cindenteElegido.fecha!.day}',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          ),
                          Text(
                            'Hora: ${_cindenteElegido.fecha!.hour}:${_cindenteElegido.fecha!.minute}:${_cindenteElegido.fecha!.second}',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 130,
                      width: 58,
                      padding: EdgeInsets.all(10),
                      child: (estadoIncidente.text == 'En camino' ||
                              estadoIncidente.text == 'Realizado')
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  IconData(0xf6f1, fontFamily: 'MaterialIcons'),
                                  color: Color.fromARGB(255, 2, 177, 8),
                                  size: 35.0,
                                ),
                                Text(
                                  '${_cindenteElegido.fechaE!.difference(_cindenteElegido.fecha!).inMinutes} Min',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white),
                                )
                              ],
                            )
                          : Container(
                              width: 10,
                            ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(10))),
                      onPressed: () {
                        final tiempo = DateTime.now();
                        BlocProvider.of<IncidenciasBloc>(context).add(
                            changeStateIncidentViewUnit('En camino', tiempo));
                        _cindenteElegido.seFechaE = tiempo;
                      },
                      child: Column(
                        children: [
                          Text('En proceso'),
                          Container(
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: estadoIncidente.text ==
                                                'En camino' ||
                                            estadoIncidente.text == 'Realizado'
                                        ? Color.fromARGB(255, 2, 177, 8)
                                        : Colors.white.withOpacity(0.8),
                                    offset: const Offset(0.0, 0.0),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                child: AspectRatio(
                                  aspectRatio: 1.28,
                                  child: Image.asset('assets/En_camino.png'),
                                ),
                              ),
                            ),
                          ),
                          _cindenteElegido.fechaE == null
                              ? Column(
                                  children: [
                                    Text(
                                      'Hora: -',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Text(
                                      'Fecha: ${_cindenteElegido.fechaE!.year}/${_cindenteElegido.fechaE!.month}/${_cindenteElegido.fechaE!.day}',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'Hora: ${_cindenteElegido.fechaE!.hour}:${_cindenteElegido.fechaE!.minute}:${_cindenteElegido.fechaE!.second}',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 58,
                      child: estadoIncidente.text == 'Realizado'
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  IconData(0xf6f1, fontFamily: 'MaterialIcons'),
                                  color: Color.fromARGB(255, 2, 177, 8),
                                  size: 35.0,
                                ),
                                Text(
                                  '${_cindenteElegido.fechaR!.difference(_cindenteElegido.fechaE!).inMinutes} Min',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white),
                                )
                              ],
                            )
                          : Container(
                              width: 10,
                            ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(10))),
                      onPressed: () {
                        final tiempo = DateTime.now();
                        print('jsssssssssssssssssssssssssssssss');

                        if (_cindenteElegido.estado == 'En camino') {
                          _verFecha(context);
                        }
                      },
                      child: Column(
                        children: [
                          Text('Atendido'),
                          Container(
                              child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: estadoIncidente.text == 'Realizado'
                                      ? Color.fromARGB(255, 2, 177, 8)
                                      : Colors.white.withOpacity(0.8),
                                  offset: const Offset(0.0, 0.0),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
                              child: AspectRatio(
                                aspectRatio: 1.28,
                                child: Image.asset('assets/Realizado.png'),
                              ),
                            ),
                          )),
                          _cindenteElegido.fechaR == null
                              ? Column(
                                  children: [
                                    Text(
                                      'Hora: -',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Text(
                                      'Fecha: ${_cindenteElegido.fechaR!.year}/${_cindenteElegido.fechaR!.month}/${_cindenteElegido.fechaR!.day}',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'Hora: ${_cindenteElegido.fechaR!.hour}:${_cindenteElegido.fechaR!.minute}:${_cindenteElegido.fechaR!.second}',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Tipo: ',
                        style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          color: Color(0xff14DAE2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${_cindenteElegido.tipo}',
                          style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Descripción: ',
                        style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          color: Color(0xff14DAE2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${_cindenteElegido.descripcion}',
                          style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      const Text(
                        'ID: ',
                        style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          color: Color(0xff14DAE2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${_cindenteElegido.idIncidente}',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color.fromARGB(66, 23, 21, 21),
                    offset: const Offset(0.0, 0.0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    child: const Text(
                      "USUARIO",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff14DAE2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      children: [
                        const Text(
                          'Nombre: ',
                          style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            color: Color(0xff14DAE2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${_UsuarioDenun.nombre}',
                            style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      children: [
                        const Text(
                          'DNI: ',
                          style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            color: Color(0xff14DAE2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${_UsuarioDenun.dni}',
                            style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      children: [
                        const Text(
                          'Correo: ',
                          style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            color: Color(0xff14DAE2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${_UsuarioDenun.correo}',
                            style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      children: [
                        const Text(
                          'Celular: ',
                          style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            color: Color(0xff14DAE2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${_UsuarioDenun.numero}',
                            style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _cindenteElegido.fotos!.length == 0
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                        child: FloatingActionButton(
                          onPressed: () {
                            BlocProvider.of<IncidenciasBloc>(context)
                                .add(changePhotosViewUnit());
                          },
                          heroTag: 'image1',
                          tooltip: 'Fotos',
                          child: const Icon(Icons.photo_library),
                        ),
                      ),
                _cindenteElegido.video == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: FloatingActionButton(
                          backgroundColor: Colors.red,
                          onPressed: () {
                            //changeVideosPhotoViewUnit
                            BlocProvider.of<IncidenciasBloc>(context)
                                .add(changeVideoViewUnit());
                          },
                          heroTag: 'video0',
                          tooltip: 'Videos',
                          child: const Icon(Icons.video_library),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
