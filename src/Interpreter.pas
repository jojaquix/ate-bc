unit Interpreter;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Status,
  AteTypes,
  AteAst;

{ eval expression list on TAteStack }
function eval(ateStack: TAteStack; exprColl: TExprList): TStatus;

//may be use generic functions for ast eval
//generic function Add<T, T2>(const A: T; const B: T2): T;


implementation


function eval(ateStack: TAteStack; exprColl: TExprList): TStatus;
var
  i: longint;
  expr: TExprItem;
  aux: TAteVal;
begin
  {$ifopt D+}
  writeln('Content of Expr Collection');
  writeln('==================================');
  for i := exprColl.Count - 1 downto 0 do
   begin
     expr := exprColl[i];
     writeln('Index: ', i,
         ' Kind: ', IntToStr(Ord(expr.kind)),
         ' StrVal: ', expr.strVal);
  end;
  writeln('==================================');
  writeln;
  writeln('Evaluating ast using stack');
  {$endif}
  i:= exprColl.Count - 1;
  while i >= 0 do
  begin
    expr := exprColl[i];

    {$ifopt D+}
    writeln('Index: ', i,
        ' Kind: ', IntToStr(Ord(expr.kind)),
        ' StrVal: ', expr.strVal);
    {$endif}
    case expr.kind of
      etIntVal:
      begin
        aux.kind := vkInt;
        aux.intVal := StrToInt(expr.strVal);
        ateStack.Push(aux);
      end;

      etIntSum:
      begin
        aux.kind := vkInt;
        aux.intVal :=
          ateStack.Pop.intVal + ateStack.Pop.intVal;
        ateStack.Push(aux);
      end;

      etIntSub:
      begin
        aux.kind := vkInt;
        aux.intVal := ateStack.Pop.intVal;
        aux.intVal := ateStack.Pop.intVal - aux.intVal;
        ateStack.Push(aux);
      end;

      etIntProd:
      begin
        aux.kind := vkInt;
        aux.intVal :=
          ateStack.Pop.intVal * ateStack.Pop.intVal;
        ateStack.Push(aux);
      end;

      etIntDiv:
      begin
        aux.kind := vkInt;
        aux.intVal := ateStack.Pop.intVal;
          aux.intVal := ateStack.Pop.intVal div aux.intVal;
        ateStack.Push(aux);
      end;

      etUnaryMinus:
      begin
        //writeln('Evaluating etUnaryMinus');
        aux.kind := vkInt;
        aux.intVal := -StrToInt(exprColl[i-1].strVal);
        ateStack.Push(aux);
        dec(i);
      end;
    end;

    //writeln('Result: ', ateStack.Peek.intVal);
    dec(i);
  end;
end;



{ to dont forget generic functions }
generic function Add<T, T2>(const A: T; const B: T2): T;
begin
  Result := A;
end;



initialization
  // here may be placed code that is
  // executed as the unit gets loaded


finalization
  // code executed at program end

end.
