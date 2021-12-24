// Copyright 2015 Theodore Tsirpanis. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
unit FAState;

{$Mode objfpc}
{$ModeSwitch ADVANCEDRECORDS}

interface

uses
  Classes, SysUtils, fgl, CharacterSet, Symbol, GContnrs;

type

  { TFAEdge }

  TFAEdge = record
  private
    FChars: TCharacterSet;
    FTarget: integer;
  public
    class function Create(const cs: TCharacterSet; const tg: integer): TFAEdge; static;
    property Chars: TCharacterSet read FChars write FChars;
    property Target: integer read FTarget write FTarget;
  end;

  TEdgeList = specialize TGenVector<TFAEdge>;

  { TFAState }

  TFAState = class
  private
    FEdges: TEdgeList;
    FAccept: TSymbol;
  public
    constructor Create(const s: TSymbol);
    destructor Destroy; override;
    property Edges: TEdgeList read FEdges;
    property Accept: TSymbol read FAccept;
  end;

  TFAList = specialize TFPGObjectList<TFAState>;

  { TFAStateList }

  TFAStateList = class(TFAList)
  private
    FInitialState: integer;
    FErrorSymbol: TSymbol;
  public
    property InitialState: integer read FInitialState write FInitialState;
    property ErrorSymbol: TSymbol read FErrorSymbol write FErrorSymbol;
  end;

implementation

{ TFAState }

constructor TFAState.Create(const s: TSymbol);
begin
  FEdges := TEdgeList.Create;
  FAccept := s;
end;

destructor TFAState.Destroy;
begin
  FEdges.Free;
  inherited Destroy;
end;

{ TFAEdge }

class function TFAEdge.Create(const cs: TCharacterSet; const tg: integer): TFAEdge;
begin
  Result.FChars := cs;
  Result.FTarget := tg;
end;

end.
