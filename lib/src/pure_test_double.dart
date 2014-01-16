part of dartmocks;

@proxy
class PureTestDouble {
  TestDouble _testDouble;
  PureTestDouble(this._testDouble);
  noSuchMethod(mirror) => _testDouble.noSuchMethod(mirror);
}