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

    if(b.throws){
      if(b.throwsMultiple){
        b.throwValues.forEach((_) => m.thenThrow(_));
      } else {
        m.alwaysThrow(b.throwValues.first);
      }
      return;
    }

    if(b.hasCallbacks){
      if(b.multipleCallbacks){
        b.callbacks.forEach((_) => m.thenCall(_));
      } else {
        m.alwaysCall(b.callbacks.first);
      }
      return;
    }

    if(b.returns){
      if(b.multipleReturnValues){
        b.returnValues.forEach((_) => m.thenReturn(_));
      } else {
        m.alwaysReturn(b.returnValues.first);
      }
      return;
    }

    m.alwaysReturn(null);
  }
}

class _Empty{
  const _Empty();
}
const _e = const _Empty();

class MethodBehaviour {
  String methodName;

  var arguments = [];
  List returnValues;
  List throwValues;
  List callbacks;

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

  andThrow(a0, [a1=_e, a2 =_e, a3=_e, a4=_e, a5=_e, a6=_e, a7=_e, a8=_e, a9=_e]) {
    throwValues = _takeNonEmpty([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9]);
    return this;
  }

  andCall(a0, [a1=_e, a2 =_e, a3=_e, a4=_e, a5=_e, a6=_e, a7=_e, a8=_e, a9=_e]) {
    callbacks = _takeNonEmpty([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9]);
    return this;
  }

  times(int value) {
    _times = value;
    return this;
  }

  bool get throws => throwValues != null;
  bool get throwsMultiple => throwValues.length > 1;

  bool get hasCallbacks => callbacks != null;
  bool get multipleCallbacks => callbacks.length > 1;

  bool get returns => returnValues != null;
  bool get multipleReturnValues => returnValues.length > 1;

  verify(ut.Mock mock) => new ExpectationBuilder().build(this, mock);
  configure(ut.Mock mock) => new StubBuilder().build(this, mock);

  _takeNonEmpty(list) => list.takeWhile((_) => _ != _e).toList();
}
