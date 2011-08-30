unit FechamentoU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, Mask, JvExMask, JvToolEdit, JvBaseEdits,
  UtilsU;

type
  TFechamentoFrm = class(TForm)
    PnlFechamento: TPanel;
    grdFormasDePagto: TStringGrid;
    btnOk: TButton;
    btnCancelar: TButton;
    edtTotal: TJvCalcEdit;
    lblTotal: TLabel;
    edtDesconto: TJvCalcEdit;
    lblDesconto: TLabel;
    edtAPagar: TJvCalcEdit;
    edtPago: TJvCalcEdit;
    edtSaldo: TJvCalcEdit;
    edtValor: TJvCalcEdit;
    procedure btnOkClick(Sender: TObject);
    procedure edtDescontoExit(Sender: TObject);
    procedure edtTotalKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtValorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtValorKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Pagto: TFormaDePagto;
    UsouTEF: Boolean;
    procedure AtualizarTotais;
    procedure BloqueiarCampos;
    procedure CarregarFormaDePagto;
    procedure EfetuarPagamento;
    procedure HabilitarCampos;
    procedure SelecionarEditValor;
  public
    PodeFinalizarCupom: Boolean;
  end;

var
  FechamentoFrm: TFechamentoFrm;

implementation

uses
  EcfU, ACBrECF, knight, ACBrDevice, ACBrTEFDClass;

{$R *.dfm}

procedure TFechamentoFrm.AtualizarTotais;
begin
  edtAPagar.Value := EcfDm.ECF.Device.Subtotal;
  //if  false then
  if EcfDm.ECF.Device.Estado = estlivre then
  begin
    edtPago.Value := edtAPagar.Value;
    edtDesconto.Enabled := false;
  end
  else
  begin
    edtPago.Value := EcfDm.ECF.Device.TotalPago;
  end;

  edtSaldo.Value := edtAPagar.Value - edtPago.Value;
  //edtSaldo.Color := clBlack;
  edtSaldo.Font.Color := clBlack;
  EcfDm.Cupom.Troco := 0;
  if edtSaldo.Value < 0 then
  begin
    edtSaldo.Value := edtSaldo.Value * -1;
    edtSaldo.Font.Color := clRed;
    EcfDm.Cupom.Troco := edtSaldo.Value;
  end;
  EcfDm.Cupom.Total := edtTotal.Value;
  EcfDm.Cupom.Desconto := edtDesconto.Value;
  EcfDm.Cupom.GravarTbl;
  BloqueiarCampos;
end;

procedure TFechamentoFrm.BloqueiarCampos;
var
  nSaldo : Currency;
  impEst : TACBrECFEstado;
begin
  nSaldo := edtAPagar.Value - edtPago.Value;
  impEst := EcfDm.ECF.Device.Estado;
  //cls.oMsg.erroOK('estado:'+uprincipal.ECFEstados[impEst]);
  edtDesconto.Enabled := (impEst<>estPagamento) AND (impEst<>estLivre) ;
  edtValor.Enabled  :=  nSaldo > 0;
  btnOk.Enabled     :=  nSaldo <= 0;
end;

procedure TFechamentoFrm.btnOkClick(Sender: TObject);
begin
  //FrmPrincipal.impECF.Fecha1Cupom(FrmPrincipal.cECFMensPromo);
  if (EcfDm.ECF.Device.Estado <> estlivre) or (EcfDm.TEF.TiposTEF = gpNenhum) then
  begin
    EcfDm.ECF.FecharCupom();
    if UsouTEF then
    begin
      EcfDm.TEF.Device.ImprimirTransacoesPendentes;
      EcfDm.TEF.Device.ConfirmarTransacoesPendentes;
    end;
  end;

  if EcfDm.ECF.MovimentaEstoque then
  begin
    EcfDm.Cupom.AlimentarEstoque;
  end;
  PodeFinalizarCupom := true;
  Close;
end;

procedure TFechamentoFrm.FormCreate(Sender: TObject);
begin
  CarregarFormaDePagto;
end;

procedure TFechamentoFrm.CarregarFormaDePagto;
var i : integer;
    nTotal : integer;
begin
  { Bematech e NaoFiscal permitem cadastrar formas de Pagamento dinamicamente }
  if (EcfDm.ECF.Device.Modelo in [ecfBematech, ecfNaoFiscal]) then
    EcfDm.ECF.Device.CarregaFormasPagamento
  else
    EcfDm.ECF.Device.AchaFPGIndice('') ;  { força carregar, se ainda nao o fez }

  nTotal := EcfDm.ECF.Device.FormasPagamento.Count -1;

  grdFormasDePagto.RowCount := nTotal +2;
  grdFormasDePagto.Cells[0,0] :='código';
  grdFormasDePagto.Cells[1,0] :='Pagamento';
  grdFormasDePagto.Cells[2,0] :='Valor';

  for i := 0 to nTotal do
  begin
    //mmFormasPagto.Lines.Add( FormasPagamento[i].Indice+' -> '+
    //      FormasPagamento[i].Descricao+' - '+IfThen(
    //      FormasPagamento[i].PermiteVinculado,'v',''));
    grdFormasDePagto.Cells[0,i+1] := EcfDm.ECF.Device.FormasPagamento[i].Indice;
    grdFormasDePagto.Cells[1,i+1] := EcfDm.ECF.Device.FormasPagamento[i].Descricao;
    grdFormasDePagto.Cells[2,i+1] := '0,00';
  end;
end;

procedure TFechamentoFrm.edtDescontoExit(Sender: TObject);
var Desconto: Double;
begin
  Desconto := edtDesconto.Value;
  if Desconto > 0 then
  begin
    if  Knt.UserDlg.ConfirmationYesNo('Deseja conceder desconto de ' + edtDesconto.Text + '?') then
    begin
      EcfDm.ECF.Device.SubtotalizaCupom(Desconto * -1);
    end
    else
    begin
      edtDesconto.SetFocus;
    end;
  end
  else
  begin
    EcfDm.ECF.Device.SubtotalizaCupom();
  end;
  AtualizarTotais;

  edtValor.SetFocus;
end;

procedure TFechamentoFrm.edtTotalKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
end;

procedure TFechamentoFrm.edtValorKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
var nPosicao : integer;
begin

  case Key of
    VK_UP :
    begin
      //SelectedRowCount := SelectedRowCount + 1;
      //SelectCells(SelectedColCount + 1,SelectedRowCount + 1,SelectedColCount + 1,SelectedRowCount + 1);
      nPosicao := grdFormasDePagto.Row -1;
      if nPosicao >= 1 then
        grdFormasDePagto.Row := nPosicao;
      Key := 0;
      SelecionarEditValor;
    end;
    VK_DOWN :
    begin
      //SelectCells(SelectedColCount + 1,SelectedRowCount + 1,SelectedColCount + 1,SelectedRowCount + 1);
      nPosicao := grdFormasDePagto.Row + 1;
      if nPosicao < grdFormasDePagto.RowCount then
        grdFormasDePagto.Row := nPosicao;
      Key := 0;
      SelecionarEditValor;
    end;
  end;
end;

procedure TFechamentoFrm.edtValorKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    EfetuarPagamento;
    edtValor.Value := 0;
    Key := #0;
    SelecionarEditValor;
  end;
end;

procedure TFechamentoFrm.EfetuarPagamento;
var
  ValorPagto: Double;
  SelLinha: Integer;
  CodPagto: String;
  TEFOk: boolean;
begin
  if edtValor.Value > 0 then
  begin
    TEFOk := false;
    SelLinha := grdFormasDePagto.Row;
    CodPagto := grdFormasDePagto.Cells[0,SelLinha];

    Pagto.buscarPorDescricao(grdFormasDePagto.Cells[1, SelLinha]);
    if 1 > 0 then//oPagto.nID > 0 then
    begin
      case Pagto.TEF of
        0: TEFOk := true;
        1:
        begin
          //FrmPrincipal.ativaTEF;
          TEFOk :=  EcfDm.TEF.Device.CRT(edtValor.Value, CodPagto, EcfDm.ECF.Device.NumCOO);
          UsouTEF := true;
        end;
        2:
        begin
          //FrmPrincipal.ativaTEF;
          TEFOk := EcfDm.TEF.Device.CHQ(edtValor.Value, CodPagto, EcfDm.ECF.Device.NumCOO);
          UsouTEF := true;
        end;
      end;

      if TEFOk then
      begin
        if EcfDm.Cupom.GravarPagamento(Pagto.ID, edtValor.Value,
          EcfDm.ECF.Device.NumCOO, EcfDm.ECF.Device.NumCCF,
          EcfDm.ECF.Device.NumGNF) then
        begin
          if Pagto.TEF <= 0 then
          begin
            EcfDm.ECF.Device.EfetuaPagamento(CodPagto, edtValor.Value );
          end
          else
          begin
            EcfDm.TEF.Device.BloquearMouseTeclado(false);
          end;
          grdFormasDePagto.Cells[2, SelLinha] := FormatFloat('0.00',
            StrToFloat(grdFormasDePagto.Cells[2, SelLinha]) + edtValor.Value);
          AtualizarTotais;
        end;
      end;
    end
    else
    begin
      knt.UserDlg.ErrorOK('Forma de pagamento não está cadastrada no sistema.');
    end;
  end
  else
  begin
    knt.UserDlg.ErrorOK('O valor do pagamento tem que ser maior que 0.');
  end;
end;

procedure TFechamentoFrm.FormShow(Sender: TObject);
var i : integer;
begin
  for i := 0 to ComponentCount -1 do
    if Components[i] is TEdit then
      TEdit(Components[i]).Visible := false ;
  edtDesconto.SetFocus;
  edtTotal.Value := EcfDm.ECF.Device.Subtotal;
  HabilitarCampos;
  AtualizarTotais;
  //configuraCamposDigitacao;
  UsouTEF := false;
end;

procedure TFechamentoFrm.HabilitarCampos;
begin
  edtDesconto.Enabled := true;
  edtValor.Enabled := true;
  btnOk.Enabled := true;
end;

procedure TFechamentoFrm.SelecionarEditValor;
begin
  //edtValor.SelStart:=0;
  //edtValor.SelLength := 100;
  edtTotal.SetFocus;
  if edtValor.Enabled then
  begin
    edtValor.SetFocus;
  end;
end;

end.
