module types.maltype;

import env;


abstract class MalType
{
  MalType eval(Env env);
  string print();
  
  string type()
  {
    import std.string : split;
    return typeid(this).name.split(".")[$-1];
  }
}
