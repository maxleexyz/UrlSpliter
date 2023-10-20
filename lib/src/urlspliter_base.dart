class TextSpanData {
  static const TXT = 0;
  static const URL = 1;
  String content;
  int contentType;
  TextSpanData(this.content, this.contentType);
}

/// Checks if you are awesome. Spoiler: you are.
class UrlSpliter {
  String text;
  static const int INIT = 0;
  static const int TESTING = 1;
  static const int FETCHING = 2;
  UrlSpliter(this.text);
  List<String> validWord =
      'qazxswedcvfrtgbnhyujmkiolpQAZXSWEDCVFRTGHBNYUJMKIOLP1234567890://=+?&#-_.%@*~^()'
          .split('');
  List<String> testBuffer = <String>[];
  List<String> sequnceBuffer = <String>[];
  List<String> urlBuffer = <String>[];
  List<TextSpanData> results = <TextSpanData>[];
  int state = INIT;

  void checkStartTest(String w) {
    if (w.toLowerCase() == 'h' && testBuffer.isEmpty) {
      startTest(w);
    } else {
      sequnceBuffer.add(w);
    }
  }

  void startTest(String w) {
    state = TESTING;
    testBuffer.add(w);
    if (sequnceBuffer.isNotEmpty) {
      results.add(TextSpanData(sequnceBuffer.join(''), TextSpanData.TXT));
    }
    sequnceBuffer.clear();
  }

  void checkEndTest(String w) {
    testBuffer.add(w);
    if (['http://', 'https://'].contains(testBuffer.join('').toLowerCase())) {
      // test 成功
      startFetching();
    } else {
      if (testBuffer.length > 7) {
        // test 失败
        testFaild();
      }
    }
  }

  void testFaild() {
    sequnceBuffer.addAll(testBuffer);
    testBuffer.clear();
    state = INIT;
  }

  void startFetching() {
    urlBuffer.addAll(testBuffer);
    testBuffer.clear();
    state = FETCHING;
  }

  void checkEndFetching(String w) {
    if (validWord.contains(w)) {
      urlBuffer.add(w);
    } else {
      state = INIT;
      results.add(TextSpanData(urlBuffer.join(''), TextSpanData.URL));
      urlBuffer.clear();
      sequnceBuffer.add(w);
    }
  }

  void checkTail() {
    if (testBuffer.isNotEmpty) {
      results.add(TextSpanData(testBuffer.join(''), TextSpanData.TXT));
      testBuffer.clear();
    }
    if (urlBuffer.isNotEmpty) {
      results.add(TextSpanData(urlBuffer.join(''), TextSpanData.URL));
      urlBuffer.clear();
    }
    if (sequnceBuffer.isNotEmpty) {
      results.add(TextSpanData(sequnceBuffer.join(''), TextSpanData.TXT));
      sequnceBuffer.clear();
    }
  }

  List<TextSpanData> process() {
    for (var w in text.split('')) {
      if (state == INIT) {
        checkStartTest(w);
        continue;
      }
      if (state == TESTING) {
        checkEndTest(w);
        continue;
      }
      if (state == FETCHING) {
        checkEndFetching(w);
        continue;
      }
    }
    checkTail();
    return results;
  }
}
