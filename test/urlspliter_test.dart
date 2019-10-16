import 'package:urlspliter/urlspliter.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    UrlSpliter spliter;

    setUp(() {
      spliter = UrlSpliter('haha');
    });

    test('First Test', () {
      final result = spliter.process();
      for (var span in result){
        print("${span.content} : ${span.contentType}");
      }
      expect(result.length > 0, isTrue);
    });
  });
}
