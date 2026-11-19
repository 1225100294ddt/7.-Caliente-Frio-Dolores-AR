import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../dominio/almacen.dart';
import '../dominio/aparicion.dart';
import '../dominio/catalogo.dart';
import '../dominio/geo.dart';
import '../dominio/partida.dart';
import '../dominio/radar.dart';
import '../datos/fuentes_simuladas.dart';
import '../datos/fuentes_reales.dart';
import 'radar_widget.dart';

class PantallaRally extends StatefulWidget {
  final bool demo;
  final AlmacenColeccion almacen;
  const PantallaRally({super.key, required this.demo, required this.almacen});
  @override
  State<PantallaRally> createState() => _PantallaRallyState();
}

class _PantallaRallyState extends State<PantallaRally> {
  late PosicionSimulada simulada;
  late Partida partida;
  Coordenada usuario = plazaPrincipal;
  double rumbo = 0;
  CameraController? camara;
  String estado = 'Busca los puntos naranjas en el radar.';
  bool cargando = false;
  @override
  void initState() {
    super.initState();
    simulada = PosicionSimulada(plazaPrincipal);
    final apariciones = generarApariciones(centro: plazaPrincipal,
      personajes: personajes, random: Random());
    partida = Partida(apariciones, reubicar: () =>
      destino(usuario, Random().nextDouble()*360, 180 + Random().nextDouble()*250));
    if (!widget.demo) { _iniciarGps(); _iniciarCamara(); }
  }

  Future<void> _iniciarGps() async {
    try {
      usuario = await FuentesReales.obtenerPosicion();
      FuentesReales.posiciones().listen((p) { if (mounted) setState(() => usuario = p); });
      FuentesReales.rumbos.listen((g) { if (mounted) setState(() => rumbo = g); });
      if (mounted) setState(() => estado = 'GPS activo. Busca a los personajes.');
    } catch (e) {
      if (mounted) setState(() => estado = 'No se pudo activar el GPS: $e');
    }
  }

  Future<void> _iniciarCamara() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      camara = CameraController(cameras.first, ResolutionPreset.medium, enableAudio: false);
      await camara!.initialize();
      if (mounted) setState(() {});
    } catch (_) { /* La cámara es opcional; el juego conserva el radar. */ }
  }

  @override
  void dispose() { camara?.dispose(); super.dispose(); }

  double _distancia(Aparicion a) => distanciaMetros(usuario, a.coordenada);
  Future<void> _preguntar(Aparicion a) async {
    final d = _distancia(a);
    if (d > Partida.radioCaptura) {
      setState(() => estado = 'Estás a ${formatearDistancia(d)}. Acércate a 15 m o menos.');
      return;
    }
    int? opcion;
    opcion = await showDialog<int>(context: context, builder: (context) {
      return AlertDialog(
        title: Text('${a.personaje.emoji} ${a.personaje.nombre}'),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(a.personaje.bio), const SizedBox(height: 12),
            Text(a.personaje.pregunta.texto, style: const TextStyle(fontWeight: FontWeight.bold)),
            ...List.generate(a.personaje.pregunta.opciones.length, (i) => RadioListTile<int>(
              contentPadding: EdgeInsets.zero, value: i, groupValue: opcion,
              title: Text(a.personaje.pregunta.opciones[i]),
              onChanged: (v) => Navigator.pop(context, v),
            )),
          ]),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
      );
    });
    if (opcion == null || !mounted) return;
    try {
      final r = partida.capturar(a.personaje.id, opcion, d);
      switch (r) {
        case Capturado(:final puntos):
          await widget.almacen.guardarCapturados(partida.capturados);
          final mejor = await widget.almacen.cargarMejorPuntaje();
          if (partida.puntos > mejor) await widget.almacen.guardarMejorPuntaje(partida.puntos);
          setState(() => estado = '¡Capturado! +$puntos puntos. ${partida.capturados.length}/6');
          if (partida.terminada) _fin();
          break;
        case Fallo(:final intentosRestantes):
          setState(() => estado = 'Respuesta incorrecta. Te queda(n) $intentosRestantes intento(s).');
          break;
        case SeEscapo():
          setState(() => estado = '¡Se escapó! Busca su nueva ubicación en el radar.');
          break;
      }
    } catch (e) { setState(() => estado = e.toString()); }
  }

  void _fin() {
    showDialog<void>(context: context, builder: (_) => AlertDialog(
      title: const Text('¡Rally completado! 🏆'),
      content: Text('Encontraste a los seis personajes. Puntaje: ${partida.puntos}'),
      actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); },
        child: const Text('Terminar'))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final pendientes = partida.pendientes;
    final cercanos = pendientes.map((a) => (a, _distancia(a))).toList()
      ..sort((a,b) => a.$2.compareTo(b.$2));
    final cercano = cercanos.isEmpty ? null : cercanos.first;
    final temp = cercano == null ? Temperatura.ardiente : temperaturaPorDistancia(cercano.$2);
    return Scaffold(
      appBar: AppBar(title: Text(widget.demo ? 'Modo demo' : 'Rally con GPS'),
        actions: [Padding(padding: const EdgeInsets.all(12), child: Center(child: Text('${partida.puntos} pts')))]),
      body: Stack(children: [
        Positioned.fill(child: camara != null && camara!.value.isInitialized
          ? CameraPreview(camara!)
          : Container(decoration: const BoxDecoration(gradient: LinearGradient(
              colors: [Color(0xff203c34), Color(0xff607b5b)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: const Center(child: Icon(Icons.landscape, size: 100, color: Colors.white24)))),
        Positioned(top: 12, left: 12, child: RadarWidget(usuario: usuario, rumbo: rumbo, apariciones: pendientes)),
        Positioned(top: 18, right: 16, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Text('TEMPERATURA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(temp.texto, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          if (cercano != null) Text(formatearDistancia(cercano.$2), style: const TextStyle(color: Colors.white)),
        ])),
        Positioned.fill(child: IgnorePointer(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.add, color: Colors.white70, size: 32),
          ...pendientes.where((a) => _distancia(a) <= 600).take(3).map((a) => Padding(
            padding: const EdgeInsets.all(5), child: Text('${a.personaje.emoji} ${a.personaje.nombre}',
              style: const TextStyle(color: Colors.white, fontSize: 17, shadows: [Shadow(blurRadius: 5, color: Colors.black)])))),
        ])))),
        Positioned(left: 12, right: 12, bottom: 12, child: Column(mainAxisSize: MainAxisSize.min, children: [
          Card(color: Colors.black.withOpacity(.72), child: Padding(padding: const EdgeInsets.all(12),
            child: Text(estado, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)))),
          if (widget.demo) Card(color: Colors.black.withOpacity(.75), child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12), child: Column(children: [
              Row(children: [const Text('Gira', style: TextStyle(color: Colors.white)),
                Expanded(child: Slider(value: rumbo, min: 0, max: 359,
                  onChanged: (v) => setState(() => rumbo = v))),
                Text('${rumbo.round()}°', style: const TextStyle(color: Colors.white))]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                TextButton(onPressed: () => setState(() { usuario = destino(usuario, rumbo, -10); simulada.actual = usuario; }),
                  child: const Text('⬇ 10 m')),
                FilledButton(onPressed: () => setState(() { usuario = destino(usuario, rumbo, 10); simulada.actual = usuario; }),
                  child: const Text('⬆ Avanzar 10 m')),
                TextButton(onPressed: () => setState(() { usuario = destino(usuario, rumbo, 2); simulada.actual = usuario; }),
                  child: const Text('+2 m')),
              ]),
            ]))),
          const SizedBox(height: 4),
          SizedBox(height: 52, child: ListView(scrollDirection: Axis.horizontal,
            children: cercanos.map((item) {
              final a = item.$1; final d = item.$2;
              return Padding(padding: const EdgeInsets.only(right: 8), child: FilledButton.tonal(
                onPressed: () => _preguntar(a),
                child: Text('${a.personaje.emoji} ${a.personaje.nombre}\n${formatearDistancia(d)}'),
              ));
            }).toList())),
        ])),
      ]),
    );
  }
}
