
import 'dart:convert';

class Recipe {
    Recipe({
        required this.category,
        required this.desc,
        this.img,
        required this.name,
        required this.steps,
        required this.user,
        required this.id,
    });

    String category;
    String desc;
    String? img;
    String name;
    String steps;
    String user;
    String id;

    factory Recipe.fromJson(String str) => Recipe.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Recipe.fromMap(Map<String, dynamic> json) => Recipe(
        category: json["category"],
        desc: json["desc"],
        img: json["img"],
        name: json["name"],
        steps: json["steps"],
        user: json["user"], id: '',
    );

    Map<String, dynamic> toMap() => {
        "category": category,
        "desc": desc,
        "img": img,
        "name": name,
        "steps": steps,
        "user": user,
    };
}
