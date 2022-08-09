import 'package:equatable/equatable.dart';

class UsuarioDenunciante extends Equatable {
  String? _uid;
  String? _nombre;
  String? _correo;
  String? _numero;
  String? _dni;
  UsuarioDenunciante(
      {String? uid,
      String? nombre,
      String? correo,
      String? numero,
      String? dni}) {
    _uid = uid;
    _nombre = nombre;
    _correo = correo;
    _numero = numero;
    _dni = dni;
  }

  static UsuarioDenunciante fromUsers(
      String uid, String nombre, String correo, String numero, String dni) {
    UsuarioDenunciante usarioet =
        UsuarioDenunciante(uid:uid, nombre:nombre, correo:correo,numero: numero, dni:dni);
    return usarioet;
  }

  String? get uid => _uid;
  String? get correo => _correo;
  String? get numero => _numero;
  String? get nombre => _nombre;
  String? get dni => _dni;

  void set seDNIUsuario(String dni) {
    _dni = dni;
  }

  void set seTelefono(String telefono) {
    _numero = telefono;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [uid, correo, numero, nombre, dni];
}
