// Copyright 2015 Theodore Tsirpanis. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
unit Symbol;

{$Mode objfpc}

interface

uses
  Classes, SysUtils, fgl, gold_types;

const
  SYMBOL_COMMENT = 'COMMENT';
  SYMBOL_COMMENT_BLOCK = 'COMMENT_BLOCK';
  SYMBOL_COMMENT_LINE = 'COMMENT_LINE';

type
  TGroup = class;

  { TSymbol }

  TSymbol = class
  protected
    FName: string;
    FType: TSymbolType;
    FTableIndex: integer;
    FGroup: TGroup;
  public
    constructor Create;
    constructor Create(n: string; st: TSymbolType; i: integer);
    class function LiteralFormat(const src: string; ForceDelimiter: boolean): string;
    function ToString: ansistring; override; overload;
    function ToString(const DelimitTerminals: boolean): string; overload;
    property SymbolGroup: TGroup read FGroup write FGroup;
    property Name: string read FName write FName;
    property TableIndex: integer read FTableIndex write FTableIndex;
    property SymbolType: TSymbolType read FType write FType;
  end;

  TSymList = specialize TFPGObjectList<TSymbol>;

  { TSymbolList }

  TSymbolList = class(TSymList)
    function FindByName(const n: string): TSymbol;
    function ToString: ansistring; override;
  end;

  { TGroup }

  TGroup = class
  private
    FName: string;
    FContainer, FStart, FEnd: TSymbol;
    FAdvMode: TAdvanceMode;
    FEndingMode: TEndingMode;
    FIndex: integer;
    FNesting: TIntegerList;
    procedure SetContainer(AValue: TSymbol);
    procedure SetEnd(AValue: TSymbol);
    procedure SetStart(AValue: TSymbol);
  public
    constructor Create;
    destructor Destroy; override;
    property Name: string read FName write FName;
    property Container: TSymbol read FContainer write SetContainer;
    property Start: TSymbol read FStart write SetStart;
    property _End: TSymbol read FEnd write SetEnd;
    property AdvanceMode: TAdvanceMode read FAdvMode write FAdvMode;
    property EndingMode: TEndingMode read FEndingMode write FEndingMode;
    property Index: integer read FIndex write FIndex;
    property Nesting: TIntegerList read FNesting write FNesting;
  end;

  TGroupList = specialize TFPGObjectList<TGroup>;

implementation

{ TSymbolList }

function TSymbolList.FindByName(const n: string): TSymbol;
var
  sm: TSymbol;
begin
  Result := nil;
  for sm in self do
    if SameText(sm.Name, n) then
      Exit(sm);
end;

function TSymbolList.ToString: ansistring;
var
  i: TSymbol;
begin
  Result := '';
  for i in Self do
    Result += ' ' + i.ToString;
  Result := Trim(Result);
end;

{ TSymbol }

class function TSymbol.LiteralFormat(const src: string;
  ForceDelimiter: boolean): string;

  function IsLetter(const c: char): boolean;
  begin
    Result := lowerCase(c) in ['a'..'z'];
  end;

var
  i: integer;
  c: char;
begin
  if src = '''' then
    Result := ''''''
  else
  begin
    if not ForceDelimiter then
    begin
      ForceDelimiter := (Length(src) = 0) or IsLetter(src[1]);
      if not ForceDelimiter then
      begin
        i := 1;
        while (not ForceDelimiter) and (i < Length(src)) do
        begin
          c := src[i];
          ForceDelimiter := not (IsLetter(c) or (c in ['.', '-', '_']));
          Inc(i);
        end;
      end;
    end;
    if ForceDelimiter then
      Result := '''' + src + ''''
    else
      Result := src;
  end;
end;

constructor TSymbol.Create;
begin
  inherited;
end;

constructor TSymbol.Create(n: string; st: TSymbolType; i: integer);
begin
  inherited Create;
  FName := n;
  FType := st;
  FTableIndex := i;
end;

function TSymbol.ToString: ansistring;
begin
  Result := ToString(False);
end;

function TSymbol.ToString(const DelimitTerminals: boolean): string;
begin
  case SymbolType of
    stNON_TERMINAL: Result := '<' + Name + '>';
    stCONTENT: Result := LiteralFormat(Name, DelimitTerminals);
    else
      Result := '(' + Name + ')';
  end;
end;

{ TGroup }

procedure TGroup.SetStart(AValue: TSymbol);
begin
  FStart := AValue;
  FStart.SymbolGroup := self;
end;

procedure TGroup.SetEnd(AValue: TSymbol);
begin
  FEnd := AValue;
  FEnd.SymbolGroup := self;
end;

procedure TGroup.SetContainer(AValue: TSymbol);
begin
  FContainer := AValue;
  FContainer.SymbolGroup := self;
end;

constructor TGroup.Create;
begin
  FAdvMode := amCharacter;
  FEndingMode := emClosed;
  FNesting := TIntegerList.Create;
end;

destructor TGroup.Destroy;
begin
  FNesting.Free;
  inherited Destroy;
end;

end.
