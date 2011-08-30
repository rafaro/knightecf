unit MovimentacaoCaixaU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, Mask, JvExMask, JvToolEdit, JvBaseEdits,
  UtilsU;

type
  TMovimentacaoCaixaFrm = class(TForm)
    pnlPrincipal: TPanel;
    grdFormasDePagto: TStringGrid;
    btnFechar: TButton;
    edtValor: TJvCalcEdit;
    procedure btnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtValorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtValorKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FTipoMovimentacao: Integer;
    Pagto: TFormaDePagto;
    { Private declarations }
  public
    procedure CarregarFormaDePagto;
    function MovimentarCaixa: Integer;
    property TipoMovimentacao: Integer read FTipoMovimentacao write
        FTipoMovimentacao;
    { Public declarations }
  end;

var
  MovimentacaoCaixaFrm: TMovimentacaoCaixaFrm;

implementation

uses
  EcfU, ACBrDevice, ACBrECF, knight, PrincipalU;

{$R *.dfm}

procedure TMovimentacaoCaixaFrm.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TMovimentacaoCaixaFrm.FormCreate(Sender: TObject);
begin
  CarregarFormaDePagto;
  Pagto := TFormaDePagto.Create;
end;

procedure TMovimentacaoCaixaFrm.CarregarFormaDePagto;
var i : integer;
    nTotal : integer;
begin
  with EcfDm.ECF.Device do
  begin
     { Bematech e NaoFiscal permitem cadastrar formas de Pagamento dinamicamente }
     if (Modelo in [ecfBematech, ecfNaoFiscal])then
        CarregaFormasPagamento
     else
        AchaFPGIndice('') ;  { força carregar, se ainda nao o fez }

     nTotal := FormasPagamento.Count -1;

     grdFormasDePagto.RowCount := nTotal +2;
     grdFormasDePagto.Cells[0,0] :='código';
     grdFormasDePagto.Cells[1,0] :='Pagamento';

     for i := 0 to nTotal do
     begin
        //mmFormasPagto.Lines.Add( FormasPagamento[i].Indice+' -> '+
        //      FormasPagamento[i].Descricao+' - '+IfThen(
        //      FormasPagamento[i].PermiteVinculado,'v',''));
        grdFormasDePagto.Cells[0,i+1] := FormasPagamento[i].Indice;
        grdFormasDePagto.Cells[1,i+1] := FormasPagamento[i].Descricao;
     end;
  end;
end;

procedure TMovimentacaoCaixaFrm.edtValorKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
var Posicao : integer;
begin
  with grdFormasDePagto do
  begin
    case Key of
      VK_UP :
      begin
        Posicao := Row -1;
        if Posicao >= 1 then
        begin
          Row := Posicao;
        end;
      end;
      VK_DOWN :
      begin
        Posicao := Row + 1;
        if Posicao < RowCount then
        begin
          Row := Posicao;
        end;
      end;
    end;
  end;
end;

procedure TMovimentacaoCaixaFrm.edtValorKeyPress(Sender: TObject; var Key:
    Char);
begin
  if key = #13 then
  begin
    if Knt.UserDlg.ConfirmationYesNo('Deseja fazer a movimentação de R$' + edtValor.Text) then
    begin
      MovimentarCaixa;
      edtValor.Value := 0;
    end;
  end;
end;

procedure TMovimentacaoCaixaFrm.FormClose(Sender: TObject; var Action:
    TCloseAction);
begin
  FreeAndNil(Pagto);
end;

procedure TMovimentacaoCaixaFrm.FormShow(Sender: TObject);
var i : Integer;
begin
  case TipoMovimentacao of
    1:
    begin
      Caption := 'Suprimento de caixa';
    end;
    2:
    begin
      Caption := 'Sangria de caixa';
    end;
  end;
end;

function TMovimentacaoCaixaFrm.MovimentarCaixa: Integer;
var SelLinha : Integer;
    Pagamento : String;
begin
  SelLinha := grdFormasDePagto.Row;
  Pagamento := grdFormasDePagto.Cells[1,SelLinha];
  PrincipalFrm.LimparBobina;

  Pagto.BuscarPorDescricao(grdFormasDePagto.Cells[1,SelLinha]);
  if Pagto.ID > 0 then
  begin
  {  if FrmPrincipal.oImp.gravaMovimentoCaixa
      ( Pagto.nID,
        nTipoMovimentacao,
        FrmPrincipal.oImp.nID,
        edtValor.Value) then  }
    case TipoMovimentacao of
      1 :
      begin
        EcfDm.ECF.Device.Suprimento(edtValor.Value,'','SUPRIMENTO',Pagamento);
      end;
      2 :
      begin
        EcfDm.ECF.Device.Sangria(edtValor.Value,'','SANGRIA',Pagamento);
      end;
    end;

        {
    nIdPgto,nTipo : integer;
    nValor : currency;
    cCOO,cGNF,cGRG,cCDC,cCCF: string;
    dDtFinal: TDateTime;
    aDenDoc :TDenDocEmitido
    }
    EcfDm.Imp.GravarMovimentoCaixa( Pagto.ID, TipoMovimentacao, edtValor.Value,
      EcfDm.ECF.Device.NumCOO, EcfDm.ECF.Device.NumGNF, EcfDm.ECF.Device.NumGRG,
      EcfDm.ECF.Device.NumCDC, EcfDm.ECF.Device.NumCCF,
      EcfDm.ECF.Device.DataHora, tddeComprovNaoFisc);
  end
  else
  begin
    Knt.UserDlg.ErrorOK('Forma de pagamento não está cadastrada no sistema');
  end;
end;

end.
