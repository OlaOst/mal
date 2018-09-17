module types.malatom;

import env;
import types.maltype;


class MalAtom : MalType
{
  override MalType eval(Env env)
  {
    return this;
  }
  
  override string print()
  {
    import std.string : split;
    return "<" ~ this.classinfo.name.split(".")[$-1] ~ ">";
  }
}

class MalNil : MalAtom {}
class MalTrue : MalAtom {}
class MalFalse : MalAtom {}
