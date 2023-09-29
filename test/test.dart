import 'package:test/test.dart';
import 'package:translator/src/langs/language.dart';
import 'package:translator/translator.dart';

void main() {
  test('Conection test: Is Google Translate API working?', () async {
    final translator = GoogleTranslator();
    final t = await translator.translate('test', to: 'pt');
    expect(t.text, 'teste');
  });

  test('Changing the base URL', () async {
    final translator = GoogleTranslator()..baseUrl = 'translate.google.cn';
    final transl = await translator.translate('friendship', to: 'es');
    expect(transl.toString(), 'amistad');
  });

  test('Get the right auto detected language', () async {
    final translator = GoogleTranslator();
    final translation = await translator.translate('Translation', to: 'es');
    expect(translation.sourceLanguage.code, 'en');
  });

  // this is because sometimes Google Translate doesn't translate well
  test("Get the 'GT buggy' auto detected language", () async {
    final translator = GoogleTranslator();
    final translation = await translator.translate('Translation', to: 'pt');
    expect(translation.sourceLanguage.toString(), 'Automatic');
  });

  test('GTX client', () async {
    final translator = GoogleTranslator(client: ClientType.extensionGT);
    final t = await translator.translate('test', to: 'pt');
    expect('$t', 'teste');
  });

  test('Translation stuff', () async {
    final translator = GoogleTranslator(client: ClientType.extensionGT);
    final t = await translator.translate('perro', to: 'ru');
    expect(t.targetLanguage.name, 'Russian');
    expect(t.text, 'собака');
    expect(t.source, 'perro');
    expect(t.sourceLanguage.name, 'Spanish');
  });

  test('Language stuff', () {
    final bool b = LanguageList.contains('kke');
    final bool b2 = LanguageList.contains('ja');
    expect(b, false);
    expect(b2, true);
  });
}
