import 'package:agenda_eletronica_pessoal/screens/events/event_form_screen.dart';
import 'package:agenda_eletronica_pessoal/screens/groups/group_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:agenda_eletronica_pessoal/screens/contacts/contact_form_screen.dart';

/// Widget que cria um FloatingActionButton dinâmico baseado na aba ativa
Widget buildDynamicFAB(BuildContext context, int index) {
  IconData icon;
  String tooltip;
  Widget formScreen;

  if (index == 0) {
    icon = Icons.person_add;
    tooltip = 'Adicionar Contato';
    formScreen = const ContactFormScreen();
  } else if (index == 1) {
    icon = Icons.group_add;
    tooltip = 'Adicionar Grupo';
    formScreen = const GroupFormScreen();
  } else {
    icon = Icons.event;
    tooltip = 'Adicionar Evento';
    formScreen = const EventFormScreen();
  }

  return FloatingActionButton(
    onPressed: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => formScreen,
      );
    },
    tooltip: tooltip,
    child: Icon(icon),
  );
}
