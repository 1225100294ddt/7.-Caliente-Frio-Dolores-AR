import 'package:shared_preferences/shared_preferences.dart';
import '../dominio/almacen.dart';

class AlmacenPrefs implements AlmacenColeccion {
  static const _claveIds = 'capturados';
  static const _claveMejor = 'mejor_puntaje';
  @override
  Future<Set<String>> cargarCapturados() async =>
      (await SharedPreferences.getInstance()).getStringList(_claveIds)?.toSet() ?? {};
  @override
  Future<void> guardarCapturados(Set<String> ids) async {
    await (await SharedPreferences.getInstance()).setStringList(_claveIds, ids.toList());
  }
  @override
  Future<int> cargarMejorPuntaje() async =>
      (await SharedPreferences.getInstance()).getInt(_claveMejor) ?? 0;
  @override
  Future<void> guardarMejorPuntaje(int puntos) async {
    await (await SharedPreferences.getInstance()).setInt(_claveMejor, puntos);
  }
}
