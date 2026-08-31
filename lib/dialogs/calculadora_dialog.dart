import 'package:flutter/material.dart';

class CalculadoraDialog extends StatefulWidget {
  const CalculadoraDialog({super.key});

  @override
  State<CalculadoraDialog> createState() => _CalculadoraDialogState();
}

class _CalculadoraDialogState extends State<CalculadoraDialog> {
  String display = '0';
  double? firstNumber;
  String? operation;

  void presionar(String valor) {
    setState(() {
      if (valor == 'C') {
        display = '0';
        firstNumber = null;
        operation = null;
        return;
      }

      if (['+', '-', '×', '÷'].contains(valor)) {
        firstNumber = double.parse(display);
        operation = valor;
        display = '0';
        return;
      }

      if (valor == '=') {
        final secondNumber = double.parse(display);
        double result = 0;

        switch (operation) {
          case '+':
            result = firstNumber! + secondNumber;
            break;
          case '-':
            result = firstNumber! - secondNumber;
            break;
          case '×':
            result = firstNumber! * secondNumber;
            break;
          case '÷':
            result = secondNumber == 0 ? 0 : firstNumber! / secondNumber;
            break;
        }

        display = result.toStringAsFixed(2);
        firstNumber = null;
        operation = null;
        return;
      }

      // Números
      if (display == '0') {
        display = valor;
      } else {
        display += valor;
      }
    });
  }

  Widget boton(String texto,
      {Color color = Colors.black, Color fondo = Colors.grey}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: fondo,
            foregroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          onPressed: () => presionar(texto),
          child: Text(
            texto,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // Display
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(16),
            child: Text(
              display,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Row(children: [boton('7'), boton('8'), boton('9'), boton('÷')]),
          Row(children: [boton('4'), boton('5'), boton('6'), boton('×')]),
          Row(children: [boton('1'), boton('2'), boton('3'), boton('-')]),
          Row(children: [boton('0'), boton('C', fondo: Colors.red), boton('='), boton('+')]),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ),
        ],
      ),
    );
  }
}
