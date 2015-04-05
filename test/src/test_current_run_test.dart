part of dartmocks_test;

testCurrentTestRun() {
  group("[currentTestRun]", () {
    setUp(() {
      currentTestRun.clear();
    });

    test("returns normally when all expectations are met", () {
      var double1 = mock('Double1')..shouldReceive("method1");
      var double2 = mock('Double2')..shouldReceive("method2");

      double1.method1();
      double2.method2();

      expect(currentTestRun.verify, returnsNormally);
    });

    test("throws when some expectations are not met", () {
      var double1 = mock('Double1')..shouldReceive("method1");
      var double2 = mock('Double2')..shouldReceive("method2");

      double1.method1();

      expect(currentTestRun.verify, throws);
    });
  });
}
