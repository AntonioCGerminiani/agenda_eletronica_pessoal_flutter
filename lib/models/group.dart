import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String name;
  final String createdAt;
  final String lastUpdate;
  final List<int> contactKeys;

  Group({
    required this.name,
    this.contactKeys = const [],
    String? createdAt,
    String? lastUpdate,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String(),
       lastUpdate = lastUpdate ?? DateTime.now().toIso8601String();

  @override
  List<Object> get props => [name, createdAt, lastUpdate];

  // ContactGroup >> Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contactKeys': contactKeys,
      'createdAt': createdAt,
      'lastUpdate': lastUpdate,
    };
  }

  // Map >> ContactGroup
  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      name: map['name'] ?? '',
      contactKeys: List<int>.from(map['contactKeys'] ?? []),
      createdAt: map['createdAt'] ?? '',
      lastUpdate: map['lastUpdate'] ?? '',
    );
  }

  // ContactGroup >> copyWith
  Group copyWith({
    String? name,
    List<int>? contactKeys,
    String? createdAt,
    String? lastUpdate,
  }) {
    return Group(
      name: name ?? this.name,
      contactKeys: contactKeys ?? this.contactKeys,
      createdAt: createdAt ?? this.createdAt,
      lastUpdate: lastUpdate ?? DateTime.now().toIso8601String(),
    );
  }
}
