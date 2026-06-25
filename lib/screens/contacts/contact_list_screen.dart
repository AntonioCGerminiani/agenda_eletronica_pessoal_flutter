import 'package:agenda_eletronica_pessoal/controllers/contact_controller.dart';
import 'package:agenda_eletronica_pessoal/models/contact.dart';
import 'package:agenda_eletronica_pessoal/screens/contacts/contact_form_screen.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/custom_list_tile.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/delete_confirmation_dialog.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/custom_text_field.dart';
import 'package:agenda_eletronica_pessoal/screens/contacts/components/contact_sort_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Tela de istagem de contatos salvos
class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- 
    // Uso de Provider para evitar 'prop-drilling' e manter widget otimizado.
    // Assim, o widget só é renderizado novamente se o ContactController notificar uma mudança.
    final contactController = Provider.of<ContactController>(context);
    // ---
    
    final contacts = contactController.filteredContacts;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: CustomTextField(
                  labelText: 'Buscar contatos',
                  prefixIcon: Icons.search,
                  onChanged: (value) =>
                      contactController.updateSearchQuery(value),
                ),
              ),
              const SizedBox(width: 8),
              const ContactSortMenu(),
            ],
          ),
        ),
        Expanded(
          child: contacts.isEmpty
              ? const Center(child: Text('Nenhum contato encontrado'))
              : ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    final fullName = '${contact['name']} ${contact['surname']}';

                    return CustomListTile(
                      name: fullName,
                      aditionalText: contact['phoneNumber'] ?? '',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ContactFormScreen(
                            contact: Contact.fromMap(contact),
                            contactKey: contact['key'] as int,
                          ),
                        );
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (context) => DeleteConfirmationDialog(
                            title: 'Excluir Contato',
                            message: 'Tem certeza que deseja excluir o contato',
                            boldText: fullName,
                            onConfirm: () {
                              contactController.deleteContact(
                                key: contact['key'],
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
