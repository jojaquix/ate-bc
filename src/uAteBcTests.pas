unit uAteBcTests;

{$mode objfpc}{$H+}
{$define ATE_BC_UTESTS}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,
  Interpreter, Status, AteAst, AteTypes, AteParser;

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
  e: TStream;
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
  //st1 := loadTables('');
  //AssertTrue(st1.Code <> 0);

  //st2 := loadTables('../assets/ate-bc.cgt');
  AssertTrue(st2.Code = 0);
  AssertTrue(st2.Message = 'Ok');

  st3 := parse('3*5+6*7');
  AssertTrue(st3.Code = 0);
  AssertTrue(st3.Message = 'Ok');

  writeln;

end;

procedure TAteBcTests.TestGenFunction;
begin
   //AssertTrue(specialize Add<Integer, String>(3,'Cadena') = 3);
end;


procedure TAteBcTests.TestAstGen;
var
  i: integer;
  res: TAteVal;
  expList: TExprList;
  ateStack: TAteStack;
  st2, st3, st: TStatus;
begin
  expList := nil;
  ateStack := nil;
  try
    expList := TExprList.Create();
    ateStack := TAteStack.Create();
    writeln;
    { why cant not load multiple times }
    //st2 := loadTables('../assets/ate-bc.cgt');
    AssertTrue(st2.Code = 0);
    AssertTrue(st2.Message = 'Ok');
    // fix asociativity ?
    st3 := parse('-5-12+2*4');
    //st3 := parse('-5+8');
    AssertTrue(st3.Code = 0);
    AssertTrue(st3.Message = 'Ok');

    writeln('Generating Ast2');
    generateAst2(expList);
    writeln('Expr Item coll size ', expList.Count);
    st := eval(ateStack, expList);
    writeLn('Valor en pila: ', ateStack.Peek.intVal, ' Size pila: ', ateStack.Count);
  finally
    FreeAndNil(ateStack);
    FreeAndNil(expList);
  end;
end;


initialization

  RegisterTest(TAteBcTests);
end.

