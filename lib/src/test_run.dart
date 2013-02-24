part of dartmocks;

class TestRun {
  List<TestDouble> testDoubles = [];

  void register(TestDouble td) => testDoubles.add(td);

  void clear() => testDoubles.clear();

  void verify(){
    try{
      testDoubles.forEach((_) => _.verify());
    } finally {
      clear();
    }
  }
}