// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'dart:convert';

class User {
    User({
        required this.id,
        required this.username,
        required this.email,
        required this.password,
        required this.admin, 
        required this.description,
        required this.urlImg,
    });

    int? id;
    String? username;
    String? description;
    String? email;
    String? password;
    String? urlImg;
    bool? admin;

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        description: json["description"],
        urlImg: json["urlImg"],
        email: json["email"],
        password: json["password"],
        admin: json["admin"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "description": description,
        "urlImg": urlImg,
        "email": email,
        "password": password,
        "admin": admin,
    };
}
