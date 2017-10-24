module types.malfunction;

import env;
import types.malsymbol;
import types.maltype;


abstract class MalFunction : MalSymbol
{
  //MalType[] arguments;
  
  this(string name)
  {
    super(name);
  }
  
  MalType eval(Env env)
  {
    return this;
  }
  
  MalType apply(MalType[] arguments, Env env);
}
