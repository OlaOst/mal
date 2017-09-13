module ast;


interface MalType
{
  string print();
}

class MalArray : MalType
{
  MalType[] types;
  
  string print()
  {
    import std.algorithm : map;
    import std.range : join;
    
    return "(" ~ types.map!(type => type.print).join(" ") ~ ")";
  }
}

class MalAtom : MalType
{
  string name;
  
  this(string name)
  {
    import std.string : strip;
    
    this.name = name.strip;
  }
  
  string print()
  {
    return name;
  }
}
