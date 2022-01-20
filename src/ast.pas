unit Ast;
{
 Ast module, defines the types (and methods, helpers ets)
 to build an AST that will be evaluated for the interpreter
 for now:
     * TExpression -> node of the AST
     * TValue -> the value of an evaluated TExpression
}

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
 for now is public just for testing
 maybe values should be properties
 to allow un set values when change
 and keep the node in consistent
 state
}
type
  TExpression = class  //expresion own its childrens
  private

    function GetParam(index: Integer): TExpression;

  public
    kind: TExpTypes;
    expParams: TExpParams;
    strValue: string;
    Value: TValue;

    constructor Create;
    constructor Create(exType: TExpTypes; sval: string);
    constructor Create(exType: TExpTypes; args: array of TExpression);
    destructor Destroy; override;

    property Param[index : Integer]: TExpression read GetParam; default;


  private


  end;




implementation



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

function TExpression.GetParam(index: Integer): TExpression;
begin
  Result:= self.expParams[index];
end;

end.
