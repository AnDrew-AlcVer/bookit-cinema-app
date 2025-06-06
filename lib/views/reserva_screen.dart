import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pelicula.dart';
import 'asiento_screen.dart';

class ReservaScreen extends StatefulWidget {
  final Pelicula pelicula;

  const ReservaScreen({super.key, required this.pelicula});

  @override
  State<ReservaScreen> createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  int? selectedDay;
  int? selectedHour;

  final List<Map<String, String>> days = [
    {"day": "Jue", "date": "21"},
    {"day": "Vie", "date": "22"},
    {"day": "Sab", "date": "23"},
    {"day": "Dom", "date": "24"},
    {"day": "Lun", "date": "25"},
  ];

  late final List<String> hours;

  @override
  void initState() {
    super.initState();
    hours = _generarSesiones(widget.pelicula.duracion);
  }

  List<String> _generarSesiones(String duracion) {
    final regex = RegExp(r'(\d+)h\s*(\d+)?');
    final match = regex.firstMatch(duracion);
    int minutos = 0;
    if (match != null) {
      minutos += int.parse(match.group(1)!) * 60;
      if (match.group(2) != null) minutos += int.parse(match.group(2)!);
    }
    if (minutos == 0) minutos = 120;

    List<String> sesiones = [];
    int hora = 15 * 60;
    while (hora + minutos <= 23 * 60) {
      final h = (hora ~/ 60).toString().padLeft(2, '0');
      final m = (hora % 60).toString().padLeft(2, '0');
      sesiones.add("$h:$m");
      hora += minutos;
    }
    return sesiones;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF21094E),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Reserva",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Hero(
                tag: 'peli-img-${widget.pelicula.titulo}',
                child: Image.network(
                  widget.pelicula.imagen,
                  height: 220,
                  width: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.pelicula.titulo,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.pelicula.subtitulo,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Duración: ${widget.pelicula.duracion}",
              style: GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.pelicula.sinopsis,
                style: GoogleFonts.poppins(
                  color: Colors.white.withAlpha((0.85 * 255).toInt()),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            _SelectorFechaHora(
              onChanged: (day, hour) {
                setState(() {
                  selectedDay = day;
                  selectedHour = hour;
                });
              },
              selectedDay: selectedDay,
              selectedHour: selectedHour,
              hours: hours,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (selectedDay == null || selectedHour == null)
                      ? null
                      : () {
                          final day = days[selectedDay!];
                          final hour = hours[selectedHour!];

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AsientoScreen(
                                pelicula: widget.pelicula,
                                fecha: "${day['day']} ${day['date']}",
                                hora: hour,
                              ),
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
                    "Elegir Asiento",
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
      ),
    );
  }
}

class _SelectorFechaHora extends StatefulWidget {
  final Function(int?, int?) onChanged;
  final int? selectedDay;
  final int? selectedHour;
  final List<String> hours;

  const _SelectorFechaHora({
    required this.onChanged,
    this.selectedDay,
    this.selectedHour,
    required this.hours,
  });

  @override
  State<_SelectorFechaHora> createState() => _SelectorFechaHoraState();
}

class _SelectorFechaHoraState extends State<_SelectorFechaHora> {
  int? selectedDay;
  int? selectedHour;

  final List<Map<String, String>> days = [
    {"day": "Jue", "date": "21"},
    {"day": "Vie", "date": "22"},
    {"day": "Sab", "date": "23"},
    {"day": "Dom", "date": "24"},
    {"day": "Lun", "date": "25"},
  ];

  @override
  void initState() {
    super.initState();
    selectedDay = widget.selectedDay;
    selectedHour = widget.selectedHour;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(days.length, (i) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDay = i;
                  widget.onChanged(selectedDay, selectedHour);
                });
              },
              child: _Chip(
                days[i]["day"]!,
                days[i]["date"]!,
                selectedDay == i,
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.hours.length, (i) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedHour = i;
                  widget.onChanged(selectedDay, selectedHour);
                });
              },
              child: _TimeChip(
                widget.hours[i],
                selectedHour == i,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String day;
  final String date;
  final bool selected;
  const _Chip(this.day, this.date, this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFB721FF) : Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      width: 54,
      height: 54,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: GoogleFonts.poppins(
              color: selected ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Text(
            date,
            style: GoogleFonts.poppins(
              color: selected ? Colors.white : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String time;
  final bool selected;
  const _TimeChip(this.time, this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF21D4FD) : Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      width: 70,
      height: 36,
      alignment: Alignment.center,
      child: Text(
        time,
        style: GoogleFonts.poppins(
          color: selected ? Colors.white : Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}