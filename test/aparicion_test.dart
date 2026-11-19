import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:caliente_frio_dolores_ar/dominio/aparicion.dart';
import 'package:caliente_frio_dolores_ar/dominio/catalogo.dart';
import 'package:caliente_frio_dolores_ar/dominio/geo.dart';
import 'ayudas.dart';
void main() {
  test('genera una aparición por personaje', () {
    final a = generarApariciones(centro: origen, personajes: personajes, random: Random(1));
    expect(a.length, personajes.length);
    expect(a.map((x)=>x.personaje.id).toSet().length, personajes.length);
  });
  test('todas quedan dentro del radio configurado', () {
    final a = generarApariciones(centro: origen, personajes: personajes,
      random: Random(7), radioMin: 60, radioMax: 500);
    for (final x in a) {
      expect(distanciaMetros(origen,x.coordenada), inInclusiveRange(59.8,500.2));
    }
  });
}
