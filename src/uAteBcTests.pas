unit uAteBcTests;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,
  Engine, Status;

type

  { TAteBcTests }

  TAteBcTests = class(TTestCase)
  private

  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure EvaluateIntLiteral;
    procedure TestStatuses;
    procedure TestLoadTables;
  end;

implementation


procedure StaticExample;
var
  counter: integer;
begin

end;

procedure TAteBcTests.SetUp;
begin

end;

procedure TAteBcTests.TearDown;
begin

end;

procedure TAteBcTests.EvaluateIntLiteral;
begin
  AssertTrue(eval('5') = 0);
end;

procedure TAteBcTests.TestStatuses;
var
  st1, st2: TStatus;
  stp1: ^TStatus;
begin
  st1:= Success();
  New(stp1);

  AssertTrue(st1.Code = stp1^.Code);
  AssertTrue(st1.Message = stp1^.Message);

  AssertTrue(st1.Code = st2.Code);
  AssertTrue(st1.Message = st2.Message);


  Dispose(stp1);
end;

procedure TAteBcTests.TestLoadTables;
var
  st1, st2, st3: TStatus;
begin
  st1 := loadTables('');
  AssertTrue(st1.Code <> 0);

  st2 := loadTables('../assets/ate-bc.cgt');
  AssertTrue(st2.Code = 0);
  AssertTrue(st2.Message = 'Ok');

  st3 := load('5*4');
  AssertTrue(st3.Code = 0);
  AssertTrue(st3.Message = 'Ok');

  st1:= parse();
  checkTree();

end;


initialization

  RegisterTest(TAteBcTests);
end.

