unit Status;
{
 ==============================================================================
 Unit Status
 TStatus type (Value)
 This type represents the status of given operation/action

 Success function to create TStatus with 0 Code and  'Ok' message
 Failure functions to create TStatus with non 0 Code and custom message
 ==============================================================================
}

{$mode objfpc}{$H+}
{$modeswitch advancedRecords}

interface

uses
  Classes, SysUtils;

{ TStatus }
{ status type to represent that statuses }
const
  kSuccessCode = 0;
  kError = 1; //from here any number > 1 could be used for errors

type
  TStatus = record
    Code: integer;
    Message: string;
    procedure Init(theCode: integer = kSuccessCode; msg: string = 'Ok');
    function Ok: boolean;
    class operator initialize(var sta:TStatus);

  end;


function Failure(msg: string): TStatus;
function Failure(code: integer; msg: string): TStatus;
function Success(): TStatus;



implementation

procedure TStatus.Init(theCode: integer; msg: string);
begin
  Code := theCode;
  Message := msg;
end;

class operator TStatus.initialize(var sta: TStatus);
begin
   sta.Init(kSuccessCode, 'Ok');
end;


function TStatus.Ok: boolean;
begin
  Result := Code = kSuccessCode;
end;

function Failure(msg: string): TStatus;
begin
  Result.Init(kError, msg);
end;

function Failure(code: integer; msg: string): TStatus;
begin
  Result.Init(code, msg);
end;

function Success: TStatus;
begin
  Result.Init(kSuccessCode, 'Ok');
end;

end.

