program AteBsTests;

{$mode objfpc}{$H+}

uses
  Classes, consoletestrunner, uAteBcTests, Status, Ast, GOLDParser, AteTypes;

type

  { TMyTestRunner }

  TMyTestRunner = class(TTestRunner)
  protected
  // override the protected methods of TTestRunner to customize its behavior
  end;


var
  Application: TMyTestRunner;

begin
  Application := TMyTestRunner.Create(nil);
  Application.Initialize;
  Application.Title:='AteBsTests';
  Application.Run;
  Application.Free;
end.
 
