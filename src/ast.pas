unit Ast;

{$mode ObjFPC}{$H+}
{$modeswitch advancedRecords}
//{$scopedEnums on}

interface

uses
  Classes, SysUtils, Generics.Collections,
  status;

type
  { exp types that comes from parser}
  TExpTypes = (keEmpty, keIntVal, keIntSum, keIntProd);


type
  { Used after eval the ast nodes }
  TValTypes = (kvEmpty, kvInt, kvReal);


type
  { TValue }
  TValue = record
    class operator Initialize(var val: TValue);
    case kind: TValTypes of
      kvInt: (intValue: integer);
      kvReal: (realValue: double);
  end;

//forward dec
type
  TExpression = class;

type
  TExpParams = specialize TObjectList<TExpression>;//this can own childrens


{ TExpression }
{
 for now is public for testing
}
type
  TExpression = class  //expresion own its childrens
  public
    kind: TExpTypes;
    expParams: TExpParams;
    strValue: string;
    Value: TValue;

    constructor Create;
    constructor Create(exType: TExpTypes; sval: string);
    constructor Create(exType: TExpTypes; args: array of TExpression);
    destructor Destroy; override;


  private


  end;


function visit(expr: TExpression): TStatus;

//may be use generic functions for ast eval

//  generic function Add<T, T2>(const A: T; const B: T2): T;

implementation

{ post-order traversal }
function visit(expr: TExpression): TStatus;
var
  e: TExpression;
begin
  writeln;
  if Assigned(expr.expParams) then
    for e in expr.expParams do
    begin
      visit(e);
    end;

  //post order actions
  case expr.kind of
    keIntVal:
    begin
      writeln('evaluating kIntVal', expr.strValue);
      expr.Value.kind:=kvInt;
      expr.Value.intValue := StrToInt(expr.strValue);
    end;

    keIntSum:
    begin
      writeln('evaluating kIntSum');
      expr.Value.kind := kvInt;
      expr.Value.intValue :=
        (expr.expParams[0].Value.intValue +
        expr.expParams[1].Value.intValue);
    end;
  end;
end;

generic function Add<T, T2>(const A: T; const B: T2): T;
begin
  Result := A;
end;

{ TValue }

class operator TValue.Initialize(var val: TValue);
begin
  val.kind := TValTypes.kvEmpty;
end;

{ TExpression }

constructor TExpression.Create;
begin
  inherited Create();
  self.kind := keEmpty;
end;


constructor TExpression.Create(exType: TExpTypes; sval: string);
begin
  inherited Create();
  self.kind := exType;
  self.strValue := sval;
end;

constructor TExpression.Create(exType: TExpTypes; args: array of TExpression);
var
  i: integer;
begin
  inherited Create();
  self.kind := exType;
  self.expParams := TExpParams.Create(True);
  for i := Low(args) to High(args) do
  begin
    self.expParams.Add(args[i]);
  end;
end;

destructor TExpression.Destroy;
begin
  if Assigned(expParams) then
    FreeAndNil(expParams);
  inherited;
end;

end.
