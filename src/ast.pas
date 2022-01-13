unit Ast;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Generics.Collections;

type TExpTypes = (kIntLiteral, kIntSum, kIntProd);


//forward dec
type
  TExp = class;

type
  TExpParams = specialize TObjectList<TExp>;  //TObjectList can own childrens

type

{ TExp }

 TExp = class  //expresion own its childrens
  public
    expType: TExpTypes;
    expParams: TExpParams;
    strValue: String;

    constructor Create;
    destructor Destroy; override;


end;

//may be use generic functions for ast eval
generic function Add<T, T2>(const A: T; const B: T2): T;

implementation


generic function Add<T, T2>(const A: T; const B: T2): T;
begin
    Result := A
end;

{ TExp }

constructor TExp.Create;
begin
  inherited;
  self.expParams:= TExpParams.Create(True);
end;

destructor TExp.Destroy;
begin
  FreeAndNil(expParams);
  inherited;
end;

end.

