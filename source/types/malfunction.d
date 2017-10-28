module types.malfunction;

import env;
import types.mallist;
import types.malsymbol;
import types.maltype;


class MalFunction : MalSymbol
{
  MalType functionBody;
  MalType[] arguments;
  
  this(MalType functionBody)
  {
    this("<function>", functionBody);
  }
  
  this(string name, MalType functionBody)
  {
    super(name);
    
    this.functionBody = functionBody;
  }
  
  MalType apply(MalType[] arguments, Env env)
  {
    this.arguments = arguments;
    return eval(env);
  }
  
  abstract MalType eval(Env env);
}
