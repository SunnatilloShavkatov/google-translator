library google_transl;

import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'dart:developer';

import 'package:http/http.dart' as http;

import './langs/language.dart';
import './tokens/google_token_gen.dart';

part './model/translation.dart';

class GoogleTranslator {
  GoogleTranslator({this.client = ClientType.siteGT});

  String _baseUrl = 'translate.googleapis.com';
  final _path = '/translate_a/single';
  final _tokenProvider = GoogleTokenGenerator();
  final _languageList = LanguageList();
  final ClientType client;

  /// Translates texts from specified language to another
  Future<Translation> translate(
    String sourceText, {
    String from = 'auto',
    String to = 'en',
  }) async {
    String from0 = from;
    for (final each in [from, to]) {
      if (!LanguageList.contains(each)) {
        throw LanguageNotSupportedException(each);
      }
    }

    final parameters = {
      'client': client == ClientType.siteGT ? 't' : 'gtx',
      'sl': from,
      'tl': to,
      'hl': to,
      'dt': 't',
      'ie': 'UTF-8',
      'oe': 'UTF-8',
      'otf': '1',
      'ssel': '0',
      'tsel': '0',
      'kc': '7',
      'tk': _tokenProvider.generateToken(sourceText),
      'q': sourceText
    };

    final url = Uri.https(_baseUrl, _path, parameters);
    final data = await http.get(url);

    if (data.statusCode != 200) {
      throw http.ClientException('Error ${data.statusCode}: ${data.body}', url);
    }

    final jsonData = jsonDecode(data.body);
    if (jsonData == null) {
      throw http.ClientException('Error: Can\'t parse json data');
    }

    final sb = StringBuffer();

    for (var c = 0; c < jsonData[0].length; c++) {
      sb.write(jsonData[0][c][0]);
    }

    if (from0 == 'auto' && from != to) {
      from0 = jsonData[2] ?? from;
      if (from == to) {
        from0 = 'auto';
      }
    }

    final translated = sb.toString();
    return _Translation(
      translated,
      source: sourceText,
      sourceLanguage: _languageList[from0],
      targetLanguage: _languageList[to],
    );
  }

  /// Translates and prints directly
  void translateAndPrint(
    String text, {
    String from = 'auto',
    String to = 'en',
  }) {
    translate(text, from: from, to: to).then(
      (e) {
        log(e.text);
      },
    );
  }

  /// Sets base URL for countries that default URL doesn't work
  set baseUrl(String url) {
    _baseUrl = url;
  }
}

enum ClientType {
  siteGT, // t
  extensionGT, // gtx (blocking ip sometimes)
}
