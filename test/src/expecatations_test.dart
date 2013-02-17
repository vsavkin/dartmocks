part of dartmocks_test;

testExpectations() {
  group("[expectations]", () {
    test("expectations fail when not invoked", () {
      var testDouble = mock('Double');
      testDouble.shouldReceive('method');

      expect(testDouble.verify, throws);
    });

    test("expectations pass when invoked", () {
      var testDouble = mock('Double');
      testDouble.shouldReceive('method');

      testDouble.method();

      expect(testDouble.verify, returnsNormally);
    });

    test("usage fails when incorrect arguments used", () {
      var testDouble = mock('Double');
      testDouble.shouldReceive('method').with('arg');

      expect(() => testDouble.method('not arg'), throws);
    });

    test("expectations fail when incorrect arguments used", () {
      var testDouble = mock('Double');
      testDouble.stub('method').andReturn(10);
      testDouble.shouldReceive('method').with('arg');

      testDouble.method('not arg');

      expect(testDouble.verify, throws);
    });

    test("expectations fail when called multiple times", () {
      var testDouble = mock('Double');
      testDouble.shouldReceive('method');

      testDouble.method();
      testDouble.method();

      expect(testDouble.verify, throws);
    });

    test("expectations fail when not called multiple times", () {
      var testDouble = mock('Double');
      testDouble.shouldReceive('method').times(2);

      testDouble.method();

      expect(testDouble.verify, throws);
    });

    test("expectations should support getters", () {
      var testDouble = mock('Double');
      testDouble.shouldReceive("get prop");
      expect(testDouble.verify, throws);
    });

    test("stub with setters", () {
      var testDouble = mock('Double');
      testDouble.shouldReceive("set prop");
      expect(testDouble.verify, throws);
    });

    test("stub with setters with arguments", () {
      var testDouble = mock('Double');
      testDouble.stub("set prop");

      testDouble.shouldReceive("set prop").with(10);

      testDouble.prop = 20;

      expect(testDouble.verify, throws);
    });
  });
}