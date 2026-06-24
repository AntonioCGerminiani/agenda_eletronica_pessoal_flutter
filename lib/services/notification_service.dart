import 'dart:async';

import 'package:agenda_eletronica_pessoal/models/event.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Inicializar fusos horários para timezone
    tz.initializeTimeZones();

    // 2. Configurações para Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 3. Configurações para iOS
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // 4. Configurações globais de inicialização
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Abrir notificação');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      linux: initializationSettingsLinux,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Tratar clique na notificação se necessário
      },
    );

    // 4. Solicitar permissões no Android (Android 13+)
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();

    // 6. Solicitar permissões no iOS
    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Função para agendar um lembrete específico
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final tz.TZDateTime tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    // Evita agendar notificações para o passado
    if (tzDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    try {
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'agenda_channel_id',
            'Lembretes da Agenda',
            channelDescription:
                'Canal de notificações para lembrete de eventos',
            importance: Importance.max,
            priority: Priority.high,
          ),
          linux: LinuxNotificationDetails(),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      if (e is UnimplementedError) {
        // Fallback for platforms that do not support zonedSchedule (e.g. Linux)
        // using an in-memory Timer. It only works while the app is open.
        final duration = scheduledDate.difference(DateTime.now());
        if (duration.isNegative) return;
        Timer(duration, () {
          _notificationsPlugin.show(
            id: id,
            title: title,
            body: body,
            notificationDetails: const NotificationDetails(
              linux: LinuxNotificationDetails(),
            ),
          );
        });
      } else {
        rethrow;
      }
    }
  }

  // Cancela todas as notificações de um evento específico
  Future<void> cancelEventNotifications(int eventKey) async {
    for (int i = 0; i < 3; i++) {
      int notificationId = (eventKey * 10) + i;
      await _notificationsPlugin.cancel(id: notificationId);
    }
  }

  /// Reagenda todas as notificações referentes a um evento
  Future<void> scheduleEventNotifications(Event event, int eventKey) async {
    // 1. Cancelar agendamentos anteriores
    await cancelEventNotifications(eventKey);

    // 2. Tentar obter a data/hora do evento
    final eventDateTime = event.dateTime;
    if (eventDateTime == null) return;

    // 3. Agendar cada um dos lembretes configurados
    for (int i = 0; i < event.reminderMinutes.length; i++) {
      final minutesBefore = event.reminderMinutes[i];
      final notificationTime = eventDateTime.subtract(
        Duration(minutes: minutesBefore),
      );
      final notificationId = (eventKey * 10) + i;

      String bodyMessage = minutesBefore == 0
          ? "Seu evento '${event.name}' está começando agora!"
          : "Seu evento '${event.name}' começa em $minutesBefore minutos.";

      await scheduleNotification(
        id: notificationId,
        title: "Lembrete de Compromisso",
        body: bodyMessage,
        scheduledDate: notificationTime,
      );
    }
  }
}
