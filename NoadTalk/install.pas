unit install;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Registry;

procedure Install;
procedure Uninstall;
function Installed: Boolean;

implementation

procedure Install;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_WOW64_32KEY or KEY_WRITE);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False) then Exit;

    Reg.WriteString('NoadTalk', ParamStr(0));
  finally
    Reg.Free;
  end;
end;

procedure Uninstall;
var
  Reg: TRegistry;
  sName: unicodestring;
begin
  Reg := TRegistry.Create(KEY_WOW64_32KEY or KEY_SET_VALUE or KEY_QUERY_VALUE);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False) then Exit;

    for sName in Reg.GetValueNames do begin
      if Reg.ReadString(sName) = unicodestring(ParamStr(0)) then begin
        Reg.DeleteValue(sName);
      end;
    end;
  finally
    Reg.Free;
  end;
end;

function Installed: Boolean;
var
  Reg: TRegistry;
  sName: unicodestring;
begin
  Result := False;

  Reg := TRegistry.Create(KEY_WOW64_32KEY or KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False) then Exit;

    for sName in Reg.GetValueNames do begin
      if Reg.ReadString(sName) = unicodestring(ParamStr(0)) then begin
        Result := True;
        Break;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

end.

