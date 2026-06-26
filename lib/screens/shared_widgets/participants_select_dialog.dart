import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agenda_eletronica_pessoal/controllers/contact_controller.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/custom_text_field.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/contact_selection_list.dart';

class ParticipantsSelectDialog extends StatefulWidget {
  final List<int> initialSelectedKeys;

  const ParticipantsSelectDialog({
    super.key,
    required this.initialSelectedKeys,
  });

  @override
  State<ParticipantsSelectDialog> createState() =>
      _ParticipantsSelectDialogState();
}

class _ParticipantsSelectDialogState extends State<ParticipantsSelectDialog> {
  late List<int> _tempSelectedKeys;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tempSelectedKeys = List<int>.from(widget.initialSelectedKeys);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contactController = Provider.of<ContactController>(context);
    final allContacts = contactController.fetchContacts();

    final filteredContacts = allContacts.where((contact) {
      final fullName = '${contact['name'] ?? ''} ${contact['surname'] ?? ''}'
          .toLowerCase();
      return fullName.contains(_searchQuery.toLowerCase());
    }).toList();

    final mediaQuery = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQuery.copyWith(
        viewInsets: mediaQuery.viewInsets.copyWith(bottom: 0),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Selecionar Participantes'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    labelText: 'Buscar contatos para adicionar...',
                    prefixIcon: Icons.search,
                    filled: true,
                    fillColor: Colors.white,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  ContactSelectionList(
                    filteredContacts: filteredContacts,
                    selectedContactKeys: _tempSelectedKeys,
                    isReadOnly: false,
                    emptyMessage: 'Nenhum contato encontrado',
                    onSelectionChanged: (contactKey, isSelected) {
                      setState(() {
                        if (isSelected) {
                          _tempSelectedKeys.add(contactKey);
                        } else {
                          _tempSelectedKeys.remove(contactKey);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_tempSelectedKeys);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
