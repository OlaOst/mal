module main;

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
  import std.string : stripRight;
  return input.stripRight.read.eval.print;
}

void main()
{
  import std.algorithm : each;
  import std.stdio : readln, write, writeln;
    
  while (true)
  {
    "user> ".write;
    readln.rep.writeln;
  }
}
