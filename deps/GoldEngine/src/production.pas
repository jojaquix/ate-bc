// Copyright 2015 Theodore Tsirpanis. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
unit Production;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl, Symbol, gold_types;

type

  { TProduction }

  TProduction = class
  private
    FHead: TSymbol;
    FHandle: TSymbolList;
    FTableIndex: integer;
  public
    constructor Create(const hd: TSymbol; const ti: integer);
    destructor Destroy; override;
    function HasOneNonTerminal: boolean;
    function ToString: ansistring; override;
    property Head: TSymbol read FHead write FHead;
    property Handle: TSymbolList read FHandle;
  end;

  TProductionList = specialize TFPGObjectList<TProduction>;

implementation

{ TProduction }

constructor TProduction.Create(const hd: TSymbol; const ti: integer);
begin
  FHead := hd;
  FTableIndex := ti;
  FHandle := TSymbolList.Create(False);
end;

destructor TProduction.Destroy;
begin
  FHandle.Free;
  inherited Destroy;
end;

function TProduction.HasOneNonTerminal: boolean;
begin
  {$B+}
  Result := (FHandle.Count = 1) and (FHandle.Items[0].SymbolType = stNON_TERMINAL);
end;

function TProduction.ToString: ansistring;
begin
  Result := FHead.ToString + ' ::= ' + FHandle.ToString;
end;

end.
