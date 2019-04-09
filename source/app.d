module main;

import std.conv : to;
import std.stdio : readln, write, writeln;

import ast;
import env;
import repl;


void main()
{  
  auto env = new Env(null);
  env["+"] = new MalFunc(&builtinAdd);
  env["*"] = new MalFunc(&builtinMul);
   
  while (true)
  {
    try
    {
      import core.stdc.errno;
      
      write("user>");
      auto line = readln();
      auto input = line.to!string;
      
      if (input == "exit")
        break;
      if (input.length == 0)
        continue;
            
      input.rep(env).writeln;
    }
    catch (Exception ex)
    { 
      writeln("EH? ", ex);
      writeln(env.print);
    }
  }
}
