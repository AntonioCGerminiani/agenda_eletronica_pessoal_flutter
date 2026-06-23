enum ReminderOption {
  atTime(0, 'No momento do evento'),
  fiveMinutes(5, '5 minutos antes'),
  fifteenMinutes(15, '15 minutos antes'),
  thirtyMinutes(30, '30 minutos antes'),
  oneHour(60, '1 hora antes'),
  twoHours(120, '2 horas antes'),
  oneDay(1440, '1 dia antes');

  final int minutes;
  final String label;

  const ReminderOption(this.minutes, this.label);

  /// Retorna o enum correspondente a partir de um valor de minutos
  static ReminderOption fromMinutes(int minutes) {
    return ReminderOption.values.firstWhere(
      (opt) => opt.minutes == minutes,
      orElse: () => ReminderOption.atTime,
    );
  }
}