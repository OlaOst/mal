module tokenizer;


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
		import std.algorithm : stripLeft;
		import std.uni : isWhite;
		
    input = input.stripLeft!isWhite[front.length .. $];
  }
  
  string front() const
  {
    import std.algorithm : any, canFind, findSplitAfter, stripLeft;
    import std.exception : enforce;
    import std.range.primitives : empty, front;
    import std.uni : isWhite;

    auto input = this.input.stripLeft!isWhite;
    string token = null;
    
    auto startLength = input.length;
    
    enforce(!input.empty);
    
    if (input.front == '"')
    {
      auto match = input[1..$].findSplitAfter("\"");
      enforce(!match[0].empty, "Could not find closing quote in ", input);
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
        if (['(', ')', '"', ';', ' '].canFind(symbol))
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
    assert(token !is null && token.length, "Zero length token from input: " ~ input);
    
    return token;
  }
}
