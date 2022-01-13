unit Engine;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Status, Token;

{ For Testing only }

function checkTree(): TStatus;


{ Engine Api functions }

function eval(exp: string): int32; overload;
function eval(exp: string): double; overload;

function loadTables(tablesFilePath: string): TStatus;
function load(prg: string): TStatus;
function parse(): TStatus;




implementation

uses
  GOLDParser;

var
  parser: TGOLDParser;

function checkTree: TStatus;
var
  tree: TReduction;
  i: Integer;
begin
  tree := parser.CurrentReduction;
  writeln('Showing the reduction to see');
  //writeln(parser.StrTree);

  for i:= 0 to tree.Count -1 do
  begin
    writeln('Name: ', tree[i].Name,
    ' type: ', IntToStr(Ord(tree[i].SymbolType)),
    ' data:', tree[i].Data,
    ' str: ', tree[i].ToString);
  end;

end;

{ eval functions }
function eval(exp: string): int32;
begin
  Result := 0;
end;

function eval(exp: string): double;
begin
  Result := 0.0;
end;

function loadTables(tablesFilePath: string): TStatus;
var
  r: boolean;
begin
  try
    r := parser.LoadTables(tablesFilePath);
  except
    on E: Exception do
      Result := Failure('Tables not loaded ' + E.Message);
  end;
end;

function load(prg: string): TStatus;
var
  r: boolean;
begin
  try
    r := parser.OpenString(prg);
  except
    on E: Exception do
      Result := Failure('Prg not loaded ' + E.Message);
  end;

  if not r then
    Result := Failure('Prg not loaded');

end;

function parse: TStatus;
begin
   if not parser.DoParse() then
     Result := Failure('Parse Failed:' + parser.Log);
end;

initialization
  // here may be placed code that is
  // executed as the unit gets loaded
  parser := TGOLDParser.Create();

finalization
  // code executed at program end
  FreeAndNil(parser);

end.
