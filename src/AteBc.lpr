program AteBc;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes, SysUtils,
  Interpreter, Status, AteAst, AteTypes, AteParser,
  CustApp;

type

  { TAteBc }

  TAteBc = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
   end;

  { TAceBc }

  procedure TAteBc.DoRun;
  var
    ErrorMsg: string;
    res: TAteVal;
    expList: TExprList;
    ateStack: TAteStack;
    st: TStatus;
  begin
    // quick check parameters
    {
    ErrorMsg := CheckOptions('h',['help']);
    if ErrorMsg <> '' then
    begin
      ShowException(Exception.Create(ErrorMsg));
      Terminate;
      Exit;
    end;

    // parse parameters
    if HasOption('h', 'help') then
    begin
      WriteHelp;
      Terminate;
      Exit;
    end;
    }

    { add your program here }
    expList := nil;
    ateStack := nil;
    try
      expList := TExprList.Create();
      ateStack := TAteStack.Create();
      parse(argv[1]);
      generateAst2(expList);
      st := eval(ateStack, expList);
      writeLn(ateStack.Peek.intVal);
    finally
      FreeAndNil(ateStack);
      FreeAndNil(expList);
    end;
    // stop program loop
    Terminate;
  end;

  constructor TAteBc.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;

  end;

  destructor TAteBc.Destroy;
  begin
    inherited Destroy;
  end;

  procedure TAteBc.WriteHelp;
  begin
    { add your help code here }
    writeln('A Basic Calculator for command line');
    writeln('Usage: ');
    writeln(ExeName, ' -h Show this help');
    writeln('this program take first arg as expression to calc');
    writeln(ExeName, ' 4*7-2');
  end;



var
  Application: TAteBc;

{$R *.res}

begin
  Application := TAteBc.Create(nil);
  Application.Title := 'Basic Calc';
  Application.Run;
  Application.Free;
end.





