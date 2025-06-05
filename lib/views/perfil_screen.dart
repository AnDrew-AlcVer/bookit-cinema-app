import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/usuario.dart';
import '../data/usuarios_data.dart';
import 'login_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late Usuario usuario;

  @override
  void initState() {
    super.initState();
    // Protege si usuarioActual es null
    if (Usuario.usuarioActual == null) {
      Future.microtask(() {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      });
    } else {
      usuario = Usuario.usuarioActual!;
    }
  }

  void _cambiarDato(String campo, String valor) async {
    setState(() {
      if (campo == "nombre") usuario.nombre = valor;
      if (campo == "correo") usuario.correo = valor;
      if (campo == "contrasenya") usuario.contrasenya = valor;
    });
    // Obtén la lista de usuarios, actualízala y guárdala
    List<Usuario> usuarios = await UsuariosData.cargarUsuarios();
    int idx = usuarios.indexWhere((u) => u.correo == usuario.correo);
    if (idx != -1) {
      usuarios[idx] = usuario;
    }
    await UsuariosData.guardarUsuarios(usuarios);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Dato actualizado correctamente")),
      );
    }
  }

  void _mostrarDialogoEditar(String campo, String actual) {
    final controller = TextEditingController(text: actual);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editar $campo"),
        content: TextField(
          controller: controller,
          obscureText: campo == "contrasenya",
          decoration: InputDecoration(
            labelText: "Nuevo $campo",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                _cambiarDato(campo, controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void _eliminarPerfil() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar perfil"),
        content: const Text("¿Seguro que deseas eliminar tu perfil? Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await UsuariosData.eliminarUsuario(usuario);
      Usuario.usuarioActual = null;
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  void _cerrarSesion() {
    Usuario.usuarioActual = null;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Si usuarioActual es null, muestra un widget vacío mientras redirige
    if (Usuario.usuarioActual == null) {
      return const SizedBox.shrink();
    }

    final double navBarHeight = 64 + 15 + 16;

    return Scaffold(
      backgroundColor: const Color(0xFF21094E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Mi Perfil",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, navBarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(0xFFB721FF),
                  child: const Icon(Icons.person, color: Colors.white, size: 40),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    usuario.nombre,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white70),
                  onPressed: () => _mostrarDialogoEditar("nombre", usuario.nombre),
                  tooltip: "Editar nombre",
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Icon(Icons.email, color: Colors.white70),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    usuario.correo,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white70),
                  onPressed: () => _mostrarDialogoEditar("correo", usuario.correo),
                  tooltip: "Editar correo",
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.lock, color: Colors.white70),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "********",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white70),
                  onPressed: () => _mostrarDialogoEditar("contrasenya", usuario.contrasenya),
                  tooltip: "Editar contraseña",
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _eliminarPerfil,
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text("Eliminar perfil"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _cerrarSesion,
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text("Cerrar sesión"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF21D4FD),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}