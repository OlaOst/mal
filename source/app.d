module main;

import std.conv : to;
import std.stdio : readln, write, writeln;

import deimos.linenoise;

import ast;
import env;
import repl;


void main()
{  
  auto env = new Env(null);
  env["+"] = new MalFunc(&builtinAdd);
  env["*"] = new MalFunc(&builtinMul);
  
  linenoiseHistorySetMaxLen(128);
  
  while (true)
  {
    try
    {
      auto line = linenoise("user> ");
      auto input = line.to!string;
      
      if (input.length == 0)
        continue;
        
      if (input == "exit")
        break;
      
      line.linenoiseHistoryAdd();
        
      input.rep(env).writeln;
    }
    catch (Exception ex)
    { 
      writeln("EH? ", ex);
      writeln(env.print);
    }
  }
}
