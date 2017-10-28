module types.malclosure;

import env;
import types.malfunction;
import types.mallist;
import types.malsymbol;
import types.maltype;


class MalClosure : MalFunction
{
  MalSymbol[] binds;
  
  this(MalType bindingListType, MalType functionBody)
  {
    import std.exception;
    
    auto bindingList = cast(MalList)bindingListType;
    enforce(bindingList !is null, "First parameter to fn* must be a list of symbols, not ", bindingListType.type);
    
    this(bindingList.items, functionBody);
  }
  
  this(MalType[] binds, MalType functionBody)
  {
    super(functionBody);
    
    import std.algorithm : all, map;
    import std.array : array;
    import std.exception : enforce;
    
    enforce(binds.all!(bind => cast(MalSymbol)bind !is null));
    
    this.binds = binds.map!(bind => cast(MalSymbol)bind).array;
    this.functionBody = functionBody;
  }
  
  MalType eval(Env env)
  {
    auto newEnv = new Env(env);
    
    import std.conv : to;
    import std.exception : enforce;
    
    enforce(binds.length == arguments.length, "Got " ~ binds.length.to!string ~ " binds and " ~ arguments.length.to!string ~ " arguments, these should have the same number");
    
    import std.range : lockstep;
    foreach (bind, argument; lockstep(binds, arguments))
    {
      newEnv[bind.name] = argument;
    }
    
    return functionBody.eval(newEnv);
  }
}
