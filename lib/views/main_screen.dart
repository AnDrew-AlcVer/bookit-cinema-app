import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pelicula.dart';
import '../data/peliculas_data.dart';
import 'reserva_screen.dart';
import 'mis_reservas_screen.dart';
import 'perfil_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // 1 = cartelera por defecto

  late Future<List<Pelicula>> _peliculasFuture;

  @override
  void initState() {
    super.initState();
    _peliculasFuture = PeliculasData.cargarPeliculas();
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      MisReservasScreen(),
      _CarteleraPage(_peliculasFuture),
      PerfilScreen(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF21094E),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF21094E), Color(0xFF6020C2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: _pages[_selectedIndex],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 15,
            child: _BottomNavBar(
              selectedIndex: _selectedIndex,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _CarteleraPage extends StatelessWidget {
  final Future<List<Pelicula>> peliculasFuture;
  const _CarteleraPage(this.peliculasFuture);

  @override
  Widget build(BuildContext context) {
    // Altura de la barra de navegación + margen inferior
    final double navBarHeight = 64 + 15 + 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Text(
            "Mi Cartelera",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Pelicula>>(
            future: peliculasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No hay películas disponibles", style: TextStyle(color: Colors.white70)));
              }
              final peliculas = snapshot.data!;
              return Padding(
                padding: EdgeInsets.only(bottom: navBarHeight),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: peliculas.length,
                  itemBuilder: (context, index) {
                    final peli = peliculas[index];
                    return Container(
                      height: 340,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Stack(
                          children: [
                            Hero(
                              tag: 'peli.img-${peli.titulo}',
                              child: Image.network(
                                peli.imagen,
                                height: 340,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      peli.titulo,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      peli.subtitulo,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ReservaScreen(pelicula: peli),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFB721FF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text("Reservar"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Lista de iconos y sus índices
    final items = [
      Icons.confirmation_num_rounded,
      Icons.local_movies_rounded,
      Icons.person_rounded,
    ];

    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF21094E),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (i) {
          final isSelected = selectedIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.all(8),
                  decoration: isSelected
                      ? BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB721FF), Color(0xFF21D4FD)],
                          ),
                          shape: BoxShape.circle,
                        )
                      : const BoxDecoration(),
                  child: Icon(
                    items[i],
                    color: isSelected ? Colors.white : Colors.white54,
                    size: i == 1 ? 32 : 28,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}