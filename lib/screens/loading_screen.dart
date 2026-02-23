import 'package:flutter/material.dart';
import '../models/pregunta.dart';
import '../services/trivial_service.dart';
import 'pregunta_screen.dart';

/// Pantalla inicial de la app.
///
/// Responsabilidades:
///   1. Mostrar un indicador de carga mientras se hace el HTTP GET.
///   2. Navegar a [PreguntaScreen] cuando los datos están listos.
///   3. Mostrar un error con botón "Reintenta" si la petición falla.
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  /// Instancia del servicio de red
  final TrivialService _service = TrivialService();

  /// Mensaje de error; null mientras no haya error o durante la carga
  String? _errorMissatge;

  @override
  void initState() {
    super.initState();
    // Iniciamos la carga automáticamente al crear la pantalla
    _carregarDades();
  }

  /// Llama al servicio y navega a [PreguntaScreen] al terminar.
  /// Si hay error actualiza [_errorMissatge] para mostrarlo en pantalla.
  Future<void> _carregarDades() async {
    // Reseteamos el error en caso de reintento
    setState(() => _errorMissatge = null);

    try {
      final List<Pregunta> preguntes = await _service.carregarPreguntes();

      // Verificamos que el widget sigue montado antes de navegar
      if (!mounted) return;

      // Sustituimos LoadingScreen por PreguntaScreen (no se puede volver atrás)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PreguntaScreen(preguntes: preguntes),
        ),
      );
    } catch (e) {
      // Mostramos el detalle del error para facilitar el diagnóstico
      setState(() {
        _errorMissatge =
            'No se han podido cargar las preguntas.\n\nDetalle: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _errorMissatge != null
            // ── ESTADO ERROR ───────────────────────────────────────────────
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        size: 64, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      _errorMissatge!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _carregarDades,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintenta'),
                    ),
                  ],
                ),
              )
            // ── ESTADO CARGANDO ────────────────────────────────────────────
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.quiz_rounded,
                      size: 80, color: Colors.indigoAccent),
                  const SizedBox(height: 24),
                  const Text(
                    'Pt Trivial',
                    style: TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Cargando preguntas...'),
                ],
              ),
      ),
    );
  }
}
