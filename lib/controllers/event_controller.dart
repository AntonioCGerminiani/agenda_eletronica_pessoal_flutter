import 'package:agenda_eletronica_pessoal/constants/enum/event_sort_option.dart';
import 'package:agenda_eletronica_pessoal/constants/enum/yes_no.dart';
import 'package:agenda_eletronica_pessoal/models/event.dart';
import 'package:agenda_eletronica_pessoal/services/notification_service.dart';
import 'package:agenda_eletronica_pessoal/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// Controller para objetos "Eventos".
// Conta com definições padrão para CRUD e listagem de eventos
class EventController extends ChangeNotifier {
  final Box hiveBox;
  final ToastService toastService;
  final NotificationService notificationService;

  EventController({
    required this.hiveBox,
    required this.toastService,
    required this.notificationService,
  });

  EventSortOption _sortOption = EventSortOption.eventDateAsc;

  //Getter da opção de ordenação atual
  EventSortOption get sortOption => _sortOption;

  void updateSortOption(EventSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  // Função para recuperar todos os eventos.
  // Retorna um list[] com todos os registros encontrados.
  List<Map<String, dynamic>> fetchEvents() {
    return hiveBox.keys
        .map((key) {
          final event = hiveBox.get(key);
          return {
            'key': key,
            'name': event['name'],
            'date': event['date'],
            'time': event['time'],
            'contactKeys': event['contactKeys'],
            'reminderMinutes': event['reminderMinutes'],
            'createdAt': event['createdAt'],
            'lastUpdate': event['lastUpdate'],
          };
        })
        .toList()
        .reversed
        .toList();
  }

  // Helper para converter Strings de data (dd/MM/yyyy) e hora (HH:mm) em DateTime
  DateTime? _parseEventDateTime(String? dateStr, String? timeStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    final dateParts = dateStr.split('/');
    if (dateParts.length != 3) return null;

    final day = int.tryParse(dateParts[0]) ?? 1;
    final month = int.tryParse(dateParts[1]) ?? 1;
    final year = int.tryParse(dateParts[2]) ?? 2000;

    int hour = 0;
    int minute = 0;
    if (timeStr != null && timeStr.isNotEmpty) {
      final timeParts = timeStr.split(':');
      if (timeParts.length == 2) {
        hour = int.tryParse(timeParts[0]) ?? 0;
        minute = int.tryParse(timeParts[1]) ?? 0;
      }
    }
    return DateTime(year, month, day, hour, minute);
  }

  // Getter para os eventos filtrados
  List<Map<String, dynamic>> get filteredEvents {
    final allEvents = fetchEvents();

    switch (_sortOption) {
      case EventSortOption.eventDateAsc:
        // Data do evento - crescente
        allEvents.sort((a, b) {
          final dateA =
              _parseEventDateTime(a['date'], a['time']) ?? DateTime(2000);
          final dateB =
              _parseEventDateTime(b['date'], b['time']) ?? DateTime(2000);
          return dateA.compareTo(dateB);
        });
        return allEvents;
      case EventSortOption.eventDateDesc:
        // Data do evento - decrescente
        allEvents.sort((a, b) {
          final dateA =
              _parseEventDateTime(a['date'], a['time']) ?? DateTime(2000);
          final dateB =
              _parseEventDateTime(b['date'], b['time']) ?? DateTime(2000);
          return dateB.compareTo(dateA);
        });
        return allEvents;
      case EventSortOption.futureEvents:
        // Eventos futuros
        final now = DateTime.now();
        return allEvents.where((event) {
          final eventDateTime = _parseEventDateTime(
            event['date'],
            event['time'],
          );
          return eventDateTime != null && eventDateTime.isAfter(now);
        }).toList();
      case EventSortOption.pastEvents:
        // Eventos passados
        final now = DateTime.now();
        return allEvents.where((event) {
          final eventDateTime = _parseEventDateTime(
            event['date'],
            event['time'],
          );
          return eventDateTime != null && eventDateTime.isBefore(now);
        }).toList();
    }
  }

  // ---------------------- v CRUD v ----------------------

  // Cria um novo Evento no Hive
  Future<void> createEvent({required Event event}) async {
    try {
      // Event >> Map e salva
      int key = await hiveBox.add(event.toMap());

      // Define as notificações de lembrete do evento
      await notificationService.scheduleEventNotifications(event, key);

      // Invoca um toast de sucesso
      toastService.notifyAfterAction(null, 'criar', YesNo.yes);
    } catch (e) {
      // Invoca um toast de erro
      toastService.notifyAfterAction(null, 'criar', YesNo.no);
    } finally {
      // Provider para atualização dinâmica da tela
      notifyListeners();
    }
  }

  // Edita um Evento, identificação por uma eventKey
  Future<void> editEvent({required Event event, required int eventKey}) async {
    try {
      // Event >> Map, busca pela itemKey correspondente e então atualiza o registro
      hiveBox.put(eventKey, event.toMap());

      // Atualiza as notificações de lembrete do evento
      await notificationService.scheduleEventNotifications(event, eventKey);

      // Invoca um toast de sucesso
      toastService.notifyAfterAction(null, 'editar', YesNo.yes);
    } catch (e) {
      // Invoca um toast de erro
      toastService.notifyAfterAction(null, 'editar', YesNo.no);
    } finally {
      // Provider para atualização dinâmica da tela
      notifyListeners();
    }
  }

  // Deleta um Evento, identificação por uma eventKey
  Future<void> deleteEvent({required int key}) async {
    try {
      // Cancela as notificações de lembrete do evento
      notificationService.cancelEventNotifications(key);

      // Remove o item de acordo com a key fornecida
      await hiveBox.delete(key);

      // Invoca um toast de sucesso
      toastService.notifyAfterAction(null, 'deletar', YesNo.yes);
    } catch (e) {
      // Invoca um toast de erro
      toastService.notifyAfterAction(null, 'deletar', YesNo.no);
    } finally {
      // Provider para atualização dinâmica da tela
      notifyListeners();
    }
  }

  // Limpa o armazenamento do Hive
  Future<void> clearEvents() async {
    try {
      // Deleção completa dos dados
      await hiveBox.clear();
      // Invoca um toast de sucesso
      toastService.notifyAfterAction(null, 'limpar', YesNo.yes);
    } catch (e) {
      // Invoca um toast de erro
      toastService.notifyAfterAction(null, 'limpar', YesNo.no);
    } finally {
      // Provider para atualização dinâmica da tela
      notifyListeners();
    }
  }
}
