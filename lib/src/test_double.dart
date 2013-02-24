part of dartmocks;

class TestDouble {
  ut.Mock _mock;
  List<MethodBehaviour> _stubs = [];
  List<MethodBehaviour> _expectations = [];

  String name;
  bool isNullObject = false;

  TestDouble(){
    currentTestRun.register(this);
  }

  asNullObject() {
    isNullObject = true;
    return this;
  }

  MethodBehaviour stub(String methodName) {
    var b = new MethodBehaviour(methodName);
    _stubs.add(b);
    return b;
  }

  MethodBehaviour shouldReceive(String methodName) {
    var b = new MethodBehaviour(methodName);
    _expectations.add(b);
    return b;
  }

  pure() => new PureTestDouble(this);

  verify() => _expectations.forEach((b) => b.verify(mock));

  noSuchMethod(mirror) => mock.noSuchMethod(mirror);

  get mock {
    if(_mock == null) _mock = _configureMock();
    return _mock;
  }

  get behaviours {
    var s = new List.from(_stubs);
    s.addAll(_expectations);
    return s;
  }

  _configureMock() {
    var mock = new ut.Mock.custom(name: name, throwIfNoBehavior: !isNullObject);
    behaviours.forEach((b) => b.configure(mock));
    return mock;
  }
}
