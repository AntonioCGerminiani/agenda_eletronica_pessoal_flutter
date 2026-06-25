import 'package:agenda_eletronica_pessoal/controllers/group_controller.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/custom_list_tile.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agenda_eletronica_pessoal/models/group.dart';
import 'package:agenda_eletronica_pessoal/screens/groups/group_form_screen.dart';

class GroupListScreen extends StatelessWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ---
    // Uso de Provider para evitar 'prop-drilling' e manter widget otimizado.
    // Assim, o widget só é renderizado novamente se o GroupController notificar uma mudança.
    final groupController = Provider.of<GroupController>(context);
    // ---

    final groups = groupController.fetchGroups();

    if (groups.isEmpty) {
      return const Center(child: Text('Nenhum grupo encontrado'));
    }

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        final contactKeys = group['contactKeys'] as List?;
        final int count = contactKeys?.length ?? 0;
        final String participantsText =
            '$count ${count == 1 ? "contato" : "contatos"}';

        return CustomListTile(
          name: group['name'] ?? '',
          aditionalText: participantsText,
          onTap: () {
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => GroupFormScreen(
                group: Group.fromMap(group),
                groupKey: group['key'] as int,
              ),
            );
          },
          onDelete: () {
            showDialog(
              context: context,
              builder: (context) => DeleteConfirmationDialog(
                title: 'Excluir Grupo',
                message: 'Tem certeza que deseja excluir o grupo',
                boldText: group['name'],
                onConfirm: () {
                  groupController.deleteGroup(key: group['key']);
                },
              ),
            );
          },
        );
      },
    );
  }
}
