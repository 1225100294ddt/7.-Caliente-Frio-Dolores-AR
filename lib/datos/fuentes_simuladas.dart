import '../dominio/geo.dart';

class PosicionSimulada {
  Coordenada actual;
  PosicionSimulada(this.actual);
  void avanzar(double rumbo, double metros) { actual = destino(actual, rumbo, metros); }
}
