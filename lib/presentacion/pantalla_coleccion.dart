import 'package:flutter/material.dart';
import '../dominio/almacen.dart';
import '../dominio/catalogo.dart';

class PantallaColeccion extends StatefulWidget {
  final AlmacenColeccion almacen;
  const PantallaColeccion({super.key, required this.almacen});
  @override
  State<PantallaColeccion> createState() => _PantallaColeccionState();
}
class _PantallaColeccionState extends State<PantallaColeccion> {
  Set<String> ids = {};
  int mejor = 0;
  @override
  void initState() { super.initState(); _cargar(); }
  Future<void> _cargar() async {
    final i = await widget.almacen.cargarCapturados();
    final p = await widget.almacen.cargarMejorPuntaje();
    if (mounted) setState(() { ids = i; mejor = p; });
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mi álbum')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(
        'Personajes encontrados: ${ids.length} de 6\nMejor puntaje: $mejor',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
      ...personajes.map((p) => Card(child: ListTile(
        leading: Text(ids.contains(p.id) ? p.emoji : '🔒', style: const TextStyle(fontSize: 30)),
        title: Text(p.nombre),
        subtitle: Text(ids.contains(p.id) ? p.bio : 'Aún no lo has encontrado'),
        trailing: Icon(ids.contains(p.id) ? Icons.check_circle : Icons.lock,
          color: ids.contains(p.id) ? Colors.green : Colors.grey),
      ))),
    ]),
  );
}
