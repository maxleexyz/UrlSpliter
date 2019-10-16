// TODO: Put public facing types in this file.

class TextSpanData{
  static const TXT = 0;
  static const URL = 1;
  String content;
  int contentType;
  TextSpanData(this.content, this.contentType);
}

/// Checks if you are awesome. Spoiler: you are.
class UrlSpliter{
  String text;
  static const int INIT = 0;
  static const int TESTING = 1;
  static const int FETCHING = 2;
  UrlSpliter(this.text);
  List<String> validWord = 'qazxswedcvfrtgbnhyujmkiolpQAZXSWEDCVFRTGHBNYUJMKIOLP1234567890://=+?&#-_.%@*~^()'.split("");
  List<String> testBuffer = new List<String>();
  List<String> sequnceBuffer = new List<String>();
  List<String> urlBuffer = new List<String>();
  List<TextSpanData> results = new List<TextSpanData>();
  int state = INIT;

  checkStartTest(String w){
    if (w.toLowerCase() == 'h' && this.testBuffer.length < 1) {
      this.startTest(w);
    }else{
      this.sequnceBuffer.add(w);
    }
  }

  startTest(String w){
    this.state = TESTING;
    this.testBuffer.add(w);
    if (this.sequnceBuffer.length > 0){
      this.results.add(TextSpanData(this.sequnceBuffer.join(''), TextSpanData.TXT));
    }
    this.sequnceBuffer.clear();
  }

  checkEndTest(String w){
    this.testBuffer.add(w);
    if (['http://', 'https://'].contains(this.testBuffer.join('').toLowerCase())){
      // test 成功
      startFetching();
    }else{
      if (this.testBuffer.length > 7){
        // test 失败
        testFaild();
      }
    }
  }

  testFaild(){
    this.sequnceBuffer.addAll(this.testBuffer);
    this.testBuffer.clear();
    this.state = INIT;
  }

  startFetching(){
    this.urlBuffer.addAll(this.testBuffer);
    this.testBuffer.clear();
    this.state = FETCHING;

  }

  checkEndFetching(String w){
    if (this.validWord.contains(w)){
      this.urlBuffer.add(w);
    }else{
      this.state = INIT;
      this.results.add(TextSpanData(this.urlBuffer.join(''), TextSpanData.URL));
      this.urlBuffer.clear();
      this.sequnceBuffer.add(w);
    }
  }

  checkTail(){
    if (this.testBuffer.length > 0){
      this.results.add(TextSpanData(this.testBuffer.join(''), TextSpanData.TXT));
      this.testBuffer.clear();
    }
    if (this.urlBuffer.length > 0){
      this.results.add(TextSpanData(this.urlBuffer.join(''), TextSpanData.URL));
      this.urlBuffer.clear();
    }
    if (this.sequnceBuffer.length > 0){
      this.results.add(TextSpanData(this.sequnceBuffer.join(''), TextSpanData.TXT));
      this.sequnceBuffer.clear();
    }
  }

  List<TextSpanData> process(){
    for(var w in this.text.split('')) {
      if (this.state == INIT){
        this.checkStartTest(w);
        continue;
      }
      if (this.state == TESTING) {
        this.checkEndTest(w);
        continue;
      }
      if (this.state == FETCHING) {
        this.checkEndFetching(w);
        continue;
      }
    }
    this.checkTail();
    return this.results;
  }
}
