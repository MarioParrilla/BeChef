
import 'dart:convert';

class Recipe {
    Recipe({
        required this.id,
        required this.idAutor,
        required this.name,
        required this.description,
        required this.category,
        required this.steps,
        this.urlImg,
    });

    int id;
    int idAutor;
    String name;
    String description;
    String category;
    String steps;
    String? urlImg;

    factory Recipe.fromJson(String str) => Recipe.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Recipe.fromMap(Map<String, dynamic> json) => Recipe(
        id: json["id"],
        idAutor: json["id_autor"],
        name: json["name"],
        description: json["description"],
        category: json["category"],
        steps: json["steps"], 
        urlImg: json["urlImg"]
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "id_autor": idAutor,
        "name": name,
        "description": description,
        "category": category,
        "steps": steps,
        "urlImg": urlImg
    };
    
}
