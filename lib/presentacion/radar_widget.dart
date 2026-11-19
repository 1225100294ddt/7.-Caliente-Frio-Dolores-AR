import 'package:flutter/material.dart';
import '../dominio/geo.dart';
import '../dominio/radar.dart';
import '../dominio/aparicion.dart';

class RadarWidget extends StatelessWidget {
  final Coordenada usuario;
  final double rumbo;
  final List<Aparicion> apariciones;
  const RadarWidget({super.key, required this.usuario, required this.rumbo, required this.apariciones});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 150, height: 150,
    child: CustomPaint(painter: _RadarPainter(usuario, rumbo, apariciones)),
  );
}

class _RadarPainter extends CustomPainter {
  final Coordenada usuario;
  final double rumbo;
  final List<Aparicion> apariciones;
  _RadarPainter(this.usuario, this.rumbo, this.apariciones);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width * .46;
    final line = Paint()..color = Colors.white70..style = PaintingStyle.stroke..strokeWidth = 1.4;
    final fill = Paint()..color = Colors.black54;
    canvas.drawCircle(c, r, fill);
    canvas.drawCircle(c, r, line);
    canvas.drawCircle(c, r * .66, line);
    canvas.drawCircle(c, r * .33, line);
    canvas.drawLine(Offset(c.dx, c.dy-r), Offset(c.dx, c.dy+r), line);
    canvas.drawLine(Offset(c.dx-r, c.dy), Offset(c.dx+r, c.dy), line);
    for (final a in apariciones) {
      final p = puntoEnRadar(usuario: usuario, rumbo: rumbo, objetivo: a.coordenada);
      if (p == null) continue;
      final dot = Offset(c.dx + p.$1*r, c.dy + p.$2*r);
      canvas.drawCircle(dot, 5, Paint()..color = Colors.orangeAccent);
    }
    canvas.drawCircle(c, 5, Paint()..color = Colors.lightGreenAccent);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) =>
      old.usuario.lat != usuario.lat || old.usuario.lon != usuario.lon ||
      old.rumbo != rumbo || old.apariciones != apariciones;
}
