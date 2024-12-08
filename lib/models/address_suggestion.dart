class AddressSuggestion {
  final String id;
  final String text;
  final String highlight;
  final int cursor;
  final String description;
  final String next;

  AddressSuggestion({
    required this.id,
    required this.text,
    required this.highlight,
    required this.cursor,
    required this.description,
    required this.next,
  });

  factory AddressSuggestion.fromJson(Map<String, dynamic> json) {
    return AddressSuggestion(
      id: json['Id'] ?? '',
      text: json['Text'] ?? '',
      highlight: json['Highlight'] ?? '',
      cursor: json['Cursor'] as int? ?? 0,
      description: json['Description'] ?? '',
      next: json['Next'] ?? '',
    );
  }
} 