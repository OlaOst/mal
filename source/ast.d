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
    import std.algorithm : map;
    import std.array : array;
    import std.exception : enforce;
    
    if (types.length == 0)
      return this;
    
    //import std.stdio : writeln;
    //writeln("list eval, types:");
    //writeln(types.map!(type => typeid(type)));
    //writeln(types.map!(type => type.print));
    
    if (typeid(types[0]) == typeid(MalSymbol))
    {
      auto symbol = cast(MalSymbol)types[0];
      
      if (symbol.name == "def!")
      {
        enforce(types.length == 3, "def! needs exactly two parameters");
        enforce(typeid(types[1]) == typeid(MalSymbol), "def! first parameter must be a symbol");
        
        auto result = types[2].eval(env);
        env[(cast(MalSymbol)types[1]).name] = result;
        return result;
      }
      
      if (symbol.name == "let*")
      {
        import std.algorithm : each;
        import std.range : chunks;
        
        auto newEnv = new Env(env);
        
        enforce(typeid(types[1]) == typeid(MalList), "First parameter to let* must be a list");
        auto bindingList = cast(MalList)types[1];
        
        auto pairs = bindingList.types.chunks(2);
        
        foreach (pair; pairs)
        {
          enforce(typeid(pair[0]) == typeid(MalSymbol), "Every even parameter in let* list must be a symbol");
          newEnv[(cast(MalSymbol)pair[0]).name] = pair[1].eval(newEnv);
        }
        
        return types[2].eval(newEnv);
      }
    }
    
    auto types = types.map!(type => type.eval(env)).array;
    
    if (typeid(types[0]) == typeid(MalFunc))
    {
      auto func = (cast(MalFunc)types[0]);
      auto args = types[1..$];
      
      return func.func(args);
    }
    else
    {
      enforce(types.length == 1, "Length must be 1 for non-function lists");
      return types[0];
    }
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

MalType evaluateSelf(MalType[] arguments)
{
  return arguments[0];
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

class MalString : MalType
{
  string value;
  
  this(string value)
  {
    this.value = value;
  }
  
  MalType eval(Env env)
  {
    return this;
  }
  
  string print()
  {
    return value;
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
