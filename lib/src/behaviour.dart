part of dartmocks;

class Behaviour {
  String methodName;

  var throwValue;

  var returnValue;

  List returnValues;

  var arguments;

  var callback;

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

  verify(ut.Mock mock) {
    var callMatcher;
    if (hasArguments) {
      callMatcher = ut.callsTo(methodName, arguments);
    } else {
      callMatcher = ut.callsTo(methodName);
    }
    mock.getLogs(callMatcher).verify(ut.happenedExactly(_times));
  }

  configure(ut.Mock mock) {
    var callMatcher;
    if (hasArguments) {
      callMatcher = ut.callsTo(methodName, arguments);
    } else {
      callMatcher = ut.callsTo(methodName);
    }

    var builder = mock.when(callMatcher);

    if (hasCallback) {
      builder.alwaysCall(callback);

    } else if (throws) {
      builder.alwaysThrow(throwValue);

    } else if (hasMultipleReturnValues) {
      for (var v in returnValues) {
        builder.thenReturn(v);
      }

    } else {
      builder.alwaysReturn(returnValue);
    }
  }
}
