module main;

import ast;
import env;
import repl;


void main()
{
  import std.stdio : readln, write, writeln;
  
  auto env = new Env(null);
  env["+"] = new MalFunc(&builtinAdd);
  env["*"] = new MalFunc(&builtinMul);
  
  while (true)
  {
    try
    {
      "user> ".write;
      readln.rep(env).writeln;
    }
    catch (Exception ex)
    {
      import std.conv : to;
      
      writeln("EH? ", ex);
      writeln(env);
      writeln(env.outer);
    }
  }
}
