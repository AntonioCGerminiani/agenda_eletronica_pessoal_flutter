import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    // Remove qualquer caractere que não seja número
    final cleanText = text.replaceAll(RegExp(r'\D'), '');

    // Limita a 11 digitos (DDD + 9 números)
    final digits = cleanText.substring(
      0,
      cleanText.length > 11 ? 11 : cleanText.length,
    );

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 0) {
        buffer.write('(');
      } else if (i == 2) {
        buffer.write(') ');
      } else if (i == 7) {
        buffer.write('-');
      }
      buffer.write(digits[i]);
    }

    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
