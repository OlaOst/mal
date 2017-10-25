module types.mallist;

import env;
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
    
    import std.exception : enforce;  
    enforce(cast(MalSymbol)items[0] !is null, "First item of evaluated list must be a MalSymbol, got " ~ items[0].type ~ " instead");
    
    {
      alias noVoidEnv = env;
      
      import forms.def;
      import forms.let;
      
      auto symbol = cast(MalSymbol)items[0];
      
      // special forms
      if (symbol.name == "def!")
        return forms.def.eval(items[1..$], noVoidEnv);
      if (symbol.name == "let*")
        return forms.let.eval(items[1..$], noVoidEnv);
      // end of special forms
      
      import std.algorithm : map;
      import std.exception : enforce;
      
      auto evaluatedList = items.map!(item => item.eval(noVoidEnv));
      enforce((cast(MalSymbol)evaluatedList[0]) !is null, "Expected MalSymbol, got " ~ evaluatedList[0].type);
      auto evaluatedSymbol = cast(MalSymbol)evaluatedList[0];
      auto evaluatedArguments = evaluatedList[1..$];
      
      import std.algorithm : all;
      import types.malinteger;
      if (symbol.name == "+")
      {
        import std.algorithm : sum;
        enforce(evaluatedArguments.all!(argument => cast(MalInteger)argument !is null), "All arguments to + must be numbers");
        auto result = evaluatedArguments.map!(argument => (cast(MalInteger)argument)).sum;
        return new MalInteger(result);
      }
      if (symbol.name == "*")
      {
        import std.algorithm : reduce;
        enforce(evaluatedArguments.all!(argument => cast(MalInteger)argument !is null), "All arguments to * must be numbers");
        auto result = evaluatedArguments.map!(argument => (cast(MalInteger)argument)).reduce!"a*b";
        return new MalInteger(result);
      }
    }
    
    assert(0);
  }
  
  string print()
  {
    import std.string : split;
    return "<" ~ typeid(this).name.split(".")[$-1] ~ ">";
  }
}
