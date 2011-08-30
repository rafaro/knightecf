object SelecaoImpressoraFrm: TSelecaoImpressoraFrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Impressoras fiscais'
  ClientHeight = 233
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grdImpFiscais: TStringGrid
    Left = 0
    Top = 0
    Width = 371
    Height = 233
    Align = alClient
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
    TabOrder = 0
    OnKeyPress = grdImpFiscaisKeyPress
    ExplicitWidth = 355
    ExplicitHeight = 251
    ColWidths = (
      16
      348)
  end
end
