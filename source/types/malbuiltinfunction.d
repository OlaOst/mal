module types.malbuiltinfunction;

import env;
import types.malfunction;
import types.maltype;


alias func = MalType function(MalType[] arguments);

class MalBuiltinFunction : MalFunction
{
  func builtinFunction;
  
  this(func builtinFunction)
  {
    super(this);
    
    this.builtinFunction = builtinFunction;
  }
  
  MalType eval(Env env)
  {
    return builtinFunction(arguments);
  }
}
