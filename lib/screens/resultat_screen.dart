import 'package:flutter/material.dart';
import 'loading_screen.dart';

/// Pantalla de resultado final de la partida.
///
/// Muestra:
///   - Puntuación total (positiva en verde, negativa en rojo)
///   - Estadísticas: correctas, incorrectas y total
///   - Mensaje motivacional según el porcentaje de aciertos
///   - Botón "Torna a jugar" que reinicia la app desde [LoadingScreen]
class ResultatScreen extends StatelessWidget {
  /// Puntuación total acumulada durante la partida
  final int puntuacio;

  /// Número de preguntas respondidas correctamente
  final int encerts;

  /// Número de preguntas respondidas incorrectamente
  final int errors;

  /// Total de preguntas de la partida
  final int total;

  const ResultatScreen({
    super.key,
    required this.puntuacio,
    required this.encerts,
    required this.errors,
    required this.total,
  });

  /// Mensaje motivacional según el porcentaje de aciertos obtenido.
  String _missatgeMotivacional() {
    final double pct = total > 0 ? encerts / total : 0;
    if (pct >= 0.8) return '¡Excelente! Eres un crack del Trivial 🏆';
    if (pct >= 0.5) return '¡Buen trabajo! Puedes mejorar aún más 💪';
    return 'Sigue practicando, ¡la próxima irá mejor! 📚';
  }

  @override
  Widget build(BuildContext context) {
    // Color del marcador de puntuación según si es positiva o negativa
    final Color colorPuntuacio =
        puntuacio >= 0 ? Colors.greenAccent : Colors.redAccent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado Final'),
        automaticallyImplyLeading: false, // Sin botón de retroceso
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Icono de trofeo ──────────────────────────────────────────
            const Icon(Icons.emoji_events_rounded,
                size: 80, color: Colors.amber),
            const SizedBox(height: 16),

            // ── Título ───────────────────────────────────────────────────
            const Text(
              '¡Partida terminada!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // ── Mensaje motivacional ─────────────────────────────────────
            Text(
              _missatgeMotivacional(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 32),

            // ── Tarjeta de estadísticas ──────────────────────────────────
            Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                    // Puntuación total en grande con color dinámico
                    Text(
                      '$puntuacio pts',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: colorPuntuacio,
                      ),
                    ),
                    const Divider(height: 32),
                    // Fila de tres estadísticas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem(Icons.check_circle,
                            '$encerts correctes', Colors.green),
                        _statItem(Icons.cancel,
                            '$errors incorrectes', Colors.red),
                        _statItem(Icons.quiz,
                            '$total totals', Colors.white70),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── Botón "Torna a jugar" ─────────────────────────────────────
            ElevatedButton.icon(
              onPressed: () {
                // Elimina toda la pila de navegación y vuelve a LoadingScreen
                // Esto fuerza una nueva descarga del JSON (partida desde cero)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LoadingScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.replay_rounded),
              label: const Text(
                'Torna a jugar',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
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

  /// Widget auxiliar que renderiza una estadística con icono + texto.
  Widget _statItem(IconData icono, String text, Color color) {
    return Column(
      children: [
        Icon(icono, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
