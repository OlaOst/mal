module reader;

import ast;


MalType readForm(Reader reader)
{
  if (reader.front == "(")
    return reader.readList;
  else
    return reader.readAtom;
}

MalList readList(Reader reader)
{
  assert(reader.front == "(");
  reader.popFront(); // pop the '(' token
  
  MalType[] types;
  
  while (reader.front != ")")
  {
    types ~= reader.readForm;
    reader.popFront();
  }
 
	auto list = new MalList(types);
  return list;
}

MalType readAtom(Reader reader)
{
	import std.algorithm : strip;
	import std.conv : to;
	import std.string : isNumeric;
	
	auto token = reader.front;
	
	if (token == "nil")
		return new MalNil;
	else if (token == "true")
		return new MalTrue;
	else if (token == "false")
		return new MalFalse;
	else if (token.isNumeric)
		return new MalInteger(token.to!int);
	else if (token[0] == '\"')
		return new MalString(token.strip('\"'));
	else
		return new MalSymbol(token);
}

class Reader
{
	import tokenizer;
	
  Tokenizer tokens;
  alias tokens this;
  
  this(string input)
  {
    this.tokens = Tokenizer(input);
  }
}
