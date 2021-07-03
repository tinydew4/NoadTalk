unit kakaotalk;

{$mode ObjFPC}{$H+}

interface

uses
  Windows,
  _fmMain, helper;

implementation

procedure StretchView(hParent, hView: HWND; nMarginHeight: longint);
var
  rtParent: TRect;
begin
  rtParent := helper.GetWindowRect(hParent);
  if helper.GetWindowRect(hView).Height = rtParent.Height - nMarginHeight then Exit;

  Windows.SetWindowPos(hView, HWND_BOTTOM, 0, 0, rtParent.Width, rtParent.Height - nMarginHeight, SWP_NOMOVE);
end;

procedure StretchView(hParent: HWND; nIDDlgItem, nMarginHeight: longint);
begin
  StretchView(hParent, GetDlgItem(hParent, nIDDlgItem), nMarginHeight);
end;

procedure Execute;
const
  LockView = $B7;
  MainView = $84;
  sWindowTextList: array of unicodestring = (
    '카카오톡',
    'Kakaotalk',
    'カカオトーク'
  );
var
  sWindowText: unicodestring;
  hTalk: HWND;
begin
  for sWindowText in sWindowTextList do begin
    hTalk := FindWindowW('EVA_Window_Dblclk', PWideChar(sWindowText));
    if hTalk = 0 then Continue;

    helper.HideWindow(FindWindowExW(hTalk, 0, 'BannerAdWnd', nil));
    StretchView(hTalk, LockView, 2);
    StretchView(hTalk, MainView, 62);
  end;
end;

Initialization
  fmMain.RegisterProcedure(@Execute);

end.

