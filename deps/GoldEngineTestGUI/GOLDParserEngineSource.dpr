program GOLDParserEngineSource;
{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}
uses
(*implement that yourself, translate with Lazarus!
  Forms,
  MainForm in 'MainForm.pas' {Main},
  *)
  GrammarReader in 'GrammarReader.pas',
  Variables in 'Variables.pas',
  Symbol in 'Symbol.pas',
  Rule in 'Rule.pas',
  FAState in 'fasTATE.pas',
  LRAction in 'LRAction.pas',
  LRActionTable in 'LRActionTable.pas',
  GOLDParser in 'GOLDParser.pas',
  Token in 'Token.pas',
  TokenStack in 'TokenStack.pas',
  Reduction in 'Reduction.pas',
  SourceFeeder in 'SourceFeeder.pas';

{$R *.res}

begin
(* after that, this should also work
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
  *)
end.
