module reader;

import ast;


MalType readForm(Reader reader)
{
  if (reader.front == "(")
    return reader.readList;
  else
    return reader.readAtom;
}

MalArray readList(Reader reader)
{
  MalArray list = new MalArray();
  
  assert(reader.front == "(");
  reader.popFront(); // pop the '(' token
  
  while (reader.front != ")")
  {
    list.types ~= reader.readForm;
    reader.popFront();
  }
  
  return list;
}

MalAtom readAtom(Reader reader)
{
	return new MalAtom(reader.front);
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
  
  /*bool empty()
  {
    return tokens.empty;
  }
  
  string front()
  {
    return tokens.front;
  }
  
  void popFront()
  {
    tokens.popFront();
  }*/
}

