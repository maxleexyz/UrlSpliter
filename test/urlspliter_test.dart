import 'package:urlspliter/urlspliter.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    UrlSpliter spliter;

    setUp(() {
      spliter = UrlSpliter('123 http://abc xx');
    });

    test('First Test', () {
      final result = spliter.process();
      expect(result.length == 3, isTrue);
      int idx = 0;
      for (var textSpandata in result){
        if (idx == 0) {
          expect(textSpandata.contentType == TextSpanData.TXT, isTrue);
          expect(textSpandata.content == '123 ', isTrue);
        }
        if (idx == 1) {
          expect(textSpandata.contentType == TextSpanData.URL, isTrue);
          expect(textSpandata.content == 'http://abc', isTrue);
        }
        if (idx == 2) {
          expect(textSpandata.contentType == TextSpanData.TXT, isTrue);
          expect(textSpandata.content == ' xx', isTrue);
        }
        idx+=1;
      }
    });
  });
}
