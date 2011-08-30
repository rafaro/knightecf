object MovimentacaoCaixaFrm: TMovimentacaoCaixaFrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'MovimentacaoCaixaFrm'
  ClientHeight = 377
  ClientWidth = 568
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlPrincipal: TPanel
    Left = 0
    Top = 0
    Width = 568
    Height = 377
    Align = alClient
    BevelOuter = bvNone
    Color = 16381427
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 7485192
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object grdFormasDePagto: TStringGrid
      Left = 8
      Top = 80
      Width = 400
      Height = 290
      ColCount = 2
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      ParentFont = False
      TabOrder = 1
      ColWidths = (
        64
        331)
    end
    object btnFechar: TButton
      Left = 440
      Top = 16
      Width = 121
      Height = 52
      Align = alCustom
      Caption = '&Fechar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnFecharClick
    end
    object edtValor: TJvCalcEdit
      Left = 14
      Top = 32
      Width = 121
      Height = 32
      Alignment = taLeftJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ShowButton = False
      TabOrder = 0
      DecimalPlacesAlwaysShown = False
      OnKeyDown = edtValorKeyDown
      OnKeyPress = edtValorKeyPress
    end
  end
end
