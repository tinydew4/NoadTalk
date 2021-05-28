object fmMain: TfmMain
  Left = 0
  Height = 30
  Top = 0
  Width = 40
  BorderStyle = bsDialog
  DesignTimePPI = 240
  LCLVersion = '7.4'
  object TrayIcon: TTrayIcon
    PopUpMenu = TrayPopup
    Visible = True
    Left = 8
    Top = 8
  end
  object TrayPopup: TPopupMenu
    OnPopup = TrayPopupPopup
    Left = 88
    Top = 8
    object MiAutorun: TMenuItem
      Caption = '&Autorun'
      OnClick = MiAutorunClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MiExit: TMenuItem
      Caption = 'E&xit'
      OnClick = MiExitClick
    end
  end
  object TmHide: TTimer
    Interval = 100
    OnTimer = TmHideTimer
    OnStartTimer = TmHideTimer
    Left = 168
    Top = 8
  end
  object UniqueInst: TUniqueInstance
    Enabled = True
    Identifier = '__NOAD_TALK__'
    Left = 8
    Top = 3
  end
end
