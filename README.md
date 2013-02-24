# DartMocks

[![Build Status](https://drone.io/github.com/vsavkin/dartmocks/status.png)](https://drone.io/github.com/vsavkin/dartmocks/latest)

DartMocks is a mock framework for Dart inspired by RSpec. It's built on top of unittest/mock.

## Installation

Add the DartMocks dependency to your project’s pubspec.yaml.

    name: my_project
    dependencies:
      dartmocks: any

And `run pub install`.

## Examples

### Stubs

    var testStub = stub('My Stub');
    testStub.stub('method').args(1, true).andReturn(10);
    expect(testStub.method(1, true), equals(10));

Or

    var testStub = stub("My Stub", {"method" : 10});
    expect(testStub.method(), equals(10));


### Expectations

    var testDouble = mock('Double');
    testDouble.shouldReceive('method').args('arg');

    testDouble.method('arg');

    expect(testDouble.verify, returnsNormally);

OR

    var testDouble = mock('Double');
    testDouble.shouldReceive('method');

    expect(testDouble.verify, throws);

### Test doubles implementing interfaces

    abstract class Greeter {
      String greet();
    }
    String greet(Greeter m) => m.greet();
    class GreeterDouble extends TestDouble implements Greeter {}

And the test:

    var s = new GreeterDouble()
            ..name = "Greeter"
            ..stub("greet").andReturn("Result");

    expect(greet(s), equals("Result"));;

### Verifying all expectations

Calling verify on every created mock can be tedious. You can use `currentTestRun.verify()` instead.

    group("[group]", (){
      tearDown((){
        currentTestRun.verify();
      });

      test("with expectations", (){
        var double1 = mock('Double1')..shouldReceive("method1");
        var double2 = mock('Double2')..shouldReceive("method2");

        double1.method1();
        double2.method2();
      });
    });

### Partial test doubles

Though using partial test doubles is considered to be a bad practice, it can be useful sometimes.

    partial = stub()
              ..real = [1, 2, 3]
              ..stub("get size").andReturn(1000);

    expect(partial.size, equals(1000));
    expect(partial.first, equals(1));

### For more details, see:

  * stubbing_test.dart
  * expectations_test.dart
  * pure_test.dart