part of dartmocks;

class TestDoubleBuilder {
  var arg1, arg2;

  TestDoubleBuilder(this.arg1, this.arg2);

  build(){
    var d = new TestDouble(_stubName);
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