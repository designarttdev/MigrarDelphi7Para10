object frExcessoes: TfrExcessoes
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Excess'#245'es'
  ClientHeight = 441
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
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
    Width = 761
    Height = 23
    TabOrder = 0
  end
  object edtDepois: TEdit
    Left = 16
    Top = 101
    Width = 761
    Height = 23
    TabOrder = 1
  end
  object btnGravar: TButton
    Left = 315
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Gravar'
    TabOrder = 2
    OnClick = btnGravarClick
  end
  object btnExcluir: TButton
    Left = 491
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 3
    OnClick = btnExcluirClick
  end
  object btnCancelar: TButton
    Left = 403
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 4
    OnClick = btnCancelarClick
  end
  object GrAcesso: TDBGrid
    Left = 16
    Top = 176
    Width = 761
    Height = 249
    DataSource = dmPrincipal.dsTodos
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnCellClick = GrAcessoCellClick
    OnDblClick = GrAcessoDblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ANTES'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DEPOIS'
        Width = 64
        Visible = True
      end>
  end
  object btnInserir: TButton
    Left = 227
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Inserir'
    TabOrder = 6
    OnClick = btnInserirClick
  end
end
