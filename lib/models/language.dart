class Language {
  final String id;
  final String name;
  final String nativeName;
  final String flagEmoji;
  final String code; // e.g. es, fr, de, ja, it
  final String ttsLocale; // e.g. es-ES, fr-FR, de-DE, ja-JP, it-IT
  final String description;
  final String greeting;

  const Language({
    required this.id,
    required this.name,
    required this.nativeName,
    required this.flagEmoji,
    required this.code,
    required this.ttsLocale,
    required this.description,
    required this.greeting,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'nativeName': nativeName,
    'flagEmoji': flagEmoji,
    'code': code,
    'ttsLocale': ttsLocale,
    'description': description,
    'greeting': greeting,
  };

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    id: json['id'] as String,
    name: json['name'] as String,
    nativeName: json['nativeName'] as String,
    flagEmoji: json['flagEmoji'] as String,
    code: json['code'] as String,
    ttsLocale: json['ttsLocale'] as String,
    description: json['description'] as String,
    greeting: json['greeting'] as String,
  );
}
