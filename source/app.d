module main;

import std.conv : to;
import std.stdio : readln, write, writeln;

import deimos.linenoise;

import env;
import repl;
import types.malsymbol;


void main()
{  
  auto env = new Env(null);
  env["+"] = new MalSymbol("+");
  env["*"] = new MalSymbol("*");
  
  linenoiseHistorySetMaxLen(128);
  
  while (true)
  {
    try
    {
      import core.stdc.errno;
      
      auto line = linenoise("user> ");
      auto input = line.to!string;
      
      if (errno == EAGAIN) // linenoise sets errno to EAGAIN on ctrl-c
        break;
      if (input == "exit")
        break;
      if (input.length == 0)
        continue;
      
      line.linenoiseHistoryAdd();
        
      input.rep(env).writeln;
    }
    catch (Exception ex)
    { 
      writeln("EH? ", ex.msg);
      writeln(env.print);
    }
  }
}
