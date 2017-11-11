module types.malstring;

import types.malatom;


class MalString : MalAtom
{
  string value;
  alias value this;
  
  this(string value)
  {
    this.value = value;
  }
    
  string print()
  {
    return value;
  }
}
