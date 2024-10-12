// group_model.dart
class Group {
  String id;
  String title;
  String state;
  String description;
  List<String> participants;

  Group({
    required this.id,
    required this.title,
    required this.state,
    required this.description,
    required this.participants,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'state': state,
      'description': description,
      'participants': participants,
    };
  }

  static Group fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      title: map['title'],
      state: map['state'],
      description: map['description'],
      participants: List<String>.from(map['participants']),
    );
  }
}
