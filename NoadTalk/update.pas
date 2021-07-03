unit update;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, StrUtils, SysUtils, Windows,
  http;

function GetLatestVersion: string;
function GetVersionInfo(const FileName, Query: string): string;
function CheckUpdate: Boolean;
procedure ShowUpdate;
function QueryUpdate: Boolean;

implementation

function GetLatestVersion: string;
var
  Reader: TStrings;
  sLine: string;
  iPos: Int32;
begin
  Reader := TStringList.Create;
  try
    Reader.Text := HTTPGet('https://github.com/tinydew4/NoadTalk/releases');
    for sLine in Reader do begin
      iPos := Pos('/tag/', sLine);
      if iPos > 0 then begin
        Result := MidStr(sLine, iPos + 6, Length(sLine));
        Result := LeftStr(Result, Pos('"', Result) - 1);
        Break;
      end;
    end;
  finally
    Reader.Free;
  end;
end;

function GetVersionInfo(const FileName, Query: string): string;
var
  dwHandle: DWORD;
  dwVerInfoLength: DWORD;
  VerInfo: TBytes;
  dwValueLength: DWORD;
  Value: Pointer;
  sQuery: string;
begin
  Result := '';
  dwVerInfoLength := GetFileVersionInfoSize(PChar(FileName), dwHandle);
  SetLength(VerInfo, dwVerInfoLength);

  if not GetFileVersionInfo(PChar(FileName), 0, dwVerInfoLength, @VerInfo[0]) then Exit;
  if not VerQueryValue(@VerInfo[0], '\VarFileInfo\Translation', Value, dwValueLength) then Exit;

  sQuery := '\StringFileInfo\' + IntToHex(MakeLong(HiWord(Longint(Value^)), LoWord(Longint(Value^))), 8) + '\' + Query;
  if not VerQueryValue(@VerInfo[0], PChar(sQuery), Value, dwValueLength) then Exit;

  Result := StrPas(Value);
end;

function CheckUpdate: Boolean;
begin
  Result := GetLatestVersion <> GetVersionInfo(ParamStr(0), 'FileVersion');
end;

procedure ShowUpdate;
begin
  ShellExecute(0, 'open', 'https://github.com/tinydew4/NoadTalk/releases', nil, nil, SW_SHOW);
end;

function QueryUpdate: Boolean;
begin
  Result := False;
  if not CheckUpdate then Exit;
  if MessageBox(0, 'Update found. Want to check?', 'Update', MB_YESNO) <> IDYES then Exit;

  ShowUpdate;
  Result := True;
end;

end.

