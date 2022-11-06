object frExcessoes: TfrExcessoes
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Excess'#245'es'
  ClientHeight = 441
  ClientWidth = 489
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object lblAnteriorE: TLabel
    Left = 16
    Top = 16
    Width = 43
    Height = 15
    Caption = 'Anterior'
  end
  object lblDepoisE: TLabel
    Left = 16
    Top = 80
    Width = 36
    Height = 15
    Caption = 'Depois'
  end
  object edtAnterior: TEdit
    Left = 16
    Top = 37
    Width = 457
    Height = 23
    TabOrder = 0
  end
  object edtDepois: TEdit
    Left = 16
    Top = 101
    Width = 457
    Height = 23
    TabOrder = 1
  end
  object btnGravar: TButton
    Left = 224
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Gravar'
    TabOrder = 2
  end
  object btnExcluir: TButton
    Left = 398
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 3
  end
  object btnCancelar: TButton
    Left = 311
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 4
  end
  object GrAcesso: TDBGrid
    Left = 16
    Top = 176
    Width = 457
    Height = 249
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
end
