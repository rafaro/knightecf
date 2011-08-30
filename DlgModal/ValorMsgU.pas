unit ValorMsgU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, JvExMask, JvToolEdit, JvBaseEdits, ComCtrls;

type
  TValorMsgFrm = class(TForm)
    stRodape: TStatusBar;
    Folder: TPageControl;
    Painel: TTabSheet;
    lblOperadorVezes: TLabel;
    edtValorDesconto: TJvCalcEdit;
    edtPercDesconto: TJvCalcEdit;
    edtValorBruto: TJvCalcEdit;
    edtValorLiquido: TJvCalcEdit;
    edtQuantidade: TJvCalcEdit;
    procedure edtPercDescontoExit(Sender: TObject);
    procedure edtValorBrutoKeyPress(Sender: TObject; var Key: Char);
    procedure edtValorDescontoExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FDecimais: Integer;
    FPercentual: Currency;
    FQuantidade: Currency;
    FRetorno: Currency;
    FValor: Currency;
    function CalcularValorLiquido(const FocoValorDesconto: Boolean): Currency;
    { Private declarations }
  public
    property Decimais: Integer read FDecimais write FDecimais;
    property Percentual: Currency read FPercentual write FPercentual;
    property Quantidade: Currency read FQuantidade write FQuantidade;
    property Retorno: Currency read FRetorno write FRetorno;
    property Valor: Currency read FValor write FValor;
  end;

var
  ValorMsgFrm: TValorMsgFrm;

implementation

uses
  Math, knight;

{$R *.dfm}

function TValorMsgFrm.CalcularValorLiquido(const FocoValorDesconto: Boolean):
    Currency;
begin
  if FocoValorDesconto then
    edtPercDesconto.Value := ( 100 * edtValorDesconto.Value)/Valor
  else
    edtValorDesconto.Value := (Valor * edtPercDesconto.Value/100);


  edtValorLiquido.Value := (Valor - edtValorDesconto.Value) *
    IfThen(Quantidade > 0 , Quantidade,1);

  if edtValorLiquido.Value < 0 then
  begin
    knt.UserDlg.ErrorOK('Valor do desconto não pode ser negativo.');
    edtValorDesconto.Value := 0;
    CalcularValorLiquido(true);
  end;
end;

procedure TValorMsgFrm.edtPercDescontoExit(Sender: TObject);
begin
  calcularValorLiquido(false);
end;

procedure TValorMsgFrm.edtValorBrutoKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    Perform(Wm_NextDlgCtl,0,0);
end;

procedure TValorMsgFrm.edtValorDescontoExit(Sender: TObject);
begin
  CalcularValorLiquido(true);
end;

procedure TValorMsgFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Retorno := edtValorDesconto.Value * IfThen(Quantidade > 0, Quantidade, 1);
end;

procedure TValorMsgFrm.FormShow(Sender: TObject);
begin
  //if Decimais = 0 then
    //Decimais := cls.nDecimalValorSaida ;
  edtValorDesconto.DecimalPlaces := Decimais;
  edtPercDesconto.DecimalPlaces := 2;
  edtValorBruto.DecimalPlaces   := Decimais;
  edtValorLiquido.DecimalPlaces := Decimais;
  edtQuantidade.DecimalPlaces   := Decimais;

  edtValorBruto.Value   := Valor;
  edtValorLiquido.Value := Valor * IfThen(Quantidade >0, Quantidade, 1);

  edtQuantidade.Visible     := Quantidade > 0;
  lblOperadorVezes.Visible  := Quantidade > 0;
  edtQuantidade.Value := Quantidade;
end;

end.
