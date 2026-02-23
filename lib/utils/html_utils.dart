/// Utilidades para procesar textos del JSON que contienen entidades HTML.
class HtmlUtils {
  /// Decodifica las entidades HTML más comunes presentes en los textos del JSON.
  ///
  /// Ejemplos:
  ///   &quot;  →  "
  ///   &#039;  →  '
  ///   &amp;   →  &
  static String decode(String text) {
    return text
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&eacute;', 'é')
        .replaceAll('&agrave;', 'à')
        .replaceAll('&aacute;', 'á')
        .replaceAll('&iacute;', 'í')
        .replaceAll('&oacute;', 'ó')
        .replaceAll('&uacute;', 'ú')
        .replaceAll('&ntilde;', 'ñ')
        .replaceAll('&ccedil;', 'ç');
  }
}
