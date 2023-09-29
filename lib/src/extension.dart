import 'package:translator/src/google_translator.dart';

extension StringExtension on String {
  Future<Translation> translate({
    String from = 'auto',
    String to = 'en',
  }) async =>
      GoogleTranslator().translate(this, from: from, to: to);
}
