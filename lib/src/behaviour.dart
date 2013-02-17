part of dartmocks;

class CallMatcherBuilder {
  build(MethodBehaviour b){
    var cm = new ut.CallMatcher();
    cm.nameFilter = matchers.wrapMatcher(b.methodName);
    cm.argMatchers = b.arguments.map((_) => matchers.wrapMatcher(_)).toList();
    return cm;
  }
}

class ExpectationBuilder {
  CallMatcherBuilder callMatcherBuilder = new CallMatcherBuilder();

  build(MethodBehaviour b, ut.Mock mock){
    var callMatcher = callMatcherBuilder.build(b);
    var verification = ut.happenedExactly(b._times);
    mock.getLogs(callMatcher).verify(verification);
  }
}

class StubBuilder {
  CallMatcherBuilder callMatcherBuilder = new CallMatcherBuilder();

  build(MethodBehaviour b, ut.Mock mock){
    var m = mock.when(callMatcherBuilder.build(b));

    if (b.hasCallback) {
      m.alwaysCall(b.callback);

    } else if (b.throws) {
      m.alwaysThrow(b.throwValue);

    } else if (b.hasMultipleReturnValues) {
      b.returnValues.forEach((_) => m.thenReturn(_));

    } else {
      m.alwaysReturn(b.returnValue);
    }
  }
}

class _Empty{
  const _Empty();
}
const _e = const _Empty();

class MethodBehaviour {
  String methodName;

  var throwValue;
  List returnValues;
  var arguments = [];
  Function callback;

  int _times = 1;

  MethodBehaviour(this.methodName);

  args(a0, [a1=_e, a2 =_e, a3=_e, a4=_e, a5=_e, a6=_e, a7=_e, a8=_e, a9=_e]) {
    arguments = _takeNonEmpty([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9]);
    return this;
  }

  andReturn(a0, [a1=_e, a2 =_e, a3=_e, a4=_e, a5=_e, a6=_e, a7=_e, a8=_e, a9=_e]) {
    returnValues = _takeNonEmpty([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9]);
    return this;
  }

  andThrow(value) {
    throwValue = value;
    return this;
  }

  andCall(Function callback) {
    this.callback = callback;
    return this;
  }

  times(int value) {
    _times = value;
    return this;
  }

  get returnValue => returnValues != null ? returnValues.first : null;
  bool get throws => throwValue != null;
  bool get hasCallback => callback != null;
  bool get hasMultipleReturnValues => returnValues != null && returnValues.length > 1;

  verify(ut.Mock mock) => new ExpectationBuilder().build(this, mock);
  configure(ut.Mock mock) => new StubBuilder().build(this, mock);

  _takeNonEmpty(list) => list.takeWhile((_) => _ != _e).toList();
}
