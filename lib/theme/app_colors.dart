import 'package:flutter/material.dart';

/// Refreshing, vibrant & engaging color palette for LingoPulse
/// Characterized by crisp, modern surfaces, punchy Electric Coral,
/// Radiant Honey Gold, Royal Iris Indigo, and sleek Cosmic Dark mode.
class AppColors {
  // Brand Primary & Accents
  static const Color primary = Color(0xFFFF4B3E); // Refreshing Electric Coral Punch
  static const Color primaryLight = Color(0xFFFF7266);
  static const Color primaryDark = Color(0xFFE02B1D);

  static const Color secondary = Color(0xFF4F46E5); // Modern Electric Indigo
  static const Color secondaryLight = Color(0xFF6366F1);
  static const Color secondaryDark = Color(0xFF3730A3);

  static const Color accentGold = Color(0xFFF59E0B); // Radiant Amber Sun
  static const Color accentGoldLight = Color(0xFFFCD34D);

  static const Color accentSky = Color(0xFF0284C7); // Electric Azure Sky
  static const Color accentRose = Color(0xFFF43F5E); // Energetic Watermelon Rose
  static const Color accentEmerald = Color(0xFF10B981); // Crisp Mint Green

  // Light Mode - Crisp, Refreshing Snow & Ice Theme
  static const Color lightBg = Color(0xFFF8FAFC); // Crisp Ice White (Slate 50)
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure Crisp White
  static const Color lightSurfaceAlt = Color(0xFFF1F5F9); // Smooth Slate 100
  static const Color lightBorder = Color(0xFFE2E8F0); // Modern Slate 200 border
  static const Color lightBorderSubtle = Color(0xFFEEF2F6);
  static const Color lightTextPrimary = Color(0xFF0F172A); // Sharp Slate 900
  static const Color lightTextSecondary = Color(0xFF475569); // Slate 600
  static const Color lightTextMuted = Color(0xFF94A3B8); // Slate 400

  // Dark Mode - Deep Cosmic Navy Theme
  static const Color darkBg = Color(0xFF0A0E1A); // Deep Cosmic Navy-Black
  static const Color darkSurface = Color(0xFF131B2E); // Elevated Navy Glass
  static const Color darkSurfaceAlt = Color(0xFF1C2640); // Deep Sapphire
  static const Color darkBorder = Color(0xFF263554);
  static const Color darkBorderSubtle = Color(0xFF1A243B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Status & Feedback
  static const Color success = Color(0xFF10B981); // Crisp Emerald
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEE2E2);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF4B3E), Color(0xFFFF7643)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFFF4B3E), Color(0xFFFF7247), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient irisGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardSoftGradient = LinearGradient(
    colors: [Color(0x14FF4B3E), Color(0x05FF4B3E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
