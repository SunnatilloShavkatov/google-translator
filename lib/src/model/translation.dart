// ignore_for_file: public_member_api_docs
// ignore_for_file: overridden_fields
// ignore: type_annotate_public_apis
part of google_transl;

/// Translation returned from GoogleTranslator.translate method, containing the translated text, the source text, the translated language and the source language
abstract class Translation {
  Translation._(
    this.text,
    this.source,
    this.sourceLanguage,
    this.targetLanguage,
  );

  final String text;
  final String source;
  final Language targetLanguage;
  final Language sourceLanguage;

  @override
  String toString() => text;
}

class _Translation extends Translation {
  _Translation(
    this.text, {
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.source,
  }) : super._(text, source, sourceLanguage, targetLanguage);

  @override
  final String text;
  @override
  final String source;
  @override
  final Language sourceLanguage;
  @override
  final Language targetLanguage;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _Translation &&
        other.text == text &&
        other.source == source &&
        other.sourceLanguage == sourceLanguage &&
        other.targetLanguage == targetLanguage;
  }

  @override
  int get hashCode => Object.hash(text, source, sourceLanguage, targetLanguage);
}
