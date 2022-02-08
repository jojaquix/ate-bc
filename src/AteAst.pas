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
    etIntDiv,
    etUnaryMinus
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
function CIInt(data: string): TExprItem; inline;
function CISum: TExprItem; inline;
function CISub: TExprItem; inline;
function CIProd: TExprItem; inline;
function CIDiv: TExprItem; inline;
function CIUnaryMinus: TExprItem; inline;


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
  Result.strVal:= '+';
end;

function CISub: TExprItem; inline;
begin
  //Result := TExprItem.Create;
  Result.kind:= etIntSub;
  Result.strVal:= '-';
end;


function CIProd: TExprItem; inline;
begin
  //Result := TExprItem.Create;
  Result.kind:= etIntProd;
  Result.strVal:= '*';
end;

function CIDiv: TExprItem; inline;
begin
  //Result := TExprItem.Create;
  Result.kind:= etIntDiv;
  Result.strVal:= '/';
end;

function CIUnaryMinus: TExprItem;
begin
  Result.kind:= etUnaryMinus;
  Result.strVal:= 'UnaryMinus';
end;





{ this function generate expList from perser reduction }
function generateAst2(expList: TExprList): TStatus;
var
  level,unary: integer;

  // Example of TToken values for a given grammar
  // node.Name = 'IntegerLiteral', '*'
  // node.Data = '5', '*'
  // node.SymbolType = see TSymbolType in gold_types unit

  procedure visit(tred: TReduction; parentName: string);
  var
    i: integer;
  begin
    Inc(level);

    Writeln('Parent Name: ', parentName);
    for i := tred.Count - 1 downto 0 do // for left asoc
    //for i :=  0 to tred.Count - 1  do
      //if not (tred[i].SymbolType in [stNON_TERMINAL]) then
    begin
      writeln('Name: ', tred[i].Name:10,
        ' Type: ', IntToStr(Ord(tred[i].SymbolType)),
        ' Data: ', tred[i].Data:10,
        ' Index: ', i,
        ' Level: ', level);
      //if Assigned(tred[i].Reduction) and Assigned(tred[i].Reduction.Parent) then
      // writeln('parent: ', tred[i].Reduction.Parent.ToString());

      case tred[i].Name of
        '+':
        begin
          //writeln('Adding Sum');
          expList.Add(CISum());
        end;

        '-':
        begin
          if Pos(parentName,'UnaryMinus') > 0 then
          begin
            expList.Add(CIUnaryMinus());
            writeln('Adding Unary Minus')
          end
          else
            expList.Add(CISub());
        end;

        '*':
        begin
          //writeln('Adding Prod');
          expList.Add(CIProd());
        end;

        '/':
        begin
          //writeln('Adding Prod');
          expList.Add(CIDiv());
        end;

        'IntLiteral':
        begin
          //writeln('Adding LitInt');
          expList.Add(CIInt(tred[i].Data));
        end;

        'UnaryMinus':
        begin
          //writeln('Adding UnaryMinus');
          //expList.Add(CIUnaryMinus());
        end;
      end;
    end;


    for i := tred.Count - 1 downto 0 do
    //for i := 0 to tred.Count - 1 do
      if (Assigned(tred[i].Reduction)) then
        visit(tred[i].Reduction, tred[i].Name);
    Dec(level);
  end;

begin
  level := 0;
  visit(AteParser.getCurrentReduction, '');
end;


end.
