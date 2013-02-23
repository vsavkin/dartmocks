part of dartmocks_test;

abstract class Greeter {
  String greet();
}

String greet(Greeter m) => m.greet();

class GreeterDouble extends TestDouble implements Greeter {}

testWithInterfaces() {
  group("[with interfaces]", () {
    test("stubbing methods", (){
      var s = new GreeterDouble()
              ..name = "Greeter"
              ..stub("greet").andReturn("Result");

      expect(greet(s), equals("Result"));;
    });

    test("setting expectations", (){
      var s = new GreeterDouble()
              ..shouldReceive("greet").andReturn("Result");

      greet(s);

      s.verify();
    });
  });
}