import 'package:flutter/material.dart';

// Avatar dinâmico que gera cores e iniciais a partir do nome e sobrenome
class DynamicContactAvatar extends StatelessWidget {
  final String name;
  final String surname;
  final double? fontSize;

  const DynamicContactAvatar({
    super.key,
    required this.name,
    required this.surname,
    this.fontSize = 20,
  });

  // Extração das iniciais
  String _getInitials(String name, String surname) {
    String initials = "";

    if (name.isNotEmpty) {
      initials += name[0].toUpperCase();
    }

    if (surname.isNotEmpty) {
      initials += surname[0].toUpperCase();
    }

    // Caso não tenha nome nem sobenome, deixa com ponto de interrogação;
    return initials.isEmpty ? "?" : initials;
  }

  //Função para "sorteio" de cores baseada no nome
  Color _getAvatarColor(String text) {
    final List<Color> colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.blueGrey,
    ];

    // Cor específica pra quando não se encontra o nome da fera
    if (text.isEmpty) return Colors.grey;

    // O hashCode gera um número a partir da string.
    // .abs() para garantir que seja positivo.
    // O operador % (módulo) garante que o índice gerado não ultrapasse o tamanho da lista.
    final int index = text.hashCode.abs() % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = '$name $surname'.trim();
    final String initials = _getInitials(name, surname);
    final Color backgroundColor = _getAvatarColor(fullName);

    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
