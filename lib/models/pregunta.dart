/// Modelo de datos que representa una pregunta del Trivial.
/// Mapea directamente los campos del JSON remoto.
class Pregunta {
  /// Tipo de pregunta: "multiple" (4 opciones) o "boolea" (Cert/Fals)
  final String tipus;

  /// Dificultad: "fàcil", "mitjana" o "difícil"
  final String dificultat;

  /// Categoría temática (p. ej. "Entreteniment: Cinema")
  final String categoria;

  /// Texto de la pregunta (puede contener entidades HTML como &quot;)
  final String pregunta;

  /// La respuesta correcta
  final String respostaCorrecta;

  /// Lista de respuestas incorrectas (1 para boolea, 3 para multiple)
  final List<String> respostesIncorrectes;

  const Pregunta({
    required this.tipus,
    required this.dificultat,
    required this.categoria,
    required this.pregunta,
    required this.respostaCorrecta,
    required this.respostesIncorrectes,
  });

  /// Factory constructor que construye un [Pregunta] desde un mapa JSON.
  /// Se invoca para cada elemento de la lista "Trivial" del JSON.
  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      tipus: json['tipus'] as String,
      dificultat: json['dificultat'] as String,
      categoria: json['categoria'] as String,
      pregunta: json['pregunta'] as String,
      respostaCorrecta: json['resposta_correcta'] as String,
      respostesIncorrectes:
          List<String>.from(json['respostes_incorrectes'] as List),
    );
  }
}
