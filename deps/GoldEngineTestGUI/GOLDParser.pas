unit GOLDParser;

//{$IFDEF FPC}{$MODE Delphi}{$ENDIF}

{
'===============================================================================
' Simple Gold Parser Class to be used as base
' for ate-bc
'================================================================================
}

interface

uses
  Classes, SysUtils,
  gold_types, Parser, Token;

type

  { TGOLDParser }

  TGOLDParser = class(TAbstractGOLDParser)

  private
    fparsedOk: boolean;
    ftreeStr: string;
    flog: TStrings;

    function GetLog: string;
    procedure AddLog(const s: string; const p: TPosition);

  public
    constructor Create; overload;
    constructor Create(const theTablesFilePath, theTestString: string); overload;
    destructor Destroy; override;

    function LoadTables(const filename: string): boolean; overload;
    function LoadTables(const s: TStream): boolean; overload;

    function OpenFile(const s: TFilename): boolean;
    function OpenStream(const s: TStream): boolean;
    function OpenString(const s: string): boolean;


    { Do Parse and update status flags}
    function DoParse(): boolean;

    property StrTree: string read ftreeStr;
    property Log: string read GetLog;
    property ParsedOk: boolean read fparsedOk;

  end;


implementation

procedure TGOLDParser.AddLog(const s: string; const p: TPosition);
begin
  FLog.Add(s + ' ' + p.ToString);
end;

function TGOLDParser.GetLog: string;
begin
  Result := FLog.Text;
end;

constructor TGOLDParser.Create;
begin
  inherited Create;
  ftreeStr := '';
  flog := TStringList.Create;
  self.fparsedOk := False;
end;

constructor TGOLDParser.Create(const theTablesFilePath, theTestString: string);
begin
  Create;
  self.LoadTables(theTablesFilePath);
  self.OpenString(theTestString);
end;

destructor TGOLDParser.Destroy;
begin
  FLog.Free;
  inherited Destroy;
end;

function TGOLDParser.DoParse(): boolean;
var
  res: TParseMessage;
  done: boolean;
  s: string;
  i: integer;
begin
  done := False; // booleans are not false/true by default!!
  self.fparsedOk := False;
  while not done do
  begin
    res := self.Parse;
    done := res in [pmACCEPT..pmINTERNAL_ERROR];
    case Res of
      pmTOKEN_READ:
        AddLog('Token read: ' + CurrentToken.Name + ', ' +
          CurrentToken.Data, CurrentToken.Position);

      pmREDUCTION:
        AddLog('Reduction: ' + CurrentReduction.Parent.ToString,
          CurrentPosition);

      pmACCEPT:
      begin
        AddLog('Grammar accepted successfully.', CurrentPosition);
        ftreeStr := DrawReductionTree(CurrentReduction);
      end;

      pmNOT_LOADED_ERROR:
        AddLog('Grammar is not loaded.', CurrentPosition);

      pmLEXICAL_ERROR:
        AddLog('Lexical error: Cannot recognize token ' +
          CurrentToken.Data, CurrentToken.Position);

      pmSYNTAX_ERROR:
      begin
        s := '';
        for i := 0 to ExpectedSymbols.Count - 1 do
          s += ', ' + ExpectedSymbols[i].Name;

        AddLog(Format('Syntax error: Expected one of these tokens: %s but got %s.',
          [s, QuotedStr(CurrentToken.Name)]), CurrentPosition);
      end;

      pmGROUP_ERROR:
        AddLog('Error: Unexpexted end of file.', CurrentPosition);

      pmINTERNAL_ERROR:
        AddLog('Internal Error: Something is bad, very bad',
          CurrentPosition);
    end;
  end;

  self.fparsedOk := res = pmACCEPT;
  Result := self.fparsedOk;
end;

function TGOLDParser.LoadTables(const filename: string): boolean;
begin
  Result:= inherited LoadTables(filename);
end;

function TGOLDParser.LoadTables(const s: TStream): boolean;
begin
  Result:= inherited LoadTables(s);
end;

function TGOLDParser.OpenFile(const s: TFilename): boolean;
begin
  Result:= inherited OpenFile(s);
end;

function TGOLDParser.OpenStream(const s: TStream): boolean;
begin
  Result:= inherited OpenStream(s);
end;

function TGOLDParser.OpenString(const s: string): boolean;
begin
  Result:= inherited OpenString(s);
end;


end.
