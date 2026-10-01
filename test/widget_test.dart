import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Verificacion inicial del entorno', () {
    const appName = 'Firebase POS Inventory';
    expect(appName, isNotEmpty);
  });
}
