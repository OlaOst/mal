module repl;

import ast;
import reader;


MalType read(string input)
{
  import std.range : join;
  import std.array : array;
  
  auto reader = new Reader(input);
  
  return reader.readForm;
}

MalType eval(MalType ast)
{
  return ast;
}

string print(MalType ast)
{
  return ast.print;
}

string rep(string input)
{
  import std.string : strip;
  return input.strip.read.eval.print;
}
