part of dartmocks_test;

testPure() {
  group("[pure]", () {
    test("doesn't respond to framework methods", () {
      var testDouble = mock('Double');
      var pureDouble = testDouble.pure();
      expect(() => pureDouble.asNullObject(), throws);
    });

    test("responds to expectations", () {
      var testDouble = mock('Double')..stub('method').andReturn(10);

      var pureDouble = testDouble.pure();
      expect(pureDouble.method(), equals(10));
    });
  });
}