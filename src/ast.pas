unit Ast;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Generics.Collections,
  status;

type
  TExpTypes = (kEmpty, kIntVal, kIntSum, kIntProd);


type
  TValue = record
     case expType: TExpTypes of
       kIntVal: (intValue: Integer);
   end;

//forward dec
type
  TExpression = class;

type
  TExpParams = specialize TObjectList<TExpression>;//this can own childrens


{ TExpression }
{
 TODO if the expression is xLiteral does not have
 childrens, then does not create params field

 for now is public for testing
}
type
  TExpression = class  //expresion own its childrens

  public
    expType: TExpTypes;  //todo change to property from value
    expParams: TExpParams;
    strValue: string;
    value: TValue;

    constructor Create;
    constructor Create(exType: TExpTypes; sval: string);
    constructor Create(exType: TExpTypes; args: array of TExpression);
    destructor Destroy; override;


  private


  end;



function visit(expr: TExpression): TStatus;

//may be use generic functions for ast eval
  generic function Add<T, T2>(const A: T; const B: T2): T;

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
  case expr.expType of
    kIntVal :
      begin
        writeln('evaluating kIntVal', expr.strValue);
        expr.value.expType := expr.expType;
        expr.value.intValue:= StrToInt(expr.strValue);
      end;

    kIntSum :
      begin
        writeln('evaluating kIntSum');
        expr.value.expType:= kIntVal;
        expr.value.intValue :=
         (expr.expParams[0].value.intValue
          +
          expr.expParams[1].value.intValue);
      end;
  end;
end;

generic function Add<T, T2>(const A: T; const B: T2): T;
begin
  Result := A;
end;

{ TExpression }

constructor TExpression.Create;
begin
  inherited Create();
  self.expType := kEmpty;
end;


constructor TExpression.Create(exType: TExpTypes; sval: string);
begin
  inherited Create();
  self.expType := exType;
  self.strValue := sval;
end;

constructor TExpression.Create(exType: TExpTypes; args: array of TExpression);
var
  i: integer;
begin
  inherited Create();
  self.expType := exType;
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
