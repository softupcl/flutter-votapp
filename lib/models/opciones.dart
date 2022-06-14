class Opcion {
  String id;
  String nombre;
  int votos;

  Opcion({
    required this.id,
    required this.nombre,
    required this.votos,
  });

  factory Opcion.fromMap(Map<String, dynamic> obj) => Opcion(
        id: obj.containsKey('id') ? obj['id'] : 'no-id',
        nombre: obj.containsKey('nombre') ? obj['nombre'] : 'sin-nombre',
        votos: obj.containsKey('votos') ? obj['votos'] : 0,
      );

  toList() {}
}
