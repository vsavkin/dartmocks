part of dartmocks_test;

testStubbing() {
  group("[stubbing]", () {
    test("stubs a method without arguments", () {
      var testStub = stub('Stub');
      testStub.stub("stubbedMethod").andReturn(10);

      expect(testStub.stubbedMethod(), equals(10));
    });

    test("stubs multiple methods", () {
      var testStub = stub('Stub');
      testStub.stub('method1').andReturn(10);
      testStub.stub('method2').andReturn(20);

      expect(testStub.method1(), equals(10));
      expect(testStub.method2(), equals(20));
    });

    test("stubs with arguments", () {
      var testStub = stub('Stub');
      testStub.stub('method').with(true).andReturn(10);
      testStub.stub('method').with(false).andReturn(20);

      expect(testStub.method(true), equals(10));
      expect(testStub.method(false), equals(20));
    });

    test("stubs with multiple arguments", () {
      var testStub = stub('Stub');
      testStub.stub('method').with(1, true).andReturn(10);

      expect(testStub.method(1, true), equals(10));
    });

    test("stubs with consecutive return values", () {
      var testStub = stub('Stub');
      testStub.stub("stubbedMethod").andReturn(10, 20);

      expect(testStub.stubbedMethod(), equals(10));
      expect(testStub.stubbedMethod(), equals(20));
    });

    test("stubs with consecutive return values throw an exception when no more return values", () {
      var testStub = stub('Stub');
      testStub.stub("stubbedMethod").andReturn(10, 20);

      expect(testStub.stubbedMethod(), equals(10));
      expect(testStub.stubbedMethod(), equals(20));
      expect(() => testStub.stubbedMethod(), throws);
    });

    test("stubs that throw", () {
      var testStub = stub('Stub');
      testStub.stub("method").andThrow("exception");

      expect(() => testStub.method(), throwsA("exception"));
    });

    test("stubs that calls a custom function", () {
      var testStub = stub('Stub');
      testStub.stub("method").andCall((value) => value);

      expect(testStub.method(10), equals(10));
    });

    test("stubs behave as null objects when specified", () {
      var testStub = stub('Stub');
      testStub.asNullObject();

      expect(testStub.invalidMethod(), isNull);
    });

    test("stub with getters", () {
      var testStub = stub("Stub");
      testStub.stub("get prop").andReturn(10);
      expect(testStub.prop, equals(10));
    });

    test("stub with setters", () {
      var testStub = stub("Stub");
      testStub.stub("set prop");
      expect(() => testStub.prop = 10, returnsNormally);
    });

    test("stub initialized with a map", () {
      var testStub = stub("Stub", {
          "method" : 10
      });
      expect(testStub.method(), equals(10));
    });

    test("name is optional", () {
      var testStub = stub({
          "method" : 10
      });
      expect(testStub.method(), equals(10));
    });
  });
}