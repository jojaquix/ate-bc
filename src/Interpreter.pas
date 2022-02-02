unit Interpreter;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Status,
  GOLDParser,
  Token,
  Gold_Types,
  AteTypes,
  Ast;

{  Api functions }

function loadTables(tablesFilePath: string): TStatus;
function parse(prg: string): TStatus;

{ eval functions here ??}


{ For Testing only }

function checkTree(): TStatus;

function eval(expr: TExpr): TAteVal;

{ eval expression list on TAteStack }
function eval(ateStack: TAteStack; exprColl: TExprList): TStatus;

//may be use generic functions for ast eval
//generic function Add<T, T2>(const A: T; const B: T2): T;

{ generate the ast from parse tree }
function generateAst(tast: TExpr; tred: TReduction): TStatus;

function generateAst2(expList: TExprList; tred: TReduction): TStatus;

implementation

{uses
  Token, GOLDParser, Ast;
}
var
  parser: TGOLDParser;

function checkTree: TStatus;
var
  tree: TReduction;
  i: integer;
  aAst: TExpr;
  res: TAteVal;
  expList: TExprList;
  ateStack: TAteStack;
begin
  tree := parser.CurrentReduction;
  aAst := nil;
  expList := nil;
  try
    aAst := TExpr.Create();
    expList := TExprList.Create();
    ateStack := TAteStack.Create();
    //writeln('generating Ast1');
    //generateAst(aAst, tree);
    //res:= eval(aAst);
    //writeln('Result for generateAst is: ', res.intVal);
    writeln('Generating Ast2');
    generateAst2(expList, tree);
    writeln('Expr Item coll size ', expList.Count);
    Result := eval(ateStack, expList);
    writeLn('Valor en la pila :', ateStack.Peek.intVal);
  finally
    FreeAndNil(ateStack);
    FreeAndNil(expList);
    FreeAndNil(aAst);
  end;
end;


function loadTables(tablesFilePath: string): TStatus;
var
  r: boolean;
begin
  try
    r := parser.LoadTables(tablesFilePath);
    if not r then
      Result := Failure('Tables not loaded');
  except
    on E: Exception do
      Result := Failure('Tables not loaded ' + E.Message);
  end;
end;

function parse(prg: string): TStatus;
var
  r: boolean;
begin
  r := parser.OpenString(prg);
  if not r then
    Result := Failure('Prg not loaded');

  if not parser.DoParse() then
    Result := Failure('Parse Failed:' + parser.Log);
end;

function eval(expr: TExpr): TAteVal;
begin
  writeln;
  case expr.kind of
    etIntVal:
    begin
      Result.kind := vkInt;
      Result.intVal := StrToInt(expr.strVal);
      exit;
    end;

    etIntSum:
    begin
      Result.kind := vkInt;
      Result.intVal :=
        eval(expr[0]).intVal + eval(expr[1]).intVal;
    end;

    etIntProd:
    begin
      Result.kind := vkInt;
      Result.intVal :=
        eval(expr[0]).intVal * eval(expr[1]).intVal;
    end;

  end;
end;

function eval(ateStack: TAteStack; exprColl: TExprList): TStatus;
var
  i: longint;
  expr: TExprItem;
  aux: TAteVal;
begin
  for i := exprColl.Count - 1 downto 0 do
  begin
    expr := exprColl[i];
    writeln('Evaluating stack ast',
        ' Kind: ', IntToStr(Ord(expr.kind)),
        ' StrVal: ', expr.strVal);

    case expr.kind of
      etIntVal:
      begin
        aux.kind := vkInt;
        aux.intVal := StrToInt(expr.strVal);
        ateStack.Push(aux);
      end;

      etIntSum:
      begin
        aux.kind := vkInt;
        aux.intVal :=
          ateStack.Pop.intVal + ateStack.Pop.intVal;
        ateStack.Push(aux);
      end;

      etIntProd:
      begin
        aux.kind := vkInt;
        aux.intVal :=
          ateStack.Pop.intVal * ateStack.Pop.intVal;
        ateStack.Push(aux);
      end;
    end;
  end;
end;



{ to dont forget generic functions }
generic function Add<T, T2>(const A: T; const B: T2): T;
begin
  Result := A;
end;

{ todo move to ast unit }
function generateAst(tast: TExpr; tred: TReduction): TStatus;
var
  level: integer;
  currentExpr: TExpr;

  // Example of TToken values for a given grammar
  // node.Name = 'IntegerLiteral', '*'
  // node.Data = '5', '*'
  // node.SymbolType = see TSymbolType in gold_types unit

  procedure visit(tred: TReduction; tast: TExpr);
  var
    i: integer;
  begin
    Inc(level);
    for i := 0 to tred.Count - 1 do
      if not (tred[i].SymbolType in [stNON_TERMINAL]) then
      begin
        writeln('Name: ', tred[i].Name,
          ' Type: ', IntToStr(Ord(tred[i].SymbolType)),
          ' Data: ', tred[i].Data,
          ' Index: ', i,
          ' Level: ', level);

        case tred[i].Name of
          '+':
          begin
            writeln('Adding Sum');
            currentExpr := currentExpr.AddParam(CESum());
          end;

          '*':
          begin
            writeln('Adding Prod');
            currentExpr := currentExpr.AddParam(CEProd());
          end;


          'IntLiteral':
          begin
            writeln('Adding LitInt');
            currentExpr.AddParam(CEInt(tred[i].Data));
          end;
        end;

      end;

    for i := 0 to tred.Count - 1 do
      if (Assigned(tred[i].Reduction)) then
        visit(tred[i].Reduction, tast);

    Dec(level);
  end;

begin
  level := 0;
  currentExpr := tast;
  visit(tred, tast);

end;


{ this function generate expList from perser reduction }
function generateAst2(expList: TExprList; tred: TReduction): TStatus;
var
  level: integer;

  // Example of TToken values for a given grammar
  // node.Name = 'IntegerLiteral', '*'
  // node.Data = '5', '*'
  // node.SymbolType = see TSymbolType in gold_types unit

  procedure visit(tred: TReduction);
  var
    i: integer;
  begin
    Inc(level);
    for i := 0 to tred.Count - 1 do
      if not (tred[i].SymbolType in [stNON_TERMINAL]) then
      begin
        writeln('Name: ', tred[i].Name,
          ' Type: ', IntToStr(Ord(tred[i].SymbolType)),
          ' Data: ', tred[i].Data,
          ' Index: ', i,
          ' Level: ', level);

        case tred[i].Name of
          '+':
          begin
            //writeln('Adding Sum');
            expList.Add(CISum());
          end;

          '*':
          begin
            //writeln('Adding Prod');
            expList.Add(CIProd());
          end;


          'IntLiteral':
          begin
            //writeln('Adding LitInt');
            expList.Add(CIInt(tred[i].Data));
          end;
        end;

      end;

    for i := 0 to tred.Count - 1 do
      if (Assigned(tred[i].Reduction)) then
        visit(tred[i].Reduction);

    Dec(level);
  end;

begin
  level := 0;
  visit(tred);

end;

initialization
  // here may be placed code that is
  // executed as the unit gets loaded
  parser := TGOLDParser.Create();

finalization
  // code executed at program end
  FreeAndNil(parser);

end.
