object frPrincipal: TfrPrincipal
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Convers'#227'o'
  ClientHeight = 345
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblOrigem: TLabel
    Left = 34
    Top = 34
    Width = 34
    Height = 13
    Caption = 'Origem'
  end
  object lblArquivos: TLabel
    Left = 34
    Top = 98
    Width = 42
    Height = 13
    Caption = 'Arquivos'
  end
  object edtDiretorio: TEdit
    Left = 34
    Top = 53
    Width = 321
    Height = 21
    TabOrder = 0
    Text = 'D:\FontesSVN\Mobile\MaisPedRapido'
  end
  object chkSub: TCheckBox
    Left = 370
    Top = 55
    Width = 97
    Height = 17
    Caption = 'Incluir Subpastas'
    TabOrder = 1
    Visible = False
  end
  object memLista: TMemo
    Left = 34
    Top = 117
    Width = 577
    Height = 166
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object btnListar: TButton
    Left = 34
    Top = 286
    Width = 105
    Height = 25
    Caption = '&Converter'
    TabOrder = 3
    OnClick = btnListarClick
  end
  object memoArquivos: TMemo
    Left = 232
    Top = 150
    Width = 185
    Height = 89
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 4
    Visible = False
  end
  object vPanelAnimation: TPanel
    Left = 370
    Top = 289
    Width = 185
    Height = 41
    Caption = 'vPanelAnimation'
    ShowCaption = False
    TabOrder = 5
    Visible = False
    object vIndicator: TActivityIndicator
      Left = 80
      Top = 8
    end
  end
end
