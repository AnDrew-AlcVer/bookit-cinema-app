class Pelicula {
  final String titulo;
  final String subtitulo;
  final String imagen;
  final String sinopsis;

  Pelicula({required this.titulo, required this.subtitulo, required this.imagen, required this.sinopsis,});

  factory Pelicula.fromJson(Map<String, dynamic> json) {
    return Pelicula(
      titulo: json['titulo'],
      subtitulo: json['subtitulo'],
      imagen: json['imagen'],
      sinopsis: json['sinopsis'] ?? '',
    );
  }

   Map<String, dynamic> toJson() => {
    'titulo': titulo,
    'subtitulo': subtitulo,
    'imagen': imagen,
    'sinopsis': sinopsis,
  };
}