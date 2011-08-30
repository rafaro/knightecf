object ProdutoPesquisaFrm: TProdutoPesquisaFrm
  Left = 0
  Top = 0
  ClientHeight = 335
  ClientWidth = 808
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pgcPrincipal: TPageControl
    Left = 0
    Top = 41
    Width = 808
    Height = 275
    ActivePage = tbsPesquisa
    Align = alClient
    TabOrder = 0
    TabPosition = tpBottom
    object tbsPesquisa: TTabSheet
      Caption = 'Pesquisa'
      object oPesq: TEdit
        Left = 24
        Top = 32
        Width = 417
        Height = 21
        TabOrder = 0
      end
      object btnPesquisa: TButton
        Left = 446
        Top = 32
        Width = 27
        Height = 22
        TabOrder = 1
      end
      object grdProdutos: TJvDBUltimGrid
        Left = 0
        Top = 72
        Width = 800
        Height = 177
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataSource = dsPesq
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
        Columns = <
          item
            Expanded = False
            FieldName = 'pro_codigo'
            Width = 107
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'pro_descricao'
            Width = 367
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'und_sigla'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'cst_cod_cst'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'pro_preco_venda'
            Width = 83
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'indicadorat'
            Width = 44
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'pro_produzido_desc'
            Width = 47
            Visible = True
          end>
      end
    end
  end
  object stbRodape: TStatusBar
    Left = 0
    Top = 316
    Width = 808
    Height = 19
    Panels = <
      item
        Width = 386
      end>
  end
  object pnlPrincipal: TPanel
    Left = 0
    Top = 0
    Width = 808
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 16381427
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 7485192
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object rdbDescricao: TRadioButton
      Left = 88
      Top = 8
      Width = 135
      Height = 20
      Alignment = taLeftJustify
      Caption = 'Descri'#231#227'o'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rdbCodigo: TRadioButton
      Left = 12
      Top = 7
      Width = 69
      Height = 20
      Alignment = taLeftJustify
      Caption = 'C'#243'digo'
      TabOrder = 1
    end
  end
  object dsPesq: TDataSource
    Left = 299
    Top = 3
  end
  object qryPesq: TSQLQuery
    Params = <>
    Left = 256
    Top = 32
  end
end
