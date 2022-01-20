unit uAteBcTests;

{$mode objfpc}{$H+}
{$define ATE_BC_UTESTS}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,
  Interpreter, Status, Ast;

type

  { TAteBcTests }

  TAteBcTests = class(TTestCase)
  private

  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestFreeOnNull;
    procedure EvaluateIntLiteral;
    procedure TestStatuses;
    procedure TestLoadTables;
    procedure TestGenFunction;
    procedure TestAst;
    procedure TestAstGen;
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

procedure TAteBcTests.TestFreeOnNull;
var
  stp1: ^TStatus;
  e: TExpression;
begin
  stp1 := nil;
  e := nil;

  { show free on nils is safe }
  e.Free;
  { for value types is not safe }
  if Assigned(stp1) then
     Dispose(stp1);
end;

procedure TAteBcTests.EvaluateIntLiteral;
begin
  //AssertTrue(eval('5') = 0);
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

  st3 := parse('5*4');
  AssertTrue(st3.Code = 0);
  AssertTrue(st3.Message = 'Ok');

  checkTree();

end;

procedure TAteBcTests.TestGenFunction;
begin
   //AssertTrue(specialize Add<Integer, String>(3,'Cadena') = 3);
end;

procedure TAteBcTests.TestAst;
var
  exp1, val1, val2: TExpression;
  res: TStatus;
begin
  val1:= TExpression.Create(keIntVal, '5');
  val2:= TExpression.Create(keIntVal, '2');
  exp1 := TExpression.Create(keIntSum, [val1, val2]);

  res:= visit(exp1);
  AssertTrue(exp1.value.intValue = 7);

  FreeAndNil(exp1);

end;

procedure TAteBcTests.TestAstGen;
begin

  //AssertTrue(exp1.value.intValue = 7);

end;


initialization

  RegisterTest(TAteBcTests);
end.

