unit Ast;

{
 Ast module, defines the types (and methods, helpers ets)
 to build an AST that will be evaluated for the interpreter
 for now:
     * TExpression -> node of the AST
}

{$mode ObjFPC}{$H+}
{$modeswitch advancedRecords}
//{$scopedEnums on}

interface

uses
  Classes, SysUtils, Generics.Collections,
  Status, AteTypes;

type
  { exp types that comes from parser}
  TExprTypes = (
    etEmpty,
    etIntVal,
    etIntSum,
    etIntProd);


//forward dec
type
  TExpr = class;

type
  TExpParams = specialize TObjectList<TExpr>;//this can own childrens


{ TExpr }
{
 for now is public just for testing
 maybe values should be properties
 to allow un set values when change
 and keep the node in consistent
 state
}
type
  TExpr = class  //expression own its childrens

  private
    function GetParam(index: integer): TExpr;

  public
    kind: TExprTypes;
    params: TExpParams;
    strVal: string;
    parent: TExpr;

    constructor Create(exType: TExprTypes = etEmpty);
    constructor Create(exType: TExprTypes; sval: string);
    constructor Create(exType: TExprTypes; args: array of TExpr);
    destructor Destroy; override;

    //when a param is added this is the owner
    function AddParam(expr: TExpr): TExpr;

    property Param[index: integer]: TExpr read GetParam; default;


  end;

{ better way to represent expression types i guess}
type
  TExprItem = record
    kind: TExprTypes;
    strVal: string;
  end;

type
  TExprList = specialize TList<TExprItem>;



{ Make helper functions here ? }
function CEInt(Data: string): TExpr;
function CESum: TExpr;
function CESum(a, b: TExpr): TExpr;
function CEProd: TExpr;
function CEProd(a, b: TExpr): TExpr;

{ Expresion Items for que stack  }
function CIInt(data: string): TExprItem;
function CISum: TExprItem;
function CIProd: TExprItem;


implementation


{ TExpr }

constructor TExpr.Create(exType: TExprTypes = etEmpty);
begin
  inherited Create();
  self.params := TExpParams.Create(True);
  self.kind := exType;
end;


constructor TExpr.Create(exType: TExprTypes; sval: string);
begin
  Create();
  self.kind := exType;
  self.strVal := sval;
end;

constructor TExpr.Create(exType: TExprTypes; args: array of TExpr);
var
  i: integer;
begin
  Create();
  self.kind := exType;
  for i := Low(args) to High(args) do
  begin
    self.params.Add(args[i]);
  end;
end;

destructor TExpr.Destroy;
begin
  if Assigned(params) then
    FreeAndNil(params);
  inherited;
end;

function TExpr.AddParam(expr: TExpr): TExpr;
begin
  params.Add(expr);
  expr.parent := self;
  Result := expr;
end;

function TExpr.GetParam(index: integer): TExpr;
begin
  Result := self.params[index];
end;

{ Helper functions for expression creation }
function CEInt(Data: string): TExpr;
begin
  Result := TExpr.Create(etIntVal, Data);
end;

function CESum: TExpr;
begin
  Result := TExpr.Create(etIntSum);
end;

function CESum(a, b: TExpr): TExpr;
begin
  Result := TExpr.Create(etIntSum, [a, b]);
end;

function CEProd: TExpr;
begin
  Result := TExpr.Create(etIntProd);
end;

function CEProd(a, b: TExpr): TExpr;
begin
  Result := TExpr.Create(etIntProd, [a, b]);
end;

function CIInt(data: string): TExprItem;
begin
  //Result := TExprItem.Create;
  Result.kind:= etIntVal;
  Result.strVal:= data;
end;

function CISum: TExprItem;
begin
  //Result := TExprItem.Create;
  Result.kind:= etIntSum;
end;


function CIProd: TExprItem;
begin
  //Result := TExprItem.Create;
  Result.kind:= etIntProd;
end;


end.
