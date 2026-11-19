import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import '../dominio/geo.dart';

class FuentesReales {
  static Future<Coordenada> obtenerPosicion() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Activa los servicios de ubicación.');
    }
    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) permiso = await Geolocator.requestPermission();
    if (permiso == LocationPermission.denied || permiso == LocationPermission.deniedForever) {
      throw Exception('No se concedió permiso de ubicación.');
    }
    final p = await Geolocator.getCurrentPosition();
    return Coordenada(p.latitude, p.longitude);
  }

  static Stream<Coordenada> posiciones() => Geolocator.getPositionStream(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 2),
  ).map((p) => Coordenada(p.latitude, p.longitude));

  static Stream<double> get rumbos => FlutterCompass.events
      ?.where((e) => e.heading != null)
      .map((e) => normalizar360(e.heading!)) ?? const Stream.empty();
}
