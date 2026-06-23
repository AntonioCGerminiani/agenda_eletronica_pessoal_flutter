import 'package:agenda_eletronica_pessoal/constants/enum/contact_sort_option.dart';
import 'package:agenda_eletronica_pessoal/controllers/contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Menu de seleção do método de organização da lista de contatos.
class ContactSortMenu extends StatelessWidget {
  const ContactSortMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // ---
    // Uso de Provider para evitar 'prop-drilling' e manter widget otimizado.
    // Assim, o widget só é renderizado novamente se o ContactController notificar uma mudança.
    final contactController = Provider.of<ContactController>(context);
    // ---

    final currentOption = contactController.sortOption;

    return PopupMenuButton<ContactSortOption>(
      icon: const Icon(Icons.sort),
      tooltip: 'Ordenar contatos',
      initialValue: currentOption,
      onSelected: (ContactSortOption selectedOption) {
        contactController.updateSortOption(selectedOption);
      },
      itemBuilder: (BuildContext context) {
        return ContactSortOption.values.map((ContactSortOption option) {
          final isSelected = option == currentOption;

          return PopupMenuItem<ContactSortOption>(
            value: option,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(option.label),
                if (isSelected)
                  Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
