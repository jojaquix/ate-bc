unit Interpreter;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Status,
  GOLDParser,
  Token,
  Ast;


{ Engine Api functions }

function loadTables(tablesFilePath: string): TStatus;
function parse(prg: string): TStatus;

{ For Testing only }

function checkTree(): TStatus;

function visit(expr: TExpression): TStatus;
//may be use generic functions for ast eval

//generic function Add<T, T2>(const A: T; const B: T2): T;

{ generate the ast from parse tree }
function generateAst(tred: TReduction; tast: TExpression): TStatus;





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
begin
  tree := parser.CurrentReduction;
  writeln('Showing the reduction to see');
  //writeln(parser.StrTree);

  for i := 0 to tree.Count - 1 do
  begin
    writeln('Name: ', tree[i].Name,
      ' type: ', IntToStr(Ord(tree[i].SymbolType)),
      ' data:', tree[i].Data,
      ' str: ', tree[i].ToString);
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

{ post-order traversal }
function visit(expr: TExpression): TStatus;
var
  e: TExpression;
begin
  writeln;
  if Assigned(expr.expParams) then
    for e in expr.expParams do
    begin
      visit(e);
    end;

  //post order actions
  case expr.kind of
    keIntVal:
    begin
      writeln('evaluating kIntVal', expr.strValue);
      expr.Value.kind:=kvInt;
      expr.Value.intValue := StrToInt(expr.strValue);
    end;

    keIntSum:
    begin
      writeln('evaluating kIntSum');
      expr.Value.kind := kvInt;
      expr.Value.intValue :=
        (expr[0].Value.intValue +
        expr[1].Value.intValue);
    end;
  end;
end;
{ to dont forget generic functions }
generic function Add<T, T2>(const A: T; const B: T2): T;
begin
  Result := A;
end;

function generateAst(tred: TReduction; tast: TExpression): TStatus;
begin

  // traverse and generate ast
  // this function looks like will
  // be large

end;

initialization
  // here may be placed code that is
  // executed as the unit gets loaded
  parser := TGOLDParser.Create();

finalization
  // code executed at program end
  FreeAndNil(parser);

end.
