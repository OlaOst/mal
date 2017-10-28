module forms.malif;

import env;
import types.malatom;
import types.maltype;


MalType eval(MalType[] arguments, Env env)
{
  import std.exception : enforce;
  
  enforce(arguments.length >= 2, "Need at least two arguments for if form");
  
  auto condition = arguments[0].eval(env);
  
  if (typeid(condition) != typeid(MalNil) && typeid(condition) != typeid(MalFalse))
    return arguments[1].eval(env);
  else if (arguments.length >= 3)
    return arguments[2].eval(env);
  else
    return new MalNil();
}
