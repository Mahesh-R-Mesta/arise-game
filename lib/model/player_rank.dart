// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlayerRank {
  final String id;
  final String name;
  final int amount;
  PlayerRank({
    required this.id,
    required this.name,
    required this.amount,
  });
  PlayerRank copyWith({
    String? id,
    String? name,
    int? amount,
  }) {
    return PlayerRank(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'score': amount,
    };
  }

  factory PlayerRank.fromMap(Map<String, dynamic> map) {
    return PlayerRank(
      id: map['id'] as String,
      name: map['name'] as String,
      amount: map['score'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerRank.fromJson(String source) => PlayerRank.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PlayerRank(id: $id, name: $name, score: $amount)';

  @override
  bool operator ==(covariant PlayerRank other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.amount == amount;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ amount.hashCode;
}
