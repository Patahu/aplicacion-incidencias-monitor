import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/animationSwitch_bloc/bloc.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late AnimationSwitchBloc _animationSwitchBloc;

  @override
  void didChangeDependencies() {
    _animationSwitchBloc = BlocProvider.of<AnimationSwitchBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(130, 37, 31, 52),
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Primer boton
            GestureDetector(
              onTap: () {
                _animationSwitchBloc.add(reportarPage());
              },
              child: BlocBuilder<AnimationSwitchBloc, AnimationSwitchState>(
                builder: (context, state) {
                  if (state.isPendiente) {
                    return Container(
                      decoration: const BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(60.0)),
                        color: Color.fromARGB(48, 28, 36, 63),
                      ),
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Center(
                        child: Row(
                          children: [
                            const Icon(
                              IconData(0xf4b1, fontFamily: 'MaterialIcons'),
                              color: Color(0xff14DAE2),
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Pendientes',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'OpenSans',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff14DAE2)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Row(
                      children: [
                        const Icon(
                          IconData(0xf4b1, fontFamily: 'MaterialIcons'),
                          color: Colors.white,
                          size: 24.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Pendientes',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: 'OpenSans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            //segundo boton
            GestureDetector(
              onTap: () {
                _animationSwitchBloc.add(BuscarChat());
              },
              child: BlocBuilder<AnimationSwitchBloc, AnimationSwitchState>(
                builder: (context, state) {
                  if (state.isCamino) {
                    return Container(
                      decoration: const BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(60.0)),
                        color: Color.fromARGB(48, 28, 36, 63),
                      ),
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Center(
                        child: Row(
                          children: [
                            const Icon(
                              IconData(0xed3d, fontFamily: 'MaterialIcons'),
                              color: Color(0xff14DAE2),
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            SizedBox(width: 10),
                            Text(
                              'En camino',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'OpenSans',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff14DAE2)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Center(
                      child: Row(
                        children: [
                          const Icon(
                            IconData(0xed3d, fontFamily: 'MaterialIcons'),
                            color: Colors.white,
                            size: 24.0,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          ),
                          SizedBox(width: 10),
                          Text(
                            'En camino',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontFamily: 'OpenSans',
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),

            //tercer boton
            GestureDetector(
              onTap: () {
                _animationSwitchBloc.add(BuscarPerfil());
              },
              child: BlocBuilder<AnimationSwitchBloc, AnimationSwitchState>(
                builder: (context, state) {
                  if (state.isRealizado) {
                    return Container(
                      decoration: const BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(60.0)),
                        color: Color.fromARGB(48, 28, 36, 63),
                      ),
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Center(
                        child: Row(
                          children: [
                            const Icon(
                              IconData(0xf0365, fontFamily: 'MaterialIcons'),
                              color: Color(0xff14DAE2),
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Resueltos',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'OpenSans',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff14DAE2)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Center(
                      child: Row(
                        children: [
                          const Icon(
                            IconData(0xf0365, fontFamily: 'MaterialIcons'),
                            color: Colors.white,
                            size: 24.0,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Resueltos',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontFamily: 'OpenSans',
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
