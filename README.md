# DartMocks

[![Build Status](https://drone.io/github.com/vsavkin/dartmocks/status.png)](https://drone.io/github.com/vsavkin/dartmocks/latest)

DartMocks is a mock framework for Dart inspired by RSpec. It's built on top of `unittest/mock`.

## Installation

Add the DartMocks dependency to your project’s pubspec.yaml.

    name: my_project
    dependencies:
      dartmocks: any

Then, run `pub install`.

Finally, import the unittest and dartmocks libraries.

    import 'package:unittest/unittest.dart';
    import 'package:dartmocks/dartmocks.dart';

## Code Under Test

In all the samples below I am going to test the following two classes:

    class Player {
      var currentValue = 0;
      var isOn = true;
      changeVolume(delta) => currentValue += delta;
    }

    class RemoteControl {
      var player;

      RemoteControl(this.player);

      turnUp() => (player.isOn) ? player.changeVolume(10) : 0;
      turnDown() => (player.isOn) ? player.changeVolume(-10) : 0;
    }

## Stubbing

### Using the `stub(Map conf)` Function

You can pass a configuration object, which maps function names to their return values, to the stub function.

    test("stubbing a turned off player", (){
      var player = stub({"get isOn" : false});
      var remote = new RemoteControl(player);
      expect(remote.turnUp(), equals(0));
    });

    test("stubbing a turned on player", (){
      var player = stub("Player", {"changeVolume" : 100, "get isOn" : true});
      var remote = new RemoteControl(player);
      expect(remote.turnUp(), equals(100));
    });

Note, that you can optionally pass a name to make error messages more descriptive.

### Using `stub(String methodName)`

In addition to passing a map to the `stub` function, you can configure each method individually.

    test("stubbing a turned off player", (){
      var player = stub("Player")
                   ..stub("get isOn").andReturn(false);

      var remote = new RemoteControl(player);
      expect(remote.turnUp(), equals(0));
    });

You can specify the argument of a stubbed method call as follows:

    test("specifying arguments", (){
      var player = stub()
                  ..stub("get isOn").andReturn(true)
                  ..stub("changeVolume").args(10).andReturn(100)
                  ..stub("changeVolume").args(-10).andReturn(-100);

      var remote = new RemoteControl(player);
      expect(remote.turnUp(), equals(100));
      expect(remote.turnDown(), equals(-100));
    });

### Throwing

Configuring a stubbed method to throw an exception is done as follows:

    test("throwing an exception", (){
      var player = stub("Player")
                   ..stub("get isOn").andThrow("BOOM!");

      var remote = new RemoteControl(player);
      expect(remote.turnUp, throws);
    });

### Custom Behaviours

Custom behaviour is specified as follows:

    test("calling custom functions", (){
      var player = stub("Player")
                  ..stub("get isOn").andReturn(true)
                  ..stub("changeVolume").andCall((delta) => delta * 100);

      var remote = new RemoteControl(player);
      expect(remote.turnUp(), equals(1000));
    });

### Multiple Behaviours

If you pass more than one argument to `andReturn`, `andCall`, or `andThrow`, DartMocks will build a sequence of behaviours.

    test("returning multiple values", (){
      var player = stub("Player")
                   ..stub("get isOn").andReturn(true)
                   ..stub("changeVolume").andReturn(10,20,30);

      var remote = new RemoteControl(player);
      expect(remote.turnUp(), equals(10));
      expect(remote.turnUp(), equals(20));
      expect(remote.turnUp(), equals(30));

      //expect(remote.turnUp(), equals(40)); Will throw: No more actions for method changeVolume.
    });

Note, that the stub throws an exception because the `changeVolume` method sort of “ran out” of return values.

### Partial Test Doubles

A partial test double, being an anti pattern, can still be useful in some situations. To create a partial test double just set the `real` property on a test double.

    test("partial stubs", (){
      var realPlayer = new Player()..isOn=false;
      var playerThatIsAlwaysOn = stub("Partial")
                                 ..real = realPlayer
                                 ..stub("get isOn").andReturn(true);

      expect(playerThatIsAlwaysOn.isOn, equals(true));
      expect(playerThatIsAlwaysOn.changeVolume(100), equals(100));
    });

### Pure

If you don't want your test double to respond to framework methods (e.g., `stub` or `shouldReceive`), call pure on it. The `pure` method returns a test double that can only respond to the messages you configured.

    test("pure", (){
      var player = stub({"get isOn" : true});
      var pure = player.pure();

      expect(pure.isOn, equals(true));

      //player.stub will work
      expect(() => pure.stub("blah"), throws);
    });


## Expectations

### Setting Expectations

    test("setting expectations", (){
      var player = mock()
                   ..shouldReceive("get isOn").andReturn(false);

      var remote = new RemoteControl(player);
      remote.turnUp();

      player.verify();
    });

The `verify` method will check if all the set expectations have been met.

### Using `currentTestRun`

Calling verify on every created mock can be tedious. To help you with that, DartMocks stores all expectations. So you can check all of them at once by calling `currentTestRun.verify()`.

    tearDown((){
      currentTestRun.verify();
    });

    test("setting expectations", (){
      var player = mock()
                   ..shouldReceive("get isOn").andReturn(false);

      var remote = new RemoteControl(player);
      remote.turnUp();
    });

## N Times

DartMocks allows you to specify how many times a particular method should be called.

    test("specifying the number of calls", (){
      var player = mock()
                   ..shouldReceive("get isOn").andReturn(false).times(2);

      var remote = new RemoteControl(player);

      remote.turnUp();
      remote.turnUp();
    });


## Extending Test Doubles

### Using TestDouble

Both the `mock` and `stub` functions return an instance of `TestDouble`. Which means that you can use the `TestDouble` class directly.

     test("using TestDouble", (){
      var player = new TestDouble()
                     ..name = "Player"
                     ..stub("get isOn").andReturn(false);

      var remote = new RemoteControl(player);
      expect(remote.turnUp(), equals(0));
    });

### TestDouble Implementing an Interface

If you run your app in the checked mode, the following code will throw an exception:

    Player player = stub();

To fix it you have to create a test double implementing the Player interface.

    class TestDoublePlayer extends TestDouble implements Player {}

    test("test doubles implementing interfaces", (){
      Player player = new TestDoublePlayer()
                     ..stub("get isOn").andReturn(false);

      var remote = new RemoteControl(player);
      expect(remote.turnUp(), equals(0));
    });

