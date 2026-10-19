class UserProfile {
  final String name;
  final int age;
  final String gender;
  final List<String> interests;
  final String avatarEmoji;
  final String nativeLanguage;
  final String learningGoal;
  final String bio;
  final DateTime joinedDate;

  UserProfile({
    this.name = 'Alex Morgan',
    this.age = 22,
    this.gender = 'Not Specified',
    this.interests = const ['Travel', 'Culture', 'Daily Conversation'],
    this.avatarEmoji = '🦊',
    this.nativeLanguage = 'English',
    this.learningGoal = 'Travel & Cultural Fluency',
    this.bio = 'Passionate about connecting with people across the globe.',
    DateTime? joinedDate,
  }) : joinedDate = joinedDate ?? DateTime.now();

  static const List<String> availableGenders = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
  ];

  static const List<String> availableInterests = [
    'Travel',
    'Culture',
    'Daily Conversation',
    'Business & Career',
    'Food & Cuisine',
    'Music & Movies',
    'Tech & Science',
    'Literature & Art',
    'Academic & Exams',
    'Gaming & Anime',
  ];

  static const List<String> availableAvatars = [
    '🦊',
    '🚀',
    '⚡',
    '🌟',
    '🎯',
    '🎓',
    '🦁',
    '🌸',
    '🐼',
    '🌍',
    '🎨',
    '👑',
  ];

  static const List<String> availableGoals = [
    'Travel & Cultural Fluency',
    'Career & Global Business',
    'Personal Passion & Hobby',
    'Academic Tests & Study',
    'Connecting with Family & Friends',
  ];

  UserProfile copyWith({
    String? name,
    int? age,
    String? gender,
    List<String>? interests,
    String? avatarEmoji,
    String? nativeLanguage,
    String? learningGoal,
    String? bio,
    DateTime? joinedDate,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      interests: interests ?? this.interests,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      learningGoal: learningGoal ?? this.learningGoal,
      bio: bio ?? this.bio,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'gender': gender,
    'interests': interests,
    'avatarEmoji': avatarEmoji,
    'nativeLanguage': nativeLanguage,
    'learningGoal': learningGoal,
    'bio': bio,
    'joinedDate': joinedDate.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? 'Alex Morgan',
      age: json['age'] as int? ?? 22,
      gender: json['gender'] as String? ?? 'Not Specified',
      interests: List<String>.from(json['interests'] as List? ?? ['Travel', 'Culture']),
      avatarEmoji: json['avatarEmoji'] as String? ?? '🦊',
      nativeLanguage: json['nativeLanguage'] as String? ?? 'English',
      learningGoal: json['learningGoal'] as String? ?? 'Travel & Cultural Fluency',
      bio: json['bio'] as String? ?? 'Passionate about connecting with people across the globe.',
      joinedDate: json['joinedDate'] != null
          ? DateTime.tryParse(json['joinedDate'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
