import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:aalcver_tf_ipc/models/pelicula.dart';

class PeliculasData {
  static Future<List<Pelicula>> cargarPeliculas() async {
    final String response = await rootBundle.loadString('lib/data/peliculas.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Pelicula.fromJson(json)).toList();
  }
}