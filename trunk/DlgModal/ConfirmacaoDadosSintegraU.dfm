object ConfirmacaoDadosSintegraFrm: TConfirmacaoDadosSintegraFrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Confirmar dados para gera'#231#227'o do sintegra'
  ClientHeight = 278
  ClientWidth = 582
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlPrincipal: TPanel
    Left = 0
    Top = 0
    Width = 582
    Height = 278
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
    ExplicitTop = -8
    ExplicitWidth = 581
    ExplicitHeight = 289
    object btnCancelar: TButton
      Left = 456
      Top = 221
      Width = 121
      Height = 52
      Align = alCustom
      Caption = '&Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ModalResult = 2
      ParentFont = False
      TabOrder = 0
    end
    object btnOk: TButton
      Left = 320
      Top = 221
      Width = 121
      Height = 52
      Align = alCustom
      Caption = '&Ok'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7485192
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 1
    end
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 582
      Height = 120
      Align = alTop
      Caption = ' Cabe'#231'alho do Arquivo '
      TabOrder = 2
      ExplicitWidth = 581
      object Label3: TLabel
        Left = 286
        Top = 23
        Width = 211
        Height = 13
        Caption = 'C'#243'digo de Identifica'#231#227'o do Conv'#234'nio'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 3
        Top = 23
        Width = 207
        Height = 13
        Caption = 'Natureza das Opera'#231#245'es Informadas'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 3
        Top = 68
        Width = 124
        Height = 13
        Caption = 'Finalidade do Arquivo'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cmbCodIdentConv: TComboBox
        Left = 286
        Top = 39
        Width = 245
        Height = 21
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 2
        ParentFont = False
        TabOrder = 0
        Text = '3 - Conv'#234'nio 57/95 Alt. 76/03'
        Items.Strings = (
          '1 - Conv'#234'nio 57/95 Vers'#227'o 31/99 Alt. 30/02'
          '2 - Conv'#234'nio 57/95 Vers'#227'o 69/02 Alt. 142/02  '
          '3 - Conv'#234'nio 57/95 Alt. 76/03')
      end
      object cmbNatOpInf: TComboBox
        Left = 3
        Top = 39
        Width = 282
        Height = 21
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 2
        ParentFont = False
        TabOrder = 1
        Text = '3 - Totalidade das opera'#231#245'es do informante'
        Items.Strings = (
          
            '1 - Interestaduais - Somente opera'#231#245'es sujeitas ao regime de Sub' +
            'stitui'#231#227'o Tribut'#225'ria'
          
            '2 - Interestaduais - Opera'#231#245'es com ou sem Substitui'#231#227'o Tribut'#225'ri' +
            'a'
          '3 - Totalidade das opera'#231#245'es do informante')
      end
      object cmbFinalidadeArq: TComboBox
        Left = 3
        Top = 84
        Width = 245
        Height = 21
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 2
        Text = '1 - Normal'
        Items.Strings = (
          '1 - Normal'
          '2 - Retifica'#231#227'o Total de Arquivo'
          '5 - Desfazimento de Arquivo')
      end
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 120
      Width = 582
      Height = 85
      Align = alTop
      Caption = ' Dados Complementares '
      TabOrder = 3
      ExplicitWidth = 581
      object Label6: TLabel
        Left = 9
        Top = 26
        Width = 74
        Height = 13
        Caption = 'Respons'#225'vel'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtResponsavel: TEdit
        Left = 8
        Top = 42
        Width = 241
        Height = 21
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 28
        ParentFont = False
        TabOrder = 0
      end
      object GroupBox3: TGroupBox
        Left = 256
        Top = 7
        Width = 273
        Height = 74
        Caption = ' Per'#237'odo '
        TabOrder = 1
        Visible = False
        object edtDtFim: TDateTimePicker
          Left = 152
          Top = 32
          Width = 108
          Height = 21
          Date = 40378.647931921290000000
          Time = 40378.647931921290000000
          TabOrder = 0
        end
        object edtDtInicio: TDateTimePicker
          Left = 16
          Top = 32
          Width = 108
          Height = 21
          Date = 40378.647932731480000000
          Time = 40378.647932731480000000
          TabOrder = 1
        end
      end
    end
  end
end
