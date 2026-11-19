import 'package:flutter_test/flutter_test.dart';
import 'package:caliente_frio_dolores_ar/dominio/geo.dart';
import 'ayudas.dart';

void main() {
  test('destino y distancia conservan 100 metros al norte', () {
    final d = destino(origen, 0, 100);
    expect(distanciaMetros(origen, d), closeTo(100, .05));
    expect(rumboGrados(origen, d), closeTo(0, .05));
  });
  test('ida y vuelta en varias direcciones', () {
    for (final r in [0,45,90,135,180,225,270,315,359]) {
      final d = destino(origen, r.toDouble(), 250);
      expect(distanciaMetros(origen, d), closeTo(250, .1));
      expect(diferenciaAngular(rumboGrados(origen,d), r.toDouble()).abs(), lessThan(.1));
    }
  });
  test('ángulos cruzan norte correctamente', () {
    expect(diferenciaAngular(10,350), 20);
    expect(diferenciaAngular(350,10), -20);
    expect(suavizarAngulo(350,10,alfa:.5), closeTo(0,1e-9));
  });
}
