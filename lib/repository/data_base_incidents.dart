import 'dart:async';
import 'dart:io';

import 'package:firedart/firedart.dart';

import '../util/incident.dart';
import '../util/usuarioDenunciante.dart';

class DataBaseIncident {
  final Firestore _firebaseFirestore;
  DataBaseIncident({Firestore? firebaseFirestore})
      : _firebaseFirestore =
            firebaseFirestore ?? Firestore.initialize("mushidb-2eca9");

  Stream<List<Incidentes>> datosIncidentesPendientes() {
    return _firebaseFirestore
        .collection("IncidenciasAtenderF")
        .stream
        .map((snapshot) {
      List<Incidentes> po = [];
      snapshot.map((doc) {
        final ic = Incidentes.fromDB(doc);
        if (ic.estado == 'Pendiente') {
          po.add(ic);
        }
      }).toList();
      return po;
    });
  }

  Stream<List<Incidentes>> datosComandasFecha(DateTime tiempo) {
    return _firebaseFirestore
        .collection('IncidenciasAtenderF')
        .where('fechaR',
            isGreaterThanOrEqualTo: tiempo.add(Duration(hours: 5)),
            isLessThanOrEqualTo: tiempo.add(Duration(hours: 29)))
        .get()
        .asStream()
        .map((snapshot) {
      List<Incidentes> po = [];
      snapshot.map((doc) {
        final ic = Incidentes.fromDB(doc);
        if (ic.estado == 'Realizado') {
          po.add(ic);
        }
      }).toList();
      return po;
    });
  }

  Stream<List<Incidentes>> datosIncidentesEnCamino() {
    return _firebaseFirestore
        .collection("IncidenciasAtenderF")
        .stream
        .map((snapshot) {
      List<Incidentes> po = [];
      snapshot.map((doc) {
        final ic = Incidentes.fromDB(doc);
        if (ic.estado == 'En camino') {
          po.add(ic);
        }
      }).toList();
      return po;
    });
  }

  Stream<List<Incidentes>> datosIncidentesRealizados() {
    return _firebaseFirestore
        .collection("IncidenciasAtenderF")
        .stream
        .map((snapshot) {
      List<Incidentes> po = [];
      snapshot.map((doc) {
        final ic = Incidentes.fromDB(doc);
        if (ic.estado == 'Realizado') {
          po.add(ic);
        }
      }).toList();
      return po;
    });
  }

  Future<UsuarioDenunciante> consultaUsuario(String idUsuario) async {
    final ref =
        await _firebaseFirestore.collection('users').document(idUsuario).get();

    return UsuarioDenunciante.fromUsers(ref['idUsuario'], ref['nombre'],
        ref['correo'], ref['numero'], ref['DNI']);
  }

  Stream<Incidentes> consultaIncidente(String idIncidente) {
    final ref = _firebaseFirestore
        .collection('IncidenciasAtenderF')
        .document(idIncidente);

    return ref.stream.map((event) => Incidentes.fromDB(event!));
  }

  Future<void> cambiarEstadoIncidente(
      Incidentes incidente, String estado, DateTime tiempo) async {
    // Ingreso a la db
    Map<String, Object> entrada = {
      'estado': estado,
    };

    print(incidente.estado);
    if (estado == 'En camino') {
      entrada['fechaE'] = tiempo;
    } else if (estado == 'Realizado') {

      entrada['fechaR'] = tiempo;
    }
    final String idNotificacion = incidente.idUsuario.toString() +
        tiempo.year.toString() +
        tiempo.month.toString() +
        tiempo.day.toString() +
        tiempo.hour.toString() +
        tiempo.minute.toString() +
        tiempo.second.toString();
    final notificacion = {
      'estado': 'Pendiente',
      'fecha': tiempo,
      'cuerpo': 'Su incidencia a cambiado de estado a ' + estado,
      'device_token': 'ninguno',
      'idIncidencia': incidente.idIncidente,
      'idNotificacion': idNotificacion,
      'idUsuario': incidente.idUsuario,
      'titulo': 'Aviso Aplicación incidencias',
    };
    _firebaseFirestore
        .collection('notificacion')
        .document(idNotificacion)
        .set(notificacion);
    final refS = _firebaseFirestore
        .collection('IncidenciasAtenderF')
        .document('${incidente.idIncidente}');
    await refS.update(entrada);
  }
}
