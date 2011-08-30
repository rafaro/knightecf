unit MenuFiscalU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TMenuFiscalFrm = class(TForm)
    pnlSelecao: TPanel;
    btnLeituraX: TButton;
    btnLeituraMemoriaFiscalCompleta: TButton;
    btnCancelaCupom: TButton;
    btnTabProd: TButton;
    btnLeituraMemoriaFiscalSimples: TButton;
    btnEspelhoMFD: TButton;
    btnArqMFD: TButton;
    btnEstoque: TButton;
    btnMovimentoPorECF: TButton;
    btnMeiosDePagto: TButton;
    btnVendasPeriodo: TButton;
    btnLeReducao: TButton;
    btnDAVEmitidos: TButton;
    btnIdentificacaoPAFECF: TButton;
    btnTabIndiceTecProd: TButton;
    pnlFiltro: TPanel;
    pgrPeriodo: TPageControl;
    pgData: TTabSheet;
    Label4: TLabel;
    edtDtInicio: TDateTimePicker;
    edtDtFim: TDateTimePicker;
    pgCRZ: TTabSheet;
    Label1: TLabel;
    edtCRZInicio: TEdit;
    edtCRZFim: TEdit;
    pgCOO: TTabSheet;
    Label2: TLabel;
    edtCOOInicio: TEdit;
    edtCOOFim: TEdit;
    rdGrpSaida: TRadioGroup;
    edtArquivo: TEdit;
    procedure btnArqMFDClick(Sender: TObject);
    procedure btnCancelaCupomClick(Sender: TObject);
    procedure btnDAVEmitidosClick(Sender: TObject);
    procedure btnEspelhoMFDClick(Sender: TObject);
    procedure btnEstoqueClick(Sender: TObject);
    procedure btnIdentificacaoPAFECFClick(Sender: TObject);
    procedure btnLeituraMemoriaFiscalCompletaClick(Sender: TObject);
    procedure btnLeituraMemoriaFiscalSimplesClick(Sender: TObject);
    procedure btnLeituraXClick(Sender: TObject);
    procedure btnLeReducaoClick(Sender: TObject);
    procedure btnMeiosDePagtoClick(Sender: TObject);
    procedure btnMovimentoPorECFClick(Sender: TObject);
    procedure btnTabIndiceTecProdClick(Sender: TObject);
    procedure btnTabProdClick(Sender: TObject);
    procedure btnVendasPeriodoClick(Sender: TObject);
    procedure rdGrpSaidaClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure EmitirLeituraMemoriaFiscal(const Simples:boolean=false);
    procedure HabilitarComponentes(ToPage: Integer = -1);
  end;

var
  MenuFiscalFrm: TMenuFiscalFrm;

implementation

uses
  EcfU, knight, ACBrPAF_P, SqlExpr, UtilsU, StrUtils, SelecaoImpressoraU,
  ACBrDevice;

{$R *.dfm}

procedure TMenuFiscalFrm.btnArqMFDClick(Sender: TObject);
begin
  Enabled := false;
  try
    try
      case pgrPeriodo.ActivePageIndex of

        0: EcfDm.ECF.Device.ArquivoMFD_DLL(edtDtInicio.Date,edtDtFim.Date,edtArquivo.Text);
        2: EcfDm.ECF.Device.ArquivoMFD_DLL(StrToIntDef(edtCOOInicio.Text,-1),StrToIntDef(edtCOOFim.Text,-1),edtArquivo.Text);
      end;
      EcfDm.ECF.EAD.AssinarArquivoComEAD(edtArquivo.Text);
    except
      on E : Exception do
        Knt.UserDlg.ErrorOK(E.ClassName+': '+E.Message);
    end;
  finally
    Enabled := true;
    SetFocus;
  end;
end;

procedure TMenuFiscalFrm.btnCancelaCupomClick(Sender: TObject);
var ImpData : TDateTime;
begin
  try
    try
      Enabled := false;
      if EcfDm.ECF.Device.Estado <> estRequerZ then
      begin
        if not Knt.UserDlg.ConfirmationYesNo('A Redução Z pode Bloquear o seu ECF até a 12:00pm'+#10+#10+
                    'Continua assim mesmo ?') then
        begin
          exit ;
        end;

        if not Knt.UserDlg.ConfirmationYesNo('Você tem certeza ?') then
          exit ;
      end ;

      ImpData := EcfDm.ECF.Device.DataHora;
      EcfDm.ECF.LerReducaoZ;
      EcfDm.ECF.Device.ReducaoZ();
      //EcfDm.EmitirMovimentoPorEcf(ImpData,ImpData,EcfDm.I  IdImp);
      //FrmPrincipal.emissaoPorEcf(ImpData,ImpData,FrmPrincipal.oImp.nID,true);
    except
      on E : Exception do
        Knt.UserDlg.ErrorOK(E.ClassName+': '+E.Message);
    end;
  finally
    Enabled := true;
  end;
end;

procedure TMenuFiscalFrm.btnDAVEmitidosClick(Sender: TObject);
begin
  if rdGrpSaida.ItemIndex = 0 then
  begin
    EcfDm.ECF.Device.AbreRelatorioGerencial();
    EcfDm.ECF.Device.LinhaRelatorioGerencial( '*** Relatorio Gerencial - DAV Emitidos ***' );
    EcfDm.ECF.Device.LinhaRelatorioGerencial( 'Nao ha DAV emitido' );
    EcfDm.ECF.Device.LinhaRelatorioGerencial( '*** Relatorio Gerencial - DAV Emitidos ***' );
    EcfDm.ECF.Device.FechaRelatorio;
  end
  else
  begin
    EcfDm.PAF.CarregarRegistroTipo1(tpfD, EcfDm.Filial, EcfDm.SoftHs);
    EcfDm.ProgressFrm.InitValues(0,5,1,0,'ECF - Processando...','Gerando arquivos de movimentação');
    EcfDm.ProgressFrm.Show;
    try
      Enabled := false;
      EcfDm.ProgressFrm.Position := EcfDm.ProgressFrm.Position +1;
    finally
      EcfDm.ProgressFrm.Hide;
      Enabled := true;
      SetFocus;
    end;
    EcfDm.PAF.SalvarRegistrosPAF(tpfD, edtArquivo. Text, True);
  end;
end;

procedure TMenuFiscalFrm.btnEspelhoMFDClick(Sender: TObject);
begin
  Enabled := false;
  try
    try
      case pgrPeriodo.ActivePageIndex of
        0: EcfDm.ECF.Device.EspelhoMFD_DLL(edtDtInicio.Date,edtDtFim.Date,
          edtArquivo.Text);
        2: EcfDm.ECF.Device.EspelhoMFD_DLL(StrToIntDef(edtCOOInicio.Text,-1),
          StrToIntDef(edtCOOFim.Text,-1),edtArquivo.Text);
      end;
      EcfDm.ECF.EAD.AssinarArquivoComEAD(edtArquivo.Text);
    except
      on E : Exception do
        Knt.UserDlg.ErrorOK(E.ClassName + ': ' + E.Message);
    end;
  finally
    Enabled := true;
    SetFocus;
  end;
end;

procedure TMenuFiscalFrm.btnEstoqueClick(Sender: TObject);
var
  Qr: TSQLQuery;
  Str: string;
begin
  // registro E1
  EcfDm.PAF.CarregarRegistroTipo1(tpfE, EcfDm.Filial, EcfDm.SoftHs);
  // registro E2
  Str :=
  ' SELECT '+
  '   max(cad_produtos.pro_codigo) as codigo, '+
  '   max(cad_produtos.pro_descricao) as descricao, '+
  '   max(cad_unidade.und_sigla) as sigla, '+
  '   est_local.id_produto, sum(est_local.est_quantidade) as quant, '+
  '   max(est_data) as data '+
  ' FROM est_local '+
  ' JOIN cad_produtos ON est_local.id_produto = cad_produtos.id_produto '+
  ' JOIN cad_unidade ON cad_produtos.id_unidade_comercial = cad_unidade.id_unidade '+
  ' GROUP BY est_local.id_produto ';

  Qr := UtilsU.TabelaCreate(Str);
  try
    try
      Qr.Open;

      EcfDm.ProgressFrm.InitValues(0,Qr.RecordCount,1,0,'Ecf - Processando...','Gerando arquivos de movimentação');
      EcfDm.ProgressFrm.Show;

      Enabled := false;
      while not Qr.Eof do
      begin
        with EcfDm.PAF.Device.PAF_E.RegistroE2.New do
        begin
          COD_MERC  := Qr.fieldbyname('codigo').AsString;
          DESC_MERC := Qr.fieldbyname('descricao').AsString;
          UN_MED    := Qr.fieldbyname('sigla').AsString;
          QTDE_EST  := Qr.fieldbyname('quant').AsCurrency;
          DT_EST    := Qr.fieldbyname('data').AsDateTime;
        end;
        Application.ProcessMessages;
        EcfDm.ProgressFrm.Position := EcfDm.ProgressFrm.Position +1;
        Qr.Next;
      end;
    except
      on E : Exception do
        knt.UserDlg.ErrorOK(E.ClassName + ': ' + E.Message);
    end;
  finally
    EcfDm.ProgressFrm.Hide;
    Enabled := true;
    SetFocus;
  end;
  EcfDm.PAF.SalvarRegistrosPAF(tpfE, edtArquivo.Text, True);
end;

procedure TMenuFiscalFrm.btnIdentificacaoPAFECFClick(Sender: TObject);
var
  Str : TStringList;
  i    : integer;
begin
  Str := TStringList.Create;
  try
    try
      Enabled := false;
      Str.Append('IDENTIFICACAO DO PAF-ECF');
      with EcfDm.SoftHs do
      begin
        Str.Append('No do laudo:'+NumLaudo);
        Str.Append('Empresa desenvolvedora:'+Nome+'-'+CNPJ);
        Str.Append(Endereco+' tel:'+Telefone+'; Contato:'+NomePessoaContato);
        Str.Append('PAF-ECF:'+PAFECFNomeComercial+'- '+PAFECFVersao );
        Str.Append('Exec:'+PAFECFPrincExec+'-'+PAFECFMD5Exec);
        Str.Append('Aquivos :');


        for i :=0 to PAFECFArqsMD5.Count-1 do
        begin
         Str.Append(PAFECFArqsMD5[i]);
        end;

      end;
      EcfDm.ECF.Device.RelatorioGerencial(Str);

    except
      on E : Exception do
        Knt.UserDlg.ErrorOK(E.ClassName + ': ' + E.Message);
    end;
  finally
    Enabled := true;
    SetFocus;
  end;
end;

procedure TMenuFiscalFrm.btnLeituraMemoriaFiscalCompletaClick(Sender: TObject);
begin
  Enabled := false;
  try
    try
      EmitirLeituraMemoriaFiscal();
    except
      on E : Exception do
        knt.UserDlg.ErrorOK(E.ClassName + ': ' + E.Message);
    end;
  finally
    Enabled := true;
    SetFocus;
  end;
end;

procedure TMenuFiscalFrm.btnLeituraMemoriaFiscalSimplesClick(Sender: TObject);
begin
  Enabled := false;
  try
    try
      EmitirLeituraMemoriaFiscal(true);
    except
      on E : Exception do
        Knt.UserDlg.ErrorOK(E.ClassName + ': ' + E.Message);
    end;
  finally
    Enabled := true;
    SetFocus;
  end;
end;

procedure TMenuFiscalFrm.btnLeituraXClick(Sender: TObject);
begin
  Enabled := false;
  try
    try
      EcfDm.ECF.Device.LeituraX;
    except
      on E : Exception do
        Knt.UserDlg.ErrorOK(E.ClassName + ': ' + E.Message);
    end;
  finally
    Enabled := true;
    SetFocus;
  end;
end;

procedure TMenuFiscalFrm.btnLeReducaoClick(Sender: TObject);
begin
  try
    Enabled := false;
    EcfDm.ECF.LerReducaoZ;
  finally
    Enabled := true;
    SetFocus;
  end;
end;

procedure TMenuFiscalFrm.btnMeiosDePagtoClick(Sender: TObject);
var
  Str: TStringList;
  Sql: string;
  Qr: TSQLQuery;
  Data: TDateTime;
  Pag: TDateTime;
  Fiscal: boolean;
  Valor: Currency;
  TotFiscal: Currency;
  TotNaoFiscal: Currency;
begin
  Sql :=
  ' SELECT '+
  '   cad_forma_pagamento.pag_descricao, ''F'' as tipopagto, '+
  '   fat_cf.cf_data as data, sum(fat_cf_pagto.cfpg_valor) as  valor '+
  ' FROM '+
  '   fat_cf_pagto '+
  ' JOIN cad_forma_pagamento ON fat_cf_pagto.id_forma_pagamento = cad_forma_pagamento.id_forma_pagamento '+
  ' JOIN fat_cf ON fat_cf_pagto.id_cf = fat_cf.id_cf '+
  ' WHERE fat_cf.cf_datacancelamento IS NULL AND fat_cf.cf_data BETWEEN :dinicio AND :dfinal '+
  ' GROUP BY 1,2,3 '+
  ' UNION ALL '+
  ' SELECT '+
  '   cad_forma_pagamento.pag_descricao, ''N'' as tipopagto, '+
  '   cai_cf_movcaix.mv_data as data, sum(cai_cf_movcaix.mv_valor) as  valor '+
  ' FROM '+
  '   cai_cf_movcaix '+
  ' JOIN cad_forma_pagamento ON cai_cf_movcaix.id_forma_pagamento = cad_forma_pagamento.id_forma_pagamento '+
  ' WHERE  cai_cf_movcaix.mv_data BETWEEN :dinicio AND :dfinal '+
  ' GROUP BY 1,2,3 '+
  ' ORDER BY 3,1 ';
  Qr := UtilsU.tabelaCreate(Sql);
  Qr.ParamByName('dinicio').AsDateTime := StrToDateTime( FormatDateTime(ShortDateFormat,edtDtInicio.Date)+' 00:00:00');
  Qr.ParamByName('dfinal').AsDateTime  := StrToDateTime( FormatDateTime(ShortDateFormat,edtDtFim.Date)+' 23:59:59');

  Data         := 0;
  TotFiscal    := 0;
  TotNaoFiscal := 0;
  Enabled  := false ;

  try
    try
      Qr.Open;
      Str := TStringList.Create;
      Str.Append('Meios de Pagamento');
      Str.Append('');

      while not Qr.Eof do
      begin
        Pag :=  int(Qr.FieldByName('data').AsDateTime);
        if Data <> Pag then
        begin
          Data := Pag;
          Str.Append('----------------------------------------');
          Str.Append('DATA '+DateToStr(Pag));
          Str.Append('----------------------------------------');
        end;
        Fiscal := Qr.fieldbyname('tipopagto').AsString = 'F';
        Valor := Qr.fieldbyname('valor').AsCurrency;

        Str.Append(
          LeftStr(Qr.fieldbyname('pag_descricao').AsString, 25)+' '+
          IfThen(Fiscal, 'FISCAL', 'NAO FISCAL')+' R$ '+
          FormatFloat('0.00',Valor)
          );
        if Fiscal then
        begin
          TotFiscal := TotFiscal + Valor;
        end
        else
        begin
           TotNaoFiscal := TotNaoFiscal + Valor;
        end;
        Qr.Next;
      end;
      Str.Append('----------------------------------------');
      Str.Append('TOTAL FISCAL     R$ '+ FormatFloat('0.00',TotFiscal));
      Str.Append('TOTAL NAO FISCAL R$ '+ FormatFloat('0.00',TotNaoFiscal));

      EcfDm.ECF.Device.RelatorioGerencial(Str);
    except
      on E : Exception do
        Knt.UserDlg.ErrorOK(E.ClassName + ': ' + E.Message);
    end;
  finally
    Enabled := true;
    SetFocus;
  end;
end;

procedure TMenuFiscalFrm.btnMovimentoPorECFClick(Sender: TObject);
var IdImp : integer;
begin
 if SelecaoImpressoraFrm = nil then
    Application.CreateForm(TSelecaoImpressoraFrm, SelecaoImpressoraFrm);

  SelecaoImpressoraFrm.ShowModal;

  IdImp := SelecaoImpressoraFrm.IdImpressora;

  FreeAndNil(SelecaoImpressoraFrm);

  try
    Enabled := false;
    try
      EcfDm.EmitirMovimentoPorEcf(edtDtInicio.Date, edtDtFim.Date, IdImp);
    except
      on E : Exception do
        Knt.UserDlg.ErrorOK(E.ClassName+': '+E.Message);
    end;
  finally
    Enabled := true;
    SetFocus;
  end;
end;

procedure TMenuFiscalFrm.btnTabIndiceTecProdClick(Sender: TObject);
var
  Qr   : TSQLQuery;
  Str  : string;
  IDProd     : Integer;
  IDProdAnt  : Integer;
  Linha      : string;
  ListaStr        : TStringList;
begin
  Str :=
  ' SELECT cad_produtos.id_produto,cad_produtos.pro_codigo, cad_produtos.pro_descricao, '+
  '   prod_comp.id_produto AS id_produto_comp,prod_comp.pro_codigo AS pro_codigo_comp, '+
  '   prod_comp.pro_descricao AS pro_descricao_comp, '+
  '   cad_composicao_produto.com_quantidade, COALESCE(saldoproduto.quantidade,0) AS quant_estoque '+
  ' FROM cad_produtos '+
  ' JOIN cad_composicao_produto ON cad_produtos.id_produto = cad_composicao_produto.id_produto '+
  ' JOIN cad_produtos AS prod_comp ON cad_composicao_produto.id_produto_composicao = prod_comp.id_produto '+
  ' LEFT JOIN saldoproduto ON cad_composicao_produto.id_produto_composicao = saldoproduto.produto '+
  ' WHERE cad_produtos.pro_composto = 1 '+
  ' ORDER BY cad_composicao_produto.id_produto, cad_composicao_produto.id_produto_composicao ';

  Qr := TabelaCreate(Str);
  IDProdAnt := -1;
  Enabled  := false ;

  try
    try
      Qr.Open;
      ListaStr := TStringList.Create;
      ListaStr.Append('TAB. INDICE TECNICO DE PRODUCAO');
      ListaStr.Append('');

      while not Qr.Eof do
      begin
        IDProd :=  Qr.FieldByName('id_produto').asinteger;

        if IDProdAnt <> IDProd then
        begin
          IDProdAnt := IDProd;
          ListaStr.Append('');
          ListaStr.Append(Knt.Str.RepeatChar(47, '-'));
          ListaStr.Append(
            'PRODUTO '+
            Knt.Str.RightFit(
              Qr.FieldByName('pro_codigo').asstring
              +'-'+
              Qr.FieldByName('pro_descricao').asstring, 29));
          ListaStr.Append(Knt.Str.RepeatChar(47, '-'));
          ListaStr.Append('INDICE TECNICO');
          ListaStr.Append(Knt.Str.RepeatChar(47, '-'));
          ListaStr.Append(
            Knt.Str.RightFit('PRODUTO', 27)+
            Knt.Str.RepeatChar(1)+
            Knt.Str.LeftFit('QUANT', 8, ' ')+
            Knt.Str.RepeatChar(1)+
            Knt.Str.LeftFit('ESTOQUE', 10, ' '));
          ListaStr.Append(Knt.Str.RepeatChar(47, '-'));
        end;
        Linha := '';
        Str := Qr.FieldByName('pro_codigo_comp').asstring+'-'+Qr.FieldByName('pro_descricao_comp').asstring;
        Linha := Linha + Knt.Str.RightFit(Str,27)+Knt.Str.RepeatChar(1);

        Str := Knt.Str.LeftFit(Qr.FieldByName('com_quantidade').AsCurrency,8,' ')+Knt.Str.RepeatChar(1);
        Linha := Linha + Str;

        Str := Knt.Str.LeftFit(Qr.FieldByName('quant_estoque').AsCurrency,10,' ');
        Linha := Linha + Str;

        ListaStr.Append(Linha);

        Qr.Next;
      end;
      if rdGrpSaida.ItemIndex = 0 then
      begin
        EcfDm.ECF.Device.RelatorioGerencial(ListaStr);
      end
      else
      begin
        ListaStr.SaveToFile(edtArquivo.Text);
        EcfDm.ECF.EAD.AssinarArquivoComEAD(edtArquivo.Text);
      end;
    except
      on E : Exception do
        Knt.UserDlg.ErrorOK(E.ClassName+': '+E.Message);
    end;
  finally
    Enabled := true;
    SetFocus;
  end;
end;

procedure TMenuFiscalFrm.btnTabProdClick(Sender: TObject);
var
  P2: TRegistroP2;
  Qr : TSQLQuery;
  Str : string;
begin
  //BlockInput(true);
  Enabled := false;
  try
    try
      // registro P1
      EcfDm.PAF.CarregarRegistroTipo1(tpfP, EcfDm.Filial, EcfDm.SoftHs);
      // registro P2
      EcfDm.PAF.Device.PAF_P.RegistroP2.Clear;
      Str :=
        ' SELECT '+
        ' cad_produtos.pro_codigo, '+
        ' cad_produtos.pro_descricao, '+
        ' cad_unidade.und_sigla, '+
        ' '+QuotedStr('A')+' as indicadorAT, '+
        ' CASE cad_cst.cst_classificacao '+
        '     WHEN 0 THEN '+
        '        ''T'' '+
        '     WHEN 1 THEN '+
        '        ''I'' '+
        '     WHEN 2 THEN '+
        '        ''F'' '+
        '     WHEN 3 THEN '+
        '        ''T'' '+
        '     WHEN 4 THEN '+
        '        ''N'' '+
        '     ELSE ''I'' '+
        ' END as cst_cod_cst, '+
        ' CASE cad_produtos.pro_produzido '+
        '     WHEN 0 THEN '+
        '        '+QuotedStr('T')+
        '     WHEN 1 THEN '+
        '        '+QuotedStr('P')+
        ' END as pro_produzido_desc, '+
        ' cad_tributacao_produto.tri_icms_aliquota, '+
        ' cad_produtos.id_produto, '+
        ' cad_produtos.id_unidade_comercial,  '+
        ' cad_produtos.pro_preco_venda,  '+
        ' cad_produtos.pro_produzido, '+
        ' cad_produtos.id_cst '+
        ' FROM cad_produtos  '+
        ' LEFT JOIN cad_unidade ON cad_produtos.id_unidade_comercial = cad_unidade.id_unidade '+
        ' LEFT JOIN cad_tributacao_produto ON cad_produtos.id_produto = cad_tributacao_produto.id_produto  '+
        ' LEFT JOIN cad_cst ON cad_produtos.id_cst = cad_cst.id_cst ';

      Qr := UtilsU.TabelaCreate(Str);

      with Qr do
      begin
        Open ;
        EcfDm.ProgressFrm.InitValues(0,Qr.RecordCount,1,0,'Gerando arquivo','Por favor aguarde');
        EcfDm.ProgressFrm.Show;

        while not Eof do
        begin
          EcfDm.ProgressFrm.Position := EcfDm.ProgressFrm.Position + 1;
          P2:=EcfDm.PAF.Device.PAF_P.RegistroP2.New;
          P2.COD_MERC_SERV :=fieldbyname('pro_codigo').AsString;
          P2.DESC_MERC_SERV:=fieldbyname('pro_descricao').AsString;
          P2.UN_MED        :=fieldbyname('und_sigla').AsString;
          P2.IAT           :=fieldbyname('indicadorAT').AsString;
          P2.IPPT          :=fieldbyname('pro_produzido_desc').AsString;
          P2.ST            :=fieldbyname('cst_cod_cst').AsString;
          P2.ALIQ          :=fieldbyname('tri_icms_aliquota').AsCurrency;
          P2.VL_UNIT       :=fieldbyname('pro_preco_venda').AsCurrency;
          Application.ProcessMessages;
          Next;
        end;
      end;
      //FrmPrincipal.PAF.Path := ExtractFilePath(edtArquivo.Text);
      //FrmPrincipal.PAF.SaveFileTXT_P(ExtractFileName(edtArquivo.FileName));
      EcfDm.PAF.SalvarRegistrosPAF(tpfP, edtArquivo.Text, true);
    except
      on E : Exception do
        knt.UserDlg.ErrorOK(E.ClassName + ': ' + E.Message);
    end;
  finally
    //BlockInput(false);
    EcfDm.ProgressFrm.Hide;
    Enabled := true;
    SetFocus;
  end;
end;

procedure TMenuFiscalFrm.btnVendasPeriodoClick(Sender: TObject);
var Sint: TSintegra;
  SPED: TSPEDFiscal;
begin
  SPED := TSPEDFiscal.Create(EcfDm.ACBrSPEDFiscal);
  Sint := TSintegra.Create(EcfDm.ACBrSintegra);

  try
    Enabled := false;

    SPED.DataInicio := edtDtInicio.Date;
    SPED.DataFim    := edtDtFim.Date;
    SPED.Diretorio  := Knt.Str.AppDirectory + '\sped';
    SPED.Arquivo    := EcfDm.SoftHs.GerarNomeArquivo;
    SPED.Laudo      := EcfDm.SoftHs.NumLaudo;
    SPED.GerarRegistros;

    Sint.DataInicio := edtDtInicio.Date;
    Sint.DataFim    := edtDtFim.Date;
    Sint.Diretorio  := Knt.Str.AppDirectory + '\sintegra\' + EcfDm.SoftHs.GerarNomeArquivo;
    Sint.GerarRegistros;
  finally
    Enabled := true;
    SetFocus;
    Sint.Free;
    SPED.Free;
  end;
end;

procedure TMenuFiscalFrm.EmitirLeituraMemoriaFiscal(const Simples: boolean);
begin
  if rdGrpSaida.ItemIndex = 0 then
  begin
    case pgrPeriodo.ActivePageIndex of
      0: EcfDm.ECF.Device.LeituraMemoriaFiscal(edtDtInicio.Date,edtDtFim.Date,Simples);
      1: EcfDm.ECF.Device.LeituraMemoriaFiscal(StrToIntDef(edtCRZInicio.Text,-1),StrToIntDef(edtCRZFim.Text,-1),Simples);
    end;
  end
  else
  begin
    case pgrPeriodo.ActivePageIndex of
      0: EcfDm.ECF.Device.LeituraMemoriaFiscalSerial(edtDtInicio.Date,edtDtFim.Date,edtArquivo.Text,Simples);
      1: EcfDm.ECF.Device.LeituraMemoriaFiscalSerial(StrToIntDef(edtCRZInicio.Text,-1),StrToIntDef(edtCRZFim.Text,-1),edtArquivo.Text,Simples);
    end;
    EcfDm.ECF.EAD.AssinarArquivoComEAD(edtArquivo.Text);
  end;
end;

procedure TMenuFiscalFrm.HabilitarComponentes(ToPage: Integer = -1);
var EhArquivo: Boolean;
begin
  EhArquivo := rdGrpSaida.ItemIndex = 1;

  if ToPage = -1 then
  begin
    ToPage := pgrPeriodo.ActivePageIndex;
  end;

  btnLeituraMemoriaFiscalCompleta.Enabled := ToPage in [0,1] ;
  btnLeituraMemoriaFiscalSimples.Enabled := ToPage in [0,1];

  btnArqMFD.Enabled     := (ToPage in [0,2]) and EhArquivo;
  btnEspelhoMFD.Enabled := (ToPage in [0,2]) and EhArquivo;

  btnMeiosDePagto.Enabled    := (ToPage in [0]) and NOT EhArquivo;
  btnMovimentoPorECF.Enabled := (ToPage in [0]) and EhArquivo;
  btnVendasPeriodo.Enabled   := (ToPage in [0]) and EhArquivo;
  btnDAVEmitidos.Enabled     := (ToPage in [0]);


//  btnIdentificacaoPAFECF.Enabled := NOT EhArquivo;
  btnTabProd.Enabled       := EhArquivo;
  btnEstoque.Enabled       := EhArquivo;

  edtArquivo.Enabled       := EhArquivo;
  btnIdentificacaoPAFECF.Enabled := NOT EhArquivo;
end;

procedure TMenuFiscalFrm.rdGrpSaidaClick(Sender: TObject);
begin
  HabilitarComponentes;
end;

end.
