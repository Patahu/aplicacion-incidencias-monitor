import 'package:equatable/equatable.dart';
import 'package:firedart/firedart.dart';

class Incidentes extends Equatable {
  String? _tipo;
  String? _descripcion;
  List<String>? _fotos;
  String? _idUsuario;
  String? _video;
  String? _estado;
  GeoPoint? _locationData;
  DateTime? _fecha;
  DateTime? _fechaE;
  DateTime? _fechaR;
  String? _idIncidente;
  Incidentes(
      {String? tipo,
      String? descripcion,
      List<String>? fotos,
      String? idUsuario,
      String? video,
      String? estado,
      String? nombreUsuario,
      String? idIncidente,
      GeoPoint? localizacion,
      DateTime? myTimeStamp,
      DateTime? fechaE,
      DateTime? fechaR}) {
    _tipo = tipo;
    _descripcion = descripcion ?? '-';
    _fotos = fotos ?? [];
    _idUsuario = idUsuario;
    _video = video;
    _estado = estado;
    _fechaE = fechaE;
    _fechaR = fechaR;
    _idIncidente = idIncidente;
    _locationData = localizacion;
    _fecha = myTimeStamp;
  }

  static Incidentes fromDB(Document documentSnapshot) {
    return Incidentes(
      tipo: documentSnapshot['tipo'],
      descripcion: documentSnapshot['descripcion'],
      fotos: documentSnapshot['idFotos'].cast<String>(),
      video: documentSnapshot['video'],
      nombreUsuario: documentSnapshot['nombreUsuario'],
      estado: documentSnapshot['estado'],
      idUsuario: documentSnapshot['idUsuario'],
      localizacion: documentSnapshot['localizacion'],
      myTimeStamp: documentSnapshot['fecha'],
      idIncidente: documentSnapshot['idIncidencia'],
      fechaE: documentSnapshot['fechaE'],
      fechaR: documentSnapshot['fechaR'],
    );
  }

  String? get tipo => _tipo;
  String? get descripcion => _descripcion;
  String? get idIncidente => _idIncidente;
  List<String>? get fotos => _fotos;
  String? get idUsuario => _idUsuario;
  String? get estado => _estado;
  String? get video => _video;
  DateTime? get fecha => _fecha;
  DateTime? get fechaR => _fechaR;
  DateTime? get fechaE => _fechaE;
  GeoPoint? get locationData => _locationData;
  void set seFechaE(DateTime fechaE) {
    _fechaE = fechaE;
  }

  void set seFechaR(DateTime fechaR) {
    _fechaR = fechaR;
  }

  void set seTipo(String tipo) {
    _tipo = tipo;
  }

  void set seDescripcion(String descripcion) {
    _descripcion = descripcion;
  }

  void set seLocalizacion(GeoPoint localizacion) {
    _locationData = localizacion;
  }

  void set seFotos(String path) {
    _fotos!.add(path);
  }

  void setResetFotos() {
    _fotos = [];
  }

  void set seVideo(String path) {
    _video = path;
  }

  void set seIdUsuario(String idUsuario) {
    _idUsuario = idUsuario;
  }

  void set seEstado(String estado) {
    _estado = estado;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        tipo,
        descripcion,
        fotos,
        idUsuario,
        estado,
        locationData,
        fechaE,
        fechaR
      ];
}
