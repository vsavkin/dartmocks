library dartmocks;

import 'dart:mirrors';
import 'package:unittest/mock.dart' as ut;

class Player {
  changeVolume(v) => "Changed ${v}";
}

class Remote {
  Player player;

  Remote(this.player);

  increaseVolume() => player.changeVolume(10);
}


abstract class Builder {
  String methodName;
  List args;
  var returnValue;

  Builder(this.methodName);

  andReturn(returnValue){
    this.returnValue = returnValue;
    onDone();
  }

  with(args){
    this.args = args;
    return this;
  }

  onDone();
}

class StubBuilder extends Builder {
  TestDouble testDouble;

  StubBuilder(methodName, this.testDouble) : super(methodName);

  onDone() => testDouble.stubFinished(this);
}

class MockBuilder extends Builder {
  TestDouble testDouble;

  MockBuilder(methodName, this.testDouble) : super(methodName);

  onDone() => testDouble.mockFinished(this);
}

class TestDouble {
  ut.Mock mock;
  List<StubBuilder> stubs = [];
  List<MockBuilder> mocks = [];

  TestDouble()
    : mock = new ut.Mock();

  stub(String methodName){
    var stub = new StubBuilder(methodName, this);
    stubs.add(stub);
    return stub;
  }
  shouldReceive(String methodName){
    var mock = new MockBuilder(methodName, this);
    mocks.add(mock);
    return mock;
  }

  stubFinished(StubBuilder b){
    //use matchers here
    mock.when(ut.callsTo(b.methodName)).alwaysReturn(b.returnValue);
  }

  mockFinished(MockBuilder b){
  }

  verify(){
    for(var mockBuilder in mocks){
      mock.getLogs(ut.callsTo(mockBuilder.methodName)).verify(ut.happenedAtLeastOnce);
    }
  }

  noSuchMethod(InvocationMirror mirror) => mock.noSuchMethod(mirror);
}

double(name) => new TestDouble();

main(){
  var mockPlayer = double("player")
                  ..stub("changeVolume").with(10).andReturn("BOOM")
                  ..stub("changeVolume").with(20).andReturn("BAM");

  mockPlayer.shouldReceive("changeVolume").with(11);



  print(mockPlayer.changeVolume(10));
  print(mockPlayer.changeVolume(20));

  mockPlayer.verify();

  var mock = new ut.Mock();
  mock.when(callsTo("blah", 10)).alwaysReturn(10);
  mock.getLogs(callsTo("blah")).verify(ut.happenedOnce);
}