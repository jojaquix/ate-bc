// Copyright 2015 Theodore Tsirpanis. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
unit Token;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl, contnrs, Symbol, gold_types, Production;

type
  TTokenStack = class;
  TReduction = class;

  { TToken }

  TToken = class(TSymbol)
  private
    FState: integer;
    FReduction: TReduction;
    FPosition: TPosition;
    FData: string;
    FOwnerStack: TTokenStack;
    procedure SetAsSymbol(const s: TSymbol);
    procedure SetOwnerStack(AValue: TTokenStack);
    property OwnerStack: TTokenStack read FOwnerStack write SetOwnerStack;
  public
    constructor Create;
    constructor Create(const sym: TSymbol; const dt: TReduction);
    constructor Create(const sym: TSymbol; const dt: TReduction; const Pos: TPosition);
    destructor Destroy; override;
    function ToString: ansistring; override; overload;
    procedure AppendData(const s: string);
    property AsSymbol: TSymbol write SetAsSymbol;
    property Data: string read FData write FData;
    property Position: TPosition read FPosition write FPosition;
    property Reduction: TReduction read FReduction write FReduction;
    property State: integer read FState write FState;
  end;

  // It used to be a TFPGObjectList, but a reduction
  // does not keep track of its tokens; the stacks do.
  TTokList = specialize TFPGList<TToken>;

  { TReduction }

  TReduction = class(TTokList)
  private
    FParent: TProduction;
    // It used to be a TVariable. I had thought of
    // removing this field, but why not keep it?
    FValue: string;
  public
    property Parent: TProduction read FParent write FParent;
    property Value: string read FValue write FValue;
  end;

  { TTokenStack }

  TTokenStack = class
  private
    FMemberList: TFPObjectList;
    FOwnedTokens: TFPObjectList;
    function GetCount: integer;
    function GetItem(Index: integer): TToken;
    procedure FreeOwnedTokens;
  public
    constructor Create(const fobjs: boolean = True);
    destructor Destroy; override;
    procedure Clear;
    procedure Push(TheToken: TToken);
    function Pop: TToken;
    function Top: TToken;
    property Count: integer read GetCount;
    property Items[Index: integer]: TToken read GetItem; default;
    property MemberList: TFPObjectList read FMemberList;
  end;

function DrawReductionTree(TheReduction: TReduction): string;

implementation

procedure PrintParseTree(Text: string; Lines: TStrings);
begin
  //This sub just appends the Text to the end of the txtParseTree textbox.
  Lines.Append(Text);
end;

procedure DrawReduction(TheReduction: TReduction; Indent: integer; sl: TStrings);
const
  kIndentText = '|  ';
var
  n: integer;
  IndentText: string;
begin
  {This is a simple recursive procedure that draws an ASCII version of the parse
  tree}
  IndentText := '';
  for n := 1 to Indent do
    IndentText += kIndentText;
  //==== Display Reduction
  PrintParseTree(IndentText + '+--' + TheReduction.Parent.ToString, sl);
  //=== Display the children of the reduction
  for n := 0 to TheReduction.Count - 1 do
  begin
    case TheReduction[n].SymbolType of
      stNON_TERMINAL:
        DrawReduction(TheReduction[n].Reduction, (Indent + 1), sl);
      else
        PrintParseTree(IndentText + kIndentText + '+--' +
          TheReduction[n].Data, sl);
    end;
  end;
end;

function DrawReductionTree(TheReduction: TReduction): string;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    //This procedure starts the recursion that draws the parse tree.
    DrawReduction(TheReduction, 0, sl);
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

{ TTokenStack }

function TTokenStack.GetCount: integer;
begin
  Result := MemberList.Count;
end;

function TTokenStack.GetItem(Index: integer): TToken;
begin
  if (Index >= 0) and (Index < MemberList.Count) then
    Result := MemberList.Items[Index] as TToken
  else
    Result := nil;
end;

procedure TTokenStack.FreeOwnedTokens;
begin
  FOwnedTokens.Clear;
end;

constructor TTokenStack.Create(const fobjs: boolean);
begin
  inherited Create;
  FMemberList := TFPObjectList.Create(False);
  FOwnedTokens := TFPObjectList.Create(fobjs);
end;

destructor TTokenStack.Destroy;
begin
  MemberList.Free;
  FreeOwnedTokens;
  FOwnedTokens.Free;
  inherited Destroy;
end;

procedure TTokenStack.Clear;
begin
  MemberList.Clear;
  FreeOwnedTokens;
end;

procedure TTokenStack.Push(TheToken: TToken);
begin
  MemberList.Add(TheToken);
  TheToken.OwnerStack := self;
end;

function TTokenStack.Pop: TToken;
begin
  Result := Top;
  if Assigned(Result) then
    MemberList.Delete(Count - 1);
end;

function TTokenStack.Top: TToken;
begin
  if Count <> 0 then
    Result := Items[Count - 1]
  else
    raise Exception.Create('Attempting to pop a token from an empty stack.')at
    get_caller_addr(get_frame);
end;

{ TToken }

procedure TToken.SetAsSymbol(const s: TSymbol);
begin
  if not Assigned(s) then
    Exit;
  SymbolGroup := s.SymbolGroup;
  Name := s.Name;
  SymbolType := s.SymbolType;
  TableIndex := s.TableIndex;
end;

procedure TToken.SetOwnerStack(AValue: TTokenStack);
var
  too: boolean;
begin
  if FOwnerStack = AValue then
    Exit;
  if Assigned(FOwnerStack) then
    with FOwnerStack.FOwnedTokens do
    begin
      too := OwnsObjects;
      OwnsObjects := False;
      Remove(self);
      OwnsObjects := too;
    end;
  FOwnerStack := AValue;
  FOwnerStack.FOwnedTokens.Add(Self);
end;

constructor TToken.Create;
begin
  inherited;
  FData := '';
  FState := 0;
  FReduction := nil;
end;

constructor TToken.Create(const sym: TSymbol; const dt: TReduction);
begin
  Create(sym, dt, TPosition.Create);
end;

constructor TToken.Create(const sym: TSymbol; const dt: TReduction;
  const Pos: TPosition);
begin
  Create;
  FReduction := dt;
  if Assigned(sym) then
  begin
    FName := sym.Name;
    SymbolType := sym.SymbolType;
    TableIndex := sym.TableIndex;
  end;
  FPosition := pos;
  if Assigned(dt) then
    AppendData(dt.ToString);
end;

destructor TToken.Destroy;
var
  too: boolean;
begin
  FReduction.Free;
  if Assigned(FOwnerStack) then
    with FOwnerStack.FOwnedTokens do
    begin
      too := OwnsObjects;
      OwnsObjects := False;
      Remove(self);
      OwnsObjects := too;
    end;
  inherited Destroy;
end;

function TToken.ToString: ansistring;
begin
  Result := FData;
end;

procedure TToken.AppendData(const s: string);
begin
  FData += s;
end;

end.
