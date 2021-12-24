unit uAteBcTests;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, Engine;

type
  TAteBcTests = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure EvaluateIntAdd;
  end;

implementation



procedure TAteBcTests.SetUp;
begin

end;

procedure TAteBcTests.TearDown;
begin

end;

procedure TAteBcTests.EvaluateIntAdd;
begin
  AssertTrue(Engine.Add(5 ,3) = 8);
end;

initialization

  RegisterTest(TAteBcTests);
end.

