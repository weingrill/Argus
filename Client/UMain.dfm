object Form1: TForm1
  Left = 628
  Top = 182
  Width = 359
  Height = 360
  Caption = 'Argus Client'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 41
    Width = 351
    Height = 292
    Align = alClient
    Stretch = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 351
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 12
      Top = 12
      Width = 22
      Height = 13
      Caption = 'Host'
    end
    object BGet: TButton
      Left = 196
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Get'
      TabOrder = 0
      OnClick = BGetClick
    end
    object EHost: TEdit
      Left = 44
      Top = 8
      Width = 85
      Height = 21
      TabOrder = 1
      Text = '192.168.99.33'
    end
  end
  object IdTCPClient: TIdTCPClient
    Host = '127.0.0.1'
    Port = 12275
    Left = 312
    Top = 4
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 156
    Top = 8
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 280
    Top = 4
  end
end
