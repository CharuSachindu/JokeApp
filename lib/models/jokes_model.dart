// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Joke {
  final String? category;
  final String? type;
  final String? setup;
  final String? delivery;
  final int? id;

  Joke({
    this.category,
    this.type,
    this.setup,
    this.delivery,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category,
      'type': type,
      'setup': setup,
      'delivery': delivery,
      'id': id,
    };
  }

  factory Joke.fromMap(Map<String, dynamic> map) {
    return Joke(
      category: map['category'] != null ? map['category'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      setup: map['setup'] != null ? map['setup'] as String : null,
      delivery: map['delivery'] != null ? map['delivery'] as String : null,
      id: map['id'] != null ? map['id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Joke.fromJson(String source) =>
      Joke.fromMap(json.decode(source) as Map<String, dynamic>);
}
