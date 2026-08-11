class AppValidators {
  static String? Function(String?) required(String message) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }
      return null;
    };
  }

  /// Returns a price validator. Pass localized messages so the error text
  /// matches the app's current language.
  static String? Function(String?) price({
    required String requiredMessage,
    required String invalidMessage,
    required String negativeMessage,
  }) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return requiredMessage;
      }
      if (double.tryParse(value) == null) {
        return invalidMessage;
      }
      if (double.parse(value) < 0) {
        return negativeMessage;
      }
      return null;
    };
  }
}
