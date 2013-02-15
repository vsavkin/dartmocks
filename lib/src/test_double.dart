part of dartmocks;

class TestDouble {
  String name;

  bool isNullObject = false;

  ut.Mock _mock;

  List<Behaviour> stubs = [];

  List<Behaviour> expectations = [];

  TestDouble(this.name);

  asNullObject() {
    isNullObject = true;
  }

  stub(String name) {
    var behaviour = new Behaviour(name);
    stubs.add(behaviour);
    return behaviour;
  }

  shouldReceive(String name) {
    var behaviour = new Behaviour(name);
    expectations.add(behaviour);
    return behaviour;
  }

  noSuchMethod(InvocationMirror mirror) => mock.noSuchMethod(mirror);

  configureMock() {
    var mock = new ut.Mock.custom(name: name, throwIfNoBehavior: !isNullObject);
    behaviours.forEach((b) => b.configure(mock));
    return mock;
  }

  pure() => new PureTestDouble(this);

  get behaviours {
    var s = new List.from(stubs);
    s.addAll(expectations);
    return s;
  }

  ut.Mock get mock => _mock = _mock == null ? configureMock() : _mock;

  verify() => expectations.forEach((b) => b.verify(mock));
}
