// Copyright 2015 Theodore Tsirpanis. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
unit CharacterSet;

{$MODE objfpc}{$H+}
{$MODESWITCH ADVANCEDRECORDS}

interface

uses
  Classes, SysUtils, fgl, Math, GContnrs, gold_types;

type

  { TCharacterRange }

  TCharacterRange = record
  private
    FChrSrt: UnicodeString;
    FStart, FEnd: UnicodeChar;
  public
    class function Create(const s: UnicodeString): TCharacterRange; static; overload;
    class function Create(const s, e: UnicodeChar): TCharacterRange; static; overload;
    property CharSet: UnicodeString read FChrSrt;
    property Start: UnicodeChar read FStart;
    property _End: UnicodeChar read FEnd;
  end;

  TCSet = specialize TGenVector<TCharacterRange>;

  { TCharacterSet }

  TCharacterSet = class(TCSet)
    function Contains(const code: UnicodeChar): boolean;
  end;

  TCharacterSetList = specialize TFPGObjectList<TCharacterSet>;

implementation

{ TCharacterRange }

class function TCharacterRange.Create(const s: UnicodeString): TCharacterRange;
begin
  Result.FChrSrt := s;
  Result.FStart := #0;
  Result.FEnd := #0;
end;

class function TCharacterRange.Create(const s, e: UnicodeChar): TCharacterRange;
begin
  Result.FChrSrt := '';
  Result.FStart := UnicodeChar(Min(Ord(s), Ord(e)));
  Result.FEnd := UnicodeChar(Max(Ord(s), Ord(e)));
end;


{ TCharacterSet }

function TCharacterSet.Contains(const code: UnicodeChar): boolean;
var
  cr: TCharacterRange;
begin
  Result := False;
  for cr in self do
    if Result then
      Exit
    else
    if cr.CharSet <> '' then
      Result := Pos(code, cr.CharSet) <> 0
    else
      Result := InRange(Ord(Code), Ord(cr.Start), Ord(cr._End));
end;

end.
