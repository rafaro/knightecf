unit EcfU;

interface

uses
  SysUtils, Classes, ACBrTEFD, ACBrPAF, ACBrBase, ACBrECF, UtilsU, WideStrings,
  FMTBcd, DB, SqlExpr, Dialogs, JvBaseDlg, JvProgressDialog, ACBrEAD,
  JvComponentBase, JvAppStorage, JvAppIniStorage, ACBrSintegra, ACBrSpedFiscal;

type
  TEcfDm = class(TDataModule)
    ACBrECF: TACBrECF;
    ACBrPAF: TACBrPAF;
    ACBrTEF: TACBrTEFD;
    Con: TSQLConnection;
    Qry1: TSQLQuery;
    ProgressFrm: TJvProgressDialog;
    ACBrEAD: TACBrEAD;
    iniAliq: TJvAppIniFileStorage;
    ACBrSintegra: TACBrSintegra;
    ACBrSPEDFiscal: TACBrSPEDFiscal;
  private
  public
    Cliente: TCedente;
    Cupom: TCupom;
    ECF: TECF;
    Imp: TImpFiscal;
    TEF: TTEF;
    Filial: TFilial;
    PAF: TPAF;
    SoftHs: TSoftHouse;
    procedure EmitirMovimentoPorEcf(DataInicial, DataFinal: TDateTime;
      IdImpFiscal: integer; ReducaoZ: boolean=False);
  end;

var
  EcfDm: TEcfDm;

implementation

uses
  knight, Forms;

{$R *.dfm}

{ TEcfDm }

procedure TEcfDm.EmitirMovimentoPorEcf(DataInicial, DataFinal: TDateTime;
  IdImpFiscal: integer; ReducaoZ: boolean);
var
  QrR2   : TSQLQuery;
  QrR3Icms   : TSQLQuery;
  QrR3ISSQN  : TSQLQuery;
  QrR4   : TSQLQuery;
  QrR4R7 : TSQLQuery;
  QrR5   : TSQLQuery;
  QrR6   : TSQLQuery;
  QrR6R7 : TSQLQuery;
  NumUsuario : integer;
  DataMov    : TDateTime;
  AliqFormat : string;
  ImpTemp    : TImpFiscal;
  NomeArq    : string;
  Mens   : String;
  GerouArq   : boolean;
begin

  GerouArq := false;
  ImpTemp := TImpFiscal.create;
  ImpTemp.BuscarPorID(IdImpFiscal);

  Mens := 'Deseja emitir para o ECF '+ImpTemp.NumFabricacao+ ' a movimentação do período '+DateToStr(DataInicial)+' à '+DateToStr(DataFinal)+'?';

  if (not ReducaoZ) and (not Knt.UserDlg.ConfirmationYesNo(Mens)) then
  begin
    Knt.UserDlg.WarningOK('O arquivo de movimentação não foi gerado.');
    exit;
  end;



  QrR2 :=UtilsU.TabelaCreate(
    ' SELECT '+
    '   fat_cf_redz.id_redz, fat_cf_redz.id_impfiscal,    fat_cf_redz.rdz_data_imp, '+
    '   fat_cf_redz.rdz_coo_inicial, fat_cf_redz.rdz_loja, fat_cf_redz.rdz_num_ecf, '+
    '   fat_cf_redz.rdz_data_mov,    fat_cf_redz.rdz_coo,rdz_gnf, '+
    '   fat_cf_redz.rdz_cro, fat_cf_redz.rdz_crz,  fat_cf_redz.rdz_ccf, '+
    '   fat_cf_redz.rdz_cfd,     fat_cf_redz.rdz_cdc, '+
    '   fat_cf_redz.rdz_grg,   fat_cf_redz.rdz_gnfc, '+
    '   fat_cf_redz.rdz_cfc,    fat_cf_redz.rdz_grandetotal,  fat_cf_redz.rdz_vendabruta, '+
    '   fat_cf_redz.rdz_cancelamentoicms,    fat_cf_redz.rdz_descontoicms,  fat_cf_redz.rdz_totalissqn, '+
    '   fat_cf_redz.rdz_cancelamentoissqn,   fat_cf_redz.rdz_descontoissqn, '+
    '   fat_cf_redz.rdz_vendaliquida,    fat_cf_redz.rdz_acrescimoicms, fat_cf_redz.rdz_acrescimoissqn, '+
    '   fat_cf_redz.rdz_sticms,  			   fat_cf_redz.rdz_isentoicms,    fat_cf_redz.rdz_naotribicms, '+
    '   fat_cf_redz.rdz_stissqn,  			 fat_cf_redz.rdz_isentoissqn,   fat_cf_redz.rdz_naotribissqn, '+
    '   fat_cf_redz.rdz_totoperacaonaofiscal,fat_cf_redz.rdz_tottroco,fat_cf_redz.id_filial '+
    ' FROM '+
    '   fat_cf_redz '+
    ' WHERE  '+
    '   fat_cf_redz.rdz_data_mov between :dinicio and :dfinal AND fat_cf_redz.id_impfiscal ='+IntToStr(IdImpFiscal));

  QrR3Icms  := UtilsU.TabelaCreate(
    ' SELECT  '+
    '   rcm_indice,  rcm_aliq,  rcm_total '+
    ' FROM '+
    '   fat_cf_redz_icms '+
    ' WHERE '+
    '   fat_cf_redz_icms.id_redz = :id_redz');

  QrR3ISSQN := UtilsU.TabelaCreate(
    ' SELECT  '+
    '   rqn_indice, rqn_aliq, rqn_total '+
    ' FROM '+
    '   fat_cf_redz_issqn '+
    ' WHERE '+
    '   fat_cf_redz_issqn.id_redz = :id_redz');

  QrR4 := UtilsU.TabelaCreate(
    ' SELECT '+
    '  fat_cf.id_cf, fat_cf.cf_ccf,fat_cf.cf_coo,fat_cf.cf_data,fat_cf.cf_total,fat_cf.cf_desconto, '+
    '  cad_cliente.cli_nome, cad_detalhe_cliente_fisica.dcf_cpf, cad_detalhe_cliente_juridica.dcj_cnpj, '+
    ' CASE '+
    '   WHEN fat_cf.cf_datacancelamento IS NULL THEN ''N'' '+
    '   ELSE ''S'' '+
    ' END AS cancelou, '+
    ' fat_cf.cf_datacancelamento '+
    ' FROM '+
    '   fat_cf '+
    ' JOIN cad_cliente ON cad_cliente.id_cliente = fat_cf.id_cliente '+
    ' LEFT JOIN cad_detalhe_cliente_fisica   on cad_cliente.id_cliente = cad_detalhe_cliente_fisica.id_cliente '+
    ' LEFT JOIN cad_detalhe_cliente_juridica on cad_cliente.id_cliente = cad_detalhe_cliente_juridica.id_cliente '+
    ' WHERE fat_cf.cf_data BETWEEN :dInicio and :dFinal AND fat_cf.id_impfiscal ='+IntToStr(IdImpFiscal));

  QrR5 := UtilsU.TabelaCreate(
    ' SELECT '+
    ' fat_cf_item.cfit_sequencia, cad_produtos.pro_codigo,cad_produtos.pro_descricao, '+
    ' fat_cf_item.cfit_quantidade,cad_unidade.und_sigla, cad_produtos.pro_preco_venda,   '+
    ' fat_cf_item.cfit_desconto_item, '+
    ' cad_cst.cst_classificacao, '+
    ' CASE cad_cst.cst_classificacao '+
    '   WHEN 0 THEN '+
    '  REPLACE( cast(cad_tributacao_produto.tri_icms_aliquota as varchar),''.'','''') '+
    '   WHEN 1 THEN '+
    '  ''I1'' '+
    '   WHEN 2 THEN '+
    '  ''F1'' '+
    '   WHEN 3 THEN '+
    '  REPLACE( cast(cad_tributacao_produto.tri_icms_aliquota as varchar),''.'','''') '+
    '   WHEN 4 THEN '+
    '  ''N1'' '+
    '   ELSE ''NC'' '+
    ' END as cst_cod_cst, '+
    ' CASE cfit_situacao '+
    ' 	WHEN 0 then ''N'' '+
    '   WHEN 1 THEN ''S'' '+
    ' END as it_situacao, '+
    ' ''A'' as indicadorAT, '+
    ' CASE cad_produtos.pro_produzido '+
    '   WHEN 0 THEN ''T'' '+
    '   WHEN 1 THEN ''P'' '+
    ' END as pro_produzido_desc '+
    ' FROM '+
    '   fat_cf_item '+
    ' LEFT JOIN cad_produtos ON cad_produtos.id_produto = fat_cf_item.id_produto '+
    ' LEFT JOIN cad_unidade ON cad_produtos.id_unidade_comercial = cad_unidade.id_unidade '+
    ' LEFT JOIN cad_cst ON cad_produtos.id_cst = cad_cst.id_cst '+
    ' LEFT JOIN cad_tributacao_produto ON cad_produtos.id_produto = cad_tributacao_produto.id_produto '+
    ' WHERE fat_cf_item.id_cf = :id_cf '+
    ' ORDER BY cad_produtos.pro_descricao ');

  QrR6 := UtilsU.TabelaCreate(
    ' SELECT '+
    '   cad_forma_pagamento.pag_descricao,  cai_cf_movcaix.mv_ccf,  cai_cf_movcaix.mv_valor, '+
    '   cai_cf_movcaix.mv_data,   cai_cf_movcaix.mv_coo,  cai_cf_movcaix.mv_gnf, '+
    '   cai_cf_movcaix.mv_grg,   cai_cf_movcaix.mv_cdc,  cai_cf_movcaix.mv_codigopaf, '+
    '   cai_cf_movcaix.mv_ccf '+
    ' FROM '+
    '   cai_cf_movcaix  '+
    ' LEFT JOIN cad_forma_pagamento ON cai_cf_movcaix.id_forma_pagamento = cad_forma_pagamento.id_forma_pagamento '+
    ' WHERE cai_cf_movcaix.mv_data BETWEEN :dinicio AND :dfinal AND cai_cf_movcaix.id_impfiscal ='+IntToStr(IdImpFiscal));

  QrR4R7 := UtilsU.TabelaCreate(
    ' SELECT '+
    '   fat_cf_pagto.cfpg_coo,fat_cf_pagto.cfpg_ccf,fat_cf_pagto.cfpg_gnf, '+
    '   cad_forma_pagamento.pag_descricao, '+
    '   fat_cf_pagto.cfpg_valor '+
    ' FROM '+
    '   fat_cf_pagto '+
    ' LEFT JOIN cad_forma_pagamento ON fat_cf_pagto.id_forma_pagamento =  cad_forma_pagamento.id_forma_pagamento '+
    ' WHERE fat_cf_pagto.id_cf = :id_cf ');

  //QrR2.ParamByName('dInicio').AsDateTime := StrToDateTime( FormatDateTime(ShortDateFormat,DataInicial)+' 00:00:00');
  //QrR2.ParamByName('dFinal').AsDateTime  := StrToDateTime( FormatDateTime(ShortDateFormat,DataFinal)+' 23:59:59');
  QrR2.ParamByName('dInicio').AsDate := DataInicial;
  QrR2.ParamByName('dFinal').AsDate  := DataFinal;
  QrR2.Open;

  if QrR2.Eof then
  begin
    Knt.UserDlg.WarningOK('Não há movimentação para o período');
  end
  else
  begin
    ProgressFrm.InitValues(0,QrR2.RecordCount,1,0,'ECF - Processando...','Gerando arquivos de movimentação');
    ProgressFrm.Show
  end;

  while not QrR2.Eof do
  begin
    PAF.CarregarRegistroTipo1(tpfR, Filial, SoftHs);
    with PAF.Device.PAF_R.RegistroR01 do
    begin
      NUM_FAB := ImpTemp.NumFabricacao;
      MF_ADICIONAL:= ImpTemp.MFAdicional;
      TIPO_ECF := ImpTemp.TipoECF;
      MARCA_ECF := ImpTemp.MarcaDoECF;
      MODELO_ECF := ImpTemp.ModeloECF;
      VERSAO_SB := ImpTemp.VersaoSB;// '010101';
      DT_INST_SB := ImpTemp.DataInstalacaoSB;
      HR_INST_SB := ImpTemp.HorarioInstalacaoSB;
      NUM_SEQ_ECF := StrToInt(ImpTemp.NumeroSequencialECF);
    end;

    NumUsuario := StrToInt(ImpTemp.Usuario);

    DataMov := QrR2.fieldbyname('rdz_data_mov').AsDateTime;
    with PAF.Device.PAF_R.RegistroR02.New do
    begin
      Application.ProcessMessages;

      NUM_USU := NumUsuario;
      CRZ := QrR2.fieldbyname('rdz_crz').AsInteger;
      COO := QrR2.fieldbyname('rdz_coo').AsInteger;
      CRO := QrR2.fieldbyname('rdz_cro').AsInteger;
      DT_MOV := DataMov;
      DT_EMI := QrR2.fieldbyname('rdz_data_imp').AsDateTime;
      HR_EMI := QrR2.fieldbyname('rdz_data_imp').AsDateTime;
      VL_VBD := QrR2.fieldbyname('rdz_vendabruta').AsCurrency;

      //Parâmetro do ECF para incidência de desconto sobre itens sujeitos ao ISSQN
      //conforme item 7.2.1.4
      PAR_ECF     := 'N';

      QrR3Icms.Close;
      QrR3Icms.ParamByName('id_redz').AsInteger := QrR2.fieldbyname('id_redz').AsInteger;
      QrR3Icms.Open;

      while not QrR3Icms.Eof do
      begin
        with RegistroR03.New do
        begin
          //xxTnnnn = Exemplo: 01T1800 (totalizador 01 com alíquota de18,00% de ICMS)]
          AliqFormat := Knt.Str.padL(Knt.Str.RemovePoint(QrR3Icms.fieldbyname('rcm_aliq').AsString),4,'0');
          TOT_PARCIAL :=QrR3Icms.fieldbyname('rcm_indice').AsString+'T'+AliqFormat;
          VL_ACUM :=QrR3Icms.fieldbyname('rcm_total').AsCurrency;
        end;
        QrR3Icms.Next;
      end;

      Application.ProcessMessages;

      QrR3ISSQN.Close;
      QrR3ISSQN.ParamByName('id_redz').AsInteger := QrR2.fieldbyname('id_redz').AsInteger;
      QrR3ISSQN.Open;
      while not QrR3ISSQN.Eof do
      begin
        with RegistroR03.New do
        begin
          //xxTnnnn = Exemplo: 01S0500 (totalizador 01 com alíquota de05,00% de ISSQN]
          AliqFormat := Knt.Str.padL(Knt.Str.RemovePoint(QrR3ISSQN.fieldbyname('rqn_aliq').AsString),4,'0');
          TOT_PARCIAL :=QrR3ISSQN.fieldbyname('rqn_indice').AsString+'S'+AliqFormat;
          VL_ACUM :=QrR3ISSQN.fieldbyname('rqn_total').AsCurrency;
        end;
        QrR3ISSQN.Next;
      end;

      //Fn - Substituição Tributária - ICMS
      //Valores de operações sujeitas ao ICMS, tributadas por Substituição Tributária, onde “n” representa o número do totalizador.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='F1';
        VL_ACUM := QrR2.fieldbyname('rdz_sticms').AsCurrency;
      end;

      //In - Isento - ICMS
      //Valores de operações Isentas do ICMS, onde “n” representa o número do totalizador.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='I1';
        VL_ACUM := QrR2.fieldbyname('rdz_isentoicms').AsCurrency;
      end;

      //Nn - Não-incidência - ICMS
      //Valores de operações com Não Incidência do ICMS, onde “n” representa o número do totalizador.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='N1';
        VL_ACUM := QrR2.fieldbyname('rdz_naotribicms').AsCurrency;
      end;

      //FSn - Substituição Tributária - ISSQN
      //Valores de operações sujeitas ao ISSQN, tributadas por Substituição Tributária, onde “n” representa o número do totalizador.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='FS1';
        VL_ACUM := QrR2.fieldbyname('rdz_stissqn').AsCurrency;
      end;

      //Isn - Isento - ISSQN
      //Valores de operações Isentas do ISSQN, onde “n” representa o número do totalizador.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='IS1';
        VL_ACUM := QrR2.fieldbyname('rdz_isentoissqn').AsCurrency;
      end;

      //NSn - Não-incidência - ISSQN
      //Valores de operações com Não Incidência do ISSQN, onde “n” representa o número do totalizador.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='NS1';
        VL_ACUM := QrR2.fieldbyname('rdz_naotribissqn').AsCurrency;
      end;

      //OPNF - Operações Não Fiscais
      //Somatório dos valores acumulados nos totalizadores relativos às Operações Não Fiscais registradas no ECF.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='OPNF';
        VL_ACUM := QrR2.fieldbyname('rdz_totoperacaonaofiscal').AsCurrency;
      end;

      //DT - Desconto - ICMS
      //Valores relativos a descontos incidentes sobre operações sujeitas ao ICMS
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='DT';
        VL_ACUM := QrR2.fieldbyname('rdz_descontoicms').AsCurrency;
      end;

      //DS - Desconto - ISSQN
      //Valores relativos a descontos incidentes sobre operações sujeitas ao ISSQN
      with RegistroR03.New do
      begin
        TOT_PARCIAL := 'DS';
        VL_ACUM := QrR2.fieldbyname('rdz_descontoissqn').AsCurrency;
      end;

      //AT - Acréscimo - ICMS
      //Valores relativos a acréscimos incidentes sobre operações sujeitas ao ICMS
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='AT';
        VL_ACUM := QrR2.fieldbyname('rdz_acrescimoicms').AsCurrency;
      end;

      //AS - Acréscimo - ISSQN
      //Valores relativos a acréscimos incidentes sobre operações sujeitas ao ISSQN
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='AS';
        VL_ACUM := QrR2.fieldbyname('rdz_acrescimoissqn').AsCurrency;
      end;

      //Can-T - Cancelamento - ICMS
      //Valores das operações sujeitas ao ICMS, canceladas.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='Can-T';
        VL_ACUM := QrR2.fieldbyname('rdz_cancelamentoicms').AsCurrency;
      end;

      //Can-S - Cancelamento - ISSQN
      //Valores das operações sujeitas ao ISSQN, canceladas.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='Can-S';
        VL_ACUM := QrR2.fieldbyname('rdz_cancelamentoissqn').AsCurrency;
      end;

    end;
    QrR4.Close;
    QrR4.ParamByName('dInicio').AsDateTime := StrToDateTime( FormatDateTime(ShortDateFormat,DataMov)+' 00:00:00');
    QrR4.ParamByName('dFinal').AsDateTime  := StrToDateTime( FormatDateTime(ShortDateFormat,DataMov)+' 23:59:59');
    QrR4.Open;

    while not QrR4.Eof do
    begin
      Application.ProcessMessages;
      with PAF.Device.PAF_R.RegistroR04.New do
      begin
        NUM_USU :=NumUsuario;
        NUM_CONT :=StrToIntDef(QrR4.fieldbyName('cf_ccf').AsString,0);
        COO  :=QrR4.fieldbyName('cf_coo').AsInteger;
        DT_INI :=QrR4.fieldbyName('cf_data').AsDateTime;
        SUB_DOCTO :=QrR4.fieldbyName('cf_total').AsCurrency;
        SUB_DESCTO :=QrR4.fieldbyName('cf_desconto').AsCurrency;
        TP_DESCTO :='V';
        SUB_ACRES :=0;
        TP_ACRES :='V';
        VL_TOT :=QrR4.fieldbyName('cf_total').AsCurrency - QrR4.fieldbyName('cf_desconto').AsCurrency;
        CANC :=QrR4.fieldbyName('cancelou').AsString;
        VL_CA :=0;
        ORDEM_DA :='D';
        NOME_CLI :=QrR4.fieldbyName('cli_nome').AsString;
        CNPJ_CPF :=QrR4.fieldbyName('dcf_cpf').AsString+QrR4.fieldbyName('dcj_cnpj').AsString;

        QrR5.close;
        QrR5.ParamByName('id_cf').AsInteger  := QrR4.fieldbyName('id_cf').AsInteger;
        QrR5.Open;

        while not QrR5.Eof do
        begin
          With RegistroR05.New do
          begin
            NUM_ITEM := QrR5.fieldbyName('cfit_sequencia').AsInteger;
            COD_ITEM := QrR5.fieldbyName('pro_codigo').AsString;
            DESC_ITEM := QrR5.fieldbyName('pro_descricao').AsString;
            QTDE_ITEM := QrR5.fieldbyName('cfit_quantidade').AsCurrency;
            UN_MED := QrR5.fieldbyName('und_sigla').AsString;
            VL_UNIT := QrR5.fieldbyName('pro_preco_venda').AsCurrency;
            DESCTO_ITEM := QrR5.fieldbyName('cfit_desconto_item').AsCurrency;
            ACRES_ITEM := 0;
            VL_TOT_ITEM := QrR5.fieldbyName('cfit_quantidade').AsCurrency * QrR5.fieldbyName('pro_preco_venda').AsCurrency;

            if QrR5.fieldbyName('cst_classificacao').AsInteger in [0,3] then
            begin
              AliqFormat  := Knt.Str.padL(Knt.Str.RemovePoint(QrR5.fieldbyName('cst_cod_cst').AsString),4,'0');
              iniAliq.DefaultSection := ImpTemp.NumFabricacao;
              AliqFormat:= iniAliq.ReadString(AliqFormat,'--') +'T'+AliqFormat;
            end
            else
            begin
              AliqFormat  := TRIM(Knt.Str.RemovePoint(QrR5.fieldbyName('cst_cod_cst').AsString));
            end;
            COD_TOT_PARC := AliqFormat;
            IND_CANC := QrR5.fieldbyName('it_situacao').AsString;
            QTDE_CANC := 0;
            VL_CANC := 0;
            VL_CANC_ACRES:= 0;
            IAT := QrR5.fieldbyName('indicadorAT').AsString;
            IPPT := QrR5.fieldbyName('pro_produzido_desc').AsString;
            QTDE_DECIMAL := ECF.Device.DecimaisQtd;
            VL_DECIMAL := ECF.Device.DecimaisPreco;
          end;
          QrR5.Next;
        end;
        QrR4R7.Close ;
        QrR4R7.ParamByName('id_cf').AsInteger  := QrR4.fieldbyName('id_cf').AsInteger;
        QrR4R7.Open;

        while not QrR4R7.Eof do
        begin
          with RegistroR07.New do
          begin
            RegistroValido := true;
            CCF := StrToIntDef(QrR4R7.fieldbyname('cfpg_ccf').Text,0);
            GNF := StrToIntDef(QrR4R7.fieldbyname('cfpg_gnf').Text,0);
            MP := QrR4R7.fieldbyname('pag_descricao').AsString;
            VL_PAGTO := QrR4R7.fieldbyname('cfpg_valor').AsCurrency;
            IND_EST := 'N';
            VL_EST := 0
          end;
          QrR4R7.Next;
        end;

      end;
      QrR4.Next;
    end;

    QrR6.Close;
    QrR6.ParamByName('dInicio').AsDateTime := StrToDateTime( FormatDateTime(ShortDateFormat,DataMov)+' 00:00:00');
    QrR6.ParamByName('dFinal').AsDateTime  := StrToDateTime( FormatDateTime(ShortDateFormat,DataMov)+' 23:59:59');
    QrR6.Open;
    while not QrR6.Eof do
    begin
      Application.ProcessMessages;
      with PAF.Device.PAF_R.RegistroR06.New do
      begin
        NUM_USU := 1;
        COO := QrR6.fieldbyname('mv_coo').AsInteger;
        GNF := QrR6.fieldbyname('mv_gnf').AsInteger;
        GRG := QrR6.fieldbyname('mv_grg').AsInteger;
        CDC := QrR6.fieldbyname('mv_cdc').AsInteger;
        DENOM := QrR6.fieldbyname('mv_codigopaf').AsString;
        DT_FIN := QrR6.fieldbyname('mv_data').AsDateTime;
        HR_FIN := QrR6.fieldbyname('mv_data').AsDateTime;
        // Registro R07 - FILHO
        with RegistroR07.New do
        begin
          RegistroValido := true;
          CCF := QrR6.fieldbyname('mv_ccf').AsInteger;
          MP := QrR6.fieldbyname('pag_descricao').AsString;
          VL_PAGTO := QrR6.fieldbyname('mv_valor').AsCurrency;
          IND_EST := 'N';
          VL_EST := 0;
        end;
      end;
      QrR6.Next;
    end;
    Application.ProcessMessages;

    NomeArq := ImpTemp.ModeloECF + knt.Str.Right(ImpTemp.NumFabricacao, 14) +
      FormatDateTime('ddmmyyyy', DataMov)+'.txt';
    try
      PAF.SalvarRegistrosPAF(tpfR, Knt.Str.AppDirectory + '\movecf\' + NomeArq);
      GerouArq := true;
    except
       raise;
    end;

    ProgressFrm.Position := ProgressFrm.Position +1;
    QrR2.Next;
  end;

  ProgressFrm.Hide;
  if GerouArq then
  begin
    Knt.UserDlg.WarningOK('Os arquivos foram gerados em:' + PAF.Device.Path);
  end;

  FreeAndNil(ImpTemp);
end;

end.
