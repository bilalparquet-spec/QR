import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Formats amounts as Algerian Dinar (DZD) with locale-aware digits and
/// symbol placement.
/// - Arabic: يستعمل الأرقام العربية والرمز "د.ج" بعد المبلغ
/// - French/English: uses "DA" after the amount
class CurrencyFormatter {
  CurrencyFormatter._();

  static String _symbolFor(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'د.ج';
      default:
        return 'DA';
    }
  }

  /// Formats [amount] as Algerian Dinar for the given [locale], e.g.
  /// "1,250.00 DA" or "١٬٢٥٠٫٠٠ د.ج".
  static String format(double amount, Locale locale) {
    final numberFormat = NumberFormat.decimalPatternDigits(
      locale: locale.toLanguageTag(),
      decimalDigits: 2,
    );
    final symbol = _symbolFor(locale);
    return '${numberFormat.format(amount)} $symbol';
  }

  /// A compact prefix (used inside text fields, e.g. "DA " or "د.ج ").
  static String prefixFor(Locale locale) => '${_symbolFor(locale)} ';
}
