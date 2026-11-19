import 'package:flutter_test/flutter_test.dart';
import 'package:caliente_frio_dolores_ar/dominio/geo.dart';
import 'package:caliente_frio_dolores_ar/dominio/radar.dart';
import 'ayudas.dart';
void main() {
  test('norte aparece arriba y este a la derecha', () {
    final norte = destino(origen,0,250);
    final este = destino(origen,90,250);
    final n = puntoEnRadar(usuario:origen,rumbo:0,objetivo:norte)!;
    final e = puntoEnRadar(usuario:origen,rumbo:0,objetivo:este)!;
    expect(n.$2, closeTo(-.5,.01));
    expect(e.$1, closeTo(.5,.01));
  });
  test('temperatura respeta umbrales', () {
    expect(temperaturaPorDistancia(15), Temperatura.ardiente);
    expect(temperaturaPorDistancia(40), Temperatura.caliente);
    expect(temperaturaPorDistancia(100), Temperatura.tibio);
    expect(temperaturaPorDistancia(300), Temperatura.frio);
    expect(temperaturaPorDistancia(900), Temperatura.helado);
  });
}
