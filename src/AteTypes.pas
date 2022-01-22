unit AteTypes;

{$mode ObjFPC}{$H+}
{$modeswitch advancedRecords}

interface

uses
  Classes, SysUtils;

type
  { Used after eval the ast nodes }
  { Here will be all types supported }
  TValKind = (
    vkNil,
    vkInt,
    vkReal
    );

type
  { TAteVal }
  { * TAteVal -> the value of an evaluated TExpression }
  TAteVal = record
    class operator Initialize(var val: TAteVal);
    case kind: TValKind of
      vkInt:  (intVal: integer);
      vkReal: (realVal: double);
  end;


implementation

{ TAteVal }

class operator TAteVal.Initialize(var val: TAteVal);
begin
  val.kind := vkNil;
end;

end.
