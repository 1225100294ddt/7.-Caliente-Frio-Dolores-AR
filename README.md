# Caliente-Frío Dolores AR

Proyecto Flutter basado en el manual **Rally de la Independencia AR**. Incluye seis personajes históricos, preguntas, puntuación, intentos, huida y reaparición, radar, escala de frío/caliente, modo demo caminable, cámara opcional, GPS/brújula reales y álbum local.

## Abrir en Visual Studio Code
1. Descomprime la carpeta.
2. Abre `caliente_frio_dolores_ar` en Visual Studio Code.
3. Abre una terminal en esa carpeta.
4. Ejecuta:
   ```bash
   flutter pub get
   flutter test
   flutter run
   ```

Se recomienda probar primero **Modo demo**, que funciona sin salir del salón y no necesita permisos de ubicación ni cámara.

## Android
El proyecto incluye los permisos de cámara y ubicación en `android/app/src/main/AndroidManifest.xml`. Si creas la plataforma Android desde tu instalación de Flutter, conserva esos permisos. La cámara es opcional; si no está disponible, el juego muestra un fondo alternativo.

## Reglas principales
- Objetivo: atrapar los seis personajes.
- Captura: estar a 15 metros o menos y contestar correctamente.
- Dos intentos por personaje; si se falla dos veces, huye y aparece en otra ubicación.
- Puntos: 100 en el primer intento correcto y 50 después de un fallo.
- Temperatura: ardiente (≤15 m), caliente (≤50 m), tibio (≤150 m), frío (≤400 m), helado (>400 m).
- Las ubicaciones del catálogo son de práctica y deben verificarse localmente antes de usar el juego fuera del modo demo.

## Estructura
- `lib/dominio/`: reglas puras, coordenadas, radar, apariciones y partida.
- `lib/datos/`: GPS, brújula, almacenamiento local y modo simulado.
- `lib/presentacion/`: pantallas y radar dibujado con CustomPainter.
- `test/`: pruebas unitarias del dominio.

## Seguridad y privacidad
Camina en zonas seguras, no cruces calles mirando el teléfono y juega acompañado. La ubicación se usa en el dispositivo; el álbum solo conserva identificadores de personajes y puntaje, no coordenadas del jugador.
