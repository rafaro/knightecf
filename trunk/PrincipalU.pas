unit PrincipalU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ACBrTEFD, ACBrPAF, Menus, ACBrBase, ACBrECF, StdCtrls, OleCtrls,
  SHDocVw, ExtCtrls, ACBrTEFDClass, ComCtrls, Mask, JvExMask, JvToolEdit,
  JvBaseEdits, ACBrDevice, JvComponentBase, JvAppStorage, JvAppIniStorage,
  JvCipher, JvAppRegistryStorage;

type
  TPrincipalFrm = class(TForm)
    pnlCabecalho: TPanel;
    lblDescricao: TLabel;
    PnlRodape: TPanel;
    pnlAviso: TPanel;
    edtAviso: TEdit;
    PnlBusca: TPanel;
    edtCliente: TEdit;
    btnBuscaCliente: TButton;
    mnMnPDV: TMainMenu;
    MenuFiscal1: TMenuItem;
    Operaes1: TMenuItem;
    Suprimento1: TMenuItem;
    Sangria1: TMenuItem;
    Acoes1: TMenuItem;
    FecharCupom1: TMenuItem;
    ProcurarProduto1: TMenuItem;
    CancelarItem1: TMenuItem;
    CancelarCupom1: TMenuItem;
    MudaHorriodeVero1: TMenuItem;
    TEF1: TMenuItem;
    Administrao1: TMenuItem;
    pnlBotoes: TPanel;
    pnlEntrada: TPanel;
    pnlBotoesComando: TPanel;
    btnFecharCupom: TButton;
    btnCancelarCupom: TButton;
    btnProcurarProd: TButton;
    btnCancelarItem: TButton;
    pnlBobina: TPanel;
    wbBobina: TWebBrowser;
    mBobina: TMemo;
    brStatus: TStatusBar;
    edtPrecoTotal: TJvCalcEdit;
    edtQuantidade: TJvCalcEdit;
    edtCodigo: TJvCalcEdit;
    edtSubtotal: TJvCalcEdit;
    iniStr: TJvAppIniFileStorage;
    iniAliq: TJvAppIniFileStorage;
    cphImpressora: TJvCaesarCipher;
    reg: TJvAppRegistryStorage;
    procedure FormCreate(Sender: TObject);
    procedure Administrao1Click(Sender: TObject);
    procedure btnFecharCupomClick(Sender: TObject);
    procedure CancelarCupom1Click(Sender: TObject);
    procedure CancelarItem1Click(Sender: TObject);
    procedure FecharCupom1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure MudaHorriodeVero1Click(Sender: TObject);
    procedure ProcurarProduto1Click(Sender: TObject);
    procedure Sangria1Click(Sender: TObject);
    procedure Suprimento1Click(Sender: TObject);
  private
    procedure TrataErros(Sender: TObject; E: Exception);
    procedure AbrirCupomFiscal;
    procedure BloqueiarAcoes(Value: Boolean);
    procedure CarregarClienteCupom;
    procedure ColocarFocoPrimeiroComp;
    procedure CriarObjCupom;
    function EstaOKserieEGrandeTotal(const EmiteMensagem: Boolean = false): Boolean;
    procedure FinalizarObj;
    procedure InserirItem(const forcaBusca: Boolean);
    procedure LimparDados;
    procedure PegarEstadoECF;
    procedure TEFAguardaResp(Arquivo: String; SegundosTimeOut: Integer; var
        Interromper: Boolean);
    procedure TEFAntesCancelarTransacao(RespostaPendente: TACBrTEFDResp);
    procedure TEFAntesFinalizarRequisicao(Req: TACBrTEFDReq);
    procedure TEFBloqueiaMouseTeclado(Bloqueia: Boolean; var Tratado: Boolean);
    procedure TEFComandaECF(Operacao: TACBrTEFDOperacaoECF; Resp: TACBrTEFDResp;
        var RetornoECF: Integer);
    procedure TEFComandaECFAbreVinculado(COO, IndiceECF: String; Valor: Double; var
        RetornoECF: Integer);
    procedure TEFComandaECFImprimeVia(TipoRelatorio: TACBrTEFDTipoRelatorio; Via:
        Integer; ImagemComprovante: TStringList; var RetornoECF: Integer);
    procedure TEFComandaECFPagamento(IndiceECF: String; Valor: Double; var
        RetornoECF: Integer);
    procedure TEFDepoisConfirmarTransacoes(
      RespostasPendentes: TACBrTEFDRespostasPendentes);
    procedure TEFExibeMsg(Operacao: TACBrTEFDOperacaoMensagem; Mensagem: String;
        var AModalResult: TModalResult);
    procedure TEFMudaEstadoReq(EstadoReq: TACBrTEFDReqEstado);
    procedure TEFMudaEstadoResp(EstadoResp: TACBrTEFDRespEstado);
    procedure TEFRestauraFocoAplicacao(var Tratado: Boolean);
    procedure TEFInfoECF(Operacao: TACBrTEFDInfoECF;
      var RetornoECF: String);
    procedure VerificarCupomAbertoECancela(Estado: TACBrECFEstado =
        estDesconhecido);
  public
    procedure BuscarProduto(const ForcaBusca: Boolean);
    function CancelarCupom(const EmiteMensagem: Boolean): Boolean;
    procedure configuraImpressoraFiscal;
    procedure ConfigurarCamposDigitacao;
    procedure GravarGrandeTotalINI;
    procedure LimparBobina;
    { Public declarations }
  end;

var
  PrincipalFrm: TPrincipalFrm;

implementation

uses
  EcfU, UtilsU, knight, MensModalU, DateUtils, StrUtils, TypInfo,
  Math, FechamentoU, ProdutoPesquisaU, MovimentacaoCaixaU;

{$R *.dfm}

procedure TPrincipalFrm.AbrirCupomFiscal;
begin
  ///=============------------ATENÇÃO------------==================
  //                   NÂO UTILIZA LIMPA DADOS(limparDados)
  // Pois atrapalha o foco e o status
  //
  LimparBobina;
  //ACBrPAF1.
  CarregarClienteCupom;
  EcfDm.ECF.Device.AbreCupom(
    EcfDm.Cliente.IdentNacional,
    EcfDm.Cliente.Razao,
    EcfDm.Cliente.Ender.Endereco + ',' + EcfDm.Cliente.NumEnderEntrega + '-' +
      EcfDm.Cliente.Ender.Bairro + '-' + EcfDm.Cliente.Ender.Cidade
   );
  CriarObjCupom;

end;

procedure TPrincipalFrm.FormCreate(Sender: TObject);
begin
  Ecfdm.ACBrTEF.OnAguardaResp := TEFAguardaResp;
  Ecfdm.ACBrTEF.OnExibeMsg := TEFExibeMsg;
  Ecfdm.ACBrTEF.OnBloqueiaMouseTeclado := TEFBloqueiaMouseTeclado;
  Ecfdm.ACBrTEF.OnRestauraFocoAplicacao := TEFRestauraFocoAplicacao;
  Ecfdm.ACBrTEF.OnComandaECF := TEFComandaECF;
  Ecfdm.ACBrTEF.OnComandaECFPagamento := TEFComandaECFPagamento;
  Ecfdm.ACBrTEF.OnComandaECFAbreVinculado := TEFComandaECFAbreVinculado;
  Ecfdm.ACBrTEF.OnComandaECFImprimeVia := TEFComandaECFImprimeVia;
  Ecfdm.ACBrTEF.OnInfoECF := TEFInfoECF;
  Ecfdm.ACBrTEF.OnAntesFinalizarRequisicao := TEFAntesFinalizarRequisicao;
  Ecfdm.ACBrTEF.OnDepoisConfirmarTransacoes := TEFDepoisConfirmarTransacoes;
  Ecfdm.ACBrTEF.OnAntesCancelarTransacao := TEFAntesCancelarTransacao;
  Ecfdm.ACBrTEF.OnMudaEstadoReq := TEFMudaEstadoReq;
  Ecfdm.ACBrTEF.OnMudaEstadoResp := TEFMudaEstadoResp;
  Ecfdm.TEF := TTEF.Create(Ecfdm.ACBrTEF);

  EcfDm.ECF := TECF.Create(EcfDm.ACBrECF, EcfDm.ACBrEAD);

  try
    CreateDir(Knt.Str.AppDirectory + '\movecf');
    CreateDir(Knt.Str.AppDirectory + '\sped');
    CreateDir(Knt.Str.AppDirectory + '\sintegra');

    iniAliq.FileName := Knt.Str.AppDirectory + '\aliq.ini';
    iniStr.FileName  := Knt.Str.AppDirectory + '\cpdv.sr';
    EcfDm.ECF.ConfigurarCupom;

    configuraImpressoraFiscal;

    wbBobina.BringToFront ;

    LimparBobina;

    //CreateDir( ExtractFilePath(Application.ExeName)+'\movecf');

    //btSerial.Enabled := False ;
    //bAtivar.Caption := 'Desativar' ;
    //mResp.Lines.Add( 'Ativar' );
    //AtualizaMemos ;

    //GravarINI ;

    //if PageControl1.ActivePageIndex = 0 then
    //   PageControl1.ActivePageIndex := 1 ;
  finally
//cbxModelo.ItemIndex := Integer(ACBrECF1.Modelo) ;
    //cbxPorta.Text       := ACBrECF1.Porta ;
  end ;
end;

procedure TPrincipalFrm.TEFAguardaResp(Arquivo: String; SegundosTimeOut:
    Integer; var Interromper: Boolean);
var
  cMsg : String ;
begin
  cMsg := '' ;
  if (EcfDm.TEF.Device.GPAtual in [gpCliSiTef, gpVeSPague]) then   // É TEF dedicado ?
  begin
    if (Arquivo = '23')
     //and (not bCancelarResp.Visible)
    then  // Está aguardando Pin-Pad ?
    begin
      if EcfDm.TEF.Device.TecladoBloqueado then
      begin
        EcfDm.TEF.Device.BloquearMouseTeclado(False);  // Desbloqueia o Teclado
        // TODO: nesse ponto é necessário desbloquear o Teclado, mas permitir
        //       um clique apenas no botão cancelar.... FALTA CORRIGIR NO DEMO
      end ;

      cMsg := 'Tecle "ESC" para cancelar.';
      //bCancelarResp.Visible := True ;
    end;
  end
  else
    cMsg := 'Aguardando: '+Arquivo+' '+IntToStr(SegundosTimeOut) ;

  if cMsg <> '' then
    brStatus.Panels[2].Text := cMsg;
  Application.ProcessMessages;
  //if fCancelado then
  //   Interromper := True ;
end;

procedure TPrincipalFrm.TEFAntesCancelarTransacao(
  RespostaPendente: TACBrTEFDResp);
var
  Est: TACBrECFEstado;
begin
  Est := EcfDm.ECF.Device.Estado;
  case Est of
    estVenda, estPagamento:
    begin
      //EcfDm.ECF.Device.CancelaCupom;//cancelaCupom(false); //EcfDm.ECF.Device.CancelaCupom;
    end;
    estRelatorio :
      EcfDm.ECF.Device.FechaRelatorio;
  else
    if not (Est in [estLivre, estDesconhecido, estNaoInicializada]) then
      EcfDm.ECF.Device.CorrigeEstadoErro( False ) ;
  end;
end;

procedure TPrincipalFrm.TEFAntesFinalizarRequisicao(Req: TACBrTEFDReq);
begin
  if Req.Header = 'CRT' then
    Req.GravaInformacao(777,777,'TESTE REDECARD');
end;

procedure TPrincipalFrm.TEFBloqueiaMouseTeclado(Bloqueia: Boolean; var Tratado:
    Boolean);
begin
    Tratado := true ;
end;

procedure TPrincipalFrm.TEFComandaECF(Operacao: TACBrTEFDOperacaoECF; Resp:
    TACBrTEFDResp; var RetornoECF: Integer);
begin
  try
    case Operacao of
      opeAbreGerencial :
        EcfDm.ECF.Device.AbreRelatorioGerencial ;

      opeCancelaCupom :
        EcfDm.ECF.Device.CancelaCupom;

      opeFechaCupom :
        EcfDm.ECF.Device.FechaCupom;

      opeSubTotalizaCupom :
        EcfDm.ECF.Device.SubtotalizaCupom( 0, '' );

      opeFechaGerencial, opeFechaVinculado :
        EcfDm.ECF.Device.FechaRelatorio ;

      opePulaLinhas :
      begin
        EcfDm.ECF.Device.PulaLinhas( EcfDm.ECF.Device.LinhasEntreCupons );
        EcfDm.ECF.Device.CortaPapel( True );
        Sleep(200);
      end;
    end;

    RetornoECF := 1 ;
  except
    RetornoECF := 0 ;
  end;
end;

procedure TPrincipalFrm.TEFComandaECFAbreVinculado(COO, IndiceECF: String;
    Valor: Double; var RetornoECF: Integer);
begin
  try
    //Memo1.Lines.Add( 'ACBrTEFD1ComandaECFAbreVinculado, COO:'+COO+
   //   ' IndiceECF: '+IndiceECF+' Valor: '+FormatFloat('0.00',Valor) ) ;
   EcfDm.ECF.Device.AbreCupomVinculado( COO, IndiceECF, Valor );
   RetornoECF := 1 ;
  except
    RetornoECF := 0 ;
  end;
end;

procedure TPrincipalFrm.TEFComandaECFImprimeVia(TipoRelatorio:
    TACBrTEFDTipoRelatorio; Via: Integer; ImagemComprovante: TStringList; var
    RetornoECF: Integer);
begin
    //Memo1.Lines.Add( 'ACBrTEFD1ComandaECFImprimeVia, Tipo: '+
  //   IfThen(TipoRelatorio = trGerencial, 'trGerencial','trVinculado') +
  //   ' Via: '+IntToStr(Via) );
  //Memo1.Lines.AddStrings( ImagemComprovante );

  { *** Se estiver usando ACBrECF... Lembre-se de configurar ***
    ACBrECF1.MaxLinhasBuffer   := 3; // Os homologadores permitem no máximo
                                     // Impressao de 3 em 3 linhas
    ACBrECF1.LinhasEntreCupons := 7; // (ajuste conforme o seu ECF)

    NOTA: ACBrECF nao possui comando para imprimir a 2a via do CCD }
  try
    case TipoRelatorio of
     trGerencial :
       EcfDm.ECF.Device.LinhaRelatorioGerencial( ImagemComprovante.Text ) ;

     trVinculado :
       EcfDm.ECF.Device.LinhaCupomVinculado( ImagemComprovante.Text )
    end;
    RetornoECF := 1 ;
  except
    RetornoECF := 0 ;
  end;
end;

procedure TPrincipalFrm.TEFComandaECFPagamento(IndiceECF: String; Valor:
    Double; var RetornoECF: Integer);
begin
  try
    //Memo1.Lines.Add( 'ACBrTEFD1ComandaECFPagamento, IndiceECF: '+IndiceECF+
    //   ' Valor: '+FormatFloat('0.00',Valor) );
    EcfDm.ECF.Device.EfetuaPagamento(IndiceECF, Valor);
    RetornoECF := 1 ;
  except
    RetornoECF := 0 ;
  end;
end;

procedure TPrincipalFrm.TEFDepoisConfirmarTransacoes(
  RespostasPendentes: TACBrTEFDRespostasPendentes);
var
  I : Integer;
begin
  for I := 0 to RespostasPendentes.Count-1  do
  begin
    with RespostasPendentes[I] do
    begin
    {
      Memo1.Lines.Add('Confirmado: '+Header+' ID: '+IntToStr( ID ) );

      Memo1.Lines.Add( 'Rede: '  + Rede +
                       ' NSU: '  + NSU  +
                       ' Valor: '+ FormatFloat('###,###,##0.00',ValorTotal)) ;
      Memo1.Lines.Add('Campo 11: ' + LeInformacao(11,0).AsString );
    }
    end;
  end;
end;

procedure TPrincipalFrm.TEFExibeMsg(Operacao: TACBrTEFDOperacaoMensagem;
    Mensagem: String; var AModalResult: TModalResult);
var
   Fim : TDateTime;
   OldMensagem : String;
begin
  if MensModalFrm = nil then
  begin
    exit;
  end;
  MensModalFrm.lblMensagemOperador.Caption := '';
  MensModalFrm.lblMensagemCliente.Caption  := '';

  brStatus.Panels[1].Text := '' ;
  brStatus.Panels[2].Text := '' ;

  case Operacao of
    opmOK :
    begin
      //AModalResult := MessageDlg( Mensagem, mtInformation, [mbOK], 0);
      AModalResult := IDOK;
      Knt.UserDlg.WarningOK(Mensagem);
    end;
    opmYesNo :
    begin
      //AModalResult := MessageDlg( Mensagem, mtConfirmation, [mbYes,mbNo], 0);
      AModalResult := IfThen( knt.UserDlg.ConfirmationYesNo(Mensagem), idyes, idno);
    end;
    opmExibirMsgOperador, opmRemoverMsgOperador :
    begin
      MensModalFrm.lblMensagemOperador.Caption := Mensagem ;
      //dlgTEF.Caption := Mensagem ;
    end;
    opmExibirMsgCliente, opmRemoverMsgCliente :
    begin
      MensModalFrm.lblMensagemCliente.Caption := Mensagem ;
      //dlgTEF.Caption := Mensagem ;
    end;
    opmDestaqueVia :
    begin
      OldMensagem := MensModalFrm.lblMensagemOperador.Caption ;
      //OldMensagem := dlgTEF.Caption;
      try
        MensModalFrm.lblMensagemOperador.Caption := Mensagem ;
        MensModalFrm.lblMensagemOperador.Visible := True ;
        //dlgTEF.Caption := Mensagem;
        { Aguardando 3 segundos }
        Fim := IncSecond(now, 3)  ;
        repeat
           sleep(200) ;
           MensModalFrm.lblMensagemOperador.Caption := Mensagem + ' ' + IntToStr(SecondsBetween(Fim,now));
           Application.ProcessMessages;
        until (now > Fim) ;

      finally
        MensModalFrm.lblMensagemOperador.Caption := OldMensagem ;
      end;
    end;
  end;

  MensModalFrm.lblMensagemOperador.Visible := (trim(MensModalFrm.lblMensagemOperador.Caption) <> '') ;
  MensModalFrm.lblMensagemCliente.Visible  := (trim(MensModalFrm.lblMensagemCliente.Caption) <> '') ;
  MensModalFrm.Visible := MensModalFrm.lblMensagemOperador.Visible or MensModalFrm.lblMensagemCliente.Visible;
  Application.ProcessMessages;
end;

procedure TPrincipalFrm.TEFInfoECF(Operacao: TACBrTEFDInfoECF;
  var RetornoECF: String);
begin
  if not EcfDm.ECF.Device.Ativo then
    EcfDm.ECF.Device.Ativar;

  case Operacao of
    ineSubTotal :
      RetornoECF := FloatToStr( EcfDm.ECF.Device.Subtotal-EcfDm.ECF.Device.TotalPago ) ;

    ineEstadoECF :
    begin
      Case EcfDm.ECF.Device.Estado of
        estLivre     : RetornoECF := 'L' ;
        estVenda     : RetornoECF := 'V' ;
        estPagamento : RetornoECF := 'P' ;
        estRelatorio : RetornoECF := 'R' ;
      else
        RetornoECF := 'O' ;
      end;
    end;
  end;
end;

procedure TPrincipalFrm.TEFMudaEstadoReq(EstadoReq: TACBrTEFDReqEstado);
begin
  if MensModalFrm = nil then
    Application.CreateForm(TMensModalFrm, MensModalFrm);
end;

procedure TPrincipalFrm.TEFMudaEstadoResp(EstadoResp: TACBrTEFDRespEstado);
begin
  brStatus.Panels[1].Text := GetEnumName(TypeInfo(TACBrTEFDRespEstado), Integer(EstadoResp) ) ;
end;

procedure TPrincipalFrm.TEFRestauraFocoAplicacao(var Tratado: Boolean);
begin
  Application.BringToFront;
  Tratado := False ;  { Deixa executar o código de Foco do ACBrTEFD }
end;

procedure TPrincipalFrm.TrataErros(Sender: TObject; E: Exception);
var Str: string;
begin
  Str := E.Message;
  Str := StringReplace(Str,'Componente','',[rfIgnoreCase]);
  Str := StringReplace(Str,'acbrecf','ECF',[rfIgnoreCase]);
  edtAviso.Text := 'Erro - ' + trim(Str);
end;

procedure TPrincipalFrm.Administrao1Click(Sender: TObject);
begin
  Ecfdm.TEF.Ativar;
  Ecfdm.TEF.Device.ADM(Ecfdm.TEF.TiposTEF);
end;

procedure TPrincipalFrm.BloqueiarAcoes(Value: Boolean);
begin
  FecharCupom1.Enabled := Value;
  CancelarItem1.Enabled := Value;
end;

procedure TPrincipalFrm.btnFecharCupomClick(Sender: TObject);
begin
  FecharCupom1.Click;
end;

procedure TPrincipalFrm.BuscarProduto(const ForcaBusca: Boolean);
var Index: integer;
    AliqProd: string;
    ValorDesconto: currency;
    MensErro: string;
    CodCFOP: string;
begin
  ValorDesconto := 0;
  try
    if ProdutoPesquisaFrm = nil then
      Application.CreateForm(TProdutoPesquisaFrm, ProdutoPesquisaFrm);

    ProdutoPesquisaFrm.Codigo := edtCodigo.Text ;

    if (edtCodigo.Text = '') or ForcaBusca then
      ProdutoPesquisaFrm.ShowModal
    else
      ProdutoPesquisaFrm.PesquisarExterna;

    //
    if ProdutoPesquisaFrm.idProduto <> 0 then
    begin
      lblDescricao.Caption := ProdutoPesquisaFrm.Descricao;
      edtCodigo.Text := ProdutoPesquisaFrm.Codigo ;
      //edtVlrUnitario.Value := Frm_Busca_Produto.nProPrecoVenda;
      //edtVlrTotal.Value := Frm_Busca_Produto.nProPrecoVenda * edtQuantidade.Value;

      Index := EcfDm.Cupom.InserirItem;
//      with EcfDm.Cupom.Itens[Index] do
//      begin
      EcfDm.Cupom.Itens[Index].Preco := ProdutoPesquisaFrm.ProPrecoVenda;

      EcfDm.Cupom.Itens[Index].Produto.ID := ProdutoPesquisaFrm.idProduto ;
      EcfDm.Cupom.Itens[Index].Produto.Codigo := ProdutoPesquisaFrm.Codigo ;
      EcfDm.Cupom.Itens[Index].Produto.Desc := ProdutoPesquisaFrm.Descricao ;
      EcfDm.Cupom.Itens[Index].Produto.EhProduzido := ProdutoPesquisaFrm.EhProduzido;
      EcfDm.Cupom.Itens[Index].Unidade.Desc := ProdutoPesquisaFrm.UnidComer ;
      EcfDm.Cupom.Itens[Index].Unidade.ID := ProdutoPesquisaFrm.idUnidade  ;
      EcfDm.Cupom.Itens[Index].Preco := ProdutoPesquisaFrm.ProPrecoVenda;

      if edtPrecoTotal.Visible then
        EcfDm.Cupom.Itens[Index].Preco := edtPrecoTotal.Value;

      EcfDm.Cupom.Itens[Index].Quant := edtQuantidade.Value;
      EcfDm.Cupom.Itens[Index].Desc := 0;
      EcfDm.Cupom.Itens[Index].CST.BuscarPorID(ProdutoPesquisaFrm.idCST);

      EcfDm.Cupom.RecalcularImpostos(Index);
      EcfDm.Cupom.Itens[Index].AliqInterna := ProdutoPesquisaFrm.ProAliqICMS;
      case EcfDm.Cupom.Itens[Index].CST.Classific of
        0 : //- Tributado
        begin
            AliqProd := FormatFloat('0.00', EcfDm.Cupom.Itens[Index].AliqInterna);
        end;
        1 ://- Isenta
        begin
          AliqProd := 'II';
        end;
        2 ://- Substituição Tributária
        begin
          AliqProd := 'FF';
        end;
        3://- Outras
        begin
          AliqProd := FormatFloat('0.00', EcfDm.Cupom.Itens[Index].AliqInterna);
        end;
        4://- Não incidência
        begin
          AliqProd := 'NN';
        end;
      else
        AliqProd := FormatFloat('0.00', EcfDm.Cupom.Itens[Index].AliqInterna);
      end;

      //Pegar o código de CFOP
      if EcfDm.Cupom.Itens[Index].CST.Classific = 2 then
      begin
        CodCFOP := IfThen(EcfDm.Cupom.Itens[Index].Produto.EhProduzido,
          EcfDm.ECF.CfoSTProd, EcfDm.ECF.CfoSTRevend);
      end
      else
      begin
        CodCFOP := IfThen(EcfDm.Cupom.Itens[Index].Produto.EhProduzido,
          EcfDm.ECF.CfoProd, EcfDm.ECF.CfoRevend);
      end;
      EcfDm.Cupom.Itens[Index].CFO.BuscarPorCodigo(CodCFOP);

      MensErro := '';
      if EcfDm.Cupom.Itens[Index].CST.ID <= 0 then
      begin
         MensErro := 'A situação tributária do produto não está cadastrada';
      end;

      if EcfDm.Cupom.Itens[Index].Unidade.ID <= 0 then
      begin
         MensErro := MensErro + IfThen( MensErro=EmptyStr,'',#13) +
          'A unidade do produto não está cadastrada';
      end ;

      if EcfDm.Cupom.Itens[Index].CFO.ID <= 0 then
      begin
        MensErro := MensErro + IfThen( MensErro=EmptyStr,'',#13) +
          'O CFOP não está cadastrado';
      end  ;

      if MensErro = EmptyStr  then
      begin

        if EcfDm.ECF.PodeDescontoUnitario then
        begin
//          ValorDesconto := cls.oMsg.Calcula(EcfDm.Cupom.Itens[Index].Preco, 2,
//            EcfDm.Cupom.Itens[Index].Quant);
        end;

        try
          EcfDm.ECF.Device.VendeItem(
            EcfDm.Cupom.Itens[Index].Produto.Codigo,
            EcfDm.Cupom.Itens[Index].Produto.Desc,
            AliqProd,
            EcfDm.Cupom.Itens[Index].Quant,
            EcfDm.Cupom.Itens[Index].Preco,
            ValorDesconto,
            EcfDm.Cupom.Itens[Index].Unidade.Desc,
            '$',
            'D'
            );
          EcfDm.Cupom.GravarTblItem(Index + 1);
        except
          on E : Exception do
          begin
            EcfDm.Cupom.RemoverUltimoItem;
            raise;
          end;
        end;
      end
      else
      begin
        //cls.oMsg.erroOK(MensErro);
        edtAviso.Text := MensErro;
      end;
      edtSubtotal.Value := EcfDm.ECF.Device.Subtotal;
    end;
    //end;
  finally
    FreeAndNil(ProdutoPesquisaFrm);
  end;
end;

function TPrincipalFrm.CancelarCupom(const EmiteMensagem: Boolean): Boolean;
var Confirmado: boolean;
  NumCOO: string;
  NumSerie: string;
begin
  Confirmado := true;
  NumCOO := EcfDm.ECF.Device.NumCOO;

  if EmiteMensagem then
  begin
    Confirmado := Knt.UserDlg.ConfirmationYesNo('Deseja cancelar o cupom '+NumCOO+'?');
  end;

  if Confirmado then
  begin
    EcfDm.ECF.Device.CancelaCupom ;
    if EcfDm.Cupom = nil then
    begin
      EcfDm.Cupom := TCupom.create;
    end;

    if EcfDm.Cupom.ID <= 0 then
    begin
      NumSerie := EcfDm.ECF.Device.NumSerie;
      EcfDm.Cupom.BuscarPorCOO(NumCOO,NumSerie);
    end;
    EcfDm.Cupom.GravarCancelamento(EcfDm.ECF.Device.DataHora);

    if EcfDm.ECF.MovimentaEstoque then
    begin
      EcfDm.Cupom.AlimentarEstoque(true);
    end;

    if EcfDm.TEF.TiposTEF <> gpNenhum then
    begin
      EcfDm.TEF.Device.CancelarTransacoesPendentes;
    end;
    FinalizarObj;
    LimparDados;
  end;
  if EstaOKserieEGrandeTotal then
  begin
    GravarGrandeTotalINI;
  end;
  result :=Confirmado;
end;

procedure TPrincipalFrm.CancelarCupom1Click(Sender: TObject);
begin
  if Enabled AND EcfDm.ECF.EstaOK([estLivre,estVenda,estPagamento]) then
  begin
    Enabled := false;
    try
      CancelarCupom(true);
    finally
      if EstaOKserieEGrandeTotal then
      begin
        gravarGrandeTotalINI;
      end;
      Enabled := true;
      colocarFocoPrimeiroComp;
    end;
  end;
end;

procedure TPrincipalFrm.CancelarItem1Click(Sender: TObject);
Var ItemParametro : String ;
  ItemPosicao : integer;
  EstImp : TACBrECFEstado;
begin
  if Enabled then
  begin
    EstImp := EcfDm.ECF.Device.Estado;
    if EstImp = estVenda then
    begin
      ItemParametro := '1' ;
      if InputQuery('Cancelar Item Vendido',
                  'Informe o número da sequência de venda', ItemParametro ) then
      begin
        ItemPosicao := StrToIntDef(ItemParametro, 0);
        if EcfDm.Cupom.CancelarItem(ItemPosicao) then
        begin
          EcfDm.ECF.Device.CancelaItemVendido(ItemPosicao);
          edtSubtotal.Value := EcfDm.ECF.Device.Subtotal;
        end
        else
        begin
          Knt.UserDlg.ErrorOK('Não é possível cancelar um item da sequência ' +
            IntToStr(ItemPosicao)+'.');
        end;
      end ;
    end
    else
    begin
      Knt.UserDlg.ErrorOK('Não é possível cancelar um item no estado:' +
        ECFEstados[EstImp]);
    end;
    LimparDados;
  end;
end;

procedure TPrincipalFrm.CarregarClienteCupom;
begin
  if EcfDm.Cliente = nil then
  begin
    EcfDm.Cliente := TCedente.create;
    EcfDm.Cliente.EhPessoaFisica := true;
    EcfDm.Cliente.BuscarPorCNPJ('00000000000000');
  end;
  EcfDm.Cliente.CarregarEnderecoEntrega;
end;

procedure TPrincipalFrm.ColocarFocoPrimeiroComp;
begin
  if Enabled then
  begin
    if edtPrecoTotal.Visible then
    begin
      if edtPrecoTotal.Enabled then
        edtPrecoTotal.SetFocus;
    end
    else
    begin
      if edtCodigo.Enabled and edtCodigo.Visible then
        edtCodigo.SetFocus;
    end;
  end;
end;

procedure TPrincipalFrm.configuraImpressoraFiscal;
var
  ECFModelo        : Integer;
  ECFTimeOut       : Integer;
  ECFIntevalo      : Integer;
  ECFLinhasBuffer  : Integer;
  ECFDecPreco      : Integer;
  ECFDecQuant      : Integer;
  //  TEFTipo          : Integer;
  NumSerie         : String;
  MensErro         : string;
begin

  //register.WriteInteger('ECFPorta',);
  //reg.WriteString('ECFPorta','COM3');
  //reg.WriteInteger('ECFModelo',1);
  //reg.WriteInteger('ECFTimeOut',1);
  //reg.WriteInteger('ECFIntevalo',1);
  //reg.WriteInteger('ECFLinhasBuffer',1);
  //reg.WriteInteger('ECFDecPreco',1);
  //reg.WriteInteger('ECFDecQuant',1);
  //reg.WriteBoolean('ECFDescrGrande',True);

  ////reg.WriteString('ECFMD5','1321');
  //reg.WriteString('ECFMensPromo','12345');

  //reg.WriteString('SHCNPJ','465464');
  //reg.WriteString('SHInscEst','111111111111');
  //reg.WriteString('SHInscMunic','22222222222');
  //reg.WriteString('SHNome','333333333333');
  //reg.WriteString('ECFNome','4444444444');
  //reg.WriteString('ECFVer','555555555');
  //reg.WriteBoolean('ECFMaximizado',true);
     {
  ListaStr := TStringList.Create;
  ListaStr.Add('Teste.tt-sd46a5d4f6sad');
  ListaStr.Add('Teste2.tt-sd46a5d4f6sadasdfsadf');
  reg.WriteStringList('PAFECFArqsMD5',ListaStr,'arq');
     }

  if reg.ReadBoolean('ECFMaximizado',false) then
  begin
    WindowState := wsMaximized;
  end;

  if reg.ReadBoolean('ECFOcultaQuant',false) then
  begin
    edtQuantidade.Visible := false;
    edtPrecoTotal.Visible := true;
  end;

  EcfDm.ECF.MovimentaEstoque := reg.ReadBoolean('ECFMovEstoque',false);

  EcfDm.SoftHs := TSoftHouse.Create;
  EcfDm.SoftHs.CNPJ      := reg.ReadString('SHCNPJ','');
  EcfDm.SoftHs.InscEst   := reg.ReadString('SHInscEst','');
  EcfDm.SoftHs.InscMunic := reg.ReadString('SHInscMunic','');
  EcfDm.SoftHs.Nome      := reg.ReadString('SHNome','');
  //EcfDm.SoftHs.NomePAF   := reg.ReadString('ECFNome','');
  //EcfDm.SoftHs.VerPAF    := reg.ReadString('ECFVer','');
  EcfDm.SoftHs.ERPAFECF  := reg.ReadString('ERPAFECF','');
  EcfDm.SoftHs.NumLaudo  := reg.ReadString('SHNumLaudo','');
  EcfDm.SoftHs.Endereco  := reg.ReadString('SHEndereco','');
  EcfDm.SoftHs.Telefone  := reg.ReadString('SHTelefone','');
  EcfDm.SoftHs.NomePessoaContato := reg.ReadString('SHNomePessoaContato','');

  EcfDm.SoftHs.PAFECFNomeComercial := reg.ReadString('PAFECFNomeComercial','');
  EcfDm.SoftHs.PAFECFVersao    := reg.ReadString('PAFECFVersao','');
  EcfDm.SoftHs.PAFECFPrincExec := reg.ReadString('PAFECFPrincExec','');
  EcfDm.SoftHs.PAFECFMD5Exec   := reg.ReadString('PAFECFMD5Exec','');

  reg.ReadStringList('PAFECFArqsMD5', EcfDm.SoftHs.PAFECFArqsMD5, true, 'arq');

  EcfDm.ECF.MensagemPromocional := EcfDm.SoftHs.PAFECFMD5Exec + Knt.Cons.CRLF +
    Knt.Cons.CRLF + reg.ReadString('ECFMensPromo','');

  EcfDm.ECF.CfoProd     := reg.ReadString('ECFCfoProd','5101');
  EcfDm.ECF.CfoRevend   := reg.ReadString('ECFCfoRevend','5102');
  EcfDm.ECF.CfoSTProd   := reg.ReadString('ECFCfoSTProd','5405');
  EcfDm.ECF.CfoSTRevend := reg.ReadString('ECFCfoSTRevend','5405');
  EcfDm.ECF.OpCupom     := reg.ReadInteger('ECFOpCupom',-1);

  //nOpProd      := reg.ReadInteger('ECFOpProd',-1);
  //nOpRevend    := reg.ReadInteger('ECFOpRevend',-1);
  //nOpSTProd    := reg.ReadInteger('ECFOpSTProd',-1);
  //nOpSTRevend  := reg.ReadInteger('ECFOpSTRevend',-1);
  ECFModelo := 0;

  while true do
  begin
    ECFTimeOut       := reg.ReadInteger('ECFTimeOut',0);
    if ECFTimeOut > 0 then
    begin
      EcfDm.ECF.Device.TimeOut := ECFTimeOut;
    end;

    ECFIntevalo      := reg.readInteger('ECFIntevalo',0);
    if ECFIntevalo > 0 then
    begin
      EcfDm.ECF.Device.IntervaloAposComando := ECFIntevalo;
    end;

    ECFLinhasBuffer  := reg.readInteger('ECFLinhasBuffer',0);
    if ECFLinhasBuffer > 0 then
    begin
      EcfDm.ECF.Device.MaxLinhasBuffer := ECFLinhasBuffer;
    end;

    ECFDecPreco      := reg.readInteger('ECFDecPreco',0);
    if ECFDecPreco > 0 then
    begin
      EcfDm.ECF.Device.DecimaisPreco := ECFDecPreco;
    end;

    ECFDecQuant      := reg.readInteger('ECFDecQuant',0);
    if ECFDecQuant > 0 then
    begin
      EcfDm.ECF.Device.DecimaisQtd := ECFDecQuant;
    end;

    EcfDm.ECF.Device.DescricaoGrande := reg.readBoolean('ECFDescrGrande',FALSE);

    EcfDm.ECF.Device.Porta := reg.ReadString('ECFPorta','COM1');

    ECFModelo := reg.readInteger('ECFModelo',0);

    EcfDm.TEF.TiposTEF := TACBrTEFDTipo( reg.readInteger('TEFTipo',0));

    TEF1.Visible := false;
    if EcfDm.TEF.TiposTEF <> gpNenhum then
    begin
      EcfDm.TEF.Device.ArqLOG:= Knt.Str.AppDirectory+'\Log\tf.lg';
      try
        EcfDm.TEF.Ativar;
      except
      end;
      TEF1.Visible := true;

      if not DirectoryExists(EcfDm.TEF.Device.ArqLOG) then
        ForceDirectories(EcfDm.TEF.Device.ArqLOG);
    end;


    if ECFModelo = 0 then
    begin
      if not Knt.UserDlg.ConfirmationYesNo('Não configurado o modelo do ECF. Buscar novamente?') then
        Application.Terminate;
    end
    else
    begin
      break;
    end;
  end;
  EcfDm.ECF.Device.ArqLOG := Knt.Str.AppDirectory + '\Log\imp.lg';
  EcfDm.ECF.Device.Modelo := TACBrECFModelo(ECFModelo);
  EcfDm.ECF.Device.Ativar ;

  EcfDm.Imp := TImpFiscal.create;
  NumSerie := EcfDm.ECF.Device.NumSerie;
  EcfDm.Imp.BuscarPorNumSerial(NumSerie);

  MensErro := '';
  if EcfDm.Imp.ID = -1 then
  begin
    MensErro := MensErro + ifthen(MensErro<>EmptyStr, Knt.Cons.CRLF) +
      'Impressora '+NumSerie+' não cadastrada!';
  end;

  if EcfDm.SoftHs.PAFECFMD5Exec = EmptyStr then
  begin
    MensErro := MensErro + ifthen(MensErro<>EmptyStr, Knt.Cons.CRLF) +
      'MD5 não cadastrado!';
  end;

  if (EcfDm.ECF.OpCupom <= 0) then
  begin
    MensErro := MensErro + ifthen(MensErro<>EmptyStr, Knt.Cons.CRLF) +
      'Não foi cadastrado a operação do cupom fiscal!';
  end;

  if MensErro <> EmptyStr then
  begin
    Knt.UserDlg.ErrorOK(MensErro);
    EcfDm.ECF.Device.Desativar;
    PegarEstadoECF;
  end;

  if not EstaOKserieEGrandeTotal then
  begin
    Knt.UserDlg.ErrorOK('Número de série ou Grande Total não está igual ao do ECF!');
  end;
end;

procedure TPrincipalFrm.ConfigurarCamposDigitacao;
begin
  edtQuantidade.DecimalPlaces := EcfDm.ECF.Device.DecimaisQtd;
  edtSubtotal.DecimalPlaces := EcfDm.ECF.Device.DecimaisQtd;
end;

procedure TPrincipalFrm.CriarObjCupom;
begin
  EcfDm.Cupom := TCupom.create;
  EcfDm.Cupom.Oper.BuscarPorID(EcfDm.ECF.OpCupom);

//  with qCupom do
//  begin
//    Insert ;
//    FieldByName('id_filial').AsInteger := cls.nFilial;
//    FieldByName('id_operacao_cfop').AsInteger := EcfDm.Cupom.oOper.ID;
//    Post ;
//  end;

  EcfDm.Cupom.Coo := EcfDm.ECF.Device.NumCOO;
  EcfDm.Cupom.Gnf := EcfDm.ECF.Device.NumGNF;
  EcfDm.Cupom.Grg := EcfDm.ECF.Device.NumGRG;
  EcfDm.Cupom.Cdc := EcfDm.ECF.Device.NumCDC;
  EcfDm.Cupom.Ccf := EcfDm.ECF.Device.NumCCF;
  EcfDm.Cupom.data := EcfDm.ECF.Device.DataHora;
  EcfDm.Cupom.IDImpFiscal := EcfDm.Imp.ID;
  EcfDm.Cupom.Cedente := EcfDm.Cliente;
  EcfDm.Cupom.ID := 1;//qCupom.fieldByName('id_cf').asInteger;
  EcfDm.Cupom.GravarTbl;

end;

function TPrincipalFrm.EstaOKserieEGrandeTotal(const EmiteMensagem: Boolean =
    false): Boolean;
var NumSerie     : string;
    GT           : Real;
    //aNumSerie   : array[1..4] of string;
    //aNumGT      : array[1..4] of Real;
    IniNumSerie  : string;
    IniGT        : real;
    Encontrou    : boolean;
    i             : integer;
begin
  Encontrou  := false;

  try
    NumSerie := EcfDm.ECF.Device.NumSerie;
    GT := EcfDm.ECF.Device.GrandeTotal;

    EcfDm.Imp.IdxCipher := 0;

    for i := 1 to 4 do
    begin
      IniNumSerie := cphImpressora.DecodeString(AnsiString(Cipher),
        AnsiString(iniStr.ReadString(posSerie[i], '')));
      IniGT := StrToFloatDef(cphImpressora.DecodeString(AnsiString(Cipher),
        AnsiString(iniStr.ReadString(posGT[i], '0'))), 0);

      if (not Encontrou) and (NumSerie = IniNumSerie) then
      begin
        Encontrou := GT = IniGT;
        EcfDm.Imp.IdxCipher := i;
      end;
    end;

    if not Encontrou then
    begin
      edtAviso.Text := 'Erro - '+NumSerie+'  -  '+FloatToStr(GT);
      if EmiteMensagem then
      begin
        Knt.UserDlg.ErrorOK('Número de série ou Grande Total não está igual ao do ECF!');
      end;
    end;
  except
    Raise;
    //btnCancelaCupom.SetFocus;
  end;
  result := Encontrou;

end;

procedure TPrincipalFrm.FecharCupom1Click(Sender: TObject);
begin
  if Enabled then
  begin
    if ((EcfDm.ECF.Device.Subtotal > 0) and (EcfDm.Cupom <> nil)) then
    begin
      LimparDados;

      if FechamentoFrm = nil then Application.CreateForm(TFechamentoFrm, FechamentoFrm);

      FechamentoFrm.ShowModal ;
      if FechamentoFrm.PodeFinalizarCupom then
      begin
        FinalizarObj;
        LimparDados;
      end;

      FreeAndNil(FechamentoFrm);
    end
    else
    begin
      Knt.UserDlg.ErrorOK('É necessário ter pelo menos um item em um cupom aberto.');
    end;
  end;
end;

procedure TPrincipalFrm.FinalizarObj;
begin
  FreeAndNil(EcfDm.Cupom);
  FreeAndNil(EcfDm.Cliente);
end;

procedure TPrincipalFrm.FormActivate(Sender: TObject);
begin
  if MensModalFrm = nil then
    Application.CreateForm(TMensModalFrm, MensModalFrm);
end;

procedure TPrincipalFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  EstImp     : TACBrECFEstado;
  PodeFecha  : Boolean;
begin
  PodeFecha := false;
  EstImp := EcfDm.ECF.Device.Estado;
  if EstImp in [estLivre, estNaoInicializada, estDesconhecido, estLivre,
    estBloqueada, estRequerZ, estRequerX] then
  begin
    PodeFecha := Knt.UserDlg.ConfirmationYesNo('Deseja finalizar o sistema?');
  end
  else
  begin
    Knt.UserDlg.ErrorOK('Não pode fechar o sistema no estado:' + ECFEstados[EstImp]);
  end;
  CanClose := PodeFecha;
end;

procedure TPrincipalFrm.FormShow(Sender: TObject);
var i : integer;
begin
  Application.OnException := TrataErros ;
  LimparDados;
  ConfigurarCamposDigitacao;
  EcfDm.ECF.PodeDescontoUnitario := false;
  VerificarCupomAbertoECancela();

end;

procedure TPrincipalFrm.GravarGrandeTotalINI;
begin
  iniStr.WriteString(posGT[EcfDm.Imp.IdxCipher],
    cphImpressora.EncodeString(Cipher,FloatToStr(EcfDm.ECF.Device.GrandeTotal)));
end;

procedure TPrincipalFrm.InserirItem(const forcaBusca: Boolean);
begin
  if EstaOKserieEGrandeTotal(true) then
  begin
    Enabled := false;
    try
      edtAviso.Text := '';
      edtCodigo.Enabled := false;
      if (EcfDm.ECF.Device.Estado = estLivre)then
      begin
        AbrirCupomFiscal;
      end;

      VerificarCupomAbertoECancela(EcfDm.ECF.Device.Estado);

      if EcfDm.ECF.Device.Estado = estVenda then
      begin
        BuscarProduto(forcaBusca);
      end;

    finally
      GravarGrandeTotalINI;
      Enabled := true;
      edtCodigo.Color := clWindow;
      EcfDm.ECF.PodeDescontoUnitario := false;
      LimparDados;
    end;
  end;
end;

procedure TPrincipalFrm.LimparBobina;
begin
  mBobina.Clear ;
  wbBobina.Navigate('about:blank');
end;

procedure TPrincipalFrm.LimparDados;
var impEst : TACBrECFEstado;
begin
  edtQuantidade.Value  := 1;
  edtCodigo.Text       := '';

  //edtVlrUnitario.Value := 0;
  //edtVlrTotal.Value    := 0;

  //edtCodigo.EmptyText  := '';
  edtCodigo.Enabled    := false;
  edtPrecoTotal.Value  := 0;

  MenuFiscal1.Enabled := false;
  //Operaes1.Enabled    := false;
  //Acoes1.Enabled      := false;
  BloqueiarAcoes(false);

  impEst := EcfDm.ECF.Device.Estado;

  case impEst of
    estLivre :
    begin
       lblDescricao.Caption := 'CAIXA LIVRE';
       edtCliente.Enabled := true;
       edtCliente.Text := 'CONSUMIDOR FINAL';
       btnBuscaCliente.Enabled := true;
       MenuFiscal1.Enabled := true;
       //Operaes1.Enabled    := true;
       edtSubtotal.Value    := 0;
       edtCodigo.Enabled    := true;
       ColocarFocoPrimeiroComp;
       FreeAndNil(EcfDm.Cliente);
       edtAviso.Text := '';
       //Acoes1.Enabled      := true;
       BloqueiarAcoes(true);
    end;
    estRequerZ,estRequerX:
    begin
      //lblDescricao.Caption.Text := ECFEstados[ EcfDm.ECF.Device.Estado ];
      PegarEstadoECF;
      edtCliente.Enabled := false;
      btnBuscaCliente.Enabled := false;
      MenuFiscal1.Enabled := true;
      //Operaes1.Enabled    := true;
    end;
    estNaoInicializada :
    begin
      MenuFiscal1.Enabled := true;
    end;
    estBloqueada:
    begin
      MenuFiscal1.Enabled := true;
    end
    else
    begin
      lblDescricao.Caption := '';
      edtCliente.Enabled := false;
      btnBuscaCliente.Enabled := false;
      edtCodigo.Enabled   := true;
      ColocarFocoPrimeiroComp;
      //Acoes1.Enabled      := true;
      BloqueiarAcoes(true);

      //edtAviso.Text := '';
    end;
  end;
end;

procedure TPrincipalFrm.MudaHorriodeVero1Click(Sender: TObject);
begin
  if Knt.UserDlg.ConfirmationYesNo('Deseja mudar o horário do ECF?') then
  begin
    if Knt.UserDlg.ConfirmationYesNo('Está operação só possível novamente na próxima redução Z.') then
    begin
      if Knt.UserDlg.ConfirmationYesNo('Confirma está operação irreversível até a próxima redução Z?') then
      begin
        EcfDm.ECF.Device.MudaHorarioVerao();
      end;
    end;
  end;
end;

procedure TPrincipalFrm.PegarEstadoECF;
begin
  try
    lblDescricao.Caption := ECFEstados[ EcfDm.ECF.Device.Estado ] ;
  except
    Caption := Application.Name;
  end ;
end;

procedure TPrincipalFrm.ProcurarProduto1Click(Sender: TObject);
begin
  if Enabled then
  begin
    try
      if EcfDm.ECF.Device.Estado in [estBloqueada,estRequerZ ] then
      begin
        Knt.UserDlg.ErrorOK('O ECF está bloqueado.');
        if ProdutoPesquisaFrm = nil then
          Application.CreateForm(TProdutoPesquisaFrm, ProdutoPesquisaFrm);
        ProdutoPesquisaFrm.ShowModal;
        FreeAndNil(ProdutoPesquisaFrm);
      end
      else
      begin
        InserirItem(True);
      end;
    except
      raise;
    end;
  end;
end;

procedure TPrincipalFrm.Sangria1Click(Sender: TObject);
begin
  if EcfDm.ECF.EstaOK([estLivre]) then
  begin
    if MovimentacaoCaixaFrm = nil then
      Application.CreateForm(TMovimentacaoCaixaFrm, MovimentacaoCaixaFrm);

    MovimentacaoCaixaFrm.TipoMovimentacao := 2;
    MovimentacaoCaixaFrm.ShowModal ;

    FreeAndNil(MovimentacaoCaixaFrm);
  end;
end;

procedure TPrincipalFrm.Suprimento1Click(Sender: TObject);
begin
  if EcfDm.ECF.EstaOK([estLivre]) then
  begin
    if MovimentacaoCaixaFrm = nil then
      Application.CreateForm(TMovimentacaoCaixaFrm, MovimentacaoCaixaFrm);

    MovimentacaoCaixaFrm.TipoMovimentacao := 1;
    MovimentacaoCaixaFrm.ShowModal ;

    FreeAndNil(MovimentacaoCaixaFrm);
  end;
end;

procedure TPrincipalFrm.VerificarCupomAbertoECancela(Estado: TACBrECFEstado =
    estDesconhecido);
begin
  if EcfDm.Cupom = nil then
  begin
    if Estado = estDesconhecido then
      Estado := EcfDm.ECF.Device.Estado;

    if (Estado in[estVenda,estpagamento]) then
    begin
      Knt.UserDlg.WarningOK('A venda do cupom ' + EcfDm.ECF.Device.NumCOO +
        ' foi interrompida. O cupom será cancelado.');
      //EcfDm.ECF.Device.CancelaCupom ;
      CancelarCupom(false);
      LimparDados;
    end;
  end;
end;

end.
