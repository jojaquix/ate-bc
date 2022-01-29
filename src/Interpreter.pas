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
//may be use generic functions for ast eval

//generic function Add<T, T2>(const A: T; const B: T2): T;

{ generate the ast from parse tree }
function generateAst(tast: TExpr; tred: TReduction): TStatus;




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
begin
  tree := parser.CurrentReduction;
  aAst := nil;
  try
    aAst := TExpr.Create;
    generateAst(aAst, tree);
  finally
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
  end;
end;

{ to dont forget generic functions }
generic function Add<T, T2>(const A: T; const B: T2): T;
begin
  Result := A;
end;

function generateAst(tast: TExpr; tred: TReduction): TStatus;
var
  level: integer;

  // Example of TToken values for a given grammar
  // node.Name = 'IntegerLiteral', '*'
  // node.Data = '5', '*'
  // node.SymbolType = see TSymbolType in gold_types unit

  procedure visit(tred: TReduction; tast: TExpr);
  var
    i: integer;
  begin
    inc(level);
    for i := 0 to tred.Count - 1 do
      if not (tred[i].SymbolType in [stNON_TERMINAL]) then
      begin
        writeln('Name: ', tred[i].Name,
           ' Type: ', IntToStr(Ord(tred[i].SymbolType)),
           ' Data: ', tred[i].Data,
           ' Index: ', i,
           ' Level: ', level);

        //case tred[i].Name of
          //'+': tast.AddParam(CESum(()));


        //end

      end;

    for i := 0 to tred.Count - 1 do
      if(Assigned(tred[i].Reduction)) then
        visit(tred[i].Reduction, tast);

    dec(level);
  end;

begin
  level := 0;
  visit(tred, tast);

end;

initialization
  // here may be placed code that is
  // executed as the unit gets loaded
  parser := TGOLDParser.Create();

finalization
  // code executed at program end
  FreeAndNil(parser);

end.
