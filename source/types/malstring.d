module types.malstring;

import types.malatom;


class MalString : MalAtom
{
  string value;
  
  this(string value)
  {
    this.value = value;
  }
    
  string print()
  {
    return value;
  }
}
