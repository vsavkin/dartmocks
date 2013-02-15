part of dartmocks;

stub([arg1, arg2]) => new TestDoubleBuilder(arg1, arg2).build();
mock([String name]) => new TestDoubleBuilder(name, null).build();