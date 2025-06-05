import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/usuario.dart';

class UsuariosData {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/usuarios.json');
  }

  static Future<List<Usuario>> cargarUsuarios() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> jsonData = json.decode(contents);
      return jsonData.map((e) => Usuario.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> guardarUsuarios(List<Usuario> usuarios) async {
    final file = await _localFile;
    final jsonData = usuarios.map((u) => u.toJson()).toList();
    await file.writeAsString(json.encode(jsonData));
  }

  static Future<void> eliminarUsuario(Usuario usuario) async {
    List<Usuario> usuarios = await cargarUsuarios();
    usuarios.removeWhere((u) => u.correo == usuario.correo);
    await guardarUsuarios(usuarios);
  }
}