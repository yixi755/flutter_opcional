import 'dart:math';
import 'package:flutter/material.dart';
import '../models/pregunta.dart';
import '../utils/categoria_colors.dart';
import '../utils/html_utils.dart';
import 'resultat_screen.dart';

/// Pantalla principal del juego de Trivial.
///
/// Gestiona:
///   - Mostrar cada pregunta con sus opciones barajadas (shuffle)
///   - Feedback visual tras responder (verde = correcto, rojo = incorrecto)
///   - Sistema de puntuación: +10 por acierto, -5 por error
///   - Bloqueo de botones tras responder para evitar doble clic
///   - Navegación a [ResultatScreen] al acabar todas las preguntas
class PreguntaScreen extends StatefulWidget {
  /// Lista completa de preguntas cargadas desde el JSON remoto
  final List<Pregunta> preguntes;

  const PreguntaScreen({super.key, required this.preguntes});

  @override
  State<PreguntaScreen> createState() => _PreguntaScreenState();
}

class _PreguntaScreenState extends State<PreguntaScreen> {
  /// Índice de la pregunta que se muestra actualmente
  int _indexActual = 0;

  /// Puntuación acumulada: +10 por acierto, -5 por error
  int _puntuacio = 0;

  /// Contador de respuestas correctas (para la pantalla de resultado)
  int _encerts = 0;

  /// Contador de respuestas incorrectas (para la pantalla de resultado)
  int _errors = 0;

  /// Lista de opciones mezcladas para la pregunta actual
  List<String> _opcions = [];

  /// Opción que el usuario ha pulsado; null antes de responder
  String? _respostaSeleccionada;

  /// true una vez que el usuario ha respondido (bloquea más pulsaciones)
  bool _respost = false;

  @override
  void initState() {
    super.initState();
    // Preparamos las opciones de la primera pregunta al entrar en la pantalla
    _prepararOpcions();
  }

  /// Getter de conveniencia para la pregunta que toca mostrar ahora
  Pregunta get _preguntaActual => widget.preguntes[_indexActual];

  /// Combina la respuesta correcta con las incorrectas y las baraja.
  /// Resetea también el estado de selección para la nueva pregunta.
  void _prepararOpcions() {
    final totes = [
      _preguntaActual.respostaCorrecta,
      ..._preguntaActual.respostesIncorrectes,
    ];
    // shuffle() usa Fisher-Yates internamente → orden aleatorio cada vez
    totes.shuffle(Random());

    setState(() {
      _opcions = totes;
      _respostaSeleccionada = null; // Sin selección para la nueva pregunta
      _respost = false;             // Botones desbloqueados
    });
  }

  /// Evalúa la opción pulsada, actualiza puntuación y bloquea más respuestas.
  void _respondrePregunta(String opcioSeleccionada) {
    // Protección extra: ignorar si ya se respondió
    if (_respost) return;

    final bool esCorrecta =
        opcioSeleccionada == _preguntaActual.respostaCorrecta;

    setState(() {
      _respostaSeleccionada = opcioSeleccionada;
      _respost = true;

      if (esCorrecta) {
        _puntuacio += 10; // Acierto: +10 puntos
        _encerts++;
      } else {
        _puntuacio -= 5;  // Error: -5 puntos
        _errors++;
      }
    });
  }

  /// Avanza a la siguiente pregunta o va a la pantalla de resultado final.
  void _seguent() {
    final bool esUltima = _indexActual >= widget.preguntes.length - 1;

    if (esUltima) {
      // Última pregunta: navegamos a ResultatScreen sin posibilidad de volver
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultatScreen(
            puntuacio: _puntuacio,
            encerts: _encerts,
            errors: _errors,
            total: widget.preguntes.length,
          ),
        ),
      );
    } else {
      // Avanzamos al siguiente índice y mezclamos las nuevas opciones
      setState(() => _indexActual++);
      _prepararOpcions();
    }
  }

  /// Retorna el color de fondo del botón de la [opcio] según el estado:
  ///   - Sin responder:       color de superficie del tema
  ///   - Opción correcta:     verde
  ///   - Opción seleccionada incorrecta: rojo
  ///   - Resto de opciones:   gris oscuro
  Color _colorBoto(String opcio) {
    if (!_respost) return Theme.of(context).colorScheme.surface;
    if (opcio == _preguntaActual.respostaCorrecta) return Colors.green.shade700;
    if (opcio == _respostaSeleccionada) return Colors.red.shade700;
    return Colors.grey.shade800;
  }

  /// Retorna el icono de feedback del botón tras responder, o null si aún no.
  Widget? _iconaBoto(String opcio) {
    if (!_respost) return null;
    if (opcio == _preguntaActual.respostaCorrecta) {
      return const Icon(Icons.check_circle, color: Colors.white);
    }
    if (opcio == _respostaSeleccionada) {
      return const Icon(Icons.cancel, color: Colors.white);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Color temático de la categoría actual
    final Color colorCategoria = getColorCategoria(_preguntaActual.categoria);

    return Scaffold(
      // ── AppBar con puntuación visible ───────────────────────────────────
      appBar: AppBar(
        title: const Text('Pt Trivial'),
        backgroundColor: colorCategoria.withOpacity(0.8),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Puntuació: $_puntuacio',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Indicador de progreso ──────────────────────────────────────
            Text(
              'Pregunta ${_indexActual + 1} / ${widget.preguntes.length}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            // Barra de progreso lineal proporcional al avance
            LinearProgressIndicator(
              value: (_indexActual + 1) / widget.preguntes.length,
              color: colorCategoria,
              backgroundColor: Colors.white24,
            ),
            const SizedBox(height: 16),

            // ── Header: chip de categoría + dificultad ─────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colorCategoria,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Chip con color de categoría (requisito obligatorio)
                  Chip(
                    label: Text(
                      HtmlUtils.decode(_preguntaActual.categoria),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: colorCategoria.withOpacity(0.6),
                    side: const BorderSide(color: Colors.white30),
                  ),
                  const Spacer(),
                  // Badge de dificultad en el lado derecho
                  Text(
                    _preguntaActual.dificultat.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Texto de la pregunta ───────────────────────────────────────
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  HtmlUtils.decode(_preguntaActual.pregunta),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Opciones de respuesta ──────────────────────────────────────
            Expanded(
              child: ListView.builder(
                itemCount: _opcions.length,
                itemBuilder: (context, index) {
                  final opcio = _opcions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ElevatedButton(
                      // onPressed null cuando ya se respondió (deshabilita el botón)
                      onPressed:
                          _respost ? null : () => _respondrePregunta(opcio),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _colorBoto(opcio),
                        disabledBackgroundColor: _colorBoto(opcio),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Icono de correcto/incorrecto (solo tras responder)
                          if (_iconaBoto(opcio) != null) ...[
                            _iconaBoto(opcio)!,
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              HtmlUtils.decode(opcio),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Botón "Siguiente" (solo visible tras responder) ────────────
            if (_respost)
              ElevatedButton.icon(
                onPressed: _seguent,
                icon: Icon(
                  _indexActual >= widget.preguntes.length - 1
                      ? Icons.emoji_events
                      : Icons.arrow_forward_rounded,
                ),
                label: Text(
                  _indexActual >= widget.preguntes.length - 1
                      ? 'Ver resultado'
                      : 'Siguiente',
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorCategoria,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
