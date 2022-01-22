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

    constructor Create;
    constructor Create(exType: TExprTypes; sval: string);
    constructor Create(exType: TExprTypes; args: array of TExpr);
    destructor Destroy; override;

    property Param[index: integer]: TExpr read GetParam; default;


  end;

{ Make helper functions here ? }


implementation


{ TExpr }

constructor TExpr.Create;
begin
  inherited Create();
  self.kind := etEmpty;
end;


constructor TExpr.Create(exType: TExprTypes; sval: string);
begin
  inherited Create();
  self.kind := exType;
  self.strVal := sval;
end;

constructor TExpr.Create(exType: TExprTypes; args: array of TExpr);
var
  i: integer;
begin
  inherited Create();
  self.kind := exType;
  self.params := TExpParams.Create(True);
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

function TExpr.GetParam(index: integer): TExpr;
begin
  Result := self.params[index];
end;

end.
