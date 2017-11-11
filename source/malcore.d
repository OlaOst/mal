module malcore;

import env;
import types.malatom;
import types.malbuiltinfunction;
import types.malinteger;
import types.malfunction;
import types.mallist;
import types.malstring;
import types.maltype;


Env makeCoreEnv()
{
  auto env = new Env(null);
  
  env["+"] = new MalBuiltinFunction("+", &builtinAdd);
  env["*"] = new MalBuiltinFunction("*", &builtinMul);
  env["print"] = new MalBuiltinFunction("print", &builtinPrint);
  env["list"] = new MalBuiltinFunction("list", (arguments) => new MalList(arguments));
  env["list?"] = new MalBuiltinFunction("list?", (arguments) => (arguments.length > 0 && typeid(arguments[0]) == typeid(MalList)) ? new MalTrue() : new MalFalse());
  env["empty?"] = new MalBuiltinFunction("empty?", function MalType(MalType[] arguments)
  {
    import std.exception : enforce;
    
    auto list = cast(MalList)arguments[0];
    enforce(list !is null, "First parameter to empty? should be a list, not " ~ arguments[0].type);
    
    if (list.items.length == 0)
      return new MalTrue();
    else
      return new MalFalse();
  });
  env["count"] = new MalBuiltinFunction("count", function MalType(MalType[] arguments)
  {
    import std.exception : enforce;
    
    auto list = cast(MalList)arguments[0];
    enforce(list !is null, "First parameter to count should be a list, not " ~ arguments[0].type);
    
    return new MalInteger(cast(int)list.items.length);
  });
  env["="] = new MalBuiltinFunction("=", &builtinEq);
  env["<"] = new MalBuiltinFunction("<", (arguments) => arguments.ordinalCompare!"<");
  env[">"] = new MalBuiltinFunction(">", (arguments) => arguments.ordinalCompare!">");
  env["<="] = new MalBuiltinFunction("<=", (arguments) => arguments.ordinalCompare!"<=");
  env[">="] = new MalBuiltinFunction(">=", (arguments) => arguments.ordinalCompare!">=");
  env["read-string"] = new MalBuiltinFunction("read-string", function MalType(MalType[] arguments)
  {
	import std.exception : enforce;
	import repl : read;
	
	auto malString = cast(MalString)arguments[0];
	enforce(malString !is null, "First parameter to read-string should be a string, not " ~ arguments[0].type);
	
	return read(malString);
  });
  env["slurp"] = new MalBuiltinFunction("slurp", function MalType(MalType[] arguments)
  {
	import std.exception : enforce;
	import std.file : readText;
	
	auto malString = cast(MalString)arguments[0];
	enforce(malString !is null, "First parameter to slurp should be a string, not " ~ arguments[0].type);
	
	auto content = readText(malString.value);
	
	return new MalString(content);
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

MalType builtinEq(MalType[] arguments)
{
  if (checkEquality(arguments))
    return new MalTrue();
  else
    return new MalFalse();
}

bool checkEquality(MalType[] arguments)
{
  import std.exception : enforce;
    
  assert(arguments.length >= 2);
  
  auto first = arguments[0];
  auto other = arguments[1];
  
  bool result = false;
  if (first.type == other.type)
  {
    if (typeid(first) == typeid(MalList))
    {
      auto firstList = cast(MalList)first;
      auto otherList = cast(MalList)other;
      
      if (firstList.items.length == otherList.items.length)
      {
        import std.algorithm : all;
        import std.array : array;
        import std.range : zip;
        
        result = (firstList.items.zip(otherList.items).all!(pair => builtinEq(pair.array)));
      }
    }
    else
    {
      result = first.print == other.print;
    }
  }
  
  return result;
}

MalType ordinalCompare(string op)(MalType[] arguments)
{
  import std.exception : enforce;
    
  enforce(arguments.length >= 2, "Need at least two arguments to compare");
  auto first = cast(MalInteger)arguments[0];
  auto other = cast(MalInteger)arguments[1];
  
  enforce(first !is null, "Can only compare numbers, not ", arguments[0].type);
  enforce(other !is null, "Can only compare numbers, not ", arguments[1].type);
  
  mixin("auto comparison = (first.value " ~ op ~ " other.value);");
  if (comparison)
    return new MalTrue();
  else
    return new MalFalse();
}
