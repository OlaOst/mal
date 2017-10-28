module types.mallist;

import env;
import types.malclosure;
import types.malfunction;
import types.malsymbol;
import types.maltype;


class MalList : MalType
{
  MalType[] items;
  
  this(MalType[] items)
  {
    this.items = items;
  }
  
  MalType eval(Env env)
  {
    auto debugMode = "debug" in env;
    import types.malatom : MalTrue;
    if (debugMode !is null && typeid(*debugMode) == typeid(MalTrue))
    {
      import std.algorithm : map;
      import std.stdio : writeln;
      writeln("list types:", items.map!(item => item.type));
      writeln("list values: ", items.map!(item => item.print));
      writeln("env: ", env.print);
    }
    
    if (items is null || items.length == 0)
      return this;
    
    // special forms
    auto specialSymbol = cast(MalSymbol)items[0];
    if (specialSymbol !is null)
    {
      alias noVoidEnv = env;
      
      import forms.def;
      import forms.let;
      
      if (specialSymbol.name == "def!")
        return forms.def.eval(items[1..$], noVoidEnv);
      if (specialSymbol.name == "let*")
        return forms.let.eval(items[1..$], noVoidEnv);
      if (specialSymbol.name == "do")
        return forms.maldo.eval(items[1..$], noVoidEnv);
      if (specialSymbol.name == "fn*")
        return new MalClosure(items[1], items[2]);
    }
    
    import std.algorithm : map;
    import std.array : array;
    import std.exception : enforce;
    
    auto evaluatedList = items.map!(item => item.eval(env)).array;
    auto evaluatedSymbol = cast(MalSymbol)evaluatedList[0];
    enforce(evaluatedSymbol !is null, "Expected MalSymbol as first element, got " ~ evaluatedList[0].type);
    auto evaluatedArguments = evaluatedList[1..$];
    
    auto evaluatedFunction = cast(MalFunction)evaluatedSymbol;
    if (evaluatedFunction !is null)
      return evaluatedFunction.apply(evaluatedArguments, env);
    
    import std.algorithm : all;
    import types.malinteger;
    if (evaluatedSymbol.name == "+")
    {
      import std.algorithm : sum;
      enforce(evaluatedArguments.all!(argument => cast(MalInteger)argument !is null), "All arguments to + must be numbers");
      auto result = evaluatedArguments.map!(argument => (cast(MalInteger)argument)).sum;
      return new MalInteger(result);
    }
    if (evaluatedSymbol.name == "*")
    {
      import std.algorithm : reduce;
      enforce(evaluatedArguments.all!(argument => cast(MalInteger)argument !is null), "All arguments to * must be numbers");
      auto result = evaluatedArguments.map!(argument => (cast(MalInteger)argument)).reduce!"a*b";
      return new MalInteger(result);
    }
    
    enforce(false, "Don't know how to evaluate " ~ evaluatedSymbol.name);
    assert(0);
  }
  
  string print()
  {
    import std.algorithm : map;
    import std.range : join;
    return "(" ~ items.map!(item => item.print).join(" ") ~ ")";
  }
}
