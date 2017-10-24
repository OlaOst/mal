module types.malinteger;

import types.malatom;


class MalInteger : MalAtom
{
  int value;
  alias value this;
  
  this(int value)
  {
    this.value = value;
  }
  
  string print()
  {
    import std.conv : to;
    return value.to!string;
  }
}
