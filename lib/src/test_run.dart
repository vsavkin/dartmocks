part of dartmocks;

class TestRun {
  List<TestDouble> testDoubles = [];

  void register(TestDouble td) => testDoubles.add(td);

  void clear() => testDoubles.clear();

  void verify(){
    testDoubles.forEach((_) => _.verify());
    clear();
  }
}