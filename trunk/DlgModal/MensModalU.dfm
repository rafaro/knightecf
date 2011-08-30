object MensModalFrm: TMensModalFrm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'MensModalFrm'
  ClientHeight = 150
  ClientWidth = 651
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMensagem: TPanel
    Left = 0
    Top = 0
    Width = 651
    Height = 150
    Align = alClient
    BevelInner = bvLowered
    BevelWidth = 2
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 614
    ExplicitHeight = 137
    object pnlMensagemCliente: TPanel
      Left = 4
      Top = 4
      Width = 639
      Height = 138
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
      ExplicitWidth = 602
      ExplicitHeight = 125
      object Label11: TLabel
        Left = 8
        Top = 8
        Width = 87
        Height = 13
        Caption = 'Mensagem Cliente'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        Visible = False
      end
      object lblMensagemCliente: TLabel
        Left = 0
        Top = 0
        Width = 639
        Height = 138
        Align = alClient
        Alignment = taCenter
        Caption = 'lblMensagemCliente'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7485192
        Font.Height = -24
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        WordWrap = True
        ExplicitWidth = 222
        ExplicitHeight = 29
      end
    end
    object pnlMensagemOperador: TPanel
      Left = 4
      Top = 4
      Width = 639
      Height = 138
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
      ExplicitWidth = 602
      ExplicitHeight = 125
      object Label10: TLabel
        Left = 0
        Top = 0
        Width = 99
        Height = 13
        Caption = 'Mensagem Operador'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        Visible = False
      end
      object lblMensagemOperador: TLabel
        Left = 0
        Top = 0
        Width = 639
        Height = 138
        Align = alClient
        Alignment = taCenter
        Caption = 'lblMensagemOperador'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7485192
        Font.Height = -24
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        WordWrap = True
        ExplicitWidth = 250
        ExplicitHeight = 29
      end
    end
  end
end
