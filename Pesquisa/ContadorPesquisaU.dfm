object ContadorPesquisaFrm: TContadorPesquisaFrm
  Left = 0
  Top = 0
  Caption = 'ContadorPesquisaFrm'
  ClientHeight = 349
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object pgrPrincipal: TPageControl
    Left = 0
    Top = 0
    Width = 643
    Height = 330
    ActivePage = tbsPesquisa
    Align = alClient
    TabOrder = 0
    TabPosition = tpBottom
    ExplicitTop = -58
    ExplicitWidth = 538
    ExplicitHeight = 339
    object tbsPesquisa: TTabSheet
      Caption = 'Pesquisa'
      ExplicitWidth = 530
      ExplicitHeight = 313
      object edtPesquisa: TEdit
        Left = 24
        Top = 32
        Width = 417
        Height = 21
        TabOrder = 0
        OnKeyPress = edtPesquisaKeyPress
      end
      object btnPesquisar: TButton
        Left = 446
        Top = 32
        Width = 27
        Height = 22
        TabOrder = 1
        OnClick = btnPesquisarClick
      end
      object grdResultado: TJvDBUltimGrid
        Left = 0
        Top = 66
        Width = 635
        Height = 238
        Align = alBottom
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
        OnKeyPress = grdResultadoKeyPress
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
        Columns = <
          item
            Expanded = False
            FieldName = 'cont_nome'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'cont_fone'
            Width = 425
            Visible = True
          end>
      end
    end
  end
  object stbPrincipal: TStatusBar
    Left = 0
    Top = 330
    Width = 643
    Height = 19
    Panels = <
      item
        Width = 306
      end>
    ExplicitTop = 262
    ExplicitWidth = 538
  end
  object qPesq: TSQLQuery
    Params = <>
    SQL.Strings = (
      
        'SELECT cad_contador.id_contador,cad_contador.cont_nome,cad_conta' +
        'dor.cont_fone '
      'FROM cad_contador'
      'order by cad_contador.cont_nome'
      'limit 200')
    Left = 267
    Top = 3
  end
  object dsPesq: TDataSource
    DataSet = qPesq
    Left = 299
    Top = 3
  end
end
