module forms.def;

import env;
import types.malsymbol;
import types.maltype;


MalType eval(MalType[] arguments, Env env)
{
  import std.conv : to;
  import std.exception : enforce;
    
  enforce(arguments.length == 2, "def! needs exactly two parameters, got " ~ arguments.length.to!string);
  enforce(typeid(arguments[0]) == typeid(MalSymbol), "def! first parameter must be a symbol");
      
  auto result = arguments[1].eval(env);
  env[(cast(MalSymbol)arguments[0]).name] = result;
  
  return result;
}
