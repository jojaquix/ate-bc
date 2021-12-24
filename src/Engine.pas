unit Engine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function Add(a, b: Int32): Int32;


implementation

function Add(a, b: Int32): Int32;
begin
  Result := a + b;
end;

end.

