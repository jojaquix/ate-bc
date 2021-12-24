library LibGoldParser;

{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils,
  Parser,
  gold_types,
  Token { you can add units after this };

{$R *.res}

type

  { TGOLDParser }

  TGOLDParser = class(TAbstractGOLDParser)
    fSuccess: boolean;
  public
    constructor Create(const grm_file, src_file: string);
    property Success: boolean read fSuccess;
  end;

  constructor TGOLDParser.Create(const grm_file, src_file: string);
  var
    Done: boolean = False;
    Res: TParseMessage;
  begin
    inherited Create;
    LoadTables(grm_file);
    OpenFile(src_file);
    while not Done do
    begin
      Res := Parse;
      Done := Res in [pmACCEPT..pmINTERNAL_ERROR];
    end;
    fSuccess := Res = pmAccept;
  end;

  function ParseFile(const egtFile, srcFile: PChar): HRESULT; stdcall;
  var
    gp: TGOLDParser;
  begin
    gp := TGOLDParser.Create(ansistring(egtFile), ansistring(srcFile));
    try
      if gp.Success then
        Result := 0
      else
        Result := 1;
    finally
      gp.Free;
    end;
  end;

exports ParseFile;

end.
