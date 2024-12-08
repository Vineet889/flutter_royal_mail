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

  Map<String, String> parseAddressComponents() {
    final components = text.split(',').map((s) => s.trim()).toList();
    
    String line1 = '';
    String line2 = '';
    String city = '';
    String postcode = '';

    if (components.length >= 4) {
      line1 = '${components[0]}, ${components[1]}';
      
      final thirdPartWords = components[2].trim().split(' ');
      if (thirdPartWords.length > 1) {
        city = thirdPartWords.last;
        line2 = thirdPartWords.take(thirdPartWords.length - 1).join(' ');
      }
      
      postcode = components[3].trim();
    }

    return {
      'line1': line1,
      'line2': line2,
      'city': city,
      'postcode': postcode,
    };
  }

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