module repl;

import ast;
import env;
import reader;


MalType read(string input)
{
  import std.range : join;
  import std.array : array;
  
  auto reader = new Reader(input);
  
  return reader.readForm;
}

string print(MalType ast)
{
  return ast.print;
}

string rep(string input, Env env)
{
  import std.string : strip;
  return input.strip.read.eval(env).print;
}
