module ast;

import env;
import types.malatom;
import types.malinteger;
import types.malstring;
import types.malsymbol;
import types.maltype;


//class MalList : MalType
//{
  //MalType[] types;
  
  //this(MalType[] types)
  //{
    //this.types = types;
  //}
  
  //MalType eval(Env env)
  //{
    //import std.algorithm : map;
    //import std.array : array;
    //import std.exception : enforce;
    
    //if (types.length == 0)
      //return this;
    
    //auto debugMode = "debug" in env;
    //if (debugMode !is null && typeid(*debugMode) == typeid(MalTrue))
    //{
      //import std.stdio : writeln;
      //writeln("list types:", types.map!(type => typeid(type)));
      //writeln("list values: ", types.map!(type => type.print));
      //writeln("env: ", env);
    //}
    
    //if (typeid(types[0]) == typeid(MalSymbol))
    //{
      //auto symbol = cast(MalSymbol)types[0];
      
      //if (symbol.name == "def!")
      //{
        //enforce(types.length == 3, "def! needs exactly two parameters");
        //enforce(typeid(types[1]) == typeid(MalSymbol), "def! first parameter must be a symbol");
        
        //auto result = types[2].eval(env);
        //env[(cast(MalSymbol)types[1]).name] = result;
        //return result;
      //}
      
      //if (symbol.name == "let*")
      //{
        //import std.algorithm : each;
        //import std.range : chunks;
        
        //auto newEnv = new Env(env);
        
        //enforce(typeid(types[1]) == typeid(MalList), "First parameter to let* must be a list");
        //auto bindingList = cast(MalList)types[1];
        
        //auto pairs = bindingList.types.chunks(2);
        
        //foreach (pair; pairs)
        //{
          //enforce(typeid(pair[0]) == typeid(MalSymbol), "Every even parameter in the let* binding list must be a symbol");
          //newEnv[(cast(MalSymbol)pair[0]).name] = pair[1].eval(newEnv);
        //}
        
        //return types[2].eval(newEnv);
      //}
      
      //if (symbol.name == "do")
      //{
        //auto types = types[1..$].map!(type => type.eval(env)).array;
        //return types[$-1];
      //}
      
      //if (symbol.name == "if")
      //{
        //enforce(types.length >= 2, "if statement needs at least two parameters: a condition and a true clause, optionally a false clause");
        //auto condition = types[1].eval(env);
        
        //if (typeid(condition) == typeid(MalNil) || typeid(condition) == typeid(MalFalse))
        //{
          //if (types.length >= 4)
            //return types[3].eval(env);
          //else
            //return new MalNil();
        //}
        //else
        //{
          //return types[2].eval(env);
        //}
      //}
      
      //if (symbol.name == "fn*")
      //{
        //import std.algorithm : all;
        
        //enforce(types.length == 3, "Lambda definition needs two parameters - a parameter list and a function body");
        //enforce(typeid(types[1]) == typeid(MalList), "First parameter to lambda definition must be a list");
        
        //auto argSymbolList = cast(MalList)types[1];
        //auto funcBody = types[2];
        
        //enforce(argSymbolList.types.all!(argSymbol => typeid(argSymbol) == typeid(MalSymbol)), "Only symbols allowed in lambda parameter list");
        //auto argSymbols = argSymbolList.types.map!(argSymbol => cast(MalSymbol)argSymbol).array;
                
        //return new MalClosure(argSymbols, funcBody, env);
      //}
      
      //if (symbol.name == "list")
      //{
        //return new MalList(types[1..$]);
      //}
      
      //if (symbol.name == "read-string")
      //{
        //import repl;
        //enforce(types.length == 2, "read-string needs exactly 1 parameter");
        //enforce(typeid(types[1]) == typeid(MalString), "read-string parameter must be a string");
        //return (cast(MalString)types[1]).value.read;
      //}
      
      //if (symbol.name == "slurp")
      //{
        //import std.file : exists, readText;
        //enforce(types.length == 2, "slurp needs exactly 1 parameter");
        //enforce(typeid(types[1]) == typeid(MalString), "slurp parameter must be a string");
        //auto fileName = (cast(MalString)types[1]).value;
        //enforce(fileName.exists);
        //return new MalString(fileName.readText);
      //}
    //}
    
    //auto types = types.map!(type => type.eval(env)).array;
    
    //if (typeid(types[0]) == typeid(MalClosure))
    //{
      //import std.conv : to;
      
      //auto closure = cast(MalClosure)types[0];
      //auto callEnv = new Env(closure.env);
      
      //auto params = types[1..$];
      
      //enforce(params.length == closure.argSymbols.length, "Closure expected " ~ closure.argSymbols.length.to!string ~ " arguments, got " ~ params.length.to!string ~ " params");
      
      //foreach (index, argSymbol; closure.argSymbols)
      //{
        //callEnv[argSymbol.name] = params[index];
      //}

      //return closure.funcBody.eval(callEnv);
    //}
    
    //if (typeid(types[0]) == typeid(MalFunc))
    //{
      //auto func = (cast(MalFunc)types[0]);
      //auto args = types[1..$];
      
      //return func.func(args);
    //}
    //else
    //{
      //enforce(types.length == 1, "Length must be 1 for non-function lists");
      //return types[0];
    //}
  //}
  
  //string print()
  //{
    //import std.algorithm : map;
    //import std.range : join;
    
    //return "(" ~ types.map!(type => type.print).join(" ") ~ ")";
  //}
//}

MalType builtinAdd(MalType[] arguments)
{
  import std.algorithm : map, sum;
  import std.conv : to;
  
  auto result = arguments.map!(argument => (cast(MalInteger)argument)).sum;
  return new MalInteger(result);
}

MalType builtinMul(MalType[] arguments)
{
  import std.algorithm : map, reduce, sum;
  import std.conv : to;
  
  auto result = arguments.map!(argument => (cast(MalInteger)argument)).reduce!"a*b";
  
  return new MalInteger(result);
}

class MalFunc : MalType
{
  MalType function(MalType[] arguments) func;
  
  this(MalType function(MalType[] arguments) func)
  {
    this.func = func;
  }
  
  MalType eval(Env env)
  {
    auto arguments = null;
    return func(arguments);
  }
  
  string print()
  {
    return "<func>";
  }
}

class MalClosure : MalType
{
  MalSymbol[] argSymbols;
  MalType funcBody;
  Env env;
  
  this(MalSymbol[] argSymbols, MalType funcBody, Env env)
  {
    this.argSymbols = argSymbols;
    this.funcBody = funcBody;
    this.env = env;
  }
  
  MalType eval(Env env)
  {
    return this;
  }
  
  string print()
  {
    return "<closure>";
  }
}
