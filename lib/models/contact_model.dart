import 'dart:convert';


class ContactModel {
  
  final int? id;
  final String name;
  final String email;

  ContactModel({
    this.id,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      "id":  id, // DateTime.now().microsecondsSinceEpoch, // id,
      "name": name,
      "email": email,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map["id"],
      name: map["name"] ?? "",
      email: map["email"] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) => ContactModel.fromMap(json.decode(source));
}
