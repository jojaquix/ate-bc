unit GOLDParser;

{$IFDEF FPC}{$MODE Delphi}{$ENDIF}

{
'===================================================================
' Class Name:
'    GOLDParser (basic version)
'
' Instancing:
'      Public; Creatable  (VB Setting: 5 - MultiUse)
'
' Purpose:
'    This is the main class in the GOLD Parser Engine and is used to perform
'    all duties required to the parsing of a source text string. This class
'    contains the LALR(1) State Machine code, the DFA State Machine code,
'    character table (used by the DFA algorithm) and all other structures and
'    methods needed to interact with the developer.
'
'Author(s):
'   Devin Cook
'
'Public Dependencies:
'   Token, Rule, Symbol, Reduction
'
'Private Dependencies:
'   ObjectList, SimpleDatabase, SymbolList, StringList, VariableList, TokenStack
'
'Revision History:
'   June 9, 2001:
'      Added the ReductionMode property and modified the Reduction object (which was
'      used only for internal use). In addition the Reduction property was renamed to
'      CurrentReduction to avoid possible name conflicts in different programming languages
'      (which this VB source will be converted to eventually)
'   Sept 5, 2001:
'      I was alerted to an error in the engine logic by Szczepan Holyszewski [rulatir@poczta.arena.pl].
'      When reading tokens inside a block quote, the line-comment token would still eliminate the rest
'      of a line - possibly eliminating the block quote end.
'   Nov 28, 2001:
'      Fixed several errors.
'   December 2001:
'      Added the TrimReductions property and required logic
'===================================================================
 Conversion to Delphi:
      Beany
      Beany@cloud.demon.nl

 Conversion status: Done, not tested

 Delphi Version: 6.0

 Delphi GOLDParser version: 0.1 (very alpha!)

'===============================================================================
' Refactored 2018, Thaddy de Koning: use of generics greatly simplified code
'===============================================================================

 Conversion Readme:

 This is a pretty straightforward conversion of the GOLDParser VB version.
 The most important difference is the GrammarReader and the SourceFeeder classes.
 These classes take care of reading the grammar and feeding the parser with code
 wich must be parsed. The reading of the grammar looks the same as in the VB
 version, but the LookaheadStream is not being used. The feeding of the source
 is also being done without the LookaheadStream.

 TODO's(in no particulair order):

 1. DONE 22 April 2002: Get rid of the Variant type's. It can be done without.
    The code will run faster without Variants. They can also produce weird errors.
 2. Optimize the code. Its currently a pretty straightforward conversion. It
    can be done better, wich will result in cleaner and faster code.
 3. Intensive testing. I did some tests, wich succeeded, but I want to test it
    more to be sure it does what it is supposed to do. Any input on this
    would be helpfull! ;)
 4. DONE 24 April 2002(well, I hope so!): Check if there are no memory leaks. I have the feeling there are some, but
    I have to get in to it.
 5. Write some documentation
 6. ALTHOUGH IT LOOKS LIKE ITS DONE: ALMOST DONE, JUST SOME MINOR THINGS: Make
    a nice component of this all so it can be easily used with a Delphi
    application
 7. DONE 23 April 2002: Make sure the interface has the same functionality compared to the VB
    ActiveX version.



 Warranty: None ofcourse :) If it works for you, GOOD! If it doesnt, don't demand
 that I will fix it. You can ask me, but I can't guarantee anything!



'================================================================================
'
'                 The GOLD Parser Freeware License Agreement
'                 ==========================================
'
'this software Is provided 'as-is', without any expressed or implied warranty.
'In no event will the authors be held liable for any damages arising from the
'use of this software.
'
'Permission is granted to anyone to use this software for any purpose. If you
'use this software in a product, an acknowledgment in the product documentation
'would be deeply appreciated but is not required.
'
'In the case of the GOLD Parser Engine source code, permission is granted to
'anyone to alter it and redistribute it freely, subject to the following
'restrictions:
'
'   1. The origin of this software must not be misrepresented; you must not
'      claim that you wrote the original software.
'
'   2. Altered source versions must be plainly marked as such, and must not
'      be misrepresented as being the original software.
'
'   3. This notice may not be removed or altered from any source distribution
'
'================================================================================
}

interface

uses
  Classes, SysUtils,
  gold_types, Parser, Token;

type

  { TGOLDParser }

  TGOLDParser = class(TAbstractGOLDParser)
  private
    fparsedOk: boolean;
    ftree: string;
    flog: TStrings;

    tablesFilePath: string;
    testString: string;

    function GetLog: string;
    procedure AddLog(const s: string; const p: TPosition);
  public
    constructor Create; overload;
    constructor Create(const tablesFilePath, testString: string); overload;
    destructor Destroy; override;

    function DoParse(): boolean;

    property Tree: string read ftree;
    property Log: string read GetLog;
    property ParsedOk: boolean read fparsedOk;
  end;


implementation

procedure TGOLDParser.AddLog(const s: string; const p: TPosition);
begin
  FLog.Add(s + ' ' + p.ToString);
end;

function TGOLDParser.GetLog: string;
begin
  Result := FLog.Text;
end;

constructor TGOLDParser.Create;
begin
  Create(ParamStr(1), ParamStr(2));
end;

constructor TGOLDParser.Create(const tablesFilePath, testString: string);
begin
  inherited Create;
  ftree := '';
  flog := TStringList.Create;
  self.testString := testString;
  self.tablesFilePath := tablesFilePath;
  self.fparsedOk := False;
end;

destructor TGOLDParser.Destroy;
begin
  FLog.Free;
  inherited Destroy;
end;

function TGOLDParser.DoParse(): boolean;
var
  res: TParseMessage;
  done: boolean;
  s: string;
  i: integer;
begin
  done := False; // booleans are not false by default!!
  self.LoadTables(self.tablesFilePath);
  self.OpenString(self.testString);
  //self.OpenFile(self.testString);

  while not done do
  begin
    res := self.Parse;
    done := res in [pmACCEPT..pmINTERNAL_ERROR];
    case Res of
      pmTOKEN_READ: AddLog('Token read: ' + CurrentToken.Name +
          ', ' + CurrentToken.Data, CurrentToken.Position);
      pmREDUCTION: AddLog('Reduction: ' + CurrentReduction.Parent.ToString,
          CurrentPosition);
      pmACCEPT:
      begin
        AddLog('Grammar accepted successfully.', CurrentPosition);
        ftree := DrawReductionTree(CurrentReduction);
      end;
      pmNOT_LOADED_ERROR: AddLog('Grammar is not loaded.', CurrentPosition);
      pmLEXICAL_ERROR: AddLog('Lexical error: Cannot recognize token ' +
          CurrentToken.Data, CurrentToken.Position);
      pmSYNTAX_ERROR:
      begin
        s := '';
        for i := 0 to ExpectedSymbols.Count - 1 do
          s += ', ' + ExpectedSymbols[i].Name;
        AddLog(Format('Syntax error: Expected one of these tokens: %s but got %s.',
          [s, QuotedStr(CurrentToken.Name)]), CurrentPosition);
      end;
      pmGROUP_ERROR: AddLog('Error: Unexpexted end of file.', CurrentPosition);
      pmINTERNAL_ERROR: AddLog('Internal Error: Something is bad, very bad',
          CurrentPosition);
    end;
  end;

  self.fparsedOk := res = pmACCEPT;
  Result := self.fparsedOk;
end;


end.
