import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../bloc/incident_bloc/bloc.dart';

class calendarioVer extends StatelessWidget {
  var _selectedDay;
  var _focusedDay;

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Center(
        child: ListView(
          children: [
            Center(
              child: BlocConsumer<IncidenciasBloc, IncidentViewState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Center(
                    child: TableCalendar(
                      firstDay: DateTime(2010, 10, 16),
                      lastDay: DateTime(2030, 3, 14),
                      locale: "es",
                      focusedDay: DateTime.now(),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                      ),
                      calendarStyle: CalendarStyle(
                        todayTextStyle: TextStyle(color: Colors.white),
                        defaultTextStyle: const TextStyle(color: Colors.white),
                        weekendTextStyle: TextStyle(color: Colors.red),
                        outsideTextStyle: TextStyle(color: Colors.orange),
                      ),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      selectedDayPredicate: (day) {
                        return isSameDay(state.tiempoBusqueda, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        BlocProvider.of<IncidenciasBloc>(context).add(
                            ingresarDiaCalendario(selectedDay, focusedDay));
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: const Icon(
                          IconData(0xe094, fontFamily: 'MaterialIcons'),
                          color: Color(0xff14DAE2),
                        ),
                        onPressed: () {
                          BlocProvider.of<IncidenciasBloc>(context)
                              .add(volverAnteriorCalendario());
                        },
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: const Icon(
                          IconData(0xf04d7, fontFamily: 'MaterialIcons'),
                          color: Color(0xff14DAE2),
                        ),
                        onPressed: () {
                          BlocProvider.of<IncidenciasBloc>(context)
                              .add(buscarPorFecha());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onEstadoChanged(String value, BuildContext context) {
    BlocProvider.of<IncidenciasBloc>(context).add(insertTipoBusqueda(value));
  }
}
