import 'package:flutter_test/flutter_test.dart';
import 'package:caliente_frio_dolores_ar/dominio/aparicion.dart';
import 'package:caliente_frio_dolores_ar/dominio/catalogo.dart';
import 'package:caliente_frio_dolores_ar/dominio/geo.dart';
import 'package:caliente_frio_dolores_ar/dominio/partida.dart';
void main() {
  test('captura correcta suma 100 puntos', () {
    final a = Aparicion(personajes.first, plazaPrincipal);
    final p = Partida([a], reubicar:()=>plazaPrincipal);
    expect(p.capturar('hidalgo',0,5), isA<Capturado>());
    expect(p.puntos,100);
    expect(p.terminada,true);
  });
  test('dos fallos hacen escapar al personaje', () {
    final a = Aparicion(personajes.first, plazaPrincipal);
    final p = Partida([a], reubicar:()=>const Coordenada(21.16,-100.93));
    expect(p.capturar('hidalgo',1,5), isA<Fallo>());
    expect(p.capturar('hidalgo',1,5), isA<SeEscapo>());
    expect(p.terminada,false);
  });
  test('no permite capturar desde más de 15 metros', () {
    final p = Partida([Aparicion(personajes.first,plazaPrincipal)], reubicar:()=>plazaPrincipal);
    expect(()=>p.capturar('hidalgo',0,16), throwsStateError);
  });
}
