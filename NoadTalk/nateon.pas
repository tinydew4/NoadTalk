unit nateon;

{$mode ObjFPC}{$H+}

interface

uses
  Windows,
  _fmMain, helper;

implementation

procedure Execute;
const
  TargetList: array of array of LPCWSTR = (
    ('Afx:00670000:0:00030AAB:00900010:00000000', nil),
    ('#32770', '네이트온 안내')
  );
var
  Target: array of LPCWSTR;
begin
  for Target in TargetList do begin
    helper.CloseWindow(Target[0], Target[1]);
  end;
end;

Initialization
  fmMain.RegisterProcedure(@Execute);

end.

