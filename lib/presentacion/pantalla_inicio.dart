import 'package:flutter/material.dart';
import '../dominio/almacen.dart';
import '../dominio/catalogo.dart';
import '../datos/almacen_prefs.dart';
import 'pantalla_rally.dart';
import 'pantalla_coleccion.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(gradient: LinearGradient(
        colors: [Color(0xff102d25), Color(0xff236447), Color(0xffd2a64b)],
        begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SafeArea(child: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🇲🇽', style: TextStyle(fontSize: 64)),
          const Text('CALIENTE - FRÍO', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
          const Text('DOLORES AR', style: TextStyle(fontSize: 22, color: Colors.white70, letterSpacing: 4)),
          const SizedBox(height: 18),
          const Text('Encuentra a los personajes de la Independencia usando el radar, la brújula y tus conocimientos de historia.',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 28),
          SizedBox(width: double.infinity, child: FilledButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => PantallaRally(demo: true, almacen: AlmacenMemoria()))),
            icon: const Icon(Icons.school), label: const Text('Modo demo (salón de clases)'))),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => PantallaRally(demo: false, almacen: AlmacenPrefs()))),
            icon: const Icon(Icons.explore), label: const Text('Jugar con GPS real'))),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => PantallaColeccion(almacen: AlmacenPrefs()))),
            icon: const Icon(Icons.collections_bookmark), label: const Text('Mi álbum'))),
          const SizedBox(height: 22),
          const Text('⚠️ Camina con cuidado. No cruces calles mirando el teléfono. Juega acompañado y en zonas seguras.',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(height: 8),
          const Text('Los datos históricos y coordenadas son de práctica; verifica las fuentes antes de usar el juego en campo.',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 11)),
        ]),
      ))),
    ),
  );
}
