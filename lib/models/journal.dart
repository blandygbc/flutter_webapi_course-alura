import 'dart:convert';

import 'package:uuid/uuid.dart';

class Journal {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;

  Journal({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  @override
  String toString() {
    return "Content: $content\ncreated_at: $createdAt\nupdated_at:$updatedAt\nuserId: $userId";
  }

  Journal.empty({DateTime? showedDate, required this.userId})
      : id = const Uuid().v4(),
        content = "",
        createdAt = showedDate ?? DateTime.now(),
        updatedAt = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'userId': userId,
    };
  }

  factory Journal.fromMap(Map<String, dynamic> map) {
    return Journal(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      userId: map['userId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Journal.fromJson(String source) =>
      Journal.fromMap(json.decode(source));
}
