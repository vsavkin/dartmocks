part of dartmocks;

class CallMatcherBuilder {
  build(Behaviour b){
    if (b.hasArguments) {
      return ut.callsTo(b.methodName, b.arguments);
    } else {
      return ut.callsTo(b.methodName);
    }
  }
}

class ExpectationBuilder {
  CallMatcherBuilder callMatcherBuilder = new CallMatcherBuilder();

  build(Behaviour b, ut.Mock mock){
    var callMatcher = callMatcherBuilder.build(b);
    var verification = ut.happenedExactly(b._times);
    mock.getLogs(callMatcher).verify(verification);
  }
}

class StubBuilder {
  CallMatcherBuilder callMatcherBuilder = new CallMatcherBuilder();

  build(Behaviour b, ut.Mock mock){
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

class Behaviour {
  String methodName;

  var throwValue;
  var returnValue;
  List returnValues;
  var arguments;
  Function callback;

  int _times = 1;

  Behaviour(this.methodName);

  with(args) {
    arguments = args;
    return this;
  }

  andReturn(value) {
    returnValue = value;
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

  andReturnMultipleValue(List values) {
    returnValues = values;
    return this;
  }

  times(int value) {
    _times = value;
    return this;
  }

  bool get hasArguments => arguments != null;
  bool get throws => throwValue != null;
  bool get hasCallback => callback != null;
  bool get hasMultipleReturnValues => returnValues != null;

  verify(ut.Mock mock) => new ExpectationBuilder().build(this, mock);
  configure(ut.Mock mock) => new StubBuilder().build(this, mock);
}
