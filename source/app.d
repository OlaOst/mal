import std.stdio;


string read(string input)
{
  return input;
}

string eval(string ast)
{
  return ast;
}

string print(string ast)
{
  return ast;
}

string rep(string input)
{
  return input.read.eval.print;
}

void main()
{
  while (true)
  {
    "user> ".write;
    readln.rep.writeln;
  }
}
