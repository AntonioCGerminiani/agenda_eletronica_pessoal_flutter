import 'package:agenda_eletronica_pessoal/controllers/event_controller.dart';
import 'package:agenda_eletronica_pessoal/screens/events/components/events_sort_menu.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/custom_list_tile.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/delete_confirmation_dialog.dart';
import 'package:agenda_eletronica_pessoal/models/event.dart';
import 'package:agenda_eletronica_pessoal/screens/events/event_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Tela para listagem de eventos cadastrados
class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // ---
    // Uso de Provider para evitar 'prop-drilling' e manter widget otimizado.
    // Assim, o widget só é renderizado novamente se o EventController notificar uma mudança.
    final eventController = Provider.of<EventController>(context);
    // ---

    final events = eventController.filteredEvents;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const EventSortMenu(),
        ),
        Expanded(
          child: events.isEmpty
              ? const Center(child: Text("Nenhum evento encontrado"))
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final date = event['date'] as String?;
                    final time = event['time'] as String?;
                    final String dateAndTimeText =
                        'Marcado para $date, ${time}h';

                    return CustomListTile(
                      name: event['name'] ?? '',
                      aditionalText: dateAndTimeText,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => EventFormScreen(
                            event: Event.fromMap(event),
                            eventKey: event['key'] as int,
                          ),
                        );
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (context) => DeleteConfirmationDialog(
                            title: "Excluir Evento",
                            message: 'Tem certeza que deseja excluir o evento',
                            boldText: event['name'],
                            onConfirm: () {
                              eventController.deleteEvent(key: event['key']);
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
