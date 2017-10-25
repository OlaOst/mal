module forms.maldo;

import env;
import types.maltype;


MalType eval(MalType[] arguments, Env env)
{
  import std.algorithm : map;
  import std.array : array;
  
  auto result = arguments.map!(argument => argument.eval(env));
  
  return result.array[$-1];
}
