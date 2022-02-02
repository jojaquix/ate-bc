unit AteTypes;

{$mode ObjFPC}{$H+}
{$modeswitch advancedRecords}

interface

uses
  Classes,
  SysUtils,
  Generics.Collections;

type
  { Used after eval the ast nodes }
  { Here will be all types supported or better classes ?}
  TValKind = (
    vkNil,
    vkInt,
    vkReal
    );

type
  { TAteVal }
  TAteVal = record
    class operator Initialize(var val: TAteVal);
    case kind: TValKind of
      vkInt:  (intVal: integer);
      vkReal: (realVal: double);
  end;

type
  { Base Class for all Ate Objects}
  TAteObj = class

  end;

  { Interpreter stack}
  TAteStack =  class(specialize TStack<TAteVal>)

  end;


implementation

{ TAteVal }

class operator TAteVal.Initialize(var val: TAteVal);
begin
  val.kind := vkNil;
end;

end.
