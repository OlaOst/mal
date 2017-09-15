module ast;


interface MalType
{
  MalType eval();
  string print();
}

class MalList : MalType
{
  MalType[] types;
  
  this(MalType[] types)
  {
    this.types = types;
  }
  
  MalType eval()
  {
    if (types.length == 0)
      return this;
      
    import std.algorithm : map;
    import std.array : array;
    import std.exception : enforce;
    
    auto types = types.map!(type => type.eval).array;
    
    auto functionName = (cast(MalSymbol)types[0]).name;
    auto args = types[1..$];
    
    if (functionName == "+")
      return builtinAdd(args);
    else if (functionName == "*")
      return builtinMul(args);
    else
      enforce(false, "Don't know the function " ~ functionName);
      
    assert(0);
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
  
  auto result = arguments.map!(argument => (cast(MalSymbol)argument).name.to!int).sum.to!string;
  return new MalSymbol(result);
}

MalType builtinMul(MalType[] arguments)
{
  import std.algorithm : map, reduce, sum;
  import std.conv : to;
  
  auto result = arguments.map!(argument => (cast(MalSymbol)argument).name.to!int);
                         .reduce!"a*b".to!string;
  
  return new MalSymbol(result);
}

class MalSymbol : MalType
{
  string name;
  
  this(string name)
  {
    import std.string : strip;
    this.name = name.strip;
  }
  
  MalType eval()
  {
    return this;
  }
  
  string print()
  {
    return name;
  }
}
