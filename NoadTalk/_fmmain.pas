unit _fmmain;

{$mode objfpc}{$H+}

{$push}
{$hints off}
{$warn 3123 off}

interface

uses
  Classes, ExtCtrls, Forms, Menus, Registry, SysUtils, UniqueInstance,
  fgl;

type

  TProcList = specialize TFPGList<TProcedure>;

  { TfmMain }

  TfmMain = class(TForm)
    MiAutorun: TMenuItem;
    N1: TMenuItem;
    MiExit: TMenuItem;
    TmHide: TTimer;
    TrayPopup: TPopupMenu;
    TrayIcon: TTrayIcon;
    UniqueInst: TUniqueInstance;
    procedure MiAutorunClick(Sender: TObject);
    procedure MiExitClick(Sender: TObject);
    procedure TmHideTimer(Sender: TObject);
    procedure TrayPopupPopup(Sender: TObject);
  private
  public
    procedure AfterConstruction; override;

    procedure RegisterProcedure(AProc: TProcedure);
  end;

var
  fmMain: TfmMain;

implementation

var
  GProcList: TProcList;

{$R *.frm}

{ TfmMain }

procedure TfmMain.AfterConstruction;
begin
  inherited AfterConstruction;

  TrayIcon.Hint := Application.Title;
  TrayIcon.Icon.Assign(Application.Icon);
end;

procedure TfmMain.RegisterProcedure(AProc: TProcedure);
begin
  if GProcList.IndexOf(AProc) >= 0 then Exit;
  GProcList.Add(AProc);
end;

procedure TfmMain.TrayPopupPopup(Sender: TObject);
var
  Reg: TRegistry;
  sName: unicodestring;
begin
  MiAutorun.Checked := False;

  Reg := TRegistry.Create(KEY_WOW64_32KEY or KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False) then Exit;

    for sName in Reg.GetValueNames do begin
      if Reg.ReadString(sName) = unicodestring(ParamStr(0)) then begin
        MiAutorun.Checked := True;
        Break;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TfmMain.MiAutorunClick(Sender: TObject);
var
  Reg: TRegistry;
  sName: unicodestring;
begin
  Reg := TRegistry.Create(KEY_WOW64_32KEY or KEY_ALL_ACCESS);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False) then Exit;

    if MiAutorun.Checked then begin
      for sName in Reg.GetValueNames do begin
        if Reg.ReadString(sName) = unicodestring(ParamStr(0)) then begin
          Reg.DeleteValue(sName);
        end;
      end;
    end else begin
      Reg.WriteString('NoadTalk', ParamStr(0));
    end;
  finally
    Reg.Free;
  end;
end;

procedure TfmMain.MiExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.TmHideTimer(Sender: TObject);
var
  Proc: TProcedure;
begin
  for Proc in GProcList do begin
    Proc;
  end;
end;

Initialization
  GProcList := TProcList.Create;

Finalization
  GProcList.Free;

end.

{$pop}

