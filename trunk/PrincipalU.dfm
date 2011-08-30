object PrincipalFrm: TPrincipalFrm
  Left = 0
  Top = 0
  Caption = 'PrincipalFrm'
  ClientHeight = 452
  ClientWidth = 786
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mnMnPDV
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCabecalho: TPanel
    Left = 0
    Top = 0
    Width = 786
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    Color = 16381427
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 7485192
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object lblDescricao: TLabel
      Left = 0
      Top = 0
      Width = 786
      Height = 65
      Align = alClient
      ExplicitWidth = 3
      ExplicitHeight = 13
    end
  end
  object PnlRodape: TPanel
    Left = 0
    Top = 329
    Width = 786
    Height = 72
    Align = alBottom
    BevelOuter = bvNone
    Color = 16381427
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 7485192
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object pnlAviso: TPanel
      Left = 0
      Top = 0
      Width = 609
      Height = 72
      Align = alLeft
      BevelOuter = bvNone
      Color = 16381427
      TabOrder = 0
      object edtAviso: TEdit
        Left = 0
        Top = 27
        Width = 609
        Height = 32
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7485192
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
    object edtSubtotal: TJvCalcEdit
      Left = 632
      Top = 24
      Width = 151
      Height = 32
      Alignment = taLeftJustify
      BorderStyle = bsNone
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
    end
  end
  object PnlBusca: TPanel
    Left = 0
    Top = 401
    Width = 786
    Height = 51
    Align = alBottom
    BevelOuter = bvNone
    Color = 16381427
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 7485192
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object edtCliente: TEdit
      Left = 51
      Top = 8
      Width = 400
      Height = 21
      TabOrder = 0
      Text = 'CONSUMIDOR FINAL'
    end
    object btnBuscaCliente: TButton
      Left = 453
      Top = 8
      Width = 27
      Height = 22
      TabOrder = 1
    end
    object brStatus: TStatusBar
      Left = 0
      Top = 32
      Width = 786
      Height = 19
      Panels = <
        item
          Width = 100
        end
        item
          Width = 100
        end
        item
          Width = 50
        end>
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 65
    Width = 786
    Height = 264
    Align = alClient
    BevelOuter = bvNone
    Color = 16381427
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 7485192
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object pnlEntrada: TPanel
      Left = 120
      Top = 0
      Width = 200
      Height = 264
      Align = alLeft
      BevelOuter = bvNone
      Color = 16381427
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object edtQuantidade: TJvCalcEdit
        Left = 46
        Top = 32
        Width = 150
        Height = 32
        Alignment = taLeftJustify
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7485192
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ShowButton = False
        TabOrder = 1
        Value = 1.000000000000000000
        DecimalPlacesAlwaysShown = False
      end
      object edtPrecoTotal: TJvCalcEdit
        Left = 46
        Top = 32
        Width = 150
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
        Visible = False
        DecimalPlacesAlwaysShown = False
      end
      object edtCodigo: TJvCalcEdit
        Left = 46
        Top = 96
        Width = 150
        Height = 32
        Alignment = taLeftJustify
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7485192
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ShowButton = False
        TabOrder = 2
        DecimalPlacesAlwaysShown = False
      end
    end
    object pnlBotoesComando: TPanel
      Left = 0
      Top = 0
      Width = 120
      Height = 264
      Align = alLeft
      BevelOuter = bvNone
      Color = 16381427
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object btnFecharCupom: TButton
        Left = 0
        Top = 0
        Width = 120
        Height = 64
        Align = alTop
        Caption = 'Fechar cupom'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7485192
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnFecharCupomClick
      end
      object btnCancelarCupom: TButton
        Left = 0
        Top = 192
        Width = 120
        Height = 64
        Align = alTop
        Caption = 'Cancelar cupom'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7485192
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object btnProcurarProd: TButton
        Left = 0
        Top = 64
        Width = 120
        Height = 64
        Align = alTop
        Caption = 'Procurar Produto'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7485192
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object btnCancelarItem: TButton
        Left = 0
        Top = 128
        Width = 120
        Height = 64
        Align = alTop
        Caption = 'Cancelar Item'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7485192
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
    end
    object pnlBobina: TPanel
      Left = 320
      Top = 0
      Width = 466
      Height = 264
      Align = alClient
      BevelOuter = bvNone
      Color = 16381427
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object wbBobina: TWebBrowser
        Left = 0
        Top = 0
        Width = 466
        Height = 264
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 472
        ExplicitHeight = 365
        ControlData = {
          4C0000002A300000491B00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object mBobina: TMemo
        Left = 0
        Top = 0
        Width = 466
        Height = 264
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Fixedsys'
        Font.Pitch = fpVariable
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
        Visible = False
        WordWrap = False
      end
    end
  end
  object mnMnPDV: TMainMenu
    Left = 632
    Top = 128
    object MenuFiscal1: TMenuItem
      Caption = 'MENU FISCAL'
    end
    object Operaes1: TMenuItem
      Caption = 'Opera'#231#245'es'
      object Suprimento1: TMenuItem
        Caption = 'Suprimento'
        OnClick = Suprimento1Click
      end
      object Sangria1: TMenuItem
        Caption = 'Sangria'
        OnClick = Sangria1Click
      end
    end
    object Acoes1: TMenuItem
      Caption = 'A'#231#245'es'
      object FecharCupom1: TMenuItem
        Caption = 'Fechar Cupom'
        ShortCut = 113
        OnClick = FecharCupom1Click
      end
      object ProcurarProduto1: TMenuItem
        Caption = 'Procurar Produto'
        ShortCut = 115
        OnClick = ProcurarProduto1Click
      end
      object CancelarItem1: TMenuItem
        Caption = 'Cancelar Item'
        ShortCut = 121
        OnClick = CancelarItem1Click
      end
      object CancelarCupom1: TMenuItem
        Caption = 'Cancelar Cupom'
        ShortCut = 114
        OnClick = CancelarCupom1Click
      end
      object MudaHorriodeVero1: TMenuItem
        Caption = 'Muda Hor'#225'rio de Ver'#227'o'
        OnClick = MudaHorriodeVero1Click
      end
    end
    object TEF1: TMenuItem
      Caption = 'TEF'
      object Administrao1: TMenuItem
        Caption = 'Administra'#231#227'o'
        OnClick = Administrao1Click
      end
    end
  end
  object iniStr: TJvAppIniFileStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    SubStorages = <>
    Left = 456
    Top = 104
  end
  object iniAliq: TJvAppIniFileStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    SubStorages = <>
    Left = 488
    Top = 104
  end
  object cphImpressora: TJvCaesarCipher
    Left = 448
    Top = 176
  end
  object reg: TJvAppRegistryStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    Root = '%NONE%'
    SubStorages = <>
    Left = 568
    Top = 104
  end
end
