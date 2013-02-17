# DartMocks

[![Build Status](https://drone.io/github.com/vsavkin/dartmocks/status.png)](https://drone.io/github.com/vsavkin/dartmocks/latest)

DartMocks is a mock framework for Dart inspired by RSpec. It's built on top of unittest/mock.

## INSTALLATION

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


For more details, see:

  * stubbing_test.dart
  * expectations_test.dart
  * pure_test.dart