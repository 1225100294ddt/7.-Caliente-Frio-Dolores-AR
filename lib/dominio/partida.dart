import 'aparicion.dart';
import 'geo.dart';

sealed class ResultadoCaptura { const ResultadoCaptura(); }
class Capturado extends ResultadoCaptura {
  final int puntos;
  const Capturado(this.puntos);
}
class Fallo extends ResultadoCaptura {
  final int intentosRestantes;
  const Fallo(this.intentosRestantes);
}
class SeEscapo extends ResultadoCaptura {
  final Coordenada nuevaPosicion;
  const SeEscapo(this.nuevaPosicion);
}

class Partida {
  static const double radioCaptura = 15;
  static const int maxFallos = 2;
  static const int puntosPrimerIntento = 100;
  static const int puntosSegundoIntento = 50;
  final Map<String, Aparicion> _apariciones;
  final Coordenada Function() _reubicar;
  final Set<String> _capturados = {};
  final Map<String, int> _fallos = {};
  int puntos = 0;

  Partida(List<Aparicion> apariciones, {required Coordenada Function() reubicar})
      : _apariciones = {for (final a in apariciones) a.personaje.id: a},
        _reubicar = reubicar;

  List<Aparicion> get todas => _apariciones.values.toList();
  List<Aparicion> get pendientes => _apariciones.values
      .where((a) => !_capturados.contains(a.personaje.id)).toList();
  Set<String> get capturados => Set.unmodifiable(_capturados);
  bool get terminada => _capturados.length == _apariciones.length;
  bool estaCapturado(String id) => _capturados.contains(id);
  void restaurar(Iterable<String> ids) =>
      _capturados.addAll(ids.where(_apariciones.containsKey));

  ResultadoCaptura capturar(String id, int opcion, double distancia) {
    final a = _apariciones[id];
    if (a == null) throw StateError('Ese personaje no existe en el juego.');
    if (_capturados.contains(id)) throw StateError('Ese personaje ya fue capturado.');
    if (distancia > radioCaptura) throw StateError('Acércate más para atraparlo.');
    final previos = _fallos[id] ?? 0;
    if (a.personaje.pregunta.esCorrecta(opcion)) {
      final ganados = previos == 0 ? puntosPrimerIntento : puntosSegundoIntento;
      puntos += ganados;
      _capturados.add(id);
      return Capturado(ganados);
    }
    final fallos = previos + 1;
    if (fallos >= maxFallos) {
      _fallos[id] = 0;
      final nueva = _reubicar();
      _apariciones[id] = Aparicion(a.personaje, nueva);
      return SeEscapo(nueva);
    }
    _fallos[id] = fallos;
    return Fallo(maxFallos - fallos);
  }
}

