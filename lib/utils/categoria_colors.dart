import 'package:flutter/material.dart';

/// Mapa que asigna un [Color] a cada categoría conocida del Trivial.
/// Usado en headers, chips y barras de color para identificar visualmente
/// la categoría de cada pregunta.
const Map<String, Color> categoriaColors = {
  'Entreteniment: Cinema':                Color(0xFFE53935), // Rojo
  'Entreteniment: Música':                Color(0xFF8E24AA), // Morado
  'Entreteniment: Videojocs':             Color(0xFF00897B), // Verde azulado
  'Entreteniment: Llibres':               Color(0xFF6D4C41), // Marrón
  'Entreteniment: Còmics':                Color(0xFFF4511E), // Naranja oscuro
  'Entreteniment: Anime i manga japonès': Color(0xFFD81B60), // Rosa
  'Història':                             Color(0xFF795548), // Marrón tierra
  'Ciència i natura':                     Color(0xFF43A047), // Verde
  'Ciència: Informàtica':                 Color(0xFF1E88E5), // Azul
  'Esports':                              Color(0xFFFF8F00), // Ámbar
  'Geografia':                            Color(0xFF00ACC1), // Cyan
  'Vehicles':                             Color(0xFF546E7A), // Gris azulado
  'Política':                             Color(0xFFC62828), // Rojo oscuro
  'Cultura general':                      Color(0xFF558B2F), // Verde oliva
  'Celebritats':                          Color(0xFFAD1457), // Rosa oscuro
};

/// Color de fallback para categorías no presentes en el mapa.
const Color colorPerDefecte = Color(0xFF455A64); // Gris azulado oscuro

/// Devuelve el [Color] asociado a [categoria].
/// Si no existe en el mapa, retorna [colorPerDefecte].
Color getColorCategoria(String categoria) {
  return categoriaColors[categoria] ?? colorPerDefecte;
}
