unit helper;

{$mode ObjFPC}{$H+}

interface

uses
  Windows;

function GetClassName(hWnd: HWND): unicodestring;
function GetWindowText(hWnd: HWND): unicodestring;
function GetWindowRect(hWnd: HWND): TRect;

procedure HideWindow(hWnd: HWND);
procedure CloseWindow(lpClassName, lpWindowName: LPCWSTR);

implementation

function GetClassName(hWnd: HWND): unicodestring;
begin
  SetLength(Result, MAX_PATH);
  SetLength(Result, Windows.GetClassNameW(hWnd, PWideChar(Result), Length(Result)));
end;

function GetWindowText(hWnd: HWND): unicodestring;
begin
  SetLength(Result, MAX_PATH);
  SetLength(Result, Windows.GetWindowTextW(hWnd, PWideChar(Result), Length(Result)));
end;

function GetWindowRect(hWnd: HWND): TRect;
begin
  Result := TRect.Create(0, 0, 0, 0);
  Windows.GetWindowRect(hWnd, Result);
end;

procedure HideWindow(hWnd: HWND);
begin
  Windows.ShowWindow(hWnd, SW_HIDE);
end;

procedure CloseWindow(lpClassName, lpWindowName: LPCWSTR);
begin
  Windows.CloseWindow(Windows.FindWindowW(lpClassName, lpWindowName));
end;

end.

