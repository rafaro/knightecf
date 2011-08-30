program ECF;

uses
  Forms,
  PrincipalU in 'PrincipalU.pas' {PrincipalFrm},
  EcfU in 'EcfU.pas' {EcfDm: TDataModule},
  UtilsU in 'UtilsU.pas',
  knight in 'knight\knight.pas',
  MensModalU in 'DlgModal\MensModalU.pas' {MensModalFrm},
  FechamentoU in 'FechamentoU.pas' {FechamentoFrm},
  ProdutoPesquisaU in 'Pesquisa\ProdutoPesquisaU.pas' {ProdutoPesquisaFrm},
  ValorMsgU in 'DlgModal\ValorMsgU.pas' {ValorMsgFrm},
  MenuFiscalU in 'MenuFiscalU.pas' {MenuFiscalFrm},
  SelecaoImpressoraU in 'SelecaoImpressoraU.pas' {SelecaoImpressoraFrm},
  ConfirmacaoDadosSintegraU in 'DlgModal\ConfirmacaoDadosSintegraU.pas' {ConfirmacaoDadosSintegraFrm},
  ConfirmacaoDadosSPEDFiscalU in 'DlgModal\ConfirmacaoDadosSPEDFiscalU.pas' {ConfirmacaoDadosSPEDFiscalFrm},
  ContadorPesquisaU in 'Pesquisa\ContadorPesquisaU.pas' {ContadorPesquisaFrm},
  MovimentacaoCaixaU in 'MovimentacaoCaixaU.pas' {MovimentacaoCaixaFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TEcfDm, EcfDm);
  Application.CreateForm(TPrincipalFrm, PrincipalFrm);
  Application.CreateForm(TFechamentoFrm, FechamentoFrm);
  Application.CreateForm(TProdutoPesquisaFrm, ProdutoPesquisaFrm);
  Application.CreateForm(TValorMsgFrm, ValorMsgFrm);
  Application.CreateForm(TMenuFiscalFrm, MenuFiscalFrm);
  Application.CreateForm(TSelecaoImpressoraFrm, SelecaoImpressoraFrm);
  Application.CreateForm(TConfirmacaoDadosSintegraFrm, ConfirmacaoDadosSintegraFrm);
  Application.CreateForm(TConfirmacaoDadosSPEDFiscalFrm, ConfirmacaoDadosSPEDFiscalFrm);
  Application.CreateForm(TContadorPesquisaFrm, ContadorPesquisaFrm);
  Application.CreateForm(TMovimentacaoCaixaFrm, MovimentacaoCaixaFrm);
  Application.Run;
end.
