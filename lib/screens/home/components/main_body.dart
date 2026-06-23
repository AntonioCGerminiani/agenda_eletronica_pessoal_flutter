import 'package:agenda_eletronica_pessoal/screens/events/event_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:agenda_eletronica_pessoal/screens/contacts/contact_list_screen.dart';
import 'package:agenda_eletronica_pessoal/screens/groups/group_list_screen.dart';

/// Widget que gerencia o conteúdo principal (TabBarView) da home
Widget buildBody(
  TabController tabController,
) {
  return TabBarView(
    controller: tabController,
    children: [
      // Aba 0: Contatos
      const ContactListScreen(),

      // Aba 1: Grupos
      const GroupListScreen(),

      // Aba 2: Eventos
      const EventListScreen(),
    ],
  );
}
