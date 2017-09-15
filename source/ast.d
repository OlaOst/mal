module ast;

import env;


abstract class MalType
{
  MalType eval(Env env);
  string print();
}

class MalList : MalType
{
  MalType[] types;
  
  this(MalType[] types)
  {
    this.types = types;
  }
  
  MalType eval(Env env)
  {
    if (types.length == 0)
      return this;
      
    import std.algorithm : map;
    import std.array : array;
    import std.exception : enforce;
    
    auto types = types.map!(type => type.eval(env)).array;
    
    auto func = (cast(MalFunc)types[0]);
    auto args = types[1..$];
    
    return func.func(args);
  }
  
  string print()
  {
    import std.algorithm : map;
    import std.range : join;
    
    return "(" ~ types.map!(type => type.print).join(" ") ~ ")";
  }
}

MalType builtinAdd(MalType[] arguments)
{
  import std.algorithm : map, sum;
  import std.conv : to;
  
  auto result = arguments.map!(argument => (cast(MalInteger)argument)).sum;
  return new MalInteger(result);
}

MalType builtinMul(MalType[] arguments)
{
  import std.algorithm : map, reduce, sum;
  import std.conv : to;
  
  auto result = arguments.map!(argument => (cast(MalInteger)argument)).reduce!"a*b";
  
  return new MalInteger(result);
}

class MalSymbol : MalType
{
  string name;
  
  this(string name)
  {
    import std.string : strip;
    this.name = name.strip;
  }
  
  MalType eval(Env env)
  {
    return env[name];
  }
  
  string print()
  {
    return name;
  }
}

class MalInteger : MalType
{
  int value;
  alias value this;
  
  this(int value)
  {
    this.value = value;
  }
  
  MalType eval(Env env)
  {
    return this;
  }
  
  string print()
  {
    import std.conv : to;
    
    return value.to!string;
  }
}

class MalFunc : MalType
{
  MalType function(MalType[] arguments) func;
  
  this(MalType function(MalType[] arguments) func)
  {
    this.func = func;
  }
  
  MalType eval(Env env)
  {
    auto arguments = null;
    return func(arguments);
  }
  
  string print()
  {
    return "<func>";
  }
}
