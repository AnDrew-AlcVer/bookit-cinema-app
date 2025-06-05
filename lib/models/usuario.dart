class Usuario {
  final String nombre;
  final String correo;
  final String contrasenya;

  Usuario({
    required this.nombre,
    required this.correo,
    required this.contrasenya,
  });

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'correo': correo,
    'contrasenya': contrasenya,
  };

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    nombre: json['nombre'],
    correo: json['correo'],
    contrasenya: json['contrasenya'],
  );
}