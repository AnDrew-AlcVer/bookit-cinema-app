import 'package:flutter/material.dart';
import 'package:aalcver_tf_ipc/views/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aalcver_tf_ipc/data/usuarios_data.dart';
import 'package:aalcver_tf_ipc/models/usuario.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenyaController = TextEditingController();

  final TextEditingController nombreRegistroController = TextEditingController();
  final TextEditingController correoRegistroController = TextEditingController();
  final TextEditingController contrasenyaRegistroController = TextEditingController();

  late BuildContext _rootContext;

  double _logoScale = 0.7;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _logoScale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _rootContext = context;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF21094E), Color(0xFF6020C2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: SizedBox(
                            width: double.infinity,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "BookIt",
                                style: GoogleFonts.bebasNeue(
                                  color: Colors.white,
                                  fontSize: 80,
                                  letterSpacing: 8,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 16,
                                      color: Colors.black.withAlpha((0.6 * 255).toInt()),
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedScale(
                        scale: _logoScale,
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutBack,
                        child: Image.asset(
                          'assets/icons/logo.png',
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 100),
                      Text(
                        "Inicia sesión",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField("Correo electrónico", Icons.email, controller: correoController),
                      const SizedBox(height: 20),
                      _buildTextField("Contraseña", Icons.lock, controller: contrasenyaController, obscure: true),
                      const SizedBox(height: 30),
                      _buildGradientButton("Iniciar sesión", context, onPressed: _iniciarSesion),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          _mostrarDialogoRegistro(context);
                        },
                        child: Text(
                          "¿No tienes cuenta? Regístrate",
                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 32,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.purpleAccent,
              onPressed: () async {
                String correoPrueba = "prueba@correo.com";
                String contrasenyaPrueba = "123456";

                List<Usuario> usuarios = await UsuariosData.cargarUsuarios();

                Usuario? usuarioPrueba = usuarios.firstWhere(
                  (u) => u.correo == correoPrueba,
                  orElse: () => Usuario(
                    nombre: "Prueba",
                    correo: correoPrueba,
                    contrasenya: contrasenyaPrueba,
                  ),
                );

                if (!usuarios.any((u) => u.correo == correoPrueba)) {
                  usuarios.add(usuarioPrueba);
                  await UsuariosData.guardarUsuarios(usuarios);
                }

                Usuario.usuarioActual = usuarioPrueba;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
              tooltip: 'Ir directo a inicio',
              child: const Icon(Icons.developer_mode, color: Colors.white),
            ),
          ),
          Positioned(
            top: 32,
            left: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Eliminar todos los usuarios"),
                    content: const Text("¿Seguro que deseas borrar TODOS los usuarios guardados? Esta acción no se puede deshacer."),
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
                  await UsuariosData.guardarUsuarios([]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Todos los usuarios han sido eliminados")),
                  );
                }
              },
              tooltip: 'Eliminar todos los usuarios',
              child: const Icon(Icons.delete_forever, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, {bool obscure = false, TextEditingController? controller}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildGradientButton(String label, BuildContext context, {required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEF32D9), Color(0xFF89FFFD)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoRegistro(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E2C),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Text(
                    'Crear cuenta',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField("Nombre", Icons.person, controller: nombreRegistroController),
                  const SizedBox(height: 15),
                  _buildTextField("Correo electrónico", Icons.email, controller: correoRegistroController),
                  const SizedBox(height: 15),
                  _buildTextField("Contraseña", Icons.lock, obscure: true, controller: contrasenyaRegistroController),
                  const SizedBox(height: 30),
                  _buildGradientButton("Registrarse", context, onPressed: _registrarse),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _registrarse() async {
    String nombre = nombreRegistroController.text.trim();
    String correo = correoRegistroController.text.trim();
    String contrasenya = contrasenyaRegistroController.text;

    if (nombre.isEmpty || correo.isEmpty || contrasenya.isEmpty) {
      ScaffoldMessenger.of(_rootContext).showSnackBar(
        SnackBar(content: Text("Por favor, completa todos los campos")),
      );
      return;
    }

    List<Usuario> usuarios = await UsuariosData.cargarUsuarios();

    bool existe = usuarios.any((u) => u.correo == correo);
    if (existe) {
      ScaffoldMessenger.of(_rootContext).showSnackBar(
        SnackBar(content: Text("El correo ya está registrado")),
      );
      return;
    }

    usuarios.add(Usuario(nombre: nombre, correo: correo, contrasenya: contrasenya));
    await UsuariosData.guardarUsuarios(usuarios);

    nombreRegistroController.clear();
    correoRegistroController.clear();
    contrasenyaRegistroController.clear();

    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 200));

    ScaffoldMessenger.of(_rootContext).showSnackBar(
      SnackBar(content: Text("Cuenta registrada correctamente")),
    );
  }

  void _iniciarSesion() async {
    String correoIngresado = correoController.text.trim();
    String contrasenyaIngresada = contrasenyaController.text;

    List<Usuario> usuarios = await UsuariosData.cargarUsuarios();

    Usuario? usuario = usuarios
        .where((u) => u.correo == correoIngresado && u.contrasenya == contrasenyaIngresada)
        .cast<Usuario?>()
        .firstWhere((u) => true, orElse: () => null);

    if (usuario != null) {
      Usuario.usuarioActual = usuario;

      correoController.clear();
      contrasenyaController.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(_rootContext).showSnackBar(
        SnackBar(content: Text("Correo o contraseña incorrectos")),
      );
    }
  }
}