library dartmocks_test;

import 'package:dartmocks/dartmocks.dart';
import 'package:unittest/unittest.dart';

part 'src/stub_test.dart';
part 'src/mock_test.dart';
part 'src/pure_test.dart';

main() {
  testStub();
  testMock();
  testPure();
//partial mocks
//object construction
//yield
}