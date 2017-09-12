string read(string input)
{
  import std.range : join;
  import std.array : array;
  
  return input.Tokenizer.array.join(",");
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
  import std.string : stripRight;
  return input.stripRight.read.eval.print;
}

struct Tokenizer
{
  string input;
  string token;
  
  bool empty() const
  {
    import std.range.primitives : empty;
    
    return input.empty;
  }
  
  void popFront()
  {
  }
  
  void popFrontInternal()
  {
    import std.algorithm : any, canFind, findSplitAfter, stripLeft;
    import std.exception : enforce;
    import std.range.primitives : empty, front;
    import std.uni : isWhite;
    
    auto startLength = input.length;

    input = input.stripLeft!isWhite;
    
    if (input.front == '"')
    {
      auto match = input[1..$].findSplitAfter("\"");
      enforce(!match[0].empty, "Could not find closing quote");
      token = input[0] ~ match[0];
      input = match[1];
    }
    else if (['(', ')'].canFind(input.front))
    {
      import std.conv : to;
      import std.range.primitives : popFront;
      
      token = input.front.to!string;
      input.popFront();
    }
    else if (input.front == ';')
    {
      token = input;
      input.length = 0;
    }
    else
    {
      foreach (index, symbol; input)
      {
        if (['(', ')', '"', ';'].canFind(symbol))
        {
          token = input[0..index];
          input = input[index..$];
          break;
        }
        
        if (index == input.length - 1)
        {
          token = input;
          input.length = 0;
        }
      }
    }
    
    assert(startLength > input.length, "Nothing consumed from input: " ~ input);
  }
  
  string front()
  {
    popFrontInternal();
    return token;
  }
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
