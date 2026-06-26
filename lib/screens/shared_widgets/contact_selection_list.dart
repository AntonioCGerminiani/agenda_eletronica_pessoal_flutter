import 'package:agenda_eletronica_pessoal/screens/contacts/components/dynamic_contact_avatar.dart';
import 'package:flutter/material.dart';

class ContactSelectionList extends StatelessWidget {
  final List<Map<String, dynamic>> filteredContacts;
  final List<int> selectedContactKeys;
  final bool isReadOnly;
  final Function(int contactKey, bool isSelected) onSelectionChanged;
  final String? emptyMessage;

  const ContactSelectionList({
    super.key,
    required this.filteredContacts,
    required this.selectedContactKeys,
    required this.isReadOnly,
    required this.onSelectionChanged,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 250),
      child: Material(
        color: theme.colorScheme.surfaceContainerLowest,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.dividerColor),
        ),
        child: filteredContacts.isEmpty
            ? Center(
                heightFactor: 1.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    isReadOnly
                        ? (emptyMessage ?? 'Nenhum contato adicionado')
                        : 'Nenhum contato encontrado',
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = filteredContacts[index];
                  final contactKey = contact['key'] as int;
                  final fullName =
                      '${contact['name'] ?? ''} ${contact['surname'] ?? ''}';
                  final isSelected = selectedContactKeys.contains(contactKey);

                  if (isReadOnly) {
                    return ListTile(
                      leading: DynamicContactAvatar(
                        name: contact['name'],
                        surname: contact['surname'],
                      ),
                      title: Text(fullName),
                      subtitle: Text(contact['phoneNumber'] ?? ''),
                    );
                  }

                  return CheckboxListTile(
                    activeColor: theme.colorScheme.primary,
                    title: Text(fullName),
                    subtitle: Text(contact['phoneNumber'] ?? ''),
                    value: isSelected,
                    onChanged: (bool? checked) {
                      onSelectionChanged(contactKey, checked == true);
                    },
                  );
                },
              ),
      ),
    );
  }
}
