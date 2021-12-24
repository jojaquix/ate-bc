// Copyright 2015 Theodore Tsirpanis. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
unit LRState;

{$MODE objfpc}
{$ModeSwitch AdvancedRecords}

interface

uses
  Classes, SysUtils, fgl, GContnrs, Symbol, gold_types;

type

  { TLRAction }

  TLRAction = record
  private
    fsym: TSymbol;
    ftype: TLRActionType;
    fvalue: integer;
  public
    class function Create(const sym: TSymbol; const tp: TLRActionType;
        const vl: integer): TLRAction; static;
    class function Undefined: TLRAction; static;
    class function Equals(const l1, l2: TLRAction): boolean; static;
    function Equals(const l: TLRAction): boolean;
    property TheSymbol: TSymbol read fsym;
    property LRType: TLRActionType read ftype;
    property Value: integer read fvalue;
  end;

  TLRList = specialize TGenVector<TLRAction>;

  { TLRState }

  TLRState = class(TLRList)
    function Find(const s: TSymbol): TLRAction;
  end;

  TStateList = specialize TFPGObjectList<TLRState>;

  TLRStateList = class(TStateList)
  private
    FInitialState: integer;
  public
    property InitialState: integer read FInitialState write FInitialState;
  end;

implementation

var
  undefsym: TSymbol;

{ TLRState }

function TLRState.Find(const s: TSymbol): TLRAction;
var
  sm: TLRAction;
begin
  if not Assigned(s) then
    Result := TLRAction.Create(nil, laUndefined, -1)
  else
    for sm in self do
      if sm.TheSymbol.TableIndex = s.TableIndex then
        Exit(sm);
end;

{ TLRAction }

class function TLRAction.Create(const sym: TSymbol; const tp: TLRActionType;
  const vl: integer): TLRAction;
begin
  Result.fsym := sym;
  Result.ftype := tp;
  Result.fvalue := vl;
end;

class function TLRAction.Undefined: TLRAction;
begin
  Result := Create(undefsym, laUndefined, -1);
end;

class function TLRAction.Equals(const l1, l2: TLRAction): boolean;
begin
  Result := (l1.LRType = l2.LRType) and (l1.TheSymbol.Equals(l2.TheSymbol)) and
    (l1.Value = l2.Value);
end;

function TLRAction.Equals(const l: TLRAction): boolean;
begin
  Result := Equals(Self, l);
end;

initialization
  undefsym := TSymbol.Create();

finalization
  undefsym.Free;

end.
