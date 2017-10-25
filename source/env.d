module env;

import types.maltype;


class Env
{
  //alias Func = MalType function(MalType[] arguments);
  
  MalType[string] data;
  alias data this;
  
  Env outer;
  
  this(Env outer)
  {
    this.outer = outer;
  }
  
  void opIndexAssign(MalType value, string key)
  {
    data[key] = value;
  }
  
  MalType opIndex(string key)
  {
    import std.exception : enforce;
    
    auto match = key in data;
    
    if (match is null)
    {
      if (outer !is null)
      {
        return outer[key];
      }
      else
      {
        enforce(false, "Did not find key " ~ key ~ " in any environment");
        assert(0);
      }
    }
    else
    {
      return *match;
    }
  }
  
  string print()
  {
    import std.conv : to;
    
    string[string] printable;
    foreach (keyValue; data.byKeyValue)
    {
      printable[keyValue.key] = keyValue.value.type;
    }
    
    if (outer !is null)
      return printable.to!string ~ "\n" ~ outer.print;
    else
      return printable.to!string;
  }
}
