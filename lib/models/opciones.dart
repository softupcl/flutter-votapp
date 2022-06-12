class Opciones {
  String id;
  String nombre;
  int? votos;

  Opciones({
    required this.id,
    required this.nombre,
    this.votos,
  });

  factory Opciones.fromMap(Map<String, dynamic> obj) => Opciones(
        id: obj['id'],
        nombre: obj['mombre'],
        votos: obj['votos'],
      );
}
