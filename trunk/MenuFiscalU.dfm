object MenuFiscalFrm: TMenuFiscalFrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Menu fiscal'
  ClientHeight = 211
  ClientWidth = 758
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlSelecao: TPanel
    Left = 0
    Top = 0
    Width = 758
    Height = 121
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
    object btnLeituraX: TButton
      Left = 0
      Top = 0
      Width = 150
      Height = 40
      Hint = 'Leitura X'
      Align = alCustom
      Caption = 'LX'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnLeituraXClick
    end
    object btnLeituraMemoriaFiscalCompleta: TButton
      Left = 0
      Top = 40
      Width = 150
      Height = 40
      Hint = 'Leitura da Mem'#243'ria Fiscal Completa'
      Align = alCustom
      Caption = 'LMFC'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnLeituraMemoriaFiscalCompletaClick
    end
    object btnCancelaCupom: TButton
      Left = 608
      Top = 40
      Width = 150
      Height = 40
      Align = alCustom
      Caption = 'Redu'#231#227'oZ'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnCancelaCupomClick
    end
    object btnTabProd: TButton
      Left = 152
      Top = 0
      Width = 150
      Height = 40
      Hint = 'tabela de produtos'
      Align = alCustom
      Caption = 'Tab. Prod.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnTabProdClick
    end
    object btnLeituraMemoriaFiscalSimples: TButton
      Left = 0
      Top = 80
      Width = 150
      Height = 40
      Hint = 'Leitura da Mem'#243'ria Fiscal Simples'
      Align = alCustom
      Caption = 'LMFS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = btnLeituraMemoriaFiscalSimplesClick
    end
    object btnEspelhoMFD: TButton
      Left = 152
      Top = 40
      Width = 150
      Height = 40
      Hint = 'Espelho MFD'
      Align = alCustom
      Caption = 'Espelho MFD'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = btnEspelhoMFDClick
    end
    object btnArqMFD: TButton
      Left = 152
      Top = 80
      Width = 150
      Height = 40
      Hint = 'Arq. MFD'
      Align = alCustom
      Caption = 'Arq. MFD'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = btnArqMFDClick
    end
    object btnEstoque: TButton
      Left = 304
      Top = 0
      Width = 150
      Height = 40
      Hint = 'Estoque'
      Align = alCustom
      Caption = 'Estoque'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = btnEstoqueClick
    end
    object btnMovimentoPorECF: TButton
      Left = 304
      Top = 40
      Width = 150
      Height = 40
      Hint = 'Estoque'
      Align = alCustom
      Caption = 'Movimento por ECF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = btnMovimentoPorECFClick
    end
    object btnMeiosDePagto: TButton
      Left = 608
      Top = 0
      Width = 150
      Height = 40
      Hint = 'Meios de Pagamento'
      Align = alCustom
      Caption = 'Meios de Pagto.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnClick = btnMeiosDePagtoClick
    end
    object btnVendasPeriodo: TButton
      Left = 456
      Top = 40
      Width = 150
      Height = 40
      Hint = 'Vendas do Per'#237'odo'
      Align = alCustom
      Caption = 'Vendas do Per'#237'odo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      OnClick = btnVendasPeriodoClick
    end
    object btnLeReducao: TButton
      Left = 671
      Top = 86
      Width = 73
      Height = 40
      Align = alCustom
      Caption = 'l'#234' Redu'#231#227'oZ'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
      OnClick = btnLeReducaoClick
    end
    object btnDAVEmitidos: TButton
      Left = 455
      Top = 0
      Width = 150
      Height = 40
      Hint = 'Vendas do Per'#237'odo'
      Align = alCustom
      Caption = 'DAV Emitidos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
      OnClick = btnDAVEmitidosClick
    end
    object btnIdentificacaoPAFECF: TButton
      Left = 303
      Top = 80
      Width = 173
      Height = 40
      Hint = 'Vendas do Per'#237'odo'
      Align = alCustom
      Caption = 'Identifica'#231#227'o do PAF-ECF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
      OnClick = btnIdentificacaoPAFECFClick
    end
    object btnTabIndiceTecProd: TButton
      Left = 477
      Top = 80
      Width = 188
      Height = 40
      Hint = 'Meios de Pagamento'
      Align = alCustom
      Caption = 'Tab. '#205'ndice T'#233'cnico Produ'#231#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 14
      OnClick = btnTabIndiceTecProdClick
    end
  end
  object pnlFiltro: TPanel
    Left = 0
    Top = 121
    Width = 758
    Height = 90
    Align = alClient
    BevelOuter = bvNone
    Color = 16381427
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 7485192
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object pgrPeriodo: TPageControl
      Left = 0
      Top = 0
      Width = 282
      Height = 90
      ActivePage = pgCOO
      Align = alLeft
      TabOrder = 0
      object pgData: TTabSheet
        Caption = 'Data'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label4: TLabel
          Left = 128
          Top = 28
          Width = 18
          Height = 13
          Caption = '  '#224'  '
          Transparent = True
        end
        object edtDtInicio: TDateTimePicker
          Left = 16
          Top = 24
          Width = 108
          Height = 21
          Date = 40378.391057418980000000
          Time = 40378.391057418980000000
          TabOrder = 0
        end
        object edtDtFim: TDateTimePicker
          Left = 152
          Top = 24
          Width = 108
          Height = 21
          Date = 40378.391058113430000000
          Time = 40378.391058113430000000
          TabOrder = 1
        end
      end
      object pgCRZ: TTabSheet
        Caption = 'CRZ'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label1: TLabel
          Left = 128
          Top = 28
          Width = 18
          Height = 13
          Caption = '  '#224'  '
          Transparent = True
        end
        object edtCRZInicio: TEdit
          Left = 16
          Top = 24
          Width = 54
          Height = 21
          TabOrder = 0
          Text = '0'
        end
        object edtCRZFim: TEdit
          Left = 152
          Top = 24
          Width = 54
          Height = 21
          TabOrder = 1
          Text = '0'
        end
      end
      object pgCOO: TTabSheet
        Caption = 'COO'
        object Label2: TLabel
          Left = 128
          Top = 28
          Width = 18
          Height = 13
          Caption = '  '#224'  '
          Transparent = True
        end
        object edtCOOInicio: TEdit
          Left = 16
          Top = 24
          Width = 54
          Height = 21
          TabOrder = 0
          Text = '0'
        end
        object edtCOOFim: TEdit
          Left = 152
          Top = 24
          Width = 54
          Height = 21
          TabOrder = 1
          Text = '0'
        end
      end
    end
    object rdGrpSaida: TRadioGroup
      Left = 288
      Top = 24
      Width = 73
      Height = 65
      Caption = 'Sa'#237'da'
      ItemIndex = 0
      Items.Strings = (
        'ECF'
        'Arquivo')
      ParentBackground = False
      TabOrder = 1
      OnClick = rdGrpSaidaClick
    end
    object edtArquivo: TEdit
      Left = 368
      Top = 48
      Width = 376
      Height = 21
      TabOrder = 2
    end
  end
end
