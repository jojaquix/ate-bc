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
    ftree: string;
    flog: TStrings;

    tablesFilePath: string;
    testString: string;

    function GetLog: string;
    procedure AddLog(const s: string; const p: TPosition);


  public
    constructor Create; overload;
    constructor Create(const tablesFilePath, testString: string); overload;
    destructor Destroy; override;

    { Do Parse and update status flags}
    function DoParse(): boolean;

    property Tree: string read ftree;
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
  Create(ParamStr(1), ParamStr(2));
end;

constructor TGOLDParser.Create(const tablesFilePath, testString: string);
begin
  inherited Create;
  ftree := '';
  flog := TStringList.Create;
  self.testString := testString;
  self.tablesFilePath := tablesFilePath;
  self.fparsedOk := False;
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
  done := False; // booleans are not false by default!!
  self.fparsedOk := False;
  self.LoadTables(self.tablesFilePath);
  self.OpenString(self.testString);
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
        ftree := DrawReductionTree(CurrentReduction);
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


end.
