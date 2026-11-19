import 'dart:math';
import 'catalogo.dart';
import 'geo.dart';
import 'personaje.dart';

class Aparicion {
  final Personaje personaje;
  final Coordenada coordenada;
  const Aparicion(this.personaje, this.coordenada);
}

List<Aparicion> generarApariciones({required Coordenada centro,
  required List<Personaje> personajes, required Random random,
  double radioMin = 60, double radioMax = 500}) {
  return personajes.map((p) {
    final u = random.nextDouble();
    final distancia = sqrt(radioMin * radioMin +
        u * (radioMax * radioMax - radioMin * radioMin));
    final rumbo = random.nextDouble() * 360;
    return Aparicion(p, destino(centro, rumbo, distancia));
  }).toList();
}
