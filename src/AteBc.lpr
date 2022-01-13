program AteBc;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  SysUtils, Ast,
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
  begin
    // quick check parameters
    ErrorMsg := CheckOptions('h', 'help');
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

    { add your program here }

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
    writeln('Usage: ', ExeName, ' -h');
  end;

var
  Application: TAteBc;
begin
  Application := TAteBc.Create(nil);
  Application.Title := 'Basic Calc';
  Application.Run;
  Application.Free;
end.





