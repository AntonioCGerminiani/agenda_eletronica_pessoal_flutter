import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agenda_eletronica_pessoal/controllers/contact_controller.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/participants_select_dialog.dart';
import 'package:agenda_eletronica_pessoal/screens/contacts/components/dynamic_contact_avatar.dart';

class ParticipantsSelector extends StatelessWidget {
  final List<int> selectedContactKeys;
  final bool isReadOnly;
  final ValueChanged<List<int>> onChanged;

  const ParticipantsSelector({
    super.key,
    required this.selectedContactKeys,
    required this.isReadOnly,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contactController = Provider.of<ContactController>(context);
    final allContacts = contactController.fetchContacts();

    // Map keys to actual contact objects
    final selectedContacts = allContacts.where((c) {
      return selectedContactKeys.contains(c['key']);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Participantes do Evento (${selectedContactKeys.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            if (!isReadOnly)
              IconButton(
                icon: Icon(
                  Icons.person_add_alt_1_outlined,
                  color: theme.primaryColor,
                ),
                tooltip: 'Adicionar participantes',
                onPressed: () async {
                  final List<int>? result = await showDialog<List<int>>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => ParticipantsSelectDialog(
                      initialSelectedKeys: selectedContactKeys,
                    ),
                  );
                  if (result != null) {
                    onChanged(result);
                  }
                },
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (selectedContactKeys.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Nenhum participante adicionado.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedContacts.map((contact) {
              final contactKey = contact['key'] as int;
              final name = contact['name'] ?? '';
              final surname = contact['surname'] ?? '';
              final fullName = '$name $surname'.trim();

              return Chip(
                avatar: SizedBox(
                  width: 34,
                  height: 34,
                  child: DynamicContactAvatar(name: name, surname: surname),
                ),
                label: Text(fullName),
                onDeleted: isReadOnly
                    ? null
                    : () {
                        final newList = List<int>.from(selectedContactKeys)
                          ..remove(contactKey);
                        onChanged(newList);
                      },
                deleteIconColor: Colors.redAccent,
                backgroundColor: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
