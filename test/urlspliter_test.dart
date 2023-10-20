import 'package:urlspliter/urlspliter.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {});

    test('First Test', () {
      UrlSpliter spliter;
      spliter = UrlSpliter('hahahahahah');

      final result = spliter.process();
      for (var span in result) {
        print('${span.content} : ${span.contentType}');
      }
      expect(result.isNotEmpty, isTrue);
    });
  });
}
