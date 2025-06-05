import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pelicula.dart';
import '../models/usuario.dart';
import '../models/pelicula_reservada.dart';
import 'main_screen.dart';
import '../data/usuarios_data.dart';

class AsientoScreen extends StatefulWidget {
  final Pelicula pelicula;
  final String fecha;
  final String hora;

  const AsientoScreen({
    super.key,
    required this.pelicula,
    required this.fecha,
    required this.hora,
  });

  @override
  State<AsientoScreen> createState() => _AsientoScreenState();
}

class _AsientoScreenState extends State<AsientoScreen> {
  static const int filas = 7;
  static const int columnas = 8;
  Set<String> reservados = {"2-3", "3-4", "5-6"};
  String? seleccionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF21094E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: Text(
          "Elige tu asiento",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            widget.pelicula.titulo,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "${widget.fecha} · ${widget.hora}",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(filas, (fila) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(columnas, (col) {
                      String key = "${fila + 1}-${col + 1}";
                      bool isReserved = reservados.contains(key);
                      bool isSelected = seleccionado == key;
                      return GestureDetector(
                        onTap: isReserved
                            ? null
                            : () {
                                setState(() {
                                  seleccionado = key;
                                });
                              },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isReserved
                                ? Colors.pink[200]
                                : isSelected
                                    ? Colors.cyanAccent
                                    : Colors.white10,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.cyan
                                  : isReserved
                                      ? Colors.pink
                                      : Colors.white24,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.event_seat,
                            color: isReserved
                                ? Colors.pink[700]
                                : isSelected
                                    ? Colors.cyan[900]
                                    : Colors.white70,
                            size: 20,
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendBox(Colors.white10, "Disponible"),
                const SizedBox(width: 12),
                _legendBox(Colors.pink[200]!, "Reservado"),
                const SizedBox(width: 12),
                _legendBox(Colors.cyanAccent, "Seleccionado"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: seleccionado == null
                    ? null
                    : () async {
                        // Guardar la reserva en el usuario actual y en persistencia
                        if (Usuario.usuarioActual != null) {
                          Usuario.usuarioActual!.reservas.add(
                            PeliculaReservada(
                              pelicula: widget.pelicula,
                              fecha: widget.fecha,
                              hora: widget.hora,
                              asiento: seleccionado!,
                            ),
                          );
                          // Guardar los usuarios en persistencia
                          List<Usuario> usuarios = await UsuariosData.cargarUsuarios();
                          int idx = usuarios.indexWhere((u) => u.correo == Usuario.usuarioActual!.correo);
                          if (idx != -1) {
                            usuarios[idx] = Usuario.usuarioActual!;
                            await UsuariosData.guardarUsuarios(usuarios);
                          }
                        }
                        // Volver a la pantalla principal y mostrar mensaje
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MainScreen()),
                          (route) => false,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("¡Reserva realizada correctamente!"),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  backgroundColor: const Color(0xFFB721FF),
                ),
                child: Text(
                  "Confirmar asiento",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendBox(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white24),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}