import '../models/pelicula.dart';

class PeliculaReservada {
  final Pelicula pelicula;
  final String fecha;
  final String hora;
  final String asiento;

  PeliculaReservada({
    required this.pelicula,
    required this.fecha,
    required this.hora,
    required this.asiento,
  });

  Map<String, dynamic> toJson() => {
    'pelicula': pelicula.toJson(),
    'fecha': fecha,
    'hora': hora,
    'asiento': asiento,
  };

  factory PeliculaReservada.fromJson(Map<String, dynamic> json) => PeliculaReservada(
    pelicula: Pelicula.fromJson(json['pelicula']),
    fecha: json['fecha'],
    hora: json['hora'],
    asiento: json['asiento'],
  );
}