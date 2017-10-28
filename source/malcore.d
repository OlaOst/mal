module malcore;

import env;
import types.malbuiltinfunction;
import types.malinteger;
import types.malatom;
import types.maltype;


Env makeCoreEnv()
{
  auto env = new Env(null);
  
  env["+"] = new MalBuiltinFunction(&builtinAdd);
  env["*"] = new MalBuiltinFunction(&builtinMul);
  env["print"] = new MalBuiltinFunction(&builtinPrint);
  
  return env;
}

MalType builtinAdd(MalType[] arguments)
{
  import std.algorithm : all, map, sum;
  import std.exception : enforce;
  enforce(arguments.all!(argument => cast(MalInteger)argument !is null), "All arguments to + must evaluate to numbers");
  auto result = arguments.map!(argument => (cast(MalInteger)argument)).sum;
  return new MalInteger(result);
}

MalType builtinMul(MalType[] arguments)
{
  import std.algorithm : all, map, reduce;
  import std.exception : enforce;
  enforce(arguments.all!(argument => cast(MalInteger)argument !is null), "All arguments to + must evaluate to numbers");
  auto result = arguments.map!(argument => (cast(MalInteger)argument)).reduce!"a*b";
  return new MalInteger(result);
}

MalType builtinPrint(MalType[] arguments)
{
  import std.stdio : writeln;
  arguments[0].print.writeln;
  return new MalNil();
}
