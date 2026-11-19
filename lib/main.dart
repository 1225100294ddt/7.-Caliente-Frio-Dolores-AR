import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'presentacion/pantalla_inicio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const RallyApp());
}
class RallyApp extends StatelessWidget {
  const RallyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Caliente-Frío Dolores AR',
    theme: ThemeData(colorSchemeSeed: const Color(0xff23734d), useMaterial3: true),
    home: const PantallaInicio(),
  );
}
