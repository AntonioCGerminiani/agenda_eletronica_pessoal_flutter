import 'package:agenda_eletronica_pessoal/controllers/contact_controller.dart';
import 'package:agenda_eletronica_pessoal/models/contact.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:agenda_eletronica_pessoal/utils/phone_input_formatter.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/modal_bottom_sheet_layout.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/bottom_sheet_header.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/form_action_buttons.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/record_metadata_text.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact? contact;
  final int? contactKey;

  const ContactFormScreen({super.key, this.contact, this.contactKey});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late bool _isReadOnly;

  bool get _isEditing => widget.contact != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _surnameController = TextEditingController(
      text: widget.contact?.surname ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.contact?.phoneNumber ?? '',
    );
    _emailController = TextEditingController(text: widget.contact?.email ?? '');
    _isReadOnly = widget.contact != null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _resetForm() {
    if (widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _surnameController.text = widget.contact!.surname;
      _phoneController.text = widget.contact!.phoneNumber;
      _emailController.text = widget.contact!.email;
    }
    setState(() {
      _isReadOnly = true;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    
    // --- 
    // Uso de Provider para evitar 'prop-drilling' e manter widget otimizado.
    // "listen: false": widget não é reconstruído conforme ContactController atualiza,
    // somente utiliza a instância para realizar uma ação pontual.
    final contactController = Provider.of<ContactController>(
      context,
      listen: false,
    );
    // ---

    if (_isEditing) {
      final updatedContact = widget.contact!.copyWith(
        name: name,
        surname: surname,
        phoneNumber: phone,
        email: email,
      );
      contactController.editContact(
        contact: updatedContact,
        contactKey: widget.contactKey!,
      );
    } else {
      final newContact = Contact(
        name: name,
        surname: surname,
        phoneNumber: phone,
        email: email,
      );
      contactController.createContact(contact: newContact);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Título e ícone dinâmicos baseados no estado de visualização/edição/adição
    String titleText;
    IconData headerIcon;
    if (_isReadOnly) {
      titleText = 'Detalhes do Contato';
      headerIcon = Icons.contact_phone_outlined;
    } else if (_isEditing) {
      titleText = 'Editar Contato';
      headerIcon = Icons.edit_outlined;
    } else {
      titleText = 'Novo Contato';
      headerIcon = Icons.person_add_alt_1_outlined;
    }

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
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Nome',
                      prefixIcon: Icons.person_outline,
                      readOnly: _isReadOnly,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Insira o nome';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _surnameController,
                      labelText: 'Sobrenome',
                      prefixIcon: Icons.badge_outlined,
                      readOnly: _isReadOnly,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Insira o sobrenome';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneController,
                      labelText: 'Telefone',
                      prefixIcon: Icons.phone_outlined,
                      readOnly: _isReadOnly,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Insira o telefone';
                        }
                        if (value.length < 15) {
                          return 'Insira um telefone válido no formato (00) 00000-0000';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PhoneInputFormatter(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'E-mail',
                      prefixIcon: Icons.mail_outlined,
                      readOnly: _isReadOnly,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Insira o e-mail';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Insira um e-mail válido';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _isReadOnly ? null : _submit(),
                    ),
                    const SizedBox(height: 10),

                    RecordMetadataText(
                      createdAt: widget.contact?.createdAt,
                      updatedAt: widget.contact?.lastUpdate,
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
