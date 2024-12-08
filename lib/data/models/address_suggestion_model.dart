import '../../domain/entities/address_suggestion.dart';

class AddressSuggestionModel extends AddressSuggestion {
  const AddressSuggestionModel({
    required super.id,
    required super.text,
    required super.highlight,
    required super.cursor,
    required super.description,
    required super.next,
  });

  factory AddressSuggestionModel.fromJson(Map<String, dynamic> json) {
    return AddressSuggestionModel(
      id: json['Id'] ?? '',
      text: json['Text'] ?? '',
      highlight: json['Highlight'] ?? '',
      cursor: json['Cursor'] as int? ?? 0,
      description: json['Description'] ?? '',
      next: json['Next'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Text': text,
      'Highlight': highlight,
      'Cursor': cursor,
      'Description': description,
      'Next': next,
    };
  }
}
