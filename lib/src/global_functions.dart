part of dartmocks;

class _TestDoubleBuilder {
  var arg1, arg2;

  _TestDoubleBuilder(this.arg1, this.arg2);

  build(){
    var d = new TestDouble()
            ..name = _stubName;
    _setupStubs(d);
    return d;
  }

  _setupStubs(d){
    if(_stubConfig != null){
      _stubConfig.forEach((methodName, returnValue){
        d.stub(methodName).andReturn(returnValue);
      });
    }
  }

  get _stubName => (arg1 != null && arg1 is Map) ? null : arg1;
  get _stubConfig => (arg1 != null && arg1 is Map) ? arg1 : arg2;
}

stub([arg1, arg2]) => new _TestDoubleBuilder(arg1, arg2).build();
mock([String name]) => new _TestDoubleBuilder(name, null).build();
var currentTestRun = new TestRun();