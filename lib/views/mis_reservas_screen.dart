import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/usuario.dart';
import '../models/pelicula_reservada.dart';
import 'reserva_screen.dart';

class MisReservasScreen extends StatefulWidget {
  const MisReservasScreen({super.key});

  @override
  State<MisReservasScreen> createState() => _MisReservasScreenState();
}

class _MisReservasScreenState extends State<MisReservasScreen> {
  @override
  Widget build(BuildContext context) {
    final reservas = Usuario.usuarioActual?.reservas ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF21094E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Mis Reservas",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: reservas.isEmpty
          ? Center(
              child: Text(
                "No tienes reservas.",
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reservas.length,
              itemBuilder: (context, index) {
                final reserva = reservas[index];
                return _ReservaCard(
                  reserva: reserva,
                  onModificar: () async {
                    setState(() {
                      Usuario.usuarioActual!.reservas.removeAt(index);
                    });
                    // Navega a ReservaScreen para modificar
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservaScreen(pelicula: reserva.pelicula),
                      ),
                    );
                    setState(() {});
                  },
                  onEliminar: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Eliminar reserva"),
                        content: const Text("¿Seguro que deseas eliminar esta reserva?"),
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
                      setState(() {
                        Usuario.usuarioActual!.reservas.removeAt(index);
                      });
                    }
                  },
                );
              },
            ),
    );
  }
}

class _ReservaCard extends StatelessWidget {
  final PeliculaReservada reserva;
  final VoidCallback onModificar;
  final VoidCallback onEliminar;

  const _ReservaCard({
    required this.reserva,
    required this.onModificar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    // Extrae fila y asiento para mostrarlo tipo ticket
    final asientoSplit = reserva.asiento.split('-');
    final fila = asientoSplit[0];
    final asientoNum = asientoSplit[1];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Imagen de la película
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            child: Image.network(
              reserva.pelicula.imagen,
              width: 110,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reserva.pelicula.titulo,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reserva.pelicula.subtitulo,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        reserva.fecha,
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        reserva.hora,
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.event_seat, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "Fila: $fila, Asiento: $asientoNum",
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: ElevatedButton.icon(
                            onPressed: onModificar,
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text("Modificar"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF21D4FD),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              minimumSize: Size.zero,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: ElevatedButton.icon(
                            onPressed: onEliminar,
                            icon: const Icon(Icons.delete, size: 18),
                            label: const Text("Eliminar"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              minimumSize: Size.zero,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}