module forms.let;

import env;
import types.mallist;
import types.malsymbol;
import types.maltype;


MalType eval(MalType[] arguments, Env env)
{
  import std.algorithm : each;
  import std.exception : enforce;
  import std.range : chunks;
  
  auto newEnv = new Env(env);
  
  enforce(typeid(arguments[0]) == typeid(MalList), "First parameter to let* must be a list");
  auto bindingList = cast(MalList)arguments[0];
  
  auto pairs = bindingList.items.chunks(2);
  
  foreach (pair; pairs)
  {
    enforce(typeid(pair[0]) == typeid(MalSymbol), "Every even parameter in the let* binding list must be a symbol");
    newEnv[(cast(MalSymbol)pair[0]).name] = pair[1].eval(newEnv);
  }
  
  return arguments[1].eval(newEnv);
}
