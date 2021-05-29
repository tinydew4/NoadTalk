unit _fmmain;

{$mode objfpc}{$H+}

{$push}
{$hints off}
{$warn 3123 off}

interface

uses
  Classes, ExtCtrls, Forms, Menus, SysUtils, UniqueInstance, Windows,
  fgl,
  install;

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
begin
  MiAutorun.Checked := install.Installed;
end;

procedure TfmMain.MiAutorunClick(Sender: TObject);
  function GetParams: string;
  begin
    case MiAutorun.Checked of
      False: Result := '/install';
      True: Result := '/uninstall';
    end;
  end;

begin
  Windows.ShellExecute(0, 'runas', PChar(ParamStr(0)), PChar(GetParams), nil, SW_HIDE);
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

