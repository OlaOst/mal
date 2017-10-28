module types.malbuiltinfunction;

import env;
import types.malfunction;
import types.maltype;


alias func = MalType function(MalType[] arguments);

class MalBuiltinFunction : MalFunction
{
  func builtinFunction;
  
  this(string name, func builtinFunction)
  {
    super(name, this);
    
    this.builtinFunction = builtinFunction;
  }
  
  MalType eval(Env env)
  {
    return builtinFunction(arguments);
  }
}
