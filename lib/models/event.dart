import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String name;
  final String date;
  final String time;
  final List<int> contactKeys;
  final List<int> reminderMinutes;
  final String createdAt;
  final String lastUpdate;

  Event({
    required this.name,
    required this.date,
    required this.time,
    required this.contactKeys,
    List<int>? reminderMinutes,
    String? createdAt,
    String? lastUpdate,
  }) : reminderMinutes = reminderMinutes ?? const [],
       createdAt = createdAt ?? DateTime.now().toIso8601String(),
       lastUpdate = lastUpdate ?? DateTime.now().toIso8601String();

  @override
  List<Object> get props => [
    name,
    date,
    time,
    contactKeys,
    reminderMinutes,
    createdAt,
    lastUpdate,
  ];

  // Event >> Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'time': time,
      'contactKeys': contactKeys,
      'reminderMinutes': reminderMinutes,
      'createdAt': createdAt,
      'lastUpdate': lastUpdate,
    };
  }

  // Map >> Event
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      name: map['name'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      contactKeys: List<int>.from(map['contactKeys'] ?? []),
      reminderMinutes: List<int>.from(map['reminderMinutes'] ?? []),
      createdAt: map['createdAt'] ?? '',
      lastUpdate: map['lastUpdate'] ?? '',
    );
  }

  Event copyWith({
    String? name,
    String? date,
    String? time,
    List<int>? contactKeys,
    List<int>? reminderMinutes,
    String? createdAt,
    String? lastUpdate,
  }) {
    return Event(
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
      contactKeys: contactKeys ?? this.contactKeys,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      createdAt: createdAt ?? this.createdAt,
      lastUpdate: lastUpdate ?? DateTime.now().toIso8601String(),
    );
  }

  /// Converte a data e hora do evento em um objeto DateTime
  DateTime? get dateTime {
    final dateParts = date.split('/');
    if (dateParts.length != 3) return null;
    
    final day = int.tryParse(dateParts[0]) ?? 1;
    final month = int.tryParse(dateParts[1]) ?? 1;
    final year = int.tryParse(dateParts[2]) ?? 2000;

    int hour = 0;
    int minute = 0;
    if (time.isNotEmpty) {
      final timeParts = time.split(':');
      if (timeParts.length == 2) {
        hour = int.tryParse(timeParts[0]) ?? 0;
        minute = int.tryParse(timeParts[1]) ?? 0;
      }
    }
    return DateTime(year, month, day, hour, minute);
  }
}
