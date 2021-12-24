// Copyright 2015 Theodore Tsirpanis. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
unit gold_types;

{$mode objfpc}{$H+}
{$ModeSwitch ADVANCEDRECORDS}

interface

uses
  Classes, SysUtils, GContnrs;

type
  TAdvanceMode = (amToken, amCharacter);
  TCGTRecord = (crCHARSET = 67, crDFASTATE = 68, crINITIALSTATES =
    73, crLRSTATE = 76, crPARAMETER = 80, crRULE = 82, crSYMBOL = 83,
    crCOUNTS = 84, crCHARRANGES = 99, crGROUP = 103, crGROUPNESTING =
    110, crPROPERTY = 112, crCOUNTS5 = 116);
  TEndingMode = (emOpen, emClosed);
  TEntryType = (
    etERROR = 0,
    etBOOLEAN = 66,   // B 1 byte 0=false, 1=true
    etEMPTY = 69,   // E
    etUINT16 = 73,   // I unsigned 16 bit integer
    etSTRING = 83,   // S Unicode
    etBYTE = 98);   // b
  TLRActionType = (
    laUndefined,
    laSHIFT,     // Shift a symbol and goto a state
    laREDUCE,     // Reduce by a specified rule
    laGOTO,     // Goto a state on reduction
    laACCEPT,     // Input successfully parsed
    laERROR);     // Programmers see this often!
  TParseMessage = (
    pmTOKEN_READ,  // A new token is read
    pmREDUCTION,  // A production is reduced
    pmACCEPT,  // Parse of grammar is complete
    pmNOT_LOADED_ERROR,  // The tables are not loaded
    pmLEXICAL_ERROR,  // Token is not recognized
    pmSYNTAX_ERROR,  // Token is not expected
    pmGROUP_ERROR,  // Reached the end of the file inside a block
    pmINTERNAL_ERROR); // Something is wrong, very wrong
  TParseResult = (
    prACCEPT = 1, prSHIFT, prREDUCE_NORMAL, prREDUCE_ELIMINATED,
    prSYNTAX_ERROR, prINTERNAL_ERROR);
  TSymbolType = (
    stNON_TERMINAL,   // Nonterminal
    stCONTENT,   // Passed to the parser
    stNOISE,   // Ignored by the parser
    stEND,   // End character =EOF
    stGROUP_START,   // Group start
    stGROUP_END,   // Group end
    stCOMMENT_LINE,   // Note COMMENT_LINE is deprecated starting at V5.
    stERROR);   // Error symbol

  { TIntegerList }

  TIntegerList = class(specialize TGenVector<integer>)
  public
    function DefaultCompareItems(const A, B: integer): integer; override;
    function DefaultItemToString(const Item: integer): string; override;
  end;

  EParserException = class(Exception);

  { TPosition }

  TPosition = record
  private
    fline, fcolumn: DWord;
  public
    class function Create: TPosition; static; overload;
    class function Create(const l, c: DWord): TPosition; static; overload;
    class function Create(const p: TPosition): TPosition; static; overload;
    procedure IncCol;
    procedure IncLine;
    function ToString: string;
    property Column: DWord read fcolumn;
    property Line: DWord read fline;
  end;


implementation

{ TIntegerList }

function TIntegerList.DefaultCompareItems(const A, B: integer): integer;
begin
  Result := b - a;
end;

function TIntegerList.DefaultItemToString(const Item: integer): string;
begin
  Result := IntToStr(Item);
end;

{ TPosition }

class function TPosition.Create: TPosition;
begin
  Result := Create(1, 1);
end;

class function TPosition.Create(const l, c: DWord): TPosition;
begin
  Result.fline := l;
  Result.fcolumn := c;
end;

class function TPosition.Create(const p: TPosition): TPosition;
begin
  Result := p;
end;

procedure TPosition.IncCol;
begin
  Inc(fcolumn);
end;

procedure TPosition.IncLine;
begin
  Inc(fline);
  fcolumn := 1;
end;

function TPosition.ToString: string;
begin
  Result := Format('(%u,%u)', [fline, fcolumn]);
end;

end.
