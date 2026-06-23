import 'package:agenda_eletronica_pessoal/constants/enum/event_sort_option.dart';
import 'package:agenda_eletronica_pessoal/controllers/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Widget que exibe o menu suspenso para ordenação dos eventos
class EventSortMenu extends StatelessWidget {
  const EventSortMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // ---
    // Uso de Provider para evitar 'prop-drilling' e manter widget otimizado.
    // Assim, o widget só é reconstruído se o EventController notificar uma mudança.
    final eventController = Provider.of<EventController>(context);
    final currentOption = eventController.sortOption;
    // ---

    return PopupMenuButton<EventSortOption>(
      tooltip: 'Ordenar eventos',
      initialValue: currentOption,
      onSelected: (EventSortOption selectedOption) {
        eventController.updateSortOption(selectedOption);
      },
      itemBuilder: (BuildContext context) {
        return EventSortOption.values.map((EventSortOption option) {
          final isSelected = option == currentOption;

          return PopupMenuItem<EventSortOption>(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentOption.label,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.sort),
          ],
        ),
      ),
    );
  }
}
