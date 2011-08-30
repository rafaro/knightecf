unit ConfirmacaoDadosSPEDFiscalU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TConfirmacaoDadosSPEDFiscalFrm = class(TForm)
    pnlPrincipal: TPanel;
    btnCancelar: TButton;
    btnOk: TButton;
    rdGrpTipoArquivo: TRadioGroup;
    btnBuscaCedente: TButton;
    rdGrpPerfilArqFiscal: TRadioGroup;
    rdGrpAtividade: TRadioGroup;
    edtContador: TLabeledEdit;
    procedure btnBuscaCedenteClick(Sender: TObject);
  private
    { Private declarations }
  public
    IDContador : integer;
  end;

var
  ConfirmacaoDadosSPEDFiscalFrm: TConfirmacaoDadosSPEDFiscalFrm;

implementation

uses
  ContadorPesquisaU;

{$R *.dfm}

procedure TConfirmacaoDadosSPEDFiscalFrm.btnBuscaCedenteClick(Sender: TObject);
begin
  if ContadorPesquisaFrm = nil then
    Application.CreateForm(TContadorPesquisaFrm, ContadorPesquisaFrm);
  ContadorPesquisaFrm.ShowModal;
  IDContador := ContadorPesquisaFrm.ID;
  edtContador.Text := ContadorPesquisaFrm.Nome;
end;

end.
