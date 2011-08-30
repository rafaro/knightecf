object FechamentoFrm: TFechamentoFrm
  Left = 0
  Top = 0
  Caption = 'Fechamento'
  ClientHeight = 379
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PnlFechamento: TPanel
    Left = 0
    Top = 0
    Width = 643
    Height = 379
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
    DesignSize = (
      643
      379)
    object lblTotal: TLabel
      Left = 54
      Top = 5
      Width = 24
      Height = 13
      Caption = 'Total'
    end
    object lblDesconto: TLabel
      Left = 54
      Top = 62
      Width = 46
      Height = 13
      Caption = 'Desconto'
    end
    object grdFormasDePagto: TStringGrid
      Left = 8
      Top = 120
      Width = 400
      Height = 250
      Anchors = [akLeft, akTop, akBottom]
      ColCount = 3
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      ParentFont = False
      TabOrder = 5
      ColWidths = (
        64
        255
        73)
    end
    object btnOk: TButton
      Left = 440
      Top = 240
      Width = 121
      Height = 52
      Align = alCustom
      Caption = '&Ok'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = btnOkClick
    end
    object btnCancelar: TButton
      Left = 440
      Top = 304
      Width = 121
      Height = 52
      Align = alCustom
      Caption = '&Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object edtTotal: TJvCalcEdit
      Left = 54
      Top = 24
      Width = 121
      Height = 32
      ClickKey = 0
      DecimalPlaces = 5
      DisplayFormat = '0.#####'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Anchors = [akLeft, akTop, akBottom]
      ParentFont = False
      ParentShowHint = False
      ShowButton = False
      ShowHint = True
      TabOrder = 8
      DecimalPlacesAlwaysShown = False
      OnKeyDown = edtTotalKeyDown
    end
    object edtDesconto: TJvCalcEdit
      Left = 54
      Top = 80
      Width = 121
      Height = 32
      ClickKey = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowButton = False
      ShowHint = True
      TabOrder = 0
      DecimalPlacesAlwaysShown = False
      OnExit = edtDescontoExit
      OnKeyDown = edtTotalKeyDown
    end
    object edtAPagar: TJvCalcEdit
      Left = 446
      Top = 24
      Width = 121
      Height = 32
      ClickKey = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ShowButton = False
      TabOrder = 1
      DecimalPlacesAlwaysShown = False
      OnKeyDown = edtTotalKeyDown
    end
    object edtPago: TJvCalcEdit
      Left = 446
      Top = 80
      Width = 121
      Height = 32
      ClickKey = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ShowButton = False
      TabOrder = 2
      DecimalPlacesAlwaysShown = False
      OnKeyDown = edtTotalKeyDown
    end
    object edtSaldo: TJvCalcEdit
      Left = 446
      Top = 136
      Width = 121
      Height = 32
      ClickKey = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ShowButton = False
      TabOrder = 3
      DecimalPlacesAlwaysShown = False
      OnKeyDown = edtTotalKeyDown
    end
    object edtValor: TJvCalcEdit
      Left = 446
      Top = 192
      Width = 121
      Height = 32
      ClickKey = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ShowButton = False
      TabOrder = 4
      DecimalPlacesAlwaysShown = False
      OnKeyDown = edtValorKeyDown
      OnKeyPress = edtValorKeyPress
    end
  end
end
