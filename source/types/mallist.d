module types.maldef;

import env;
import types.malfunction;
import types.malsymbol;
import types.maltype;


class MalList : MalType
{
  MalType[] items;
  
  this(MalType[] items)
  {
    this.items = items;
    
    if (this.items is null || this.items.length == 0)
    {
      import std.exception : enforce;
      enforce(typeid(items[0]) == typeid(MalFunction), "First parameter of a list form must be a function symbol");
    }
  }
  
  MalType eval(Env env)
  {
    auto functionSymbol = cast(MalFunction)items[0];
    return functionSymbol.apply(items[1..$], env);
  }
  
  string print()
  {
    import std.string : split;
    return "<" ~ this.classinfo.name.split(".")[$-1] ~ ">";
  }
}
