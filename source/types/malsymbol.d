module types.malsymbol;

import env;
import types.maltype;


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
