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
	auto token = reader.front;
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
