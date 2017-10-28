module malcore;

import env;
import types.malatom;
import types.malbuiltinfunction;
import types.malinteger;
import types.mallist;
import types.maltype;


Env makeCoreEnv()
{
  auto env = new Env(null);
  
  env["+"] = new MalBuiltinFunction(&builtinAdd);
  env["*"] = new MalBuiltinFunction(&builtinMul);
  env["print"] = new MalBuiltinFunction(&builtinPrint);
  env["list"] = new MalBuiltinFunction((arguments) => new MalList(arguments));
  env["list?"] = new MalBuiltinFunction((arguments) => (arguments.length > 0 && typeid(arguments[0]) == typeid(MalList)) ? new MalTrue() : new MalFalse());
  env["empty?"] = new MalBuiltinFunction(function MalType(MalType[] arguments)
  {
    import std.exception : enforce;
    
    auto list = cast(MalList)arguments[0];
    enforce(list !is null, "First parameter to empty? should be a list, not " ~ arguments[0].type);
    
    if (list.items.length == 0)
      return new MalTrue();
    else
      return new MalFalse();
  });
  
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
