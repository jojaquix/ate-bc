program GOLDParserEngineSource;
{
'===============================================================================
' Refactored 2018, Thaddy de Koning: use a generic stack
'===============================================================================
}
{$IFDEF FPC}{$MODE Delphi}{$ENDIF}

uses
  Forms, Interfaces,
  MainForm in 'MainForm.pas' {Main};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
