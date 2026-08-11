import 'package:flutter/material.dart';
import '../data/hive_database.dart';

/// App-wide language switcher (Arabic / French / English).
///
/// Persists the chosen language in Hive so it survives app restarts.
/// Arabic automatically renders the whole app right-to-left because
/// MaterialApp derives text direction from the active locale.
class LocaleController extends ValueNotifier<Locale> {
  static const String _storageKey = 'app_locale';

  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('fr'),
    Locale('en'),
  ];

  LocaleController() : super(_loadInitialLocale());

  static Locale _loadInitialLocale() {
    try {
      final saved = HiveDatabase.settingsBox.get(_storageKey) as String?;
      if (saved != null) {
        return Locale(saved);
      }
    } catch (_) {
      // Hive not ready yet / web fallback - default to Arabic.
    }
    return const Locale('ar');
  }

  void setLocale(Locale locale) {
    if (value == locale) return;
    value = locale;
    try {
      HiveDatabase.settingsBox.put(_storageKey, locale.languageCode);
    } catch (_) {
      // Ignore persistence errors (e.g. box not open on some platforms).
    }
  }

  String labelFor(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }
}
