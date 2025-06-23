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
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
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
  object lblContador: TLabel
    Left = 151
    Top = 292
    Width = 314
    Height = 13
    AutoSize = False
    Caption = 'Contador de arquivos alterados'
  end
  object edtDiretorio: TEdit
    Left = 34
    Top = 53
    Width = 496
    Height = 21
    TabOrder = 0
    Text = 'D:\FontesSVN\Mobile\MaisPedRapido'
  end
  object chkSub: TCheckBox
    Left = 34
    Top = 75
    Width = 97
    Height = 17
    Caption = 'Incluir Subpastas'
    TabOrder = 1
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
    HotImageIndex = 1
    ImageIndex = 1
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
  object btnSelecionaPasta: TButton
    Left = 536
    Top = 51
    Width = 75
    Height = 25
    Caption = 'Pasta...'
    TabOrder = 5
    OnClick = btnSelecionaPastaClick
  end
  object btnAdicionar: TButton
    Left = 480
    Top = 286
    Width = 131
    Height = 25
    Caption = '&Adicionar Excess'#245'es'
    HotImageIndex = 0
    ImageIndex = 0
    TabOrder = 6
    OnClick = btnAdicionarClick
  end
  object chkApenasPAS: TCheckBox
    Left = 154
    Top = 75
    Width = 97
    Height = 17
    Caption = 'Apenas ".pas"'
    TabOrder = 7
  end
end
