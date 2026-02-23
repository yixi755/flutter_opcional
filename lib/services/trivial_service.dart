import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pregunta.dart';

/// Servicio responsable de obtener las preguntas desde la URL remota.
/// Usa el proxy de CodeTabs para evitar restricciones de acceso CORS
/// que bloquean peticiones directas al servidor de la escuela.
class TrivialService {
  /// URL base del proxy. Se antepone a la URL real del JSON.
  /// El proxy reenvía la petición GET al servidor destino y retorna la respuesta.
  static const String _proxyBase =
      'https://api.codetabs.com/v1/proxy?quest=';

  /// URL original del JSON con las preguntas del Trivial
  static const String _urlJson =
      'https://www.vidalibarraquer.net/android/trivial.json';

  /// URL final = proxy + URL real
  static const String _urlFinal = '$_proxyBase$_urlJson';

  /// Realiza la petición HTTP GET y devuelve la lista de [Pregunta].
  ///
  /// Flujo:
  ///   App → proxy CodeTabs → servidor escola → JSON → List<Pregunta>
  ///
  /// Lanza [Exception] si:
  ///   - El código HTTP no es 200
  ///   - El JSON no tiene el formato esperado
  Future<List<Pregunta>> carregarPreguntes() async {
    final uri = Uri.parse(_urlFinal);

    // Petición GET a través del proxy
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Decodificamos en UTF-8 para preservar acentos y caracteres especiales
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      // La clave raíz del JSON es "Trivial"
      final List<dynamic> llista = data['Trivial'] as List<dynamic>;

      // Convertimos cada objeto JSON a un [Pregunta] tipado
      return llista
          .map((item) => Pregunta.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Error al cargar preguntas. Código HTTP: ${response.statusCode}');
    }
  }
}
