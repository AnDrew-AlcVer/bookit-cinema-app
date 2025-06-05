import 'pelicula_reservada.dart';

class Usuario {
  String nombre;
  String correo;
  String contrasenya;
  List<PeliculaReservada> reservas;

  static Usuario? usuarioActual;

  Usuario({
    required this.nombre,
    required this.correo,
    required this.contrasenya,
    this.reservas = const [],
  });

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'correo': correo,
    'contrasenya': contrasenya,
    'reservas': reservas.map((r) => r.toJson()).toList(),
  };

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    nombre: json['nombre'],
    correo: json['correo'],
    contrasenya: json['contrasenya'],
    reservas: json['reservas'] != null
        ? (json['reservas'] as List)
            .map((r) => PeliculaReservada.fromJson(r))
            .toList()
        : [],
  );
}