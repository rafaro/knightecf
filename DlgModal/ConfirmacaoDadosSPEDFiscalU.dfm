object ConfirmacaoDadosSPEDFiscalFrm: TConfirmacaoDadosSPEDFiscalFrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Confirma'#231#227'o de dados para gera'#231#227'o do SPED'
  ClientHeight = 235
  ClientWidth = 432
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
    Width = 432
    Height = 235
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
    object btnCancelar: TButton
      Left = 304
      Top = 173
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
      Left = 168
      Top = 173
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
    object rdGrpTipoArquivo: TRadioGroup
      Left = 8
      Top = 16
      Width = 145
      Height = 41
      Caption = 'Arquivo'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Original'
        'Substituto')
      ParentBackground = False
      TabOrder = 2
    end
    object btnBuscaCedente: TButton
      Left = 308
      Top = 145
      Width = 27
      Height = 22
      TabOrder = 3
      OnClick = btnBuscaCedenteClick
    end
    object rdGrpPerfilArqFiscal: TRadioGroup
      Left = 168
      Top = 16
      Width = 145
      Height = 41
      Caption = 'Perfil Arquivo Fiscal'
      Columns = 3
      ItemIndex = 0
      Items.Strings = (
        'A'
        'B'
        'C')
      ParentBackground = False
      TabOrder = 5
    end
    object rdGrpAtividade: TRadioGroup
      Left = 8
      Top = 64
      Width = 145
      Height = 57
      Caption = 'Atividade'
      ItemIndex = 0
      Items.Strings = (
        'Industrial ou Equiparado'
        'Outros')
      ParentBackground = False
      TabOrder = 6
    end
    object edtContador: TLabeledEdit
      Left = 8
      Top = 146
      Width = 294
      Height = 21
      EditLabel.Width = 43
      EditLabel.Height = 13
      EditLabel.BiDiMode = bdLeftToRight
      EditLabel.Caption = 'Contador'
      EditLabel.ParentBiDiMode = False
      ReadOnly = True
      TabOrder = 4
    end
  end
end
