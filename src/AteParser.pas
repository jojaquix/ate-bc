unit AteParser;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,
  Token, GOLDParser, Gold_Types,
  Status;

{  Api functions }

function loadTables(tablesFilePath: string = ''): TStatus;
function parse(prg: string): TStatus;

{ expose intearnal parser type (}

function getCurrentReduction : TReduction;


implementation

uses Windows;

var
  parser: TGOLDParser;

function loadTables(tablesFilePath: string = ''): TStatus;
var
  r: boolean;
  s: TResourceStream;
begin
  s := nil;
  try
    try
      if (tablesFilePath.IsEmpty) then
      begin
        s:= TResourceStream.Create(hinstance(), 'ATE-BC', RT_RCDATA );
        r := parser.LoadTables(s);
      end
      else
          r := parser.LoadTables(tablesFilePath);

      if not r then
        Result := Failure('Tables not loaded');
    except
      on E: Exception do
        Result := Failure('Tables not loaded ' + E.Message);
    end;
  finally
    FreeAndNil(s);
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

function getCurrentReduction: TReduction;
begin
  Result:= parser.CurrentReduction;
end;

initialization
  // here may be placed code that is
  // executed as the unit gets loaded
  //{$I ../assets/AteRes.lrs }
  parser := TGOLDParser.Create();
  loadTables();

finalization
  // code executed at program end
  FreeAndNil(parser);

end.

