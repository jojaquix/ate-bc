unit AteAst;

{
 Ast module, defines the types (and methods, helpers ets)
 to build an AST that will be evaluated by the interpreter
}

{$mode ObjFPC}{$H+}
{$modeswitch advancedRecords}

interface

uses
  Classes, SysUtils,
  Generics.Collections,
  GOLDParser, Token, Gold_Types,
  Status, AteTypes;

type
  { exp types that comes from parser}
  TExprTypes = (
    etEmpty,
    etIntVal,
    etIntSum,
    etIntSub,
    etIntProd,
    etIntDiv
    );


{ a way to represent expression types i guess}
type
  TExprItem = record
    kind: TExprTypes;
    strVal: string;
  end;

type
  TExprList = specialize TList<TExprItem>;


{ Make helper functions here ? }

{ Expresion Items for que stack  }
function CIInt(data: string): TExprItem;
function CISum: TExprItem;
function CISub: TExprItem;
function CIProd: TExprItem;
function CIDiv: TExprItem;


{ generate the ast from parse tree }

function generateAst2(expList: TExprList): TStatus;

implementation

uses
  AteParser;

{ Helper functions for expression creation }

function CIInt(data: string): TExprItem; inline;
begin
  //Result := TExprItem.Create;
  Result.kind:= etIntVal;
  Result.strVal:= data;
end;

function CISum: TExprItem; inline;
begin
  //Result := TExprItem.Create;
  Result.kind:= etIntSum;
end;

function CISub: TExprItem; inline;
begin
  //Result := TExprItem.Create;
  Result.kind:= etIntSub;
end;


function CIProd: TExprItem; inline;
begin
  //Result := TExprItem.Create;
  Result.kind:= etIntProd;
end;

function CIDiv: TExprItem; inline;
begin
  //Result := TExprItem.Create;
  Result.kind:= etIntDiv;
end;





{ this function generate expList from perser reduction }
function generateAst2(expList: TExprList): TStatus;
var
  level: integer;

  // Example of TToken values for a given grammar
  // node.Name = 'IntegerLiteral', '*'
  // node.Data = '5', '*'
  // node.SymbolType = see TSymbolType in gold_types unit

  procedure visit(tred: TReduction);
  var
    i: integer;
  begin
    Inc(level);
    for i := tred.Count - 1 downto 0  do
      if not (tred[i].SymbolType in [stNON_TERMINAL]) then
      begin
        writeln('Name: ', tred[i].Name,
          ' Type: ', IntToStr(Ord(tred[i].SymbolType)),
          ' Data: ', tred[i].Data,
          ' Index: ', i,
          ' Level: ', level);

        case tred[i].Name of
          '+':
          begin
            writeln('Adding Sum');
            expList.Add(CISum());
          end;

          '-':
          begin
            writeln('Adding Sub');
            expList.Add(CISub());
          end;

          '*':
          begin
            writeln('Adding Prod');
            expList.Add(CIProd());
          end;

          '/':
          begin
            writeln('Adding Prod');
            expList.Add(CIDiv());
          end;

          'IntLiteral':
          begin
            writeln('Adding LitInt');
            expList.Add(CIInt(tred[i].Data));
          end;
        end;

      end;

    for i := tred.Count - 1 downto 0 do
      if (Assigned(tred[i].Reduction)) then
        visit(tred[i].Reduction);

    Dec(level);
  end;

begin
  level := 0;
  visit(AteParser.getCurrentReduction);
end;


end.
