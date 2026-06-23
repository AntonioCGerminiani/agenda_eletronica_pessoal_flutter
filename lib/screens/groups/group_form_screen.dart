import 'package:agenda_eletronica_pessoal/controllers/contact_controller.dart';
import 'package:agenda_eletronica_pessoal/controllers/group_controller.dart';
import 'package:agenda_eletronica_pessoal/models/group.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agenda_eletronica_pessoal/screens/shared_widgets/modal_bottom_sheet_layout.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/bottom_sheet_header.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/form_action_buttons.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/record_metadata_text.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/contact_selection_list.dart';

class GroupFormScreen extends StatefulWidget {
  final Group? group;
  final int? groupKey;

  const GroupFormScreen({super.key, this.group, this.groupKey});

  @override
  State<GroupFormScreen> createState() => _GroupFormScreenState();
}

class _GroupFormScreenState extends State<GroupFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  // Lista local para gerenciar os contatos selecionados durante a edição do formulário
  late List<int> _selectedContactKeys;
  late bool _isReadOnly;

  // Termo de busca local para filtrar contatos na listagem interna
  String _contactSearchQuery = '';

  bool get _isEditing => widget.group != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group?.name ?? '');

    // Inicializa a lista de selecionados clonando do grupo existente ou vazia se for novo
    _selectedContactKeys = widget.group != null
        ? List<int>.from(widget.group!.contactKeys)
        : [];

    _isReadOnly = widget.group != null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Restaura o formulário para os valores originais caso o usuário cancele a edição
  void _resetForm() {
    if (widget.group != null) {
      _nameController.text = widget.group!.name;
      _selectedContactKeys = List<int>.from(widget.group!.contactKeys);
    }
    setState(() {
      _isReadOnly = true;
    });
  }

  // Salva ou atualiza o grupo no banco
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();

    // ---
    // Uso de Provider para evitar 'prop-drilling' e manter widget otimizado.
    // "listen: false": widget não é reconstruído conforme GroupController atualiza,
    // somente utiliza a instância para realizar uma ação pontual.
    final groupController = Provider.of<GroupController>(
      context,
      listen: false,
    );
    // ---

    if (_isEditing) {
      final updatedGroup = widget.group!.copyWith(
        name: name,
        contactKeys: _selectedContactKeys,
      );
      groupController.editGroup(
        group: updatedGroup,
        groupKey: widget.groupKey!,
      );
    } else {
      final newGroup = Group(name: name, contactKeys: _selectedContactKeys);
      groupController.createGroup(group: newGroup);
    }
  }

  List<Map<String, dynamic>> _getFilteredContacts(
    List<Map<String, dynamic>> allContacts,
  ) {
    return allContacts.where((contact) {
      final contactKey = contact['key'] as int;

      if (_isReadOnly && !_selectedContactKeys.contains(contactKey)) {
        return false;
      }

      final fullName = '${contact['name'] ?? ''} ${contact['surname'] ?? ''}'
          .toLowerCase();
      return fullName.contains(_contactSearchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Definição dinâmica do título e ícone
    String titleText;
    IconData headerIcon;
    if (_isReadOnly) {
      titleText = 'Detalhes do Grupo';
      headerIcon = Icons.group_outlined;
    } else if (_isEditing) {
      titleText = 'Editar Grupo';
      headerIcon = Icons.edit_outlined;
    } else {
      titleText = 'Novo Grupo';
      headerIcon = Icons.group_add_outlined;
    }

    // ---
    // Uso de Provider para evitar 'prop-drilling' e manter widget otimizado.
    // Assim, o widget só é renderizado novamente se o ContactController notificar uma mudança.
    final contactController = Provider.of<ContactController>(context);
    // ---

    // Acessa todos os contatos cadastrados no app via ContactController
    final allContacts = contactController.fetchContacts();
    final filteredContacts = _getFilteredContacts(allContacts);

    return ModalBottomSheetLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetHeader(icon: headerIcon, title: titleText),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Nome do Grupo',
                      prefixIcon: Icons.group_work_outlined,
                      readOnly: _isReadOnly,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Insira o nome do grupo';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Selecionar Participantes (${_selectedContactKeys.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (!_isReadOnly) ...[
                      CustomTextField(
                        labelText: 'Buscar contatos para adicionar...',
                        prefixIcon: Icons.search,
                        onChanged: (val) {
                          setState(() {
                            _contactSearchQuery = val;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    ContactSelectionList(
                      filteredContacts: filteredContacts,
                      selectedContactKeys: _selectedContactKeys,
                      isReadOnly: _isReadOnly,
                      emptyMessage: 'Nenhum contato adicionado ao grupo',
                      onSelectionChanged: (contactKey, isSelected) {
                        setState(() {
                          if (isSelected) {
                            _selectedContactKeys.add(contactKey);
                          } else {
                            _selectedContactKeys.remove(contactKey);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    RecordMetadataText(
                      createdAt: widget.group?.createdAt,
                      updatedAt: widget.group?.lastUpdate,
                      isReadOnly: _isReadOnly,
                      isEditing: _isEditing,
                    ),
                    FormActionButtons(
                      isReadOnly: _isReadOnly,
                      isEditing: _isEditing,
                      onClose: () => Navigator.of(context).pop(),
                      onEdit: () {
                        setState(() {
                          _isReadOnly = false;
                        });
                      },
                      onCancel: () {
                        if (_isEditing) {
                          _resetForm();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      onSubmit: _submit,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
