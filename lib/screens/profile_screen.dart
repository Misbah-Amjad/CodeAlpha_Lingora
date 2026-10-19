import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/learning_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/tactile_button.dart';

class ProfileScreen extends StatefulWidget {
  final LearningState learningState;

  const ProfileScreen({super.key, required this.learningState});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _bioController;
  late TextEditingController _nativeLangController;

  late String _selectedGender;
  late String _selectedGoal;
  late String _selectedAvatar;
  late List<String> _selectedInterests;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final profile = widget.learningState.userProfile;
    _nameController = TextEditingController(text: profile.name);
    _ageController = TextEditingController(text: profile.age.toString());
    _bioController = TextEditingController(text: profile.bio);
    _nativeLangController = TextEditingController(text: profile.nativeLanguage);

    _selectedGender = profile.gender;
    _selectedGoal = profile.learningGoal;
    _selectedAvatar = profile.avatarEmoji;
    _selectedInterests = List.from(profile.interests);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _nativeLangController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    final parsedAge = int.tryParse(_ageController.text.trim()) ?? widget.learningState.userProfile.age;
    final updatedProfile = widget.learningState.userProfile.copyWith(
      name: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : widget.learningState.userProfile.name,
      age: parsedAge > 0 ? parsedAge : widget.learningState.userProfile.age,
      gender: _selectedGender,
      learningGoal: _selectedGoal,
      avatarEmoji: _selectedAvatar,
      nativeLanguage: _nativeLangController.text.trim().isNotEmpty
          ? _nativeLangController.text.trim()
          : widget.learningState.userProfile.nativeLanguage,
      bio: _bioController.text.trim(),
      interests: _selectedInterests,
    );

    await widget.learningState.updateUserProfile(updatedProfile);

    setState(() {
      _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully! 🎉'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Choose Your Avatar',
                style: AppTypography.getDisplayFont(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: UserProfile.availableAvatars.map((avatar) {
                  final isSelected = avatar == _selectedAvatar;
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedAvatar = avatar);
                      Navigator.pop(ctx);
                      if (!_isEditing) {
                        widget.learningState.updateUserProfile(
                          widget.learningState.userProfile.copyWith(avatarEmoji: avatar),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.18)
                            : (isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(avatar, style: const TextStyle(fontSize: 28)),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final profile = widget.learningState.userProfile;
    final progress = widget.learningState.progress;
    final lang = widget.learningState.selectedLanguage;

    final learnedCount = widget.learningState.currentVocabItems.where((i) => i.isLearned).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learner Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close_rounded : Icons.edit_note_rounded),
            tooltip: _isEditing ? 'Cancel Edit' : 'Edit Profile',
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  _initControllers();
                  _isEditing = false;
                } else {
                  _isEditing = true;
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Profile Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                      : [const Color(0xFFEFF6FF), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar with edit badge
                  GestureDetector(
                    onTap: _showAvatarPicker,
                    child: Stack(
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.15),
                            border: Border.all(color: AppColors.primary, width: 2.5),
                          ),
                          child: Center(
                            child: Text(
                              _isEditing ? _selectedAvatar : profile.avatarEmoji,
                              style: const TextStyle(fontSize: 44),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Display Name
                  Text(
                    profile.name,
                    style: AppTypography.getDisplayFont(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Bio / Motto
                  Text(
                    profile.bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Identity Tags (Age, Gender, Native Language)
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildInfoTag('🎂 ${profile.age} yrs', isDark),
                      _buildInfoTag('👤 ${profile.gender}', isDark),
                      _buildInfoTag('🗣️ Native: ${profile.nativeLanguage}', isDark),
                      _buildInfoTag('🎯 Goal: ${profile.learningGoal}', isDark, color: AppColors.secondary),
                      _buildInfoTag('🌐 Learning ${lang.name} ${lang.flagEmoji}', isDark, color: AppColors.primary),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Learning Milestones & Metrics Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    emoji: '🔥',
                    value: '${progress.streakDays}',
                    label: 'Day Streak',
                    color: AppColors.primary,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatTile(
                    emoji: '💎',
                    value: '${progress.totalXp}',
                    label: 'Total XP',
                    color: AppColors.accentGold,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatTile(
                    emoji: '🧠',
                    value: '$learnedCount',
                    label: 'Mastered',
                    color: AppColors.secondary,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatTile(
                    emoji: '🏆',
                    value: 'Lvl ${progress.level}',
                    label: progress.levelTitle,
                    color: AppColors.success,
                    isDark: isDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Content Switch: View Mode vs Edit Mode
            if (!_isEditing) ...[
              // Interests Section
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome_rounded, color: AppColors.accentGold, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Learning Interests',
                          style: AppTypography.getDisplayFont(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => setState(() => _isEditing = true),
                          child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (profile.interests.isEmpty)
                      Text(
                        'No interests selected yet. Tap Edit to add your passions!',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: profile.interests.map((interest) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              interest,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Basic Profile Details Summary Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: AppTypography.getDisplayFont(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildDetailRow('Full Name', profile.name, isDark),
                    const Divider(height: 20),
                    _buildDetailRow('Age', '${profile.age} years old', isDark),
                    const Divider(height: 20),
                    _buildDetailRow('Gender', profile.gender, isDark),
                    const Divider(height: 20),
                    _buildDetailRow('Native Language', profile.nativeLanguage, isDark),
                    const Divider(height: 20),
                    _buildDetailRow('Learning Goal', profile.learningGoal, isDark),
                    const Divider(height: 20),
                    _buildDetailRow('Active Language', '${lang.name} (${lang.nativeName})', isDark),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              TactileButton(
                onPressed: () => setState(() => _isEditing = true),
                backgroundColor: AppColors.primary,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Edit Profile Information'),
                  ],
                ),
              ),
            ] else ...[
              // EDIT MODE FORM
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.mode_edit_outline_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Edit Your Details',
                          style: AppTypography.getDisplayFont(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Full Name Input
                    _buildFieldLabel('Full Name', isDark),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Age Input
                    _buildFieldLabel('Age', isDark),
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'e.g. 24',
                        prefixIcon: Icon(Icons.cake_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Gender Selector
                    _buildFieldLabel('Gender', isDark),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: UserProfile.availableGenders.map((gender) {
                        final isSel = _selectedGender == gender;
                        return ChoiceChip(
                          label: Text(gender),
                          selected: isSel,
                          selectedColor: AppColors.primary.withValues(alpha: 0.2),
                          onSelected: (_) => setState(() => _selectedGender = gender),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSel ? AppColors.primary : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Native Language
                    _buildFieldLabel('Native Language', isDark),
                    TextFormField(
                      controller: _nativeLangController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. English, Urdu, Spanish',
                        prefixIcon: Icon(Icons.translate_rounded),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Primary Learning Motivation / Goal
                    _buildFieldLabel('Learning Purpose / Goal', isDark),
                    DropdownButtonFormField<String>(
                      initialValue: UserProfile.availableGoals.contains(_selectedGoal) ? _selectedGoal : UserProfile.availableGoals.first,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.flag_outlined),
                      ),
                      isExpanded: true,
                      items: UserProfile.availableGoals.map((g) {
                        return DropdownMenuItem(
                          value: g,
                          child: Text(g, style: const TextStyle(fontSize: 13)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedGoal = val);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Interests Selection (Multi-select)
                    _buildFieldLabel('Select Your Interests', isDark),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: UserProfile.availableInterests.map((interest) {
                        final isSel = _selectedInterests.contains(interest);
                        return FilterChip(
                          label: Text(interest),
                          selected: isSel,
                          selectedColor: AppColors.secondary.withValues(alpha: 0.2),
                          checkmarkColor: AppColors.secondary,
                          onSelected: (sel) {
                            setState(() {
                              if (sel) {
                                _selectedInterests.add(interest);
                              } else {
                                _selectedInterests.remove(interest);
                              }
                            });
                          },
                          labelStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isSel ? AppColors.secondary : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Bio / Personal Note
                    _buildFieldLabel('Bio / Personal Motto', isDark),
                    TextFormField(
                      controller: _bioController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Share a short note about your goals...',
                        prefixIcon: Icon(Icons.notes_rounded),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Actions Row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _initControllers();
                                _isEditing = false;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TactileButton(
                            onPressed: _saveProfile,
                            backgroundColor: AppColors.primary,
                            height: 48,
                            child: const Text('Save Profile'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoTag(String text, bool isDark, {Color? color}) {
    final effectiveColor = color ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? (isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt)).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: effectiveColor.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: effectiveColor,
        ),
      ),
    );
  }

  Widget _buildStatTile({
    required String emoji,
    required String value,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
        ),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTypography.getDisplayFont(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
