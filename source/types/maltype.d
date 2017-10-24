module types.maltype;

import env;


abstract class MalType
{
  MalType eval(Env env);
  string print();
}
