import 'dart:math' as math;

class Coordenada {
  final double lat;
  final double lon;
  const Coordenada(this.lat, this.lon);
}

const double radioTierra = 6371000;
double _rad(double g) => g * math.pi / 180;
double _deg(double r) => r * 180 / math.pi;

double distanciaMetros(Coordenada a, Coordenada b) {
  final dLat = _rad(b.lat - a.lat);
  final dLon = _rad(b.lon - a.lon);
  final h = math.pow(math.sin(dLat / 2), 2) +
      math.cos(_rad(a.lat)) * math.cos(_rad(b.lat)) * math.pow(math.sin(dLon / 2), 2);
  return 2 * radioTierra * math.asin(math.sqrt(h.clamp(0.0, 1.0).toDouble()));
}

double normalizar360(double g) => ((g % 360) + 360) % 360;

double rumboGrados(Coordenada a, Coordenada b) {
  final dLon = _rad(b.lon - a.lon);
  final lat1 = _rad(a.lat);
  final lat2 = _rad(b.lat);
  final y = math.sin(dLon) * math.cos(lat2);
  final x = math.cos(lat1) * math.sin(lat2) -
      math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
  return normalizar360(_deg(math.atan2(y, x)));
}

double diferenciaAngular(double objetivo, double actual) {
  var d = normalizar360(objetivo - actual);
  if (d > 180) d -= 360;
  return d;
}

double suavizarAngulo(double anterior, double nuevo, {double alfa = 0.2}) =>
    normalizar360(anterior + alfa * diferenciaAngular(nuevo, anterior));

double? posicionHorizontal(double diferencia, {double campoVision = 60}) {
  if (diferencia.abs() > campoVision / 2) return null;
  return 0.5 + diferencia / campoVision;
}

Coordenada destino(Coordenada origen, double rumbo, double metros) {
  final d = metros / radioTierra;
  final br = _rad(rumbo);
  final lat1 = _rad(origen.lat);
  final lon1 = _rad(origen.lon);
  final lat2 = math.asin(math.sin(lat1) * math.cos(d) +
      math.cos(lat1) * math.sin(d) * math.cos(br));
  final lon2 = lon1 + math.atan2(
    math.sin(br) * math.sin(d) * math.cos(lat1),
    math.cos(d) - math.sin(lat1) * math.sin(lat2),
  );
  return Coordenada(_deg(lat2), ((_deg(lon2) + 540) % 360) - 180);
}

String formatearDistancia(double m) =>
    m < 1000 ? '${m.round()} m' : '${(m / 1000).toStringAsFixed(1)} km';
