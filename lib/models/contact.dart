import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  final String name;
  final String surname;
  final String phoneNumber;
  final String email;
  final String createdAt;
  final String lastUpdate;

  Contact({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.surname,
    String? createdAt,
    String? lastUpdate,
    })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        lastUpdate = lastUpdate ?? DateTime.now().toIso8601String();

  @override
  List<Object> get props => [
    name,
    surname,
    phoneNumber,
    email,
    createdAt,
    lastUpdate,
  ];

  // Contact >> Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'email': email,
      'createdAt': createdAt,
      'lastUpdate': lastUpdate,
    };
  }

  // Map >> Contact
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['createdAt'] ?? '',
      lastUpdate: map['lastUpdate'] ?? '',
    );
  }

  Contact copyWith({
    String? name,
    String? surname,
    String? phoneNumber,
    String? email,
    String? createdAt,
    String? lastUpdate,
  }) {
    return Contact(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      lastUpdate: lastUpdate ?? DateTime.now().toIso8601String(),
    );
  }
}
