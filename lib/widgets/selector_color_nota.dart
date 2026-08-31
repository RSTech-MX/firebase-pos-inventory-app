import 'package:flutter/material.dart';

// 🎨 Colores tipo Google Keep
final List<Color> coloresNotas = [
  Colors.yellow,
  Colors.orange,
  Colors.green,
  Colors.blue,
  Colors.purple,
  Colors.red,
];

// Widget selector de color
Widget selectorColor({
  required int colorSeleccionado,
  required Function(int) onColorSelected,
}) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: coloresNotas.map((color) {
      return GestureDetector(
        onTap: () => onColorSelected(color.value),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: color,
          child: color.value == colorSeleccionado
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : null,
        ),
      );
    }).toList(),
  );
}
