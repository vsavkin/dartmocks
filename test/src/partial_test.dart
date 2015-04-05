part of dartmocks_test;

testPartial() {
  group("[partial]", () {
    var partial;

    setUp(() {
      partial = stub()
        ..real = [1, 2, 3]
        ..stub("get size").andReturn(1000);
    });

    test("calls the stub method when available", () {
      expect(partial.size, equals(1000));
    });

    test("calls the method on the real object otherwise", () {
      expect(partial.first, equals(1));
    });

    test("throws when neither object responds to the message", () {
      expect(() => partial.invalidMessage, throws);
    });

    test("throws an expected exception", () {
      partial.stub("get first").andThrow(new FormatException());
      expect(() => partial.first, throwsA(new isInstanceOf<FormatException>()));
    });
  });
}
