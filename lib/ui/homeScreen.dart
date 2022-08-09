import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/simple_hidden_drawer.dart';
import '../bloc/animationSwitch_bloc/bloc.dart';
import '../bloc/incident_bloc/bloc.dart';
import '../util/incident.dart';
import 'mapScreenEstado.dart';
import 'menuView.dart';
import 'themas.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomeScreen extends StatelessWidget {
  var _selectedDay;
  var _focusedDay;
  Color _elejirColor(String tipo) {
    if (tipo == 'Pendiente') {
      return DesignCourseAppTheme.grey;
    } else if (tipo == 'En camino') {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IncidenciasBloc, IncidentViewState>(
      listener: (context, state) {
        if (state.isUnitIncident) {}
      },
      builder: (context, state) {
        if (state.isNewIncident) {
          return SimpleHiddenDrawer(
              slidePercent: 20.0,
              verticalScalePercent: 100.0,
              contentCornerRadius: 3.0,
              menu: Menu(),
              screenSelectedBuilder: (position, controller) {
                return Scaffold(
                  backgroundColor: Color(0xfff3B324E),
                  appBar: AppBar(
                    backgroundColor: Color.fromARGB(255, 24, 40, 72),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(72.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    leading: Center(
                      child: IconButton(
                          icon: Icon(Icons.menu),
                          color: Color(0xff14DAE2),
                          onPressed: () {
                            controller.toggle();
                          }),
                    ),
                  ),
                  body: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      constraints: const BoxConstraints(
                        maxWidth: 1400,
                        minWidth: 900,
                        minHeight: 700,
                        maxHeight: 900,
                      ),
                      child: BlocConsumer<AnimationSwitchBloc,
                              AnimationSwitchState>(
                          listener: (context, state2) {},
                          builder: (context, state2) {
                            if (state2.isPendiente) {
                              return GridView(
                                padding: const EdgeInsets.all(10),
                                physics: const BouncingScrollPhysics(),
                                children: List<Widget>.generate(
                                  state.incidentesPendientes!.length,
                                  (int index) {
                                    final incindente =
                                        state.incidentesPendientes![index];
                                    return contenerSe(incindente, context);
                                  },
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                  childAspectRatio: 1,
                                ),
                              );
                            } else if (state2.isCamino) {
                              return Container(
                                child: GridView(
                                  padding: const EdgeInsets.all(10),
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  children: List<Widget>.generate(
                                    state.incidentesEnCamino!.length,
                                    (int index) {
                                      final incindente =
                                          state.incidentesEnCamino![index];
                                      return contenerSe(incindente, context);
                                    },
                                  ),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 10.0,
                                    childAspectRatio: 1,
                                  ),
                                ),
                              );
                            } else if (state2.isRealizado) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Card(
                                        child: Center(
                                          child: IconButton(
                                            icon: const Icon(
                                              IconData(0xf06bb,
                                                  fontFamily: 'MaterialIcons'),
                                              color: Color(0xff14DAE2),
                                            ),
                                            onPressed: () {
                                              BlocProvider.of<IncidenciasBloc>(
                                                      context)
                                                  .add(verCalendario());
                                            },
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: DropdownButton<String>(
                                          dropdownColor:
                                              Color.fromARGB(255, 24, 40, 72),
                                          value: state.isViewFechas
                                              ? 'Fecha'
                                              : 'Todos',
                                          icon:
                                              const Icon(Icons.arrow_downward),
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.white,
                                          ),
                                          onChanged: (String? newValue) {
                                            _onEstadoChanged(
                                                newValue!, context);
                                          },
                                          items: <String>['Todos', 'Fecha']
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(66, 13, 12, 12),
                                    ),
                                    height:
                                        MediaQuery.of(context).size.height * .8,
                                    width: MediaQuery.of(context).size.width,
                                    constraints: const BoxConstraints(
                                        maxWidth: 1400,
                                        minWidth: 700,
                                        minHeight: 570,
                                        maxHeight: 800),
                                    child: GridView(
                                      padding: const EdgeInsets.all(20),
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      children: List<Widget>.generate(
                                        state.isViewFechas
                                            ? state.fechaComandas!.length
                                            : state
                                                .incidentesRealizados!.length,
                                        (int index) {
                                          final incindente = state.isViewFechas
                                              ? state.fechaComandas![index]
                                              : state
                                                  .incidentesRealizados![index];
                                          return contenerSe(
                                              incindente, context);
                                        },
                                      ),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 10.0,
                                        crossAxisSpacing: 10.0,
                                        childAspectRatio: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Container();
                          }),
                    ),
                  ),
                );
              });
        }
        return Container();
      },
    );
  }

  Widget contenerSe(Incidentes incindente, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        // border: new Border.all(
        //     color: DesignCourseAppTheme.notWhite),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: _elejirColor(incindente.estado!).withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            // border: new Border.all(
            //     color: DesignCourseAppTheme.notWhite),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
            child: Container(
              height: 330,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: _elejirColor(incindente.estado!).withOpacity(0.1),
                    offset: const Offset(0.0, 0.0),
                  ),
                ],
              ),
              child: ListView(
                children: [
                  Container(
                    color: _elejirColor(incindente.estado!).withOpacity(0.2),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text(
                          '${incindente.tipo}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                            letterSpacing: 0.27,
                            color: DesignCourseAppTheme.darkerText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: _elejirColor(incindente.estado!).withOpacity(0.2),
                    child: Center(
                      child: Text(
                        '${incindente.fecha!.year}-' +
                            '${incindente.fecha!.month}-' +
                            '${incindente.fecha!.day}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 0.27,
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    color: _elejirColor(incindente.estado!).withOpacity(0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, right: 5, left: 5, bottom: 5),
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: DesignCourseAppTheme.grey
                                        .withOpacity(0.2),
                                    offset: const Offset(0.0, 0.0),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                child: AspectRatio(
                                  aspectRatio: 1.28,
                                  child: Image.asset(
                                      'assets/${incindente.tipo}.png'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.all(5),
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              color: Color(0xff14DAE2).withOpacity(0.65),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                'Detalles',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  letterSpacing: 0.27,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              onPressed: () {
                                BlocProvider.of<IncidenciasBloc>(context)
                                    .add(changeIncidentViewUnit(incindente));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Estado:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 0.27,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${incindente.estado}',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 0.27,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Fotos:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 0.27,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '5/${incindente.fotos!.length}',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 0.27,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Video: ',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 0.27,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '1/${incindente.video == null ? 0 : 1}',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 0.27,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Descripción:',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 0.27,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${incindente.descripcion}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      letterSpacing: 0.27,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'ID:',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.27,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${incindente.idIncidente}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      letterSpacing: 0.27,
                      color: Colors.grey[600],
                    ),
                  ),
                  incindente.estado == 'Realizado'
                      ? Text(
                          'Fecha atendida:',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 0.27,
                            color: Colors.black,
                          ),
                        )
                      : Container(),
                  incindente.estado == 'Realizado'
                      ? Text(
                          '${incindente.fechaR!.year}-${incindente.fechaR!.month}-${incindente.fechaR!.day}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: 0.27,
                            color: Colors.grey[600],
                          ),
                        )
                      : Container(),
                  incindente.estado == 'Realizado'
                      ? Text(
                          'Tiempo de respuesta:',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 0.27,
                            color: Colors.black,
                          ),
                        )
                      : Container(),
                  incindente.estado == 'Realizado'
                      ? Text(
                          '${incindente.fechaR!.difference(incindente.fecha!).inMinutes} Min',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: 0.27,
                            color: Colors.grey[600],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onEstadoChanged(String value, BuildContext context) {
    BlocProvider.of<IncidenciasBloc>(context).add(insertTipoBusqueda(value));
  }
}
