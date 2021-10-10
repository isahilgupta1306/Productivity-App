// To parse this JSON data, do
//
//     final meaningModelOwlBot = meaningModelOwlBotFromJson(jsonString);

import 'dart:convert';

MeaningModelOwlBot meaningModelOwlBotFromJson(String str) =>
    MeaningModelOwlBot.fromJson(json.decode(str));

String meaningModelOwlBotToJson(MeaningModelOwlBot data) =>
    json.encode(data.toJson());

class MeaningModelOwlBot {
  MeaningModelOwlBot({
    this.pronunciation,
    this.word,
    required this.definitions,
  });

  String? pronunciation;
  String? word;
  List<Definition> definitions;

  factory MeaningModelOwlBot.fromJson(Map<String, dynamic> json) =>
      MeaningModelOwlBot(
        pronunciation: json["pronunciation"],
        word: json["word"],
        definitions: List<Definition>.from(
            json["definitions"].map((x) => Definition.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pronunciation": pronunciation,
        "word": word,
        "definitions": List<dynamic>.from(definitions.map((x) => x.toJson())),
      };
}

class Definition {
  Definition({
    this.type,
    this.definition,
    this.example,
    this.imageUrl,
    this.emoji,
  });

  String? type;
  String? definition;
  String? example;
  dynamic imageUrl;
  dynamic emoji;

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
        type: json["type"],
        definition: json["definition"],
        example: json["example"],
        imageUrl: json["image_url"],
        emoji: json["emoji"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "definition": definition,
        "example": example,
        "image_url": imageUrl,
        "emoji": emoji,
      };
}
