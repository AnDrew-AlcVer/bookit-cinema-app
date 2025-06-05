import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Pelicula {
  final String titulo;
  final String subtitulo;
  final String imagen;

  Pelicula({required this.titulo, required this.subtitulo, required this.imagen});

  factory Pelicula.fromJson(Map<String, dynamic> json) {
    return Pelicula(
      titulo: json['titulo'],
      subtitulo: json['subtitulo'],
      imagen: json['imagen'],
    );
  }
}

class PeliculasData {
  static Future<List<Pelicula>> cargarPeliculas() async {
    final String response = await rootBundle.loadString('lib/data/peliculas.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Pelicula.fromJson(json)).toList();
  }
}