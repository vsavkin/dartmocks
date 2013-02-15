part of dartmocks;

class PureTestDouble {
  TestDouble _testDouble;

  PureTestDouble(this._testDouble);

  noSuchMethod(mirror) => _testDouble.noSuchMethod(mirror);
}