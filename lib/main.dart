import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';

/// Punto de entrada de la aplicación Pt_Trivial.
void main() {
  runApp(const PtTrivialApp());
}

/// Widget raíz de la app.
/// Define el tema global y establece [LoadingScreen] como pantalla inicial.
class PtTrivialApp extends StatelessWidget {
  const PtTrivialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pt Trivial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema oscuro basado en el color índigo
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // La primera pantalla es siempre la de carga de datos
      home: const LoadingScreen(),
    );
  }
}
