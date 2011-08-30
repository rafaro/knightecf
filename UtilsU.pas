unit UtilsU;

interface

uses
  ACBrTEFD, ACBrPAF, ACBrBase, ACBrECF, ACBrTEFDClass, Classes, DB, SqlExpr,
  ACBrDevice, ACBrEAD, ACBrSintegra, ACBrEFDBlocos, ACBrSpedFiscal;

function TabelaCreate: TSQLQuery; overload;
function TabelaCreate(const SQL: String): TSQLQuery; overload;

type
  TTipoNum = (tnPercent, tnValor);
  TTipoPAF = (tpfD, tpfE, tpfP, tpfR, tpfT);
  TDenDocEmitido = (tddeConfMesa, tddeRegVenda, tddeComprovCreDeb,
    tddeComprovNaoFisc, tddeComprovNaoFiscCanc, tddeRelGeren)  ;

const
  ECFEstados : array[TACBrECFEstado] of string =('Não Inicializada',
    'Desconhecido', 'Livre', 'Venda', 'Pagamento', 'Relatório', 'Bloqueada',
    'Requer redução Z', 'Requer leitura X', 'Nao Fiscal' );
  posGT : array[1..4] of string =('_!', '@_1', '#', '$$') ;
  posSerie : array[1..4] of string = ('!', '_@', '_#', '$') ;
  Cipher : string = 'EcF_CiPhEr';
  aDescDocEmitido : array[TDenDocEmitido] of string =
    ('CM', 'RV', 'CC', 'CN','NC','RG')   ;

type
  TObjBD = class
  private
    FID     : Integer;
    FCodigo : String;
    FDesc   : String;
    FSql    : string;
    FCon    : TSQLConnection;
    FQr     : TSQLQuery;
    FCampos : TStringList;
    FTabela : string;
    FAuxStr : string;
    procedure PreencherPropriedades(const SQL: String); overload; virtual;
    procedure PreencherPropriedades();overload;virtual;
    procedure PegarDadosQry; virtual; abstract;
    function  existeObj : boolean; overload; virtual;
    function  existeObj (Where : string) : boolean; overload;virtual;
    function existeObjAux(Id, Tabela, Where: string; var ValorId: integer):
        boolean; virtual;
    procedure tblCreate; overload;
    procedure tblCreate(const SQL: String); overload;
  public
    property Id: Integer read FID write FID;
    property Codigo: string read FCodigo write FCodigo;
    property Desc: string read FDesc write FDesc;
    procedure BuscarPorID(const IdBusca: integer); virtual; abstract;
    function gravarTbl: boolean; virtual; abstract;
    constructor create; virtual;
  end;

  TCFRedZ = class(TObjBD)
  private
    FCCF: string;
    FCDC: string;
    FCFC: string;
    FCFD: string;
    FGNFC: string;
    FGRG: string;
    FCOO: string;
    FCOOInicial: string;
    FCRO: string;
    FCRZ: string;
    FDataImp: TDateTime;
    FDataMovimentacao: TDateTime;
    FGNF: string;
    FIDImpfiscal: Integer;
    FIsentoISSQN: Double;
    FLoja: string;
    FAcrescimoICMS: currency;
    FAcrescimoISSQN: currency;
    FCancelamentoICMS: currency;
    FCancelamentoISSQN: currency;
    FDescontoICMS: currency;
    FDescontoISSQN: currency;
    FGrandeTotal: currency;
    FIsentoICMS: currency;
    FNaoTribICMS: currency;
    FNaoTribISSQN: currency;
    FSTICMS: currency;
    FTotalISSQN: currency;
    FTotOperacaoNaoFiscal: currency;
    FTotTroco: currency;
    FNumeroECF: string;
    FVendaBruta: currency;
    FVendaLiquida: currency;
    FSTISSQN: Double;
    procedure PegarDadosQry;override;
    function existeObj : boolean;override;
  public
    function InserirICMS(const Indice, Tipo: string; const Aliquota, Total:
        currency): boolean;
    function InserirISSQN(const Indice, Tipo: string; const Aliquota, Total:
        currency): boolean;
    function InserirTotalizador(const Indice, Descricao, FormaPagamento: string;
        const Total: currency; const EhFiscal: boolean): boolean;
    function GravarTbl: boolean; override;
    constructor create; override;
    procedure BuscarPorID(const ID: integer); override;
    property CCF: string read FCCF write FCCF;
    property CDC: string read FCDC write FCDC;
    property CFC: string read FCFC write FCFC;
    property CFD: string read FCFD write FCFD;
    property GNFC: string read FGNFC write FGNFC;
    property GRG: string read FGRG write FGRG;
    property COO: string read FCOO write FCOO;
    property COOInicial: string read FCOOInicial write FCOOInicial;
    property CRO: string read FCRO write FCRO;
    property CRZ: string read FCRZ write FCRZ;
    property DataImp: TDateTime read FDataImp write FDataImp;
    property DataMovimentacao: TDateTime read FDataMovimentacao write
     FDataMovimentacao;
    property GNF: string read FGNF write FGNF;
    property IDImpfiscal: Integer read FIDImpfiscal write FIDImpfiscal;
    property IsentoISSQN: Double read FIsentoISSQN write FIsentoISSQN;
    property Loja: string read FLoja write FLoja;
    property AcrescimoICMS: currency read FAcrescimoICMS write FAcrescimoICMS;
    property AcrescimoISSQN: currency read FAcrescimoISSQN write FAcrescimoISSQN;
    property CancelamentoICMS: currency read FCancelamentoICMS write
        FCancelamentoICMS;
    property CancelamentoISSQN: currency read FCancelamentoISSQN write
        FCancelamentoISSQN;
    property DescontoICMS: currency read FDescontoICMS write FDescontoICMS;
    property DescontoISSQN: currency read FDescontoISSQN write FDescontoISSQN;
    property GrandeTotal: currency read FGrandeTotal write FGrandeTotal;
    property IsentoICMS: currency read FIsentoICMS write FIsentoICMS;
    property NaoTribICMS: currency read FNaoTribICMS write FNaoTribICMS;
    property NaoTribISSQN: currency read FNaoTribISSQN write FNaoTribISSQN;
    property STICMS: currency read FSTICMS write FSTICMS;
    property TotalISSQN: currency read FTotalISSQN write FTotalISSQN;
    property TotOperacaoNaoFiscal: currency read FTotOperacaoNaoFiscal write
        FTotOperacaoNaoFiscal;
    property TotTroco: currency read FTotTroco write FTotTroco;
    property NumeroECF: string read FNumeroECF write FNumeroECF;
    property VendaBruta: currency read FVendaBruta write FVendaBruta;
    property VendaLiquida: currency read FVendaLiquida write FVendaLiquida;
    property STISSQN: Double read FSTISSQN write FSTISSQN;
  end;

  TEstLocal = class(TObjBD)
  private
    FIDFaturamento: integer;
    FIDCF: integer;
    FIDItem: integer;
    FIDProduto: integer;
    FData: TDateTime;
    FQuantidade: Currency;
    FHora: TDateTime;
    FIDLote: integer;
    FOperacao: Smallint;
    FDestino: Smallint;
    FDevolucao: Boolean;
    FIDLocal: integer;
    FCancela: boolean;
    procedure PegarDadosQry;override;
    function InserirEstoque : boolean;
    function AtualizarEstoque : boolean;
  public
    constructor create(); overload; override;
    constructor create(IDFaturamento: integer; IDCF: integer; IDItem: integer;
      IDProduto: integer; Data: TDateTime; Quantidade: Currency; Hora: TDateTime;
      IDLote: integer; Operacao: Smallint; Destino: Smallint; Devolucao: Boolean;
      IDLocal: integer; Cancela: boolean);overload;
    procedure preencheProp(IDFaturamento: integer; IDCF: integer; IDItem: integer;
      IDProduto: integer; Data: TDateTime; Quantidade: Currency; Hora: TDateTime;
      IDLote: integer; Operacao: Smallint; Destino: Smallint; Devolucao: Boolean;
      IDLocal: integer; Cancela: boolean);overload;
    function MovimentarEstoque : boolean;
    procedure BuscarPorID(const IdBusca: integer); override;
    function gravarTbl:boolean;override;
  end;

  TFormaDePagto = class(TObjBD)
  private
    FTipoPagto : Smallint;
    FDigitado  : Boolean ;
    FTEF       : integer;
    procedure PegarDadosQry;override;
  public
    property TipoPagto: Smallint read FTipoPagto write FTipoPagto;
    property Digitado: Boolean read FDigitado write FDigitado;
    property TEF: integer read FTEF write FTEF;
    procedure buscarPorDescricao(Desc : string);
    procedure BuscarPorID(const IdBusca: integer); override;
    function gravarTbl: boolean; override;
  end;

  TCFOP = class(TObjBD)
  private
    FSemST : Boolean ;
    FBCComIPI : Boolean ;
    FBCComSeguro : boolean;
    procedure PegarDadosQry;override;
  public
    property SemST : boolean read FSemST  write FSemST ;
    property BCComIPI : boolean read FBCComIPI  write FBCComIPI ;
    property BCComSeguro : boolean read FBCComSeguro  write FBCComSeguro ;
    procedure BuscarPorID(const IdBusca: integer); override;
    procedure buscarPorCodigo(const cCodigo : string);
    function gravarTbl:boolean;override;
  end;


  TOperacao = class(TObjBD)
  private
    //idOperacao_cfop será ID
    FIDcfop    : Integer;
    FIDOperacao: integer;
    FTipoOpera : Smallint;
    FDestino   : Smallint;
    FCFOP      : TCFOP;
    procedure PegarDadosQry;override;
  public
    property ID;
    property Codigo;
    property Desc;
    property IDOperacao: integer  read FIDOperacao  write FIDOperacao;
    property IDcfop: Integer read FIDcfop write FIDcfop;
    property TipoOperacao: Smallint read FTipoOpera write FTipoOpera;
    property Destino: Smallint read FDestino write FDestino;
    property CFOP: TCFOP read FCFOP write FCFOP;
    procedure BuscarPorID(const IdBusca: integer); override;

    function gravarTbl:boolean;override;
    constructor create;override;
  end;

  TCST = class(TObjBD)
  private
     FOrigem    : Smallint;
     FClassific : Smallint;//0 - Tributado,1 - Isenta,2 - Substituição Tributária,3 - Outras,4 - Não tributado
     procedure PegarDadosQry; override;
  public
     property Origem: Smallint read FOrigem write FOrigem;
     property Classific: Smallint read FClassific write FClassific;
     procedure buscarCSTPorProd(const IDProd: integer);
     procedure BuscarPorID(const IdBusca: integer); override;
     function gravarTbl: boolean; override;
  end;

  TUnidade = class(TObjBD)
  private
    procedure PegarDadosQry;override;
  public
    procedure BuscarPorID(const IdBusca: integer); override;
    function gravarTbl:boolean;override;
  end;

  TProduto = class(TObjBD)
  private
    FID  : integer;
    FCST : TCST;
    FEhProduzido: boolean;
    FNcmSh      : String  ;
    procedure setFID(nIDProd : integer);
    procedure PegarDadosQry;override;
  public
    property ID: Integer read FID write setFID;
    property CST: TCST read FCST write FCST;
    property EhProduzido: boolean read FEhProduzido write FEhProduzido;
    property NcmSh: String read FNcmSh write FNcmSh;

    procedure BuscarPorID(const IdBusca: integer); override;
    constructor create;override;

    function gravarTbl: boolean; override;
  end;

  TEndereco = class
  private
    FIDCep: Integer;
    FPais: string;
    FEstado: string;
    FCidade: string;
    FBairro: String;
    //FRua      : String;
    FCep: string;
    FEndereco: string;
    FTipo: String;
  protected
    procedure SetIDCep(const Value: Integer);
    procedure SetPais(const Value: string);
    procedure SetEstado(const Value: string);
    procedure SetBairro(const Value: String);
    procedure SetCidade(const Value: string);

    //procedure setRua(const pRua:String);
    procedure SetCep(const Value: string);
    procedure SetEndereco(const Value: string);
  public
    property Pais: string read FPais write SetPais;
    property Estado: string read FEstado write SetEstado;
    property Cidade: string read FCidade write SetCidade;
    property Bairro: String read FBairro write SetBairro;
    property Tipo: String read FTipo write FTipo;

    //property cRua    : string  read FRua      write setRua;
    property Cep: string read FCep write SetCep;
    property IDCep: Integer read FIDCep write SetIDCep;
    property Endereco: string read FEndereco write SetEndereco;
    procedure BuscarEndereco;
    function GravarEndereco: Integer;
    function RetornarSiglaEstado(NomeEstado: String): String;
    function GetNomeEstado(SiglaUF: String): String;
    constructor Create(pPais,pEstado,pCidade,pBairro,pEndereco,pCep:string); overload;
    constructor create(); overload;
  end;

  TCedente = class(TObjBD)
  private
    FRazao       : String;
    FFantasia    : String;
    FSiglaEstado : string;
    FEhContribuinte: Boolean;
    FEhPessoaFisica: boolean;
    FIDCep         : integer;
    FIDCepEntrega  : integer;
    FEnder         : TEndereco;
    FEPessoaFisica : boolean;
    FIdentNacional : String; // CPF ou CNPJ
    FNumEnder        : String    ;
    FNumEnderEntrega : String    ;
    FIdRepresentante : Integer   ;
    FVlrLimiteCred   : Currency  ;
    FPercDesconto    : Currency  ;

    procedure PegarDadosQry; override;
  public
    property ID;
    property Codigo;
    property Razao: String read FRazao write FRazao;
    property Fantasia: String read FFantasia write FFantasia;
    property SiglaEstado: string read FSiglaEstado write FSiglaEstado;
    property EhContribuinte: Boolean read FEhContribuinte write FEhContribuinte;
    property IdRepresentante: integer read FIdRepresentante write FIdRepresentante;
    property VlrLimiteCred: Currency read FVlrLimiteCred write FVlrLimiteCred;
    property PercDesconto: Currency read FPercDesconto write FPercDesconto;


    property IDCep: integer read FIDCep write FIDCep;
    property IDCepEntrega: integer read FIDCepEntrega write FIDCepEntrega;
    property EhPessoaFisica: boolean read FEhPessoaFisica write FEhPessoaFisica;
    property IdentNacional: string read FIdentNacional write FIdentNacional;
    property Ender: TEndereco read FEnder write FEnder;
    property NumEnder: String read FNumEnder write FNumEnder;
    property NumEnderEntrega: String read FNumEnderEntrega write FNumEnderEntrega;

    procedure BuscarPorID(const IdBusca: integer); override;
    procedure buscarPorCNPJ(const CNPJ: string);

    procedure carregarEndereco;
    procedure carregarEnderecoEntrega;

    function gravarTbl: boolean; override;
    constructor create;override;

  end;


  TCFItem = class
  private
    //Dados do Item
    FProduto  : TProduto;
    FUnidade  : TUnidade ;
    FCFO      : TCFOP;
    FCST      : TCST;
    FObs      : WideString;

    //valor do item
    FQuant    : Currency;
    FPreco    : Currency;
    FDesc     : Currency;

    //ST
    FValorST  : Currency;
    FBaseST   : Currency;
    FMVA      : Currency;
    FReducBaseCalculoST : Currency;

    //ICMS
    FBaseICMS             : Currency;
    FValorICMS            : Currency ;
    FAliqOperacao         : Currency;
    FAliqInterna          : Currency;
    FReducBaseCalculoICMS : Currency;

    //FAliqICMS : Currency ;

    //IPI
    FAliqIPI  : Currency;

    //FTipoDoc: Currency;
    //O total será somente leitura

    //Valores rateados da nota
    FDescontoNota : currency;
    FFreteNota    : currency;
    FSeguroNota   : currency;
    FOutrosNota   : currency;

    //PIS
    FAliqPIS    : currency;
    FValorPIS   : currency;
    FBaseCalculoPIS : currency;

    //COFINS
    FAliqCofins  : currency;
    FValorCofins : currency;
    FBaseCalculoCofins : currency;

    //ISSQN
    FAliqISSQN   : currency;
    FValorISSQN  : currency;
    FBaseISSQN   : currency;


  protected
    function getTotalItemRateoNota : currency;
    function getTotalItem : currency;
    function getValorICMS : currency;
    function getValorIPI  : currency;
  public
    property Produto: TProduto read FProduto write FProduto;
    property Unidade: TUnidade read FUnidade write FUnidade;
    property CFO: TCFOP read FCFO write FCFO;
    property CST: TCST read FCST write FCST;
    property Obs: WideString read FObs write FObs;


    property Quant: Currency read FQuant write FQuant;
    property Preco: Currency read FPreco write FPreco;
    property Desc: Currency read FDesc write FDesc;
    property TotalItem: Currency read getTotalItem;

    //ST                                          Por acausa do banco estou voltando a variável
    property BaseST: Currency read FBaseST write FBaseST;
    property MVA: Currency read FMVA write FMVA;
    property ValorST: Currency read FValorST write FValorST;
    property ReducBaseCalculoST: Currency read FReducBaseCalculoST write
        FReducBaseCalculoST;

    //ICMS                                                                Por acausa do banco estou voltando a variável
    property BaseICMS: Currency read FBaseICMS write FBaseICMS;
    property ValorICMS: Currency read FValorICMS write FValorICMS;
    //property nAliqICMS  : Currency read FAliqICMS      write FAliqICMS ;
    property AliqOperacao: Currency read FAliqOperacao write FAliqOperacao;
    property AliqInterna: Currency read FAliqInterna write FAliqInterna;
//    property ValorICMS : Currency read getValorICMS;
    property ReducBaseCalculoICMS: Currency read FReducBaseCalculoICMS write
        FReducBaseCalculoICMS;

    //IPI
    property AliqIPI: Currency read FAliqIPI write FAliqIPI;
    property ValorIPI: Currency read getValorIPI;

    //PIS
    property AliqPIS: currency read FAliqPIS write FAliqPIS;
    property ValorPIS: currency read FValorPIS write FValorPIS;
    property BaseCalculoPIS: currency read FBaseCalculoPIS write FBaseCalculoPIS;

    //COFINS
    property AliqCofins: currency read FAliqCofins write FAliqCofins;
    property ValorCofins: currency read FValorCofins write FValorCofins;
    property BaseCalculoCofins: currency read FBaseCalculoCofins write
        FBaseCalculoCofins;

    //Valor Rateado da nota
    property DescontoNota: currency read FDescontoNota write FDescontoNota;
    property FreteNota: currency read FFreteNota write FFreteNota;
    property OutrosNota: currency read FOutrosNota write FOutrosNota;
    property SeguroNota: currency read FSeguroNota write FSeguroNota;

    //ISSQN
    property AliqISSQN: currency read FAliqISSQN write FAliqISSQN;
    property ValorISSQN: currency read FValorISSQN write FValorISSQN;
    property BaseISSQN: currency read FBaseISSQN write FBaseISSQN;

    //Este método foi passado para a TNOTA
    //procedure recalculaImpostosNAOUSAR();

    function getValorST   : currency;
    function getBaseST    : currency;

    constructor create;
  end;

  TCupom = class(TObject)
  private
    FAliqInterna: Currency;
    FCoo : String; //" VARCHAR(50),
    FGnf : String; //" VARCHAR(50),
    FGrg : String; //" VARCHAR(50),
    FCdc : String; //" VARCHAR(50)
    FCcf : String; //" VARCHAR(50)
    FCedente: TCedente;
    FTotal    : Currency;
    FDesconto : Currency;
    FTroco    : Currency;
    FData     : TDateTime;
    FEstadoOri: string;
    FID: Integer;
    FSituacao : smallint;
    FIDImpFiscal : integer;
    FItens        : array of TCFItem;
    //Rafael Rocha - 08/09/2010 - Irei fazer o backup funcionar.
    FItensBckUp   : array of TCFItem;
    FOper: TOperacao;
    FSql : string;
    procedure preencherPropriedades(const SQL: String);
    procedure bckUpItens;
    procedure restoreItens;
    procedure buscaFilial;
    function  getAliqOperacao( ) : Currency ;
    function  getAliqInterna( ) : Currency ;
    function  RetornaMvaOperacaoUF(idProd: Integer; UFOrig: String=''; UFDest: String=''): Currency ;
  protected
    function  getItem(Index: Integer): TCFItem;
    procedure setItem(Index: Integer; Value: TCFItem);
  public
    property AliqInterna: Currency read FAliqInterna write FAliqInterna;
    property Oper: TOperacao read FOper write FOper;
    property Data     : TDateTime read FData write FData;
    property Situacao : smallint read FSituacao write FSituacao;
    property Coo: String read FCoo write FCoo;
    property Gnf: String read FGnf write FGnf;
    property Grg: String read FGrg write FGrg;
    property Cdc: String read FCdc write FCdc;
    property Ccf: String read FCcf write FCcf;
    property Cedente: TCedente read FCedente write FCedente;
    property Total: Currency read FTotal write FTotal;
    property Desconto: Currency read FDesconto write FDesconto;
    property EstadoOri: string read FEstadoOri write FEstadoOri;
    property ID: Integer read FID write FID;
    property Troco: Currency read FTroco write FTroco;
    property IDImpFiscal: integer read FIDImpFiscal write FIDImpFiscal;
    property Itens[Index: Integer]: TCFItem read getItem write setItem;
    function inserirItem: integer;
    procedure removerUltimoItem;
    procedure gravarTbl;
    procedure gravarTblItem(const Sequencia: integer);
    procedure gravarCancelamento; overload;
    procedure gravarCancelamento(const Data: TDateTime); overload;
    function gravarPagamento(IDPgto: integer; Valor: Currency; Coo, Ccf, Gnf:
        string): boolean;
    function CancelarItem(const Sequencia: integer): boolean;
    procedure BuscarPorCOO(const numCOO :string; const numSerie : string);
    function AlimentarEstoque(const Cancela: Boolean = false): Boolean;
    procedure RecalcularImpostos;overload;
    procedure RecalcularImpostos(nIndexItem:integer);overload;

    constructor create;
  end;

  TImpFiscal = class(TObjBD)
  private
    FIdxCipher: smallint;
    Fnumfabricacao : string;
    Fmfadicional   : string;
    Ftipoecf       : string;
    Fmarcadoecf    : string;
    Fmodeloecf     : string;
    Fdatainstalacaosb     : TDateTime;
    Fhorarioinstalacaosb  : TDateTime;
    Fnumerosequencialecf  : string;
    FVersaoSB  : string;
    FUsuario   : string;
    procedure PegarDadosQry; override;
  public
    property IdxCipher: smallint read FIdxCipher write FIdxCipher;
    property NumFabricacao: string read FNumFabricacao write FNumFabricacao;
    property MFAdicional: string read FMFAdicional write FMFAdicional;
    property TipoECF: string read FTipoECF write FTipoECF;
    property MarcaDoECF: string read FMarcaDoECF write FMarcaDoECF;
    property ModeloECF: string read FModeloECF write FModeloECF;
    property DataInstalacaoSB: TDateTime read FDataInstalacaoSB write
        FDataInstalacaoSB;
    property HorarioInstalacaoSB: TDateTime read FHorarioInstalacaoSB write
        FHorarioInstalacaoSB;
    property NumeroSequencialECF: string read FNumeroSequencialECF write
        FNumeroSequencialECF;
    property VersaoSB: string read FVersaoSB write FVersaoSB;
    property Usuario: string read FUsuario write FUsuario;

    procedure BuscarPorNumSerial(const NumSerial: string);
    procedure BuscarPorID(const ID: integer); override;
    function GravarTbl: boolean; override;
    function GravarMovimentoCaixa(IdPgto, Tipo: integer; Valor: currency; COO, GNF,
        GRG, CDC, CCF: string; DtFinal: TDateTime; DenDoc: TDenDocEmitido): boolean;

    constructor create; override;
  end;



  TFilial = class(TObjBD)
  private
    FUF           : string;
    FCNPJ         : string;
    FInscEst: string;
    FInscMunic    : string;
    FRazaoSocial  : string;
    procedure PegarDadosQry; override;
  public
    property UF: string read FUF write FUF;
    property CNPJ: string read FCNPJ write FCNPJ;
    property InscEst: string read FInscEst write FInscEst;
    property InscMunic: string read FInscMunic write FInscMunic;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    procedure BuscarPorID(const ID: integer); override;
    function GravarTbl: boolean; override;
    constructor create;override;
  end;

  TSoftHouse = class
  private
    FCNPJ: string;
    FInscEst: string;
    FInscMunic: string;
    FNome: string;
    //FNomePAF    : string;
    //FVerPAF     : string;
    FERPAFECF: string;
    //FMD5        : string;
    FNumLaudo: string;
    FEndereco: string;
    FTelefone: string;
    FNomePessoaContato: string;
    FPAFECFNomeComercial: string;
    FPAFECFVersao: string;
    FPAFECFPrincExec: string;
    FPAFECFMD5Exec: string;
    FPAFECFArqsMD5: TStringList;
  public
    property CNPJ: string read FCNPJ write FCNPJ;
    property InscEst: string read FInscEst write FInscEst;
    property InscMunic: string read FInscMunic write FInscMunic;
    property Nome: string read FNome write FNome;
    //property cNomePAF   : string read FNomePAF   write FNomePAF ;
    //property cVerPAF    : string read FVerPAF    write FVerPAF ;
    property ERPAFECF: string read FERPAFECF write FERPAFECF;
    //property cMD5       : string read FMD5       write FMD5 ;
    property NumLaudo: string read FNumLaudo write FNumLaudo;
    property Endereco: string read FEndereco write FEndereco;
    property Telefone: string read FTelefone write FTelefone;
    property NomePessoaContato: string read FNomePessoaContato write
        FNomePessoaContato;
    property PAFECFNomeComercial: string read FPAFECFNomeComercial write
        FPAFECFNomeComercial;
    property PAFECFVersao: string read FPAFECFVersao write FPAFECFVersao;
    property PAFECFPrincExec: string read FPAFECFPrincExec write FPAFECFPrincExec;
    property PAFECFMD5Exec: string read FPAFECFMD5Exec write FPAFECFMD5Exec;
    property PAFECFArqsMD5: TStringList read FPAFECFArqsMD5 write FPAFECFArqsMD5;
    constructor create;
    function GerarNomeArquivo: string;
  end;

  TPAF = class(TObject)
  private
    FDevice: TACBrPAF;
  public
    constructor Create(var Value: TACBrPAF);
    procedure CarregarRegistroTipo1(const TipoPAF: TTipoPAF; const Filial: TFilial;
        const SoftHs: TSoftHouse);
    procedure SalvarRegistrosPAF(const TipoPAF: TTipoPAF; CaminhoCompleto: string;
        EmiteMsg: boolean = false);
    procedure EmitirMovimentoPorEcf(DataInicial, DataFinal: TDateTime;
      IdImpFiscal: integer; ReducaoZ: boolean=False);
    property Device: TACBrPAF read FDevice write FDevice;
  end;

  //Rafael Rocha - rafaro@gmail.com - 04/08/2011
  //Classe responsável pela manipulação do Device
  TTEF = class(TObject)
  private
    FDevice: TACBrTEFD;
    FTiposTEF: TACBrTEFDTipo;
  public
    //Rafael Rocha - rafaro@gmail.com - 04/08/2011
    //Neste construtor dever ser passado o componente Device do ACBr
    //Caso não queira utilizar o componente visual sobrecarregue este método
    constructor Create(var Value: TACBrTEFD);
    procedure Ativar;
    property Device: TACBrTEFD read FDevice write FDevice;
    property TiposTEF: TACBrTEFDTipo read FTiposTEF write FTiposTEF;
  end;

  TECF = class(TObject)
  private
    FDevice: TACBrECF;
    FMensagemPromocional: string;
    FCfoSTProd: string;
    FCfoProd: string;
    FCfoRevend: string;
    FCfoSTRevend: string;
    FEAD: TACBrEAD;
    FOpCupom: Integer;
    FPodeDescontoUnitario: boolean;
    FMovimentaEstoque: Boolean;
  public
    constructor Create(var ECF: TACBrECF; var EADParam: TACBrEAD);
    procedure ConfigurarCupom;
    procedure EmitirLeituraMemoriaDoMesPassado;
    function FecharCupom(const Mensagem: String = ''): Boolean;
    procedure LerReducaoZ;
    function EstaOK(Estado:TACBrECFEstadoSet): Boolean;
    property Device: TACBrECF read FDevice write FDevice;
    property MensagemPromocional: string read FMensagemPromocional write
        FMensagemPromocional;
    property CfoSTProd: string read FCfoSTProd write FCfoSTProd;
    property CfoProd: string read FCfoProd write FCfoProd;
    property CfoRevend: string read FCfoRevend write FCfoRevend;
    property CfoSTRevend: string read FCfoSTRevend write FCfoSTRevend;
    property EAD: TACBrEAD read FEAD write FEAD;
    property MovimentaEstoque: Boolean read FMovimentaEstoque write
        FMovimentaEstoque;
    property OpCupom: Integer read FOpCupom write FOpCupom;
    property PodeDescontoUnitario: boolean read FPodeDescontoUnitario write
        FPodeDescontoUnitario;
  end;

  TSintegra = class
  private
    FDataInicio : TDateTime;
    FDataFim    : TDateTime;
    FDiretorio  : string;
    FVersao     : TVersaoValidador;
    FCancelado  : boolean;
    FDevice: TACBrSintegra;
    procedure setDataInicio(const dData: TDateTime);
    procedure setDataFim   (const dData: TDateTime);
  public
    property Cancelado: boolean read FCancelado write FCancelado;
    property DataInicio: TDateTime read FDataInicio write setDataInicio;
    property DataFim: TDateTime read FDataFim write setDataFim;
    property Device: TACBrSintegra read FDevice write FDevice;
    property Diretorio: string read FDiretorio write FDiretorio;
    property Versao: TVersaoValidador read FVersao write FVersao;


    constructor Create(var ACBrSintegra: TACBrSintegra);
    procedure registro10_11;
    procedure registro50;
    procedure registro54;
    procedure registro60M;
    procedure registro60A;
    procedure registro60D;
    procedure registro75;

    procedure GerarArquivo;
    procedure GerarRegistros;
  end;

  TSPEDFiscal = class
  private
    FDataInicio : TDateTime;
    FDataFim    : TDateTime;
    FDiretorio  : string;
    FArquivo    : string;
    //FVersao     : TVersaoValidador;
    FLaudo      : string;
    FPerfil     : TACBrPerfil;
    FCancelado  : boolean;
    FDevice: TACBrSPEDFiscal;
    procedure setDataInicio(const dData: TDateTime);
    procedure setDataFim   (const dData: TDateTime);

  public
    property Cancelado: boolean read FCancelado write FCancelado;
    property DataInicio: TDateTime read FDataInicio write setDataInicio;
    property DataFim: TDateTime read FDataFim write setDataFim;
    property Diretorio: string read FDiretorio write FDiretorio;
    property Arquivo: string read FArquivo write FArquivo;
    property Device: TACBrSPEDFiscal read FDevice write FDevice;
    property Laudo: string read FLaudo write FLaudo;
    property Perfil: TACBrPerfil read FPerfil write FPerfil;

    constructor Create(var SPED: TACBrSPEDFiscal);
    procedure bloco0;
    procedure blocoC;
    procedure blocoH;
    procedure GerarArquivo;
    procedure GerarRegistros;
  end;




implementation

uses
  knight, SysUtils, EcfU, StrUtils, Math, Forms, ConfirmacaoDadosSintegraU,
  Controls, ConfirmacaoDadosSPEDFiscalU;

function TabelaCreate: TSQLQuery;
var tmpQr: TSQLQuery;
begin
  tmpQr := TSQLQuery.Create(nil);
  tmpQr.Active := false;
  tmpQr.SQLConnection := EcfDm.Con;
  Result:= tmpQr;
end;

function tabelaCreate(const SQL: String): TSQLQuery;
var tmpQr: TSQLQuery;
begin
  tmpQr := TSQLQuery.Create(nil);
  tmpQr.Active := false;
  tmpQr.SQLConnection := EcfDm.Con;
  tmpQr.SQL.Add(SQL);
  Result:= tmpQr;
end;

constructor TTEF.Create(var Value: TACBrTEFD);
begin
  Device := Value;
end;

procedure TTEF.Ativar;
begin
  Device.Inicializar(FTiposTEF);
  FTiposTEF := Device.GPAtual;
  Device.AtivarGP(FTiposTEF);
end;

constructor TECF.Create(var ECF: TACBrECF; var EADParam: TACBrEAD);
begin
  FDevice := ECF;
  FEAD := EADParam;
end;

procedure TECF.ConfigurarCupom;
var Str : string;
begin

//'[Cabecalho]'+
//'LIN000=<center><b>'+Nome da Empresa+'</b></center>'+
//'LIN001=<center>Nome da Rua , 1234  -  Bairro</center>
///'LIN002=<center>Cidade  -  UF  -  99999-999</center>
//'LIN003=<center>CNPJ: 01.234.567/0001-22    IE: 012.345.678.90</center>
//'LIN004=<table width=100%><tr><td align=left><code>Data</code> <code>Hora</code></td><td align=right>COO: <b><code>NumCupom</code></b></td></tr></table>
//LIN005=<hr>

  Str :=
    '[Cabecalho]'+
    'LIN000=<table width=100%><tr><td align=left><code>Data</code> <code>Hora</code></td><td align=right>COO: <b><code>NumCupom</code></b></td></tr></table>'+
    'LIN001=<hr>'+
    '[Cabecalho_Item]'+
    'LIN000=ITEM   CODIGO     DESCRICAO'+
    'LIN001=QTD         x UNITARIO       Aliq     VALOR (R$)'+
    'LIN002=<hr>'+
    'MascaraItem=III CCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDQQQQQQQQ UU x VVVVVVVVVVVVV AAAAAA TTTTTTTTTTTTT'+
    '[Rodape]'+
    'LIN000=<hr>'+
    'LIN001=<table width=100%><tr><td align=left><code>Data</code> <code>Hora</code></td><td align=right>Projeto ACBr: <b><code>ACBR</code></b></td></tr></table>'+
    'LIN002=<center>Obrigado Volte Sempre</center>'+
    'LIN003=<hr>'+
    '[Formato]'+
    'Colunas=48'+
    'HTML=1'+
    'HTML_Title_Size=2'+
    'HTML_Font=<font size="2" face="Lucida Console">';
    Device.MemoParams.Clear;
    Device.MemoParams.Append(Str);
end;

procedure TECF.EmitirLeituraMemoriaDoMesPassado;
var Qr  : TSQLQuery;
    Str : String;
    Dia : Word;
    Mes : Word;
    Ano : word;
    DataInicio :TDateTime;
    DataFim    :TDateTime;
begin
//   myDate := StrToDate('15/03/75');
  Knt.Date.DecodeDate(Ano, Mes, Dia);
  DataFim := Knt.Date.EndOfAMonth(Ano, Mes);
  DataInicio := Knt.Date.EncodeDate(Ano, Mes, 1);
  try
    Str :=
      ' SELECT count(id_redz) as total '+
      ' FROM fat_cf_redz '+
      ' WHERE '+
      '   rdz_data_mov between :dInicio and :dFim AND'+
      '   id_filial = :nFilial and id_impfiscal =:nIdImp';

    Qr := tabelaCreate(Str);
    Qr.ParamByName('dInicio').AsDate := DataInicio;
    Qr.ParamByName('dFim').AsDate := DataFim;
    //Qr.ParamByName('nFilial').AsInteger  := cls.nFilial;
    Qr.ParamByName('nIdImp').AsInteger   := EcfDm.Imp.ID;
    Qr.Open;

    if not Qr.Eof then
    begin
      if Qr.FieldByName('total').AsInteger = 1 then
      begin
        DataFim :=  Knt.Date.EndOfAMonth(Ano, Mes-1);
        DataInicio := Knt.Date.EncodeDate(Ano, Mes-1, 1);
        Device.LeituraMemoriaFiscal(DataInicio, DataFim, true);
      end;
    end;
  finally
    FreeAndNil(Qr);
  end;
end;

function TECF.EstaOK(Estado: TACBrECFEstadoSet): Boolean;
var EstImp : TACBrECFEstado;
begin
  result := true;
  EstImp := Device.Estado;
  if not(EstImp in Estado) then
  begin
    Knt.UserDlg.ErrorOK(
      'Impossível comandar a operação no estado:' + ECFEstados[EstImp]);
    result := false;
  end
end;

function TECF.FecharCupom(const Mensagem: String = ''): Boolean;
begin
  Device.FechaCupom(AnsiString(MensagemPromocional + knt.Cons.CRLF + Mensagem));
  Result := true;
end;

procedure TECF.LerReducaoZ;
var
  I: integer;
  Rdz : TCFRedZ;
begin
  Rdz := TCFRedZ.create;
  //mRZ.Clear;
  Device.DadosReducaoZ;
  //impECF.DadosUltimaReducaoZ ;
  with Device.DadosReducaoZClass do
  begin
    Rdz.DataImp     := DataDaImpressora;
    //Rdz.NumECF  := NumeroDeSerie;
    Rdz.NumeroECF      := NumeroDoECF;
    Rdz.loja        := NumeroDaLoja;
    Rdz.COOInicial  := NumeroCOOInicial;
    Rdz.DataMovimentacao := DataDoMovimento;
    Rdz.COO         := IntToStr(COO);
    Rdz.GNF         := IntToStr(GNF);
    Rdz.CRO         := IntToStr(CRO);
    Rdz.CRZ         := IntToStr(CRZ);
    Rdz.CCF         := IntToStr(CCF);
    Rdz.CFD         := IntToStr(CFD);
    Rdz.CDC         := IntToStr(CDC);
    Rdz.GRG         := IntToStr(GRG);
    Rdz.GNFC        := IntToStr(GNFC);
    Rdz.CFC         := IntToStr(CFC);

    Rdz.Grandetotal := ValorGrandeTotal;
    Rdz.Vendabruta  := ValorVendaBruta;
    Rdz.Cancelamentoicms := CancelamentoICMS;
    Rdz.DescontoICMS := DescontoICMS;
    Rdz.TotalISSQN := TotalISSQN;
    Rdz.CancelamentoISSQN := CancelamentoISSQN;
    Rdz.DescontoISSQN := DescontoISSQN;
    Rdz.VendaLiquida := VendaLiquida;
    Rdz.AcrescimoICMS := AcrescimoICMS;
    Rdz.AcrescimoISSQN := AcrescimoISSQN;

    Rdz.stICMS := SubstituicaoTributariaICMS;
    Rdz.IsentoICMS := IsentoICMS;
    Rdz.NaoTribicms := NaoTributadoICMS;

    Rdz.stISSQN := SubstituicaoTributariaISSQN;
    Rdz.IsentoISSQN := IsentoISSQN;
    Rdz.Naotribissqn := NaoTributadoISSQN;

    Rdz.Totoperacaonaofiscal := TotalOperacaoNaoFiscal;

    Rdz.Tottroco := TotalTroco;

    Rdz.idImpfiscal :=EcfDm.Imp.Id;
    Rdz.GravarTbl;


    // mRZ.Lines.Add( '{ ICMS }' );
    for I := 0 to ICMS.Count -1 do
    begin
      Rdz.InserirICMS(ICMS[I].Indice,ICMS[I].Tipo,ICMS[I].Aliquota,ICMS[I].Total);
    end;

    //mRZ.Lines.Add( '{ ISSQN }' );
    for I := 0 to ISSQN.Count -1 do
    begin
      Rdz.InserirISSQN(ISSQN[I].Indice,ISSQN[I].Tipo , ISSQN[I].Aliquota, ISSQN[I].Total);
    end;

    //mRZ.Lines.Add( '{ TOTALIZADORES NÃO FISCAIS }' );
    for I := 0 to TotalizadoresNaoFiscais.Count -1 do
    begin
     Rdz.InserirTotalizador(
       TotalizadoresNaoFiscais[I].Indice,
       TotalizadoresNaoFiscais[I].Descricao ,
       TotalizadoresNaoFiscais[I].FormaPagamento ,
       TotalizadoresNaoFiscais[I].Total,
       false);
    end;

    {
    //mRZ.Lines.Add( ' RELATÓRIO GERENCIAL ' );
    for I := 0 to RelatorioGerencial.Count -1 do
    begin
        mRZ.Lines.Add( 'Indice     : ' + RelatorioGerencial[I].Indice );
        mRZ.Lines.Add( 'Descrição  : ' + RelatorioGerencial[I].Descricao );
    end;
    mRZ.Lines.Add( '' );  }

    // mRZ.Lines.Add( '{ MEIOS DE PAGAMENTO }' );
    for I := 0 to MeiosDePagamento.Count -1 do
    begin
     Rdz.InserirTotalizador(
       MeiosDePagamento[I].Indice ,
       MeiosDePagamento[I].Descricao,
       '',
       MeiosDePagamento[I].Total,
       true);
    end;

  end;

  EmitirLeituraMemoriaDoMesPassado;
end;

procedure TFormaDePagto.buscarPorDescricao(Desc : string);
var Qr: TSQLQuery;
  Str: String;
begin
  try
    Str :=
      ' select cad_forma_pagamento.id_forma_pagamento,cad_forma_pagamento.pag_tipo,cad_forma_pagamento.pag_digitada, '+
      '   cad_forma_pagamento.pag_tef '   +
      ' from cad_forma_pagamento '+
      ' where ' +
      ' cad_forma_pagamento.pag_descricao = '+QuotedStr(Desc)+
      ' limit 1';
    Qr := tabelaCreate(Str);
    Qr.Open;

    if not Qr.Eof then
    begin
      ID        := Qr.FieldByName('id_forma_pagamento').AsInteger;
      TipoPagto := Qr.FieldByName('pag_tipo').AsInteger;
      Digitado  := (Qr.FieldByName('pag_digitada').AsInteger = 1);
      TEF       := Qr.FieldByName('pag_tef').AsInteger;
      //cCodigo := cNumSerial;//Qr.FieldByName('ifc_numfabricacao').AsString;
      Desc      := Desc;//Qr.FieldByName('ifc_numfabricacao').AsString;
    end
    else
    begin
      ID := -1;
    end;
  finally
    FreeAndNil(Qr);
  end;
end;

procedure TFormaDePagto.BuscarPorID(const IdBusca: integer);
begin
  inherited;
end;

function TFormaDePagto.gravarTbl: boolean;
begin
  Result := true;
end;

procedure TFormaDePagto.PegarDadosQry;
begin
  inherited;
end;

{ TObjBD }

constructor TObjBD.create;
begin
  FCon := EcfDm.Con;
  FCampos := TStringList.Create;
  FCampos.Add('ID');
end;

function TObjBD.existeObj: boolean;
//var cSQL
begin
   Result := true;
end;

function TObjBD.existeObj(Where: string): boolean;
var SQL : string;
    Qr : TSQLQuery;
begin

  SQL :=
    ' SELECT '+FTabela+'.'+FCampos[0]+
    ' FROM '+FTabela+
    ' WHERE '+Where;

  //tblCreate(SQL);
  Qr := tabelaCreate(SQL);
  try
    try
      Qr.Open;
      Id := Qr.FieldByName(FCampos[0]).AsInteger;
    except
      Id := -1
    end;
  finally
    FreeAndNil(Qr);
  end;

  Result := Id > 0;
end;

procedure TObjBD.tblCreate;
begin
  FreeAndNil(FQr);
  FQr := TSQLQuery.Create(nil);
  FQr.Active := false;
  FQr.SQLConnection := FCon;
end;

function TObjBD.existeObjAux(Id, Tabela, Where: string; var ValorId: integer):
    boolean;
var SQL : string;
begin
  SQL :=
    ' SELECT '+Id+
    ' FROM '+Tabela +
    ' WHERE '+
    Where+
    ' limit 1';

  tblCreate(SQL);

  with FQr do
  begin
    try
      Open;
      ValorId := FieldByName(Id).AsInteger;
    except
      ValorId := -1 ;
    end;
  end;
  Result := ValorId > 0;
end;

procedure TObjBD.tblCreate(const SQL: String);
begin
  FreeAndNil(FQr);
  FQr := TSQLQuery.Create(nil);
  FQr.Active := false;
  FQr.SQLConnection := FCon;
  FQr.SQL.Add(SQL);
end;

procedure TObjBD.PreencherPropriedades(const SQL: String);
begin
  tblCreate(SQL);
  FQr.Open;
  if not Eof then
  begin
    PegarDadosQry;
  end
  else
  begin
    FID := -2;
  end;
end;

procedure TObjBD.PreencherPropriedades;
begin
  PreencherPropriedades(FAuxStr);
end;

{ TCFOP }

procedure TCFOP.buscarPorCodigo(const cCodigo: string);
var Qr  : TSQLQuery;
    Str : String;
begin
  Str :=
  ' SELECT cad_cfop.cfo_basecomipi ,cad_cfop.cfo_sem_st , cad_cfop.id_cfop,cad_cfop.cfo_descricao,cad_cfop.cfo_codigo,cad_cfop.cfo_basecomseguro '+
  ' from cad_cfop where cad_cfop.cfo_codigo='+QuotedStr(cCodigo);

  Qr := tabelaCreate(Str);
  Qr.Open;
  if not Qr.Eof then
  begin
    ID := Qr.fieldbyname('id_cfop').AsInteger        ;
    Desc := Qr.fieldbyname('cfo_descricao').AsString   ;
    Codigo := Qr.fieldbyname('cfo_codigo').AsString      ;
    SemST := Qr.fieldbyname('cfo_sem_st').AsInteger = 1 ;
    BCComIPI := Qr.fieldbyname('cfo_basecomipi').AsInteger = 1 ;
    BCComSeguro := Qr.fieldbyname('cfo_basecomseguro').AsInteger = 1 ;
  end;
  FreeAndNil(Qr);
end;

procedure TCFOP.BuscarPorID(const IdBusca: integer);
var Qr: TSQLQuery;
  Str: String;
begin
  Str := ' SELECT  cad_cfop.cfo_basecomipi , cad_cfop.cfo_sem_st , '+
    'cad_cfop.id_cfop,cad_cfop.cfo_descricao,cad_cfop.cfo_codigo,cad_cfop.cfo_basecomseguro '+
    ' from cad_cfop where cad_cfop.id_cfop='+IntToStr(IdBusca);

  Qr := tabelaCreate(Str);
  Qr.Open;
  if not Qr.Eof then
  begin
    Id := Qr.fieldbyname('id_cfop').AsInteger        ;
    Desc := Qr.fieldbyname('cfo_descricao').AsString   ;
    Codigo := Qr.fieldbyname('cfo_codigo').AsString      ;
    SemST := Qr.fieldbyname('cfo_sem_st').AsInteger = 1 ;
    BCComIPI := Qr.fieldbyname('cfo_basecomipi').AsInteger = 1 ;
    BCComSeguro := Qr.fieldbyname('cfo_basecomseguro').AsInteger = 1 ;
  end;
  FreeAndNil(Qr);
end;

function TCFOP.gravarTbl: boolean;
begin
  Result := true;
end;

procedure TCFOP.PegarDadosQry;
begin
  inherited;

end;

{ TOperacao }

procedure TOperacao.BuscarPorID(const IdBusca: integer);
var Str : String;
begin
  Str := FSql +
    ' WHERE cad_operacao_cfop.id_operacao_cfop='+IntToStr(IdBusca);
  preencherPropriedades(Str);
end;

constructor TOperacao.create;
begin
  inherited;
  FCFOP  := TCFOP.create;
  FSql   :=
    ' SELECT '+
    '   cad_operacao_cfop.id_operacao_cfop, '+
    '   cad_operacao_cfop.id_cfop, '+
    ' cad_operacao_cfop.id_operacao,  '+
    ' cad_operacao.ope_operacao '+
    ' FROM cad_operacao_cfop '+
    ' JOIN cad_operacao ON cad_operacao_cfop.id_operacao = cad_operacao.id_operacao ';
end;

function TOperacao.gravarTbl: boolean;
begin
  Result := true;
end;

procedure TOperacao.PegarDadosQry;
var nLocalIDCfop: integer;
begin
  inherited;
  ID := FQr.fieldbyname('id_operacao_cfop').AsInteger;
  IDOperacao := FQr.fieldbyname('id_operacao').AsInteger;
  TipoOperacao := FQr.fieldbyname('ope_operacao').AsInteger;
  nLocalIDCfop := FQr.fieldbyname('id_cfop').AsInteger;
  CFOP.BuscarPorID(nLocalIDCfop);
end;

function TCupom.AlimentarEstoque(const Cancela: Boolean = false): Boolean;
var
  Qry: TSQLQuery;
  Qry2: TSQLQuery;
  QrProdComp: TSQLQuery;
  EhResultado: Boolean ;
  Sql: string ;
  Estoq: TEstLocal;
  Data: TDateTime ;
  TipoOpera: integer ;
  Destino: integer ;
  Produto: integer ;
  Qtde: Currency ;
  Item: integer ;
  Lote: integer ;
  Operacao: integer ;
  EhDevolucao: boolean ;
  idLoc: integer ;
  idEst: integer ;
  EstaCancelado: Boolean ;
  AlimentaEstoque: Boolean;
begin
  Qry := tabelaCreate ;
  Estoq := TEstLocal.create;

  QrProdComp := tabelaCreate(
    ' SELECT '+
    '   cad_composicao_produto.id_produto, '+
    '   cad_composicao_produto.com_quantidade, '+
    '   cad_composicao_produto.id_produto_composicao '+
    ' FROM '+
    '   cad_composicao_produto '+
    ' WHERE cad_composicao_produto.id_produto =:idprod');
  try
  Qry.sql.Clear ;

  Qry.Sql.Text :=
   ' SELECT '+
   '   fat_faturamento.id_faturamento, ' +
   '   fat_faturamento.id_operacao_cfop,'+
   '   fat_faturamento.fat_data , '+
   '   fat_faturamento.fat_tipo_operacao as operacao, '+
   '   fat_faturamento.fat_destino as destino, '+
   '   fat_item.id_produto, '+
   '   fat_item.ite_quantidade, '+
   '   fat_item.id_item, '+
   '   cad_serie_item.id_lote, '+
   '   cad_produtos.pro_composto, '+
   '   0 as fat_situacao '+
   ' FROM '+
   '   fat_faturamento '+
   '   inner join fat_item on fat_faturamento.id_faturamento = fat_item.id_faturamento '+
   '   left join cad_serie_item on  fat_item.id_item = cad_serie_item.id_item '+
   '   JOIN cad_produtos ON fat_item.id_produto = cad_produtos.id_produto '+
   ' WHERE '+
   '   fat_faturamento.id_faturamento = :id'+
   ' UNION ALL '+
   ' SELECT '+
   '   fat_faturamento.id_faturamento, '+
   '   fat_faturamento.id_operacao_cfop,'+
   '   fat_faturamento.fat_data , '+
   '   fat_faturamento.fat_tipo_operacao as operacao, '+
   '   fat_faturamento.fat_destino as destino, '+
   '   fat_item.id_produto, '+
   '   fat_item.ite_quantidade, '+
   '   fat_item.id_item, '+
   '   cad_serie_item.id_lote, '+
   '   cad_produtos.pro_composto, '+
   '   fat_faturamento.fat_situacao '+
   ' from '+
   '   fat_faturamento '+
   '   inner join fat_item on fat_faturamento.id_faturamento = fat_item.id_faturamento '+
   '   left join cad_serie_item on  fat_item.id_item = cad_serie_item.id_item '+
   '   JOIN cad_produtos ON fat_item.id_produto = cad_produtos.id_produto '+
   ' where '+
   '   fat_faturamento.fat_situacao = 40 AND '+
   '   fat_faturamento.id_faturamento = :id';

  //Qry.sql.Add(Sql) ;
  Qry.ParamByName('id').AsInteger := FID;
  Qry.open ;

  if Qry.eof then
  begin
    exit ;
  end;

  //alimenta estoque para todos os itens ;
  while not Qry.eof do
  begin
    Data      := Qry.FieldByName('fat_data').AsDateTime ;
    TipoOpera := Qry.FieldByName('operacao').AsInteger  ;
    Destino   := Qry.FieldByName('destino').AsInteger  ;
    Operacao  := Qry.FieldByName('id_operacao_cfop').AsInteger  ;
    EstaCancelado   := Qry.FieldByName('fat_situacao').AsInteger = 40;
    //Se não alimentar estoque
    //if cls.Estoque(Operacao,EhDevolucao,idLoc) then
    if AlimentaEstoque then
    begin
      Produto   := Qry.FieldByName('id_produto').AsInteger  ;
      Qtde      := Qry.FieldByName('ite_quantidade').AsCurrency  ;
      Item      := Qry.FieldByName('id_item').AsInteger  ;
      Lote      := -1;//FieldByName('id_lote').AsInteger  ;

      if Qry.FieldByName('pro_composto').AsInteger = 1 then
      begin
        QrProdComp.Close;
        QrProdComp.ParamByName('idprod').AsInteger := Produto;
        QrProdComp.Open;

        while not QrProdComp.Eof do
        begin
          Estoq.preencheProp(
            Qry.FieldByName('id_faturamento').AsInteger,
            -1, Item,
            QrProdComp.FieldByName('id_produto_composicao').AsInteger,
            Data,
            QrProdComp.FieldByName('com_quantidade').AsCurrency*Qtde,
            Time, Lote, TipoOpera, Destino, EhDevolucao, idLoc,EstaCancelado);
          Estoq.movimentarEstoque;
          QrProdComp.Next;
        end;
      end
      else
      begin
        Estoq.preencheProp(
          Qry.FieldByName('id_faturamento').AsInteger,
          -1, Item, Produto, Data, Qtde, Time,
          Lote, TipoOpera, Destino, EhDevolucao, idLoc,EstaCancelado);
        Estoq.movimentarEstoque;
      end;
    end;
    Qry.Next ;
  end;
  finally
    freeandnil(Qry);
    freeandnil(QrProdComp);
    freeandnil(Estoq);
  end;
end;

procedure TCupom.bckUpItens;
var TamAtual: integer;
  i: integer;
  j: integer;
begin
  TamAtual := high( fItens);// contaItensValidos;
  SetLength( FItensBckUp, TamAtual+1);
  j := 0 ;
  for i := 0 to high( FItensBckUp) do
  begin
    //if  fitens[i].oProduto.FID >= 0 then
    //begin
       FItensBckUp[j] :=  fitens[i];
      j := j + 1;
    //end;
  end;
end;

procedure TCupom.buscaFilial;
var Qr: TSQLQuery;
  Str: String;
begin
  Str := ' Select cad_estado.est_sigla '+
          ' from cad_filial '+
          ' join cad_logradouro on cad_filial.id_cep = cad_logradouro.id_logradouro '+
          ' join cad_bairro on cad_logradouro.id_bairro = cad_bairro.id_bairro '+
          ' join cad_cidade on cad_bairro.id_cidade = cad_cidade.id_cidade '+
          ' join cad_estado on cad_cidade.id_estado = cad_estado.id_estado ';
  Qr := tabelaCreate(Str);
  Qr.Open;

  FEstadoOri := Qr.FieldByName('est_sigla').Text;
  FreeAndNil(Qr);
end;

procedure TCupom.BuscarPorCOO(const numCOO :string; const numSerie : string);
var Str: String;
begin
 Str :=  FSql +
    ' AND cad_impfiscal.ifc_numfabricacao =' + QuotedStr(numSerie)+
    ' AND fat_cf.cf_coo =' + QuotedStr(numCOO) +
    ' order by fat_cf.cf_data desc '+
    ' limit 1 ';
  if Str <> EmptyStr then
  begin
    PreencherPropriedades(Str);
  end;
end;

function TCupom.CancelarItem(const Sequencia: integer): boolean;
var Qr  : TSQLQuery;
    SQL : string;
begin
  SQL :=
  ' UPDATE fat_cf_item '+
  ' SET cfit_situacao=1 '+
  ' WHERE '+
  '  fat_cf_item.cfit_situacao = 0 AND '+
  '  fat_cf_item.id_cf = :id AND '+
  '  fat_cf_item.cfit_sequencia =:nSeq';
  try
    try
      Qr := tabelaCreate(SQL);
      Qr.ParamByName('id').AsInteger := ID;
      Qr.ParamByName('nSeq').AsCurrency := Sequencia;
      Qr.ExecSQL;
      Result := Qr.RowsAffected > 0;
    except
      Result := false;
    end;
  finally
    FreeAndNil(Qr)
  end;
end;

constructor TCupom.create;
begin
  inherited;
   FSql :=
    ' SELECT fat_cf.id_cf '+
    ' FROM fat_cf '+
    ' JOIN cad_impfiscal ON fat_cf.id_impfiscal = cad_impfiscal.id_impfiscal ';
end;

function TCupom.getAliqInterna: Currency;
var Qr: TSQLQuery;
    Str: String;
begin
  Result :=  FAliqInterna;
  if  FAliqInterna > -1 then
  begin
    Str := 'select est_icms from cad_estado where est_sigla = '+QuotedStr( FCedente.SiglaEstado);
    Qr := tabelaCreate(Str);
    Qr.Open;

    if not Qr.Eof then
      Result := Qr.FieldByName('est_icms').AsCurrency;

    FreeAndNil(Qr);
  end;
   FAliqInterna := Result;
end;

function TCupom.getAliqOperacao: Currency;
begin

end;

function TCupom.getItem(Index: Integer): TCFItem;
var Erro : Boolean;
begin
  Erro := false;
  Result := nil;
  if (not Erro and ((FItens = nil) or (high(FItens)< index ))) then
  begin
    Result := nil;
    Erro := true;
  end;

  if not Erro then
  begin
    Result := FItens[index];
  end;
end;

procedure TCupom.gravarCancelamento(const Data: TDateTime);
var Qr  : TSQLQuery;
    SQL : string;
begin
  SQL :=
  ' UPDATE fat_cf '+
  ' SET cf_datacancelamento = :data '+
  ' where id_cf='+IntToStr(ID);
  try
    Qr := tabelaCreate(SQL);
    Qr.ParamByName('data').AsDateTime := Now;
    Qr.ExecSQL;
  finally
    FreeAndNil(Qr);
  end;
end;

procedure TCupom.gravarCancelamento;
var Qr  : TSQLQuery;
    SQL : string;
begin
  SQL :=
  ' UPDATE fat_cf '+
  ' SET '        +
  '   cf_datacancelamento = :data '+
  ' where id_cf='+IntToStr(ID);

//  '   cf_total = :nValor '+
  try

    Qr := tabelaCreate(SQL);
    Qr.ParamByName('data').AsDateTime := Data;
    //Qr.ParamByName('nValor').AsCurrency := nValor;
    Qr.ExecSQL;
  finally
    FreeAndNil(Qr);
  end;
end;

function TCupom.gravarPagamento(IDPgto: integer; Valor: Currency; Coo, Ccf,
    Gnf: string): boolean;
var Qr  : TSQLQuery;
    SQL : string;
begin
  Result := true;
  SQL :=
  ' INSERT INTO '+
  '  fat_cf_pagto(id_forma_pagamento,cfpg_valor,id_cf,'+
  '  cfpg_coo, cfpg_ccf, cfpg_gnf) '+
  ' VALUES (:nIDPgto,:nValor,:nIdCf,:coo, :ccf, :cgnf)';
  try
    try
      Qr := tabelaCreate(SQL);
      Qr.ParamByName('nIDPgto').AsInteger := IDPgto;
      Qr.ParamByName('nValor').AsCurrency := Valor;
      Qr.ParamByName('nIdCf').AsCurrency  := ID;

      Qr.ParamByName('coo').AsString   := CoO;
      Qr.ParamByName('ccf').AsString   := CCF;
      Qr.ParamByName('cgnf').AsString   := GNF;
      Qr.ExecSQL;
    except
      Result := false;
    end;
  finally
    FreeAndNil(Qr)
  end;
end;

procedure TCupom.gravarTbl;
var Qr  : TSQLQuery;
    Str : String;
begin
 //verifica situacao da nota fiscal eletronica.
 Str := ' UPDATE fat_CF SET '+
  ' id_cliente='+IntToStr(ID)+
  ' ,cf_data= :data'+
  ' ,cf_situacao='+IntToStr(Situacao)+
  ' ,cf_coo='+QuotedStr(Coo)+
  ' ,cf_gnf='+QuotedStr(Gnf)+
  ' ,cf_grg='+QuotedStr(Grg)+
  ' ,cf_cdc='+QuotedStr(Cdc)+
  ' ,cf_ccf='+QuotedStr(Ccf)+
  ' ,cf_total=:nTotal'+
  ' ,cf_desconto=:nDesconto '+
  ' ,cf_troco=:nTroco '+
  ' ,id_impfiscal='+IntToStr(IDImpFiscal)+
  ' ,id_operacao_cfop='+IntToStr(Oper.ID)+
  ' WHERE id_cf='+IntToStr(ID);

  try
    Qr := tabelaCreate(Str);
    Qr.ParamByName('data').AsDateTime      := Data;
    Qr.ParamByName('nTotal').AsCurrency    := Total;
    Qr.ParamByName('nDesconto').AsCurrency := Desconto;
    Qr.ParamByName('nTroco').AsCurrency    := Troco;
    Qr.ExecSQL;
  finally
    FreeAndNil(Qr);
  end;

end;

procedure TCupom.gravarTblItem(const Sequencia: integer);
var Qr  : TSQLQuery;
    Str : String;
begin
  try
    with  Itens[Sequencia-1] do
    begin
        Str :=
        ' INSERT INTO fat_cf_item '+
        ' (   id_produto,cfit_preco_venda,'+
        '     cfit_quantidade,cfit_desconto_item,'+
        '     cfit_AliqInterna, '+
        '     id_cfop,'+
        '     id_cst,cfit_sequencia, '+
        '     id_unidade, '+
        '     id_cf ) VALUES '+
        ' ( '+IntToStr(Produto.ID)+',:nPreco,'+
        '   :nQuant,:nDesc,'+
        '   :nAliqInterna, '+
        '   '+IntToStr(CFO.ID)+','+
        '   '+IntToStr(CST.ID)+','+IntToStr(Sequencia)+','+
        '   '+IntToStr(Unidade.ID)+','+
        '   '+IntToStr( ID)+')';
    end;

    Qr := tabelaCreate(Str);

    with  Itens[Sequencia-1] do
    begin
      Qr.ParamByName('nPreco').AsCurrency := Preco;
      Qr.ParamByName('nQuant').AsCurrency := Quant;
      Qr.ParamByName('nDesc').AsCurrency  := Desc;
      Qr.ParamByName('nAliqInterna').AsCurrency := AliqInterna;
    end;
    Qr.ExecSQL;
  finally
    FreeAndNil(Qr);
  end;
 {
  if IDItem <= 0 then
  begin
    try
      Str :=
      ' SELECT id_item '+
      ' FROM fat_cf_item '+
      ' WHERE fat_cf_item.cfit_sequencia ='+IntToStr(Sequencia) +
      ' AND fat_cf_item.id_cf =' +IntToStr( ID);
      Qr := UtilsU.TabelaCreate(Str);
      Qr.Open;
      IDItem := Qr.fieldByName('id_item').asinteger;
    finally
      FreeAndNil(Qr);
    end;
  end;  }
end;

function TCupom.inserirItem: integer;
var nTamAtual  : integer;
    nPos       : integer;
begin
  //Ao setar o novo tamanho é perdido os dados existentes
  //Por isso faço backup dos itens ---Length
   bckUpItens;
  nTamAtual := Length( fitens);
  SetLength( FItens,nTamAtual+1);
  nPos := high( FItens);
   FItens[nPos] := TCFItem.create;
  //
   FItens[nPos].CFO.BuscarPorID(Oper.FIDcfop);

  // FItens[nPos].oCST.BuscarPorID(  );

  //Restauro os dados dos itens
   restoreItens;
  Result := nPos;
end;

procedure TCupom.preencherPropriedades(const SQL: String);
begin

end;

procedure TCupom.RecalcularImpostos;
var i: integer;
  Tot: integer;
begin
  //se o cedente for contribuinte calcula impostos para o cedente
  if Cedente.EhContribuinte then
  begin
    Tot := high(fitens);
    for i:=0 to Tot do
    begin
      RecalcularImpostos(i);
    end;
  end;
end;

procedure TCupom.RecalcularImpostos(nIndexItem: integer);
begin
  //Recalcula os impostos da nota fiscal
  if Cedente.EhContribuinte then
  begin
    FItens[nIndexItem].ValorICMS:= FItens[nIndexItem].getValorICMS ;

    FItens[nIndexItem].BaseICMS := FItens[nIndexItem].TotalItem +
      FItens[nIndexItem].FreteNota + FItens[nIndexItem].OutrosNota +
      IfThen(FItens[nIndexItem].FCFO.BCComIPI, FItens[nIndexItem].valorIPI, 0)+
      IfThen(FItens[nIndexItem].FCFO.BCComSeguro, FItens[nIndexItem].SeguroNota, 0);

    FItens[nIndexItem].BaseST   := FItens[nIndexItem].getBaseST;
    FItens[nIndexItem].ValorST  := FItens[nIndexItem].getValorST;

    if FItens[nIndexItem].CFO.SemST then
    begin
      FItens[nIndexItem].BaseST   :=  0 ;
      FItens[nIndexItem].ValorST  :=  0 ;
    end;
  end;
end;

procedure TCupom.removerUltimoItem;
begin

end;

procedure TCupom.restoreItens;
begin

end;

function TCupom.RetornaMvaOperacaoUF(idProd: Integer; UFOrig,
  UFDest: String): Currency;
begin

end;

procedure TCupom.setItem(Index: Integer; Value: TCFItem);
begin

end;

procedure TProduto.BuscarPorID(const IdBusca: integer);
begin
  inherited;
end;

constructor TProduto.create;
begin
  FCST := TCST.Create;
end;

function TProduto.gravarTbl: boolean;
begin
  Result := true;
end;

procedure TProduto.PegarDadosQry;
begin
  inherited;

end;

procedure TProduto.setFID(nIDProd: integer);
begin
  FID := nIDProd;
  FCST.buscarCSTPorProd(nIDProd);
end;

{ TCST }

procedure TCST.buscarCSTPorProd(const IDProd: integer);
var Qr: TSQLQuery;
    Str: String;
begin
  Str := ' SELECT '+
    '   cad_cst.id_cst,cad_cst.cst_descricao,cad_cst.cst_cod_cst, '+
    '   cad_cst.cst_origem,cad_cst.cst_classificacao '+
    ' FROM cad_cst '+
    ' JOIN cad_tributacao_produto on cad_tributacao_produto.tri_icms_situacao_tributaria = cad_cst.id_cst '  +
    ' WHERE cad_tributacao_produto.id_produto ='+IntToStr(IDProd);

  Qr := tabelaCreate(Str);
  Qr.Open;
  if not Qr.Eof then
  begin
    FID        := Qr.fieldbyName('id_cst').AsInteger;
    FCodigo    := Qr.fieldbyName('cst_cod_cst').Text;
    FDesc      := Qr.fieldbyName('cst_descricao').Text;
    FOrigem    := Qr.fieldbyName('cst_origem').AsInteger;
    FClassific := Qr.fieldbyName('cst_classificacao').AsInteger;
  end;
  FreeAndNil(Qr);
end;

procedure TCST.BuscarPorID(const IdBusca: integer);
var Qr  : TSQLQuery;
    Str : String;
begin
  Str :=
  ' SELECT cad_cst.id_cst,cad_cst.cst_origem ,cad_cst.cst_origem,cad_cst.cst_cod_cst,cad_cst.cst_descricao,cad_cst.cst_classificacao from cad_cst where cad_cst.id_cst='+IntToStr(IdBusca);

  Qr := tabelaCreate(Str);
  Qr.Open;
  if not Qr.Eof then
  begin
    FID        := Qr.fieldbyName('id_cst').AsInteger;
    FCodigo    := Qr.fieldbyName('cst_cod_cst').Text;
    FDesc      := Qr.fieldbyName('cst_descricao').Text;
    FOrigem    := Qr.fieldbyName('cst_origem').AsInteger;
    FClassific := Qr.fieldbyName('cst_classificacao').AsInteger;
  end;
  FreeAndNil(Qr);
end;

function TCST.gravarTbl: boolean;
begin
  Result := true;
end;

procedure TCST.PegarDadosQry;
begin
  inherited;
end;

{ TCFItem }

constructor TCFItem.create;
begin
  FProduto := TProduto.Create;
  FUnidade := TUnidade.create ;
  FCFO     := TCFOP.Create;
  FCST     := TCST.Create;
end;

function TCFItem.getBaseST: currency;
var
  BsIcms : Currency ;
begin
  BsIcms := BaseICMS;
  //BC ST = BC ICMS + (BC ICMS * %MVA / 100) ;

  Result := 0 ;
  if MVA > 0 then
    Result := BsIcms +(BsIcms * MVA / 100);
end;

function TCFItem.getTotalItem: currency;
begin
  Result := FQuant * (FPreco - FDesc);
end;

function TCFItem.getTotalItemRateoNota: currency;
begin
  Result := FQuant * (FPreco - FDesc);
end;

function TCFItem.getValorICMS: currency;
var
  VlrSoma : Currency ;
begin
  VlrSoma := getTotalItem + FreteNota + OutrosNota  ;

  if FCFO.BCComIPI then
    VlrSoma := getTotalItem + FreteNota + OutrosNota + ValorIPI ;

  if FCFO.BCComSeguro then
    VlrSoma := VlrSoma + SeguroNota;

  Result := VlrSoma * AliqOperacao / 100;
end;

function TCFItem.getValorIPI: currency;
begin
  Result := getTotalItem * FAliqIPI / 100;
end;

function TCFItem.getValorST: currency;
var BsST: Currency;
  CredICMS : Currency;
begin
  BsST := BaseST;
  Result := 0 ;
  if BsST > 0 then
  begin
    //CRED ICMS = BC ST * ALIQ.ICMS / 100 ;
    CredICMS :=  BsST * AliqInterna / 100;
    //VLR ST =  CRED ICMS - VLR ICMS ;
    Result := CredICMS - ValorICMS;
  end;
  //CRED ICMS = BC ST * ALIQ.ICMS / 100 ;
  //CredICMS :=  BsST * AliqInterna / 100;
  //VLR ST =  CRED ICMS - VLR ICMS ;
end;

{ TEstLocal }

function TEstLocal.AtualizarEstoque: boolean;
begin
  ID := FQr.fieldbyname('id_estoque').AsInteger ;
  FIDFaturamento := FQr.fieldbyname('id_faturamento').AsInteger;
  FIDCF := FQr.fieldbyname('id_cf').AsInteger;
  FIDItem := FQr.fieldbyname('id_item').AsInteger;
  FIDProduto := FQr.fieldbyname('id_produto').AsInteger;
  FData := FQr.fieldbyname('est_data').AsDateTime;
  FQuantidade := FQr.fieldbyname('est_quantidade').AsCurrency;
  FHora := FQr.fieldbyname('est_hora').AsDateTime;
  FIDLote := FQr.fieldbyname('id_lote').AsInteger;
  FOperacao := FQr.fieldbyname('est_operacao').AsInteger;
  FDestino := FQr.fieldbyname('est_destino').AsInteger;
  FDevolucao := FQr.fieldbyname('est_devolucao').AsInteger = 1;
  FIDLocal := FQr.fieldbyname('id_local').AsInteger;
end;

procedure TEstLocal.BuscarPorID(const IdBusca: integer);
begin
  FAuxStr := FSql + ' WHERE est_local.id_estoque='+IntToStr(IdBusca);
  PreencherPropriedades();
end;

constructor TEstLocal.create(IDFaturamento, IDCF, IDItem, IDProduto: integer;
  Data: TDateTime; Quantidade: Currency; Hora: TDateTime; IDLote: integer;
  Operacao, Destino: Smallint; Devolucao: Boolean; IDLocal: integer;
  Cancela: boolean);
begin
  //inherited create;
  create;
  FIDFaturamento := IDFaturamento;
  FIDCF := IDCF;
  FIDItem := IDItem;
  FIDProduto := IDProduto;
  FData := Data;
  FQuantidade := Quantidade;
  FHora := Hora;
  FIDLote := IDLote;
  FOperacao := Operacao;
  FDestino := Destino;
  FDevolucao := Devolucao;
  FIDLocal := IDLocal;
  FCancela := Cancela;
end;

constructor TEstLocal.create;
begin
  inherited;
  FTabela    := ' est_local ';
  FCampos[0] := 'id_estoque';
  FSql       :=
  ' SELECT est_local.id_estoque, est_local.id_faturamento,est_local.id_cf, '+
  '   est_local.id_item,est_local.id_produto,est_local.est_data,est_local.est_quantidade, '+
  '   est_local.est_hora,est_local.id_lote,est_local.est_operacao,est_local.est_destino, '+
  '   est_local.est_devolucao,est_local.id_local '+
  ' FROM est_local ';
end;

function TEstLocal.gravarTbl: boolean;
begin
  Result := true;
end;

function TEstLocal.InserirEstoque: boolean;
var Qr: TSQLQuery;
begin
  Qr := tabelaCreate(
  'insert into est_local('+
  '  id_faturamento,'+
  '  id_cf,'+
  '  id_item,'+
  '  id_produto,'+
  '  est_data,'+
  '  est_quantidade,'+
  '  est_hora,'+
  '  id_lote,'+
  '  est_operacao,'+
  '  est_destino,'+
  '  est_devolucao,'+
  '  id_local) values('+
  IfThen(FIDFaturamento > 0, inttostr(FIDFaturamento), 'NULL') + ','+
  IfThen(FIDCF > 0, inttostr(FIDCF), 'NULL')+ ','+
  inttostr(FIDItem) + ','+
  inttostr(FIDProduto) + ','+
  QuotedStr(FormatDateTime('yyyymmdd', FData)) + ','+
  ':quant,'+
  QuotedStr(FormatDateTime('hh:mm:ss', Time)  ) + ','+
  IfThen(FIDLote > 0, inttostr(FIDLote), 'NULL') + ','+
  inttostr(FOperacao) + ','+
  inttostr(FDestino) + ','+
  IfThen(FDevolucao, '1','0') + ','+
  IfThen(FIDLocal > 0, inttostr(FIDLocal), 'NULL') + ')');
  try
    try
      Qr.ParamByName('quant').AsCurrency := FQuantidade;
      Qr.ExecSQL;
      Result := Qr.RowsAffected > 0;
    except
      Result := false;
    end;
  finally
    FreeAndNil(Qr);
  end;
end;

function TEstLocal.MovimentarEstoque: boolean;
var ret : boolean;
begin
  ret := false;
  if existeObj(
    ' id_produto = '+IntToStr(FIDProduto)+
    ' AND id_item = '+IntToStr(FIDItem)+
    ' AND (id_faturamento = '+IntToStr(FIDFaturamento)+' OR id_faturamento IS NULL)'+
    ' AND (id_cf = '+IntToStr(FIDCF)+' OR id_cf IS NULL)') then
  begin
    //Ok, entrou aki pq achou o estoque desta nota
    //Será verifica se é cancelamento ou não
    if FCancela then
    begin
      //Buscará o estoque pelo ID para carregar os dados do estoque.
      BuscarPorID(ID);
      if FID > 0 then
      begin
        //Inverterá os valores do estoque para gerar o oposto ao da nota
        FQuantidade := FQuantidade *-1;
        ret := InserirEstoque;
      end;
    end
    else
    begin
      //atualizará com os novos valores
      ret := AtualizarEstoque;
    end;
  end
  else
  begin
    //Só poderá incluir o valor direto quando não for cancelamento
    //Caso irá alimentar com se fosse uma compra ou venda.
    if not FCancela then
    begin
      ret := InserirEstoque;
    end;
  end;

  Result := ret;
end;

procedure TEstLocal.PegarDadosQry;
begin
  ID := FQr.Fieldbyname('id_estoque').AsInteger ;
  FIDFaturamento := FQr.Fieldbyname('id_faturamento').AsInteger;
  FIDCF := FQr.Fieldbyname('id_cf').AsInteger;
  FIDItem := FQr.Fieldbyname('id_item').AsInteger;
  FIDProduto := FQr.Fieldbyname('id_produto').AsInteger;
  FData := FQr.Fieldbyname('est_data').AsDateTime;
  FQuantidade := FQr.Fieldbyname('est_quantidade').AsCurrency;
  FHora := FQr.Fieldbyname('est_hora').AsDateTime;
  FIDLote := FQr.Fieldbyname('id_lote').AsInteger;
  FOperacao := FQr.Fieldbyname('est_operacao').AsInteger;
  FDestino := FQr.Fieldbyname('est_destino').AsInteger;
  FDevolucao := FQr.Fieldbyname('est_devolucao').AsInteger = 1;
  FIDLocal := FQr.Fieldbyname('id_local').AsInteger;
end;

procedure TEstLocal.preencheProp(IDFaturamento, IDCF, IDItem,
  IDProduto: integer; Data: TDateTime; Quantidade: Currency; Hora: TDateTime;
  IDLote: integer; Operacao, Destino: Smallint; Devolucao: Boolean;
  IDLocal: integer; Cancela: boolean);
begin
  FIDFaturamento := IDFaturamento;
  FIDCF := IDCF;
  FIDItem := IDItem;
  FIDProduto := IDProduto;
  FData := Data;
  FQuantidade := Quantidade;
  FHora := Hora;
  FIDLote := IDLote;
  FOperacao := Operacao;
  FDestino := Destino;
  FDevolucao := Devolucao;
  FIDLocal := IDLocal;
  FCancela := Cancela;
end;

procedure TCedente.buscarPorCNPJ(const CNPJ: string);
begin

end;

procedure TCedente.BuscarPorID(const IdBusca: integer);
var Str : String;
begin
  Str :=  FSql +
    ' WHERE cad_cliente.id_cliente='+IntToStr(IdBusca);
   PreencherPropriedades(Str);
end;

procedure TCedente.carregarEndereco;
begin
   FEnder.IDCep := IDCep;
end;

procedure TCedente.CarregarEnderecoEntrega;
begin
   FEnder.IDCep :=  IDCepEntrega;
end;

constructor TCedente.create;
begin
  inherited;
   FEnder := TEndereco.create;
   FSql :=
    ' SELECT cad_cliente.cli_pessoa,cad_cliente.id_cliente,cad_cliente.cli_nome, '+
    '   cad_cliente.id_cep,cad_cliente.cli_contribuinte,cad_cliente.cli_pessoa,  '+
    '   cad_detalhe_cliente_fisica.dcf_cpf, cad_detalhe_cliente_juridica.dcj_cnpj, '+
    '   cad_cliente.cli_num_entrega, cad_cliente.cli_num_endereco,cad_cliente.id_representante '+
    ' FROM cad_cliente '+
    ' LEFT JOIN cad_detalhe_cliente_fisica on cad_cliente.id_cliente = cad_detalhe_cliente_fisica.id_cliente '+
    ' LEFT JOIN cad_detalhe_cliente_juridica on cad_cliente.id_cliente = cad_detalhe_cliente_juridica.id_cliente ';
end;

function TCedente.gravarTbl: boolean;
begin
  Result := true;
end;

procedure TCedente.PegarDadosQry;
begin
  inherited;
  ID     := FQr.Fieldbyname('id_cliente').AsInteger ;
  // cCodigo := fieldbyname('id_cst').AsString  ;
  Razao  := FQr.Fieldbyname('cli_nome').AsString  ;
  IDCep  := FQr.Fieldbyname('id_cep').AsInteger  ;
  //SiglaEstado := cls.oEnd.buscaEstadoSigla(IDCep);

  EhContribuinte   := FQr.Fieldbyname('cli_contribuinte').AsInteger = 1;
  IdRepresentante := FQr.Fieldbyname('id_representante').AsInteger;
  EhPessoaFisica   := FQr.Fieldbyname('cli_pessoa').AsInteger = 1;
  NumEnder        := FQr.Fieldbyname('cli_num_endereco').AsString;
  NumEnderEntrega := FQr.Fieldbyname('cli_num_entrega').AsString;
  if  EhPessoaFisica then
     IdentNacional := FQr.Fieldbyname('dcf_cpf').AsString
  else
     IdentNacional := FQr.Fieldbyname('dcj_cnpj').AsString;
end;

procedure TEndereco.BuscarEndereco;
begin

end;

constructor TEndereco.Create(pPais, pEstado, pCidade, pBairro, pEndereco,
  pCep: string);
begin

end;

constructor TEndereco.Create;
begin
end;

function TEndereco.GetNomeEstado(SiglaUF: String): String;
begin
  SiglaUF := UpperCase(SiglaUF);
  Result := SiglaUF;

 if SiglaUF = 'AL' then Result := 'ALAGOAS';
 if SiglaUF = 'AP' then Result := 'AMAPÁ';
 if SiglaUF = 'AM' then Result := 'AMAZONAS';
 if SiglaUF = 'BA' then Result := 'BAHIA';
 if SiglaUF = 'CE' then Result := 'CEARÁ';
 if SiglaUF = 'DF' then Result := 'DISTRITO FEDERAL';
 if SiglaUF = 'ES' then Result := 'ESPÍRITO SANTO';
 if SiglaUF = 'GO' then Result := 'GOIÁS';
 if SiglaUF = 'MA' then Result := 'MARANHÃO';
 if SiglaUF = 'MT' then Result := 'MATO GROSSO';
 if SiglaUF = 'MS' then Result := 'MATO GROSSO DO SUL';
 if SiglaUF = 'MG' then Result := 'MINAS GERAIS';
 if SiglaUF = 'PA' then Result := 'PARÁ';
 if SiglaUF = 'PB' then Result := 'PARAÍBA';
 if SiglaUF = 'PR' then Result := 'PARANÁ';
 if SiglaUF = 'PE' then Result := 'PERNAMBUCO';
 if SiglaUF = 'PI' then Result := 'PIAUÍ';
 if SiglaUF = 'RJ' then Result := 'RIO DE JANEIRO';
 if SiglaUF = 'RN' then Result := 'RIO GRANDE DO NORTE';
 if SiglaUF = 'RS' then Result := 'RIO GRANDE DO SUL';
 if SiglaUF = 'RO' then Result := 'RONDÔNIA';
 if SiglaUF = 'RR' then Result := 'RORAIMA';
 if SiglaUF = 'SC' then Result := 'SANTA CATARINA';
 if SiglaUF = 'SP' then Result := 'SÃO PAULO';
 if SiglaUF = 'SE' then Result := 'SERGIPE';
 if SiglaUF = 'TO' then Result := 'TOCANTINS';
 if SiglaUF = 'EX' then Result := 'EXTERIOR';
end;

function TEndereco.GravarEndereco: Integer;
begin
  Result := 0;
end;

function TEndereco.RetornarSiglaEstado(NomeEstado: String): String;
begin
  Result := NomeEstado ;
  if NomeEstado = 'ALAGOAS' then Result := 'AL' ;
  if NomeEstado = 'AMAPÁ' then Result:= 'AP' ;
  if NomeEstado = 'AMAZONAS' then Result := 'AM' ;
  if NomeEstado = 'BAHIA' then Result:= 'BA' ;
  if NomeEstado = 'CEARÁ' then Result:= 'CE' ;
  if NomeEstado = 'DISTRITO FEDERAL' then Result := 'DF' ;
  if NomeEstado = 'ESPÍRITO SANTO' then Result := 'ES' ;
  if NomeEstado = 'GOIÁS' then Result:= 'GO' ;
  if NomeEstado = 'MARANHÃO' then Result := 'MA' ;
  if NomeEstado = 'MATO GROSSO' then Result := 'MT' ;
  if NomeEstado = 'MATO GROSSO DO SUL' then Result := 'MS' ;
  if NomeEstado = 'MINAS GERAIS' then Result := 'MG' ;
  if NomeEstado = 'PARÁ' then Result:='PA' ;
  if NomeEstado = 'PARAÍBA' then Result := 'PB' ;
  if NomeEstado = 'PARANA' then Result:= 'PR' ;
  if NomeEstado = 'PERNAMBUCO' then Result := 'PE' ;
  if NomeEstado = 'PIAUÍ' then Result:= 'PI' ;
  if NomeEstado = 'RIO DE JANEIRO' then Result := 'RJ' ;
  if NomeEstado = 'RIO GRANDE DO NORTE' then Result := 'RN' ;
  if NomeEstado = 'RIO GRANDE DO SUL' then Result := 'RS' ;
  if NomeEstado = 'RONDÔNIA' then Result := 'RO' ;
  if NomeEstado = 'RORAIMA' then Result := 'RR' ;
  if NomeEstado = 'SANTA CATARINA' then Result := 'SC' ;
  if NomeEstado = 'SÃO PAULO' then Result := 'SP' ;
  if NomeEstado = 'SERGIPE' then Result := 'SE' ;
  if NomeEstado = 'TOCANTINS' then Result := 'TO' ;
end;

procedure TEndereco.SetBairro(const Value: String);
begin
  FBairro := trim(uppercase(Value));
end;

procedure TEndereco.SetCep(const Value: string);
begin
  FCep := trim(uppercase(Value));
end;

procedure TEndereco.SetCidade(const Value: string);
begin
  FCidade := trim(uppercase(Value));
end;

procedure TEndereco.SetEndereco(const Value: string);
begin
  FEndereco := trim(uppercase(Value));
end;

procedure TEndereco.SetEstado(const Value: string);
begin
  FEstado := trim(uppercase(Value));
end;

procedure TEndereco.SetIDCep(const Value: Integer);
begin
  FIDCep := Value;
  BuscarEndereco;
end;

procedure TEndereco.SetPais(const Value: string);
begin
  FPais := trim(uppercase(Value)) ;
end;

procedure TUnidade.BuscarPorID(const IdBusca: integer);
var Qr: TSQLQuery;
  Str: String;
begin
  Str := ' SELECT cad_unidade.id_unidade,cad_unidade.und_sigla' +
    'from cad_unidade where id_unidade = '+IntToStr(ID);
  Qr := TabelaCreate(Str);
  with Qr do
  begin
    Open;
    if not Eof then
    begin
      ID     := fieldbyname('id_unidade').AsInteger      ;
      Desc   := fieldbyname('und_sigla').AsString ;
    end;
  end;
  FreeAndNil(Qr);
end;

function TUnidade.gravarTbl: boolean;
begin
  Result := true;
end;

procedure TUnidade.PegarDadosQry;
begin

end;

procedure TImpFiscal.BuscarPorID(const ID: integer);
var cStr : String;
begin
  cStr :=
    FSql +
    ' WHERE cad_impfiscal.id_impfiscal='+IntToStr(ID)+
    ' ORDER BY cad_impfiscal.ifc_cadastro DESC';
  PreencherPropriedades(cStr);
end;

procedure TImpFiscal.BuscarPorNumSerial(const NumSerial: string);
var cStr : String;
begin
  cStr :=
    FSql +
    ' WHERE cad_impfiscal.ifc_numfabricacao='+QuotedStr(NumSerial)+
    ' ORDER BY cad_impfiscal.ifc_cadastro DESC';
  PreencherPropriedades(cStr);
end;

constructor TImpFiscal.create;
begin
  inherited;
  FSql :=
  ' SELECT '+
  '   cad_impfiscal.id_impfiscal,cad_impfiscal.ifc_numfabricacao,cad_impfiscal.ifc_mfadicional, '+
  '   cad_impfiscal.ifc_tipoecf,cad_impfiscal.ifc_marcadoecf,cad_impfiscal.ifc_modeloecf, '+
  '   cad_impfiscal.ifc_datainstalacaosb,cad_impfiscal.ifc_horarioinstalacaosb, '+
  '   cad_impfiscal.ifc_numerosequencialecf,cad_impfiscal.ifc_versaosb, cad_impfiscal.ifc_usuario '+
  ' FROM cad_impfiscal ';
end;

function TImpFiscal.GravarMovimentoCaixa(IdPgto, Tipo: integer; Valor:
    currency; COO, GNF, GRG, CDC, CCF: string; DtFinal: TDateTime; DenDoc:
    TDenDocEmitido): boolean;
var SQL : string;
begin
  SQL :=
  ' INSERT INTO '+
  '  cai_cf_movcaix  ' +
  '(mv_valor,id_forma_pagamento,mv_tipo_mov,mv_data, '+
  '  id_impfiscal,id_usuario,id_filial, '+
  '  mv_coo, mv_gnf, mv_grg,mv_cdc, mv_codigopaf, mv_ccf) '+
  ' VALUES ' +
  '  (:nValor,:nIdPgto,:nTipo,:dData,:nImpFiscal,:nUs,:nFilial,'+
  '   :coo,:gnf,:grg, :cdc,:codigo,:ccf)';
  try
    tblCreate(SQL);
    FQr.ParamByName('nValor').AsCurrency := Valor;
    FQr.ParamByName('nIdPgto').AsInteger := IdPgto;
    FQr.ParamByName('nTipo').AsInteger := Tipo;
    FQr.ParamByName('dData').AsDateTime := DtFinal;
    FQr.ParamByName('nImpFiscal').AsInteger  := ID;

    FQr.ParamByName('coo').AsString := COO;
    FQr.ParamByName('gnf').AsString := GNF;
    FQr.ParamByName('grg').AsString := GRG;
    FQr.ParamByName('cdc').AsString := CDC;
    FQr.ParamByName('ccf').AsString := CCF;
    {***************************************************************************
    |* 7.6.1.4 - Campo 10 - Tabela de símbolos dos demais documentos emitidos pelo ECF:
    |*
    |* Documento                           Símbolo
    |* Conferência de Mesa                 CM
    |* Registro de Venda                   RV
    |* Comprovante de Crédito ou Débito    CC
    |* Comprovante Não-Fiscal              CN
    |* Comprovante Não-Fiscal Cancelamento NC
    |* Relatório Gerencial                 RG
    *************************************************************************** }
    FQr.ParamByName('codigo').AsString  := aDescDocEmitido[DenDoc];
    {******************************************************************** }

    FQr.ExecSQL;
    result := FQr.RowsAffected > 0;
  except
    result := false;
  end;
end;

function TImpFiscal.GravarTbl: boolean;
begin
  result := true;
end;

procedure TImpFiscal.PegarDadosQry;
begin
  inherited;
  ID := FQr.Fieldbyname('id_impfiscal').AsInteger ;
  NumFabricacao := FQr.Fieldbyname('ifc_numfabricacao').AsString;
  MFAdicional := FQr.Fieldbyname('ifc_mfadicional').AsString;
  TipoECF := FQr.Fieldbyname('ifc_tipoecf').AsString;
  MarcaDoECF := FQr.Fieldbyname('ifc_marcadoecf').AsString;
  ModeloECF := FQr.Fieldbyname('ifc_modeloecf').AsString;
  DataInstalacaoSB := FQr.Fieldbyname('ifc_datainstalacaosb').AsDateTime;
  HorarioInstalacaoSB := FQr.Fieldbyname('ifc_horarioinstalacaosb').AsDateTime;
  NumeroSequencialECF := FQr.Fieldbyname('ifc_numerosequencialecf').AsString;
  VersaoSB := FQr.Fieldbyname('ifc_versaosb').AsString;
  Usuario := FQr.Fieldbyname('ifc_usuario').AsString;
end;

procedure TFilial.BuscarPorID(const ID: integer);
var Str : String;
begin
  Str := FSql +
  ' WHERE cad_filial.id_filial='+IntToStr(ID);
  PreencherPropriedades(Str);
end;

constructor TFilial.create;
begin
  inherited;
  FSql :=
    ' SELECT '+
    ' cad_filial.id_filial,cad_filial.fil_nome, cad_detalhe_filial_juridica.dfj_cnpj, cad_detalhe_filial_juridica.dfj_ie, '+
    ' vw_estado.est_sigla,cad_detalhe_filial_juridica.dfj_im '+
    ' FROM cad_filial '+
    ' JOIN cad_detalhe_filial_juridica ON cad_detalhe_filial_juridica.id_filial = cad_filial.id_filial '+
    ' JOIN vw_estado on vw_estado.id_logradouro = cad_filial.id_cep ';
end;

function TFilial.GravarTbl: boolean;
begin
  result := true;
end;

procedure TFilial.PegarDadosQry;
begin
  inherited;
  ID := FQr.Fieldbyname('id_filial').AsInteger ;
  UF := FQr.Fieldbyname('est_sigla').AsString ;
  CNPJ := FQr.Fieldbyname('dfj_cnpj').AsString  ;
  InscEst := FQr.Fieldbyname('dfj_ie').AsString;
  InscMunic := FQr.Fieldbyname('dfj_im').AsString;
  RazaoSocial := FQr.Fieldbyname('fil_nome').AsString;
end;

{ TSoftHouse }

constructor TSoftHouse.create;
begin
  FPAFECFArqsMD5 := TStringList.Create;
end;

function TSoftHouse.GerarNomeArquivo: string;
begin
  Result := NumLaudo + FormatDateTime('ddmmyyyyhhnnss', Now) + '.txt';
end;

{ TPAF }

procedure TPAF.CarregarRegistroTipo1(const TipoPAF: TTipoPAF; const Filial:
    TFilial; const SoftHs: TSoftHouse);
begin
  case TipoPAF of
    tpfD:
    begin
      Device.PAF_D.RegistroD2.Clear;
      with Device.PAF_D.RegistroD1 do
      begin
        UF    := Filial.UF;
        CNPJ  := Filial.CNPJ;
        IE    := Filial.InscEst;
        IM    := Filial.InscMunic;
        RAZAOSOCIAL := Filial.RazaoSocial;
      end;
    end;
    tpfE:
    begin
      Device.PAF_E.RegistroE2.Clear;
      with Device.PAF_E.RegistroE1 do
      begin
        UF    := Filial.UF;
        CNPJ  := Filial.CNPJ;
        IE    := Filial.InscEst;
        IM    := Filial.InscMunic;
        RAZAOSOCIAL := Filial.RazaoSocial;
      end;
    end;
    tpfP:
    begin
      Device.PAF_P.RegistroP2.Clear;
      with Device.PAF_P.RegistroP1 do
      begin
        UF    := Filial.UF;
        CNPJ  := Filial.CNPJ;
        IE    := Filial.InscEst;
        IM    := Filial.InscMunic;
        RAZAOSOCIAL := Filial.RazaoSocial;
      end;
    end;
    tpfR:
    begin
      Device.PAF_R.RegistroR02.Clear;
      Device.PAF_R.RegistroR04.Clear;
      Device.PAF_R.RegistroR06.Clear;
      with Device.PAF_R.RegistroR01 do
      begin
        {
        NUM_FAB     := oImp.cNumFabricacao;
        MF_ADICIONAL:= oImp.cMFAdicional;
        TIPO_ECF    := oImp.cTipoECF;
        MARCA_ECF   := oImp.cMarcaDoECF;
        MODELO_ECF  := oImp.cModeloECF;
        VERSAO_SB   := oImp.cVersaoSB;// '010101';
        DT_INST_SB  := oImp.dDataInstalacaoSB;
        HR_INST_SB  := oImp.dHorarioInstalacaoSB;
        NUM_SEQ_ECF := StrToInt(oImp.cNumeroSequencialECF);
         }
        CNPJ        := Filial.CNPJ;
        IE          := Filial.InscEst;
        CNPJ_SH     := SoftHs.CNPJ;
        IE_SH       := SoftHs.InscEst;
        IM_SH       := SoftHs.InscMunic;
        NOME_SH     := SoftHs.Nome;
        NOME_PAF    := SoftHs.PAFECFNomeComercial; //'PAFECF';
        VER_PAF     := SoftHs.PAFECFVersao; // '0100';
        COD_MD5     := SoftHs.PAFECFMD5Exec;//GerarDados('S',32);
        DT_INI      := Date;
        DT_FIN      := date;
        ER_PAF_ECF  := SoftHs.ERPAFECF; //'0104';
      end;
    end;
    tpfT:
    begin
      Device.PAF_T.RegistroT2.Clear;
      with Device.PAF_T.RegistroT1 do
      begin
        UF    := Filial.UF;
        CNPJ  := Filial.CNPJ;
        IE    := Filial.InscEst;
        IM    := Filial.InscMunic;
        RAZAOSOCIAL := Filial.RazaoSocial;
      end;
    end;
  end;

end;

constructor TPAF.Create(var Value: TACBrPAF);
begin
  FDevice := Value;
end;

procedure TPAF.EmitirMovimentoPorEcf(DataInicial, DataFinal: TDateTime;
  IdImpFiscal: integer; ReducaoZ: boolean);
var
  QrR2       : TSQLQuery;
  QrR3Icms   : TSQLQuery;
  QrR3ISSQN  : TSQLQuery;
  QrR4       : TSQLQuery;
  QrR4R7     : TSQLQuery;
  QrR5       : TSQLQuery;
  QrR6       : TSQLQuery;
  QrR6R7     : TSQLQuery;
  NumUsuario : integer;
  DataMov    : TDateTime;
  AliqFormat : string;
  ImpTemp    : TImpFiscal;
  NomeArq    : string;
  Mens       : String;
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
    '   fat_cf_redz.rdz_cfd,         fat_cf_redz.rdz_cdc, '+
    '   fat_cf_redz.rdz_grg,   fat_cf_redz.rdz_gnfc, '+
    '   fat_cf_redz.rdz_cfc,    fat_cf_redz.rdz_grandetotal,  fat_cf_redz.rdz_vendabruta, '+
    '   fat_cf_redz.rdz_cancelamentoicms,    fat_cf_redz.rdz_descontoicms,  fat_cf_redz.rdz_totalissqn, '+
    '   fat_cf_redz.rdz_cancelamentoissqn,   fat_cf_redz.rdz_descontoissqn, '+
    '   fat_cf_redz.rdz_vendaliquida,        fat_cf_redz.rdz_acrescimoicms, fat_cf_redz.rdz_acrescimoissqn, '+
    '   fat_cf_redz.rdz_sticms,  			       fat_cf_redz.rdz_isentoicms,    fat_cf_redz.rdz_naotribicms, '+
    '   fat_cf_redz.rdz_stissqn,  			     fat_cf_redz.rdz_isentoissqn,   fat_cf_redz.rdz_naotribissqn, '+
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
    ' CASE cad_cst.cst_classificacao     '+
    '   WHEN 0 THEN '+
    '      REPLACE( cast(cad_tributacao_produto.tri_icms_aliquota as varchar),''.'','''') '+
    '   WHEN 1 THEN '+
    '      ''I1'' '+
    '   WHEN 2 THEN '+
    '      ''F1'' '+
    '   WHEN 3 THEN '+
    '      REPLACE( cast(cad_tributacao_produto.tri_icms_aliquota as varchar),''.'','''') '+
    '   WHEN 4 THEN '+
    '      ''N1'' '+
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
    EcfDm.ProgressFrm.InitValues(0,QrR2.RecordCount,1,0,'Ecf - Processando...','Gerando arquivos de movimentação');
    EcfDm.ProgressFrm.Show
  end;

  while not QrR2.Eof do
  begin
    CarregarRegistroTipo1(tpfR, EcfDm.Filial, EcfDm.SoftHs);
    with Device.PAF_R.RegistroR01 do
    begin
      NUM_FAB     := ImpTemp.NumFabricacao;
      MF_ADICIONAL:= ImpTemp.MFAdicional;
      TIPO_ECF    := ImpTemp.TipoECF;
      MARCA_ECF   := ImpTemp.MarcaDoECF;
      MODELO_ECF  := ImpTemp.ModeloECF;
      VERSAO_SB   := ImpTemp.VersaoSB;// '010101';
      DT_INST_SB  := ImpTemp.DataInstalacaoSB;
      HR_INST_SB  := ImpTemp.HorarioInstalacaoSB;
      NUM_SEQ_ECF := StrToInt(ImpTemp.NumeroSequencialECF);
    end;

    NumUsuario := strtoint(ImpTemp.Usuario);

    DataMov    := QrR2.fieldbyname('rdz_data_mov').AsDateTime;
    with Device.PAF_R.RegistroR02.New do
    begin
      Application.ProcessMessages;

      NUM_USU     := NumUsuario;
      CRZ         := QrR2.fieldbyname('rdz_crz').AsInteger;
      COO         := QrR2.fieldbyname('rdz_coo').AsInteger;
      CRO         := QrR2.fieldbyname('rdz_cro').AsInteger;
      DT_MOV      := DataMov;
      DT_EMI      := QrR2.fieldbyname('rdz_data_imp').AsDateTime;
      HR_EMI      := QrR2.fieldbyname('rdz_data_imp').AsDateTime;
      VL_VBD      := QrR2.fieldbyname('rdz_vendabruta').AsCurrency;

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
          VL_ACUM     :=QrR3Icms.fieldbyname('rcm_total').AsCurrency;
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
          VL_ACUM     :=QrR3ISSQN.fieldbyname('rqn_total').AsCurrency;
        end;
        QrR3ISSQN.Next;
      end;

      //Fn - Substituição Tributária - ICMS
      //Valores de operações sujeitas ao ICMS, tributadas por Substituição Tributária, onde “n” representa o número do totalizador.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='F1';
        VL_ACUM     := QrR2.fieldbyname('rdz_sticms').AsCurrency;
      end;

      //In - Isento - ICMS
      //Valores de operações Isentas do ICMS, onde “n” representa o número do totalizador.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='I1';
        VL_ACUM     := QrR2.fieldbyname('rdz_isentoicms').AsCurrency;
      end;

      //Nn - Não-incidência - ICMS
      //Valores de operações com Não Incidência do ICMS, onde “n” representa o número do totalizador.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='N1';
        VL_ACUM     := QrR2.fieldbyname('rdz_naotribicms').AsCurrency;
      end;

      //FSn - Substituição Tributária - ISSQN
      //Valores de operações sujeitas ao ISSQN, tributadas por Substituição Tributária, onde “n” representa o número do totalizador.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='FS1';
        VL_ACUM     := QrR2.fieldbyname('rdz_stissqn').AsCurrency;
      end;

      //Isn - Isento - ISSQN
      //Valores de operações Isentas do ISSQN, onde “n” representa o número do totalizador.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='IS1';
        VL_ACUM     := QrR2.fieldbyname('rdz_isentoissqn').AsCurrency;
      end;

      //NSn - Não-incidência - ISSQN
      //Valores de operações com Não Incidência do ISSQN, onde “n” representa o número do totalizador.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='NS1';
        VL_ACUM     := QrR2.fieldbyname('rdz_naotribissqn').AsCurrency;
      end;

      //OPNF - Operações Não Fiscais
      //Somatório dos valores acumulados nos totalizadores relativos às Operações Não Fiscais registradas no ECF.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='OPNF';
        VL_ACUM     := QrR2.fieldbyname('rdz_totoperacaonaofiscal').AsCurrency;
      end;

      //DT - Desconto - ICMS
      //Valores relativos a descontos incidentes sobre operações sujeitas ao ICMS
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='DT';
        VL_ACUM     := QrR2.fieldbyname('rdz_descontoicms').AsCurrency;
      end;

      //DS - Desconto - ISSQN
      //Valores relativos a descontos incidentes sobre operações sujeitas ao ISSQN
      with RegistroR03.New do
      begin
        TOT_PARCIAL := 'DS';
        VL_ACUM     := QrR2.fieldbyname('rdz_descontoissqn').AsCurrency;
      end;

      //AT - Acréscimo - ICMS
      //Valores relativos a acréscimos incidentes sobre operações sujeitas ao ICMS
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='AT';
        VL_ACUM     := QrR2.fieldbyname('rdz_acrescimoicms').AsCurrency;
      end;

      //AS - Acréscimo - ISSQN
      //Valores relativos a acréscimos incidentes sobre operações sujeitas ao ISSQN
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='AS';
        VL_ACUM     := QrR2.fieldbyname('rdz_acrescimoissqn').AsCurrency;
      end;

      //Can-T - Cancelamento - ICMS
      //Valores das operações sujeitas ao ICMS, canceladas.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='Can-T';
        VL_ACUM     := QrR2.fieldbyname('rdz_cancelamentoicms').AsCurrency;
      end;

      //Can-S - Cancelamento - ISSQN
      //Valores das operações sujeitas ao ISSQN, canceladas.
      with RegistroR03.New do
      begin
        TOT_PARCIAL :='Can-S';
        VL_ACUM     := QrR2.fieldbyname('rdz_cancelamentoissqn').AsCurrency;
      end;

    end;
    QrR4.Close;
    QrR4.ParamByName('dInicio').AsDateTime := StrToDateTime( FormatDateTime(ShortDateFormat,DataMov)+' 00:00:00');
    QrR4.ParamByName('dFinal').AsDateTime  := StrToDateTime( FormatDateTime(ShortDateFormat,DataMov)+' 23:59:59');
    QrR4.Open;

    while not QrR4.Eof do
    begin
      Application.ProcessMessages;
      with Device.PAF_R.RegistroR04.New do
      begin
        NUM_USU     :=NumUsuario;
        NUM_CONT    :=StrToIntDef(QrR4.fieldbyName('cf_ccf').AsString,0);
        COO         :=QrR4.fieldbyName('cf_coo').AsInteger;
        DT_INI      :=QrR4.fieldbyName('cf_data').AsDateTime;
        SUB_DOCTO   :=QrR4.fieldbyName('cf_total').AsCurrency;
        SUB_DESCTO  :=QrR4.fieldbyName('cf_desconto').AsCurrency;
        TP_DESCTO   :='V';
        SUB_ACRES   :=0;
        TP_ACRES    :='V';
        VL_TOT      :=QrR4.fieldbyName('cf_total').AsCurrency - QrR4.fieldbyName('cf_desconto').AsCurrency;
        CANC        :=QrR4.fieldbyName('cancelou').AsString;
        VL_CA       :=0;
        ORDEM_DA    :='D';
        NOME_CLI    :=QrR4.fieldbyName('cli_nome').AsString;
        CNPJ_CPF    :=QrR4.fieldbyName('dcf_cpf').AsString+QrR4.fieldbyName('dcj_cnpj').AsString;

        QrR5.close;
        QrR5.ParamByName('id_cf').AsInteger  := QrR4.fieldbyName('id_cf').AsInteger;
        QrR5.Open;

        while not QrR5.Eof do
        begin
          With RegistroR05.New do
          begin
            NUM_ITEM     := QrR5.fieldbyName('cfit_sequencia').AsInteger;
            COD_ITEM     := QrR5.fieldbyName('pro_codigo').AsString;
            DESC_ITEM    := QrR5.fieldbyName('pro_descricao').AsString;
            QTDE_ITEM    := QrR5.fieldbyName('cfit_quantidade').AsCurrency;
            UN_MED       := QrR5.fieldbyName('und_sigla').AsString;
            VL_UNIT      := QrR5.fieldbyName('pro_preco_venda').AsCurrency;
            DESCTO_ITEM  := QrR5.fieldbyName('cfit_desconto_item').AsCurrency;
            ACRES_ITEM   := 0;
            VL_TOT_ITEM  := QrR5.fieldbyName('cfit_quantidade').AsCurrency * QrR5.fieldbyName('pro_preco_venda').AsCurrency;

            if QrR5.fieldbyName('cst_classificacao').AsInteger in [0,3] then
            begin
              AliqFormat  := Knt.Str.padL(Knt.Str.RemovePoint(QrR5.fieldbyName('cst_cod_cst').AsString),4,'0');
              EcfDm.iniAliq.DefaultSection := ImpTemp.NumFabricacao;
              AliqFormat:= EcfDm.iniAliq.ReadString(AliqFormat,'--') +'T'+AliqFormat;
            end
            else
            begin
              AliqFormat := TRIM(Knt.Str.RemovePoint(QrR5.fieldbyName('cst_cod_cst').AsString));
            end;
            COD_TOT_PARC := AliqFormat;
            IND_CANC := QrR5.fieldbyName('it_situacao').AsString;
            QTDE_CANC := 0;
            VL_CANC := 0;
            VL_CANC_ACRES:= 0;
            IAT := QrR5.fieldbyName('indicadorAT').AsString;
            IPPT := QrR5.fieldbyName('pro_produzido_desc').AsString;
            QTDE_DECIMAL := EcfDm.ECF.Device.DecimaisQtd;
            VL_DECIMAL := EcfDm.ECF.Device.DecimaisPreco;
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
            MP  := QrR4R7.fieldbyname('pag_descricao').AsString;
            VL_PAGTO := QrR4R7.fieldbyname('cfpg_valor').AsCurrency;
            IND_EST  := 'N';
            VL_EST   := 0
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
      with Device.PAF_R.RegistroR06.New do
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
            CCF :=QrR6.fieldbyname('mv_ccf').AsInteger;
            MP :=QrR6.fieldbyname('pag_descricao').AsString;
            VL_PAGTO :=QrR6.fieldbyname('mv_valor').AsCurrency;
            IND_EST :='N';
            VL_EST :=0;
          end;
      end;
      QrR6.Next;
    end;
    Application.ProcessMessages;

    //FrmPrincipal.PAF.Path := ExtractFilePath(Application.ExeName)+'movecf\';
    NomeArq := ImpTemp.ModeloECF+RightStr(ImpTemp.NumFabricacao,14)+FormatDateTime('ddmmyyyy',DataMov)+'.txt';
    try
      //FrmPrincipal.PAF.SaveFileTXT_R(NomeArq);
      //FrmPrincipal.SalvarRegistrosPAF(tpfR,ExtractFilePath(Application.ExeName)+'movecf\'+NomeArq);
      SalvarRegistrosPAF(tpfR,Knt.Str.AppDirectory + '\movecf\' + NomeArq);
      GerouArq := true;
    except
       raise;
    end;

    EcfDm.ProgressFrm.Position := EcfDm.ProgressFrm.Position +1;
    QrR2.Next;
  end;

  EcfDm.ProgressFrm.Hide;
  if GerouArq then
  begin
    Knt.UserDlg.WarningOK('Os arquivos foram gerados em:' + Device.Path);
  end;

  FreeAndNil(ImpTemp);
end;

procedure TPAF.SalvarRegistrosPAF(const TipoPAF: TTipoPAF; CaminhoCompleto:
    string; EmiteMsg: boolean = false);
var
  Arq : string;
begin

  Device.Path := ExtractFilePath(CaminhoCompleto);
  Arq := ExtractFileName(CaminhoCompleto);
  case TipoPAF of
    tpfD:
    begin
      Device.SaveFileTXT_D(Arq);
    end;
    tpfE:
    begin
      Device.SaveFileTXT_E(Arq);
    end;
    tpfP:
    begin
      Device.SaveFileTXT_P(Arq);
    end;
    tpfR:
    begin
      Device.SaveFileTXT_R(Arq);
    end;
    tpfT:
    begin
      Device.SaveFileTXT_T(Arq);
    end;
  end;

  if EmiteMsg then
  begin
    knt.UserDlg.WarningOK('O arquivo ' + Arq + ' foi gerado em ' + Device.Path);
  end;
end;

constructor TSintegra.Create(var ACBrSintegra: TACBrSintegra);
begin
  Device := ACBrSintegra;
end;

procedure TSintegra.GerarArquivo;
begin
  if Cancelado then
  begin
    exit;
  end;

  //oDM.sintegra
  Device.FileName :=Diretorio;
  Device.VersaoValidador :=Versao;
  Device.GeraArquivo;
end;

procedure TSintegra.GerarRegistros;
begin
  registro10_11;
  registro60M;
  registro60A;
  registro60D;
  registro75;
  GerarArquivo;
end;

{ TSintegra }

procedure TSintegra.registro10_11;
var QrReg10 : TSqlQuery;
begin

  Device.LimparRegistros;
  QrReg10 := UtilsU.TabelaCreate(
         ' select '+
         '   cad_filial.fil_nome , '+
         '   cad_cidade.cida_nome , '+
         '   cad_estado.est_sigla , '+
         '   cad_logradouro.logra_nome,cad_filial.fil_telefone,  '+
         '   cad_filial.fil_num_endereco, cad_filial.fil_complemento, '+
         '   cad_bairro.bai_nome,        '+
         '   cad_logradouro.logra_cep,   ' +
         '   case  cad_filial.fil_pessoa '+
         '   when 1 then '+
         '    (select cad_detalhe_filial_juridica.dfj_cnpj from cad_detalhe_filial_juridica where cad_detalhe_filial_juridica.id_filial = cad_filial.id_filial) '+
         '    else '+
         '   (Select cad_detalhe_filial_fisica.dff_cpf from cad_detalhe_filial_fisica where cad_detalhe_filial_fisica.id_filial = cad_filial.id_filial) '+
         '   end as CGC_CPF, '+
         '   case  cad_filial.fil_pessoa '+
         '   when 1 then '+
         '      (select cad_detalhe_filial_juridica.dfj_ie from cad_detalhe_filial_juridica where cad_detalhe_filial_juridica.id_filial = cad_filial.id_filial) '+
         '   else ' + #39 + #39 + '  end as IE '+
         ' from '+
         '   cad_filial '+
         '   inner join cad_logradouro on cad_filial.id_cep = cad_logradouro.id_logradouro '+
         '   inner join cad_bairro on cad_logradouro.id_bairro = cad_bairro.id_bairro '+
         '   inner join cad_cidade on cad_bairro.id_cidade = cad_cidade.id_cidade '+
         '   inner join cad_estado on cad_cidade.id_estado = cad_estado.id_estado '+
         '   inner join cad_pais on cad_estado.id_pais = cad_pais.id_pais ');
  try
    if ConfirmacaoDadosSintegraFrm = nil then Application.CreateForm(TConfirmacaoDadosSintegraFrm, ConfirmacaoDadosSintegraFrm);
    Cancelado := ConfirmacaoDadosSintegraFrm.ShowModal = mrCancel;
    with QrReg10 do
    begin
      Open;
      With Device.Registro10 do
      begin
        CNPJ        := Knt.Str.RemovePoint(FieldByName('CGC_CPF').AsString);
        Inscricao   := Knt.Str.RemovePoint(FieldByName('IE').AsString);
        RazaoSocial := FieldByName('fil_nome').AsString;
        Cidade      := FieldByName('cida_nome').AsString;
        Estado      := FieldByName('est_sigla').AsString;
        Telefone    := FieldByName('fil_telefone').AsString;
        DataInicial := FDataInicio;
        DataFinal   := FDataFim;

        CodigoConvenio      := IntToStr(ConfirmacaoDadosSintegraFrm.cmbCodIdentConv.ItemIndex +1);
        NaturezaInformacoes := IntToStr(ConfirmacaoDadosSintegraFrm.cmbNatOpInf.ItemIndex+1);
        FinalidadeArquivo   := IntToStr(ConfirmacaoDadosSintegraFrm.cmbFinalidadeArq.ItemIndex+1);

      end;

      with Device.Registro11 do
      begin
        Endereco    := FieldByName('logra_nome').AsString;
        Numero      := FieldByName('fil_num_endereco').AsString;
        Complemento := FieldByName('fil_complemento').AsString;
        Bairro      := FieldByName('bai_nome').AsString;
        Cep         := FieldByName('logra_cep').AsString;
        Responsavel := ConfirmacaoDadosSintegraFrm.edtResponsavel.Text;//FieldByName('est_nome').AsString;
        Telefone    := '003133333333';//FieldByName('est_nome').AsString;
      end;
    end;
  finally
    FreeAndNil(QrReg10);
  end;
end;

procedure TSintegra.registro50;
begin
  if Cancelado then
  begin
    exit;
  end;
end;

procedure TSintegra.registro54;
var QrReg54 : TSqlQuery;
    Reg54   : TRegistro54;
//cStr : string;

begin
  if Cancelado then
  begin
    exit;
  end;
  QrReg54 := UtilsU.TabelaCreate(
    ' Select '+
    '   cad_serie_doc.ser_nome, '+
    '   fat_item.id_item, '+
    '   fat_faturamento.fat_data, '+
    '   fat_faturamento.fat_destino, '+
    '   fat_faturamento.id_cedente, '+
    '   fat_faturamento.fat_numero_documento, '+
    '   cad_cfop.cfo_codigo , '+
    '   fat_item.ite_sequencia, '+
    '   cad_cst.cst_origem, '+
    '   cad_cst.cst_cod_cst, '+
    '   cad_produtos.pro_referencia, '+
    '   fat_faturamento.id_faturamento, '+
    '   fat_item.ite_quantidade, '+
    '   fat_item.ite_preco_venda, '+
    '   fat_item.ite_desconto_item, '+
    '   (select cad_impostos_item.iim_percentual from cad_impostos_item where cad_impostos_item.id_item = fat_item.id_item and iim_tipo_imposto = ''ICMS'') AS aliq , '+
    '   (select cad_impostos_item.iim_valor_imposto from cad_impostos_item where cad_impostos_item.id_item = fat_item.id_item and iim_tipo_imposto = ''BASE_CALCULO_ST'') AS vbcst , '+
    '   (select cad_impostos_item.iim_valor_imposto from cad_impostos_item where cad_impostos_item.id_item = fat_item.id_item and iim_tipo_imposto = ''BASE_CALCULO'') AS vbcicms, '+
    '   (select cad_impostos_item.iim_valor_imposto from cad_impostos_item where cad_impostos_item.id_item = fat_item.id_item and iim_tipo_imposto = ''IPI'') AS vIpi, '+
    '   fat_item.id_cfop as cfop '+
    ' FROM '+
    ' fat_faturamento '+
    ' JOIN fat_item on fat_faturamento.id_faturamento = fat_item.id_faturamento '+
    ' JOIN  cad_serie_por_doc  on cad_serie_por_doc.id_serie_documento = fat_faturamento.id_serie_documento '+
    ' JOIN cad_serie_doc on cad_serie_doc.id_serie   =  cad_serie_por_doc.id_serie '+
    ' JOIN cad_cfop on fat_item.id_cfop = cad_cfop.id_cfop '+
    ' JOIN cad_cst  on fat_item.id_cst =  cad_cst.id_cst '+
    ' JOIN cad_produtos  on fat_item.id_produto =  cad_produtos.id_produto '+
    ' WHERE '+
    '   (fat_faturamento.fat_data BETWEEN :dinicio AND :dfinal AND '+
    '      (fat_faturamento.fat_situacao = 10 or fat_faturamento.fat_situacao = 40) '+
    '    order by fat_faturamento.fat_data,  fat_faturamento.fat_numero_documento,fat_item.ite_sequencia ');

  try
    with QrReg54 do
    begin
      ParamByName('dinicio').AsDateTime;

      Reg54 := TRegistro54.Create;

      with Reg54 do
      begin
        CPFCNPJ     := fieldbyname('').AsString;
        Modelo      := fieldbyname('').AsString;
        Serie       := fieldbyname('').AsString;
        Numero      := fieldbyname('').AsString;
        CFOP        := fieldbyname('').AsString;
        CST         := fieldbyname('').AsString;
        NumeroItem  := fieldbyname('').AsInteger;
        Codigo      := fieldbyname('').AsString;
        Descricao   := fieldbyname('').AsString;
        Quantidade  := fieldbyname('').AsCurrency;
        Valor       := fieldbyname('').AsCurrency;
        ValorDescontoDespesa := fieldbyname('').AsCurrency;
        BasedeCalculo := fieldbyname('').AsCurrency;
        BaseST      := fieldbyname('').AsCurrency;
        ValorIpi    := fieldbyname('').AsCurrency;
        Aliquota    := fieldbyname('').AsCurrency;
      end;
      Next;
    end;

  finally
    FreeAndNil(QrReg54);
  end;

end;

procedure TSintegra.registro60A;
var QrReg60A : TSqlQuery;
    QrReg60AICMS  : TSqlQuery;
    QrReg60AISSQN : TSqlQuery;
    Reg60A : TRegistro60A;
begin
  if Cancelado then
  begin
    exit;
  end;
  QrReg60A := UtilsU.TabelaCreate(
    ' SELECT '+
    '   fat_cf_redz.id_redz, '+
    '   fat_cf_redz.rdz_data_mov, '+
    '   fat_cf_redz.rdz_data_mov, '+
    '   fat_cf_redz.rdz_sticms, '+
    '   fat_cf_redz.rdz_isentoicms, '+
    '   fat_cf_redz.rdz_naotribicms, '+
    '   fat_cf_redz.rdz_descontoicms, '+
    '   fat_cf_redz.rdz_cancelamentoicms, '+
    '   fat_cf_redz.rdz_totalissqn, '+
    '   cad_impfiscal.ifc_numfabricacao '+
    ' FROM fat_cf_redz '+
    ' JOIN cad_impfiscal ON fat_cf_redz.id_impfiscal = fat_cf_redz.id_impfiscal '+
    ' WHERE fat_cf_redz.rdz_data_mov between :dinicio and :dfinal');

  QrReg60AICMS := UtilsU.TabelaCreate(
    ' SELECT  '+
    '   rcm_indice,  rcm_aliq,  rcm_total '+
    ' FROM '+
    '   fat_cf_redz_icms '+
    ' WHERE '+
    '   fat_cf_redz_icms.id_redz = :id_redz'
  );

  QrReg60AISSQN := UtilsU.TabelaCreate(
    ' SELECT  '+
    '   rqn_indice, rqn_aliq, rqn_total '+
    ' FROM '+
    '   fat_cf_redz_issqn '+
    ' WHERE '+
    '   fat_cf_redz_issqn.id_redz = :id_redz'
  );


  try
    with QrReg60A do
    begin
      ParamByName('dinicio').AsDateTime := DataInicio;
      ParamByName('dfinal').AsDateTime := DataFim;
      Open;
      EcfDm.ProgressFrm.InitValues(0,RecordCount,1,0,'Gerando arquivo - 60A','Por favor aguarde');
      EcfDm.ProgressFrm.Show;
      while not Eof do
      begin
        Application.ProcessMessages;
        EcfDm.ProgressFrm.Position := EcfDm.ProgressFrm.Position + 1;
        {************************************************************************}
        {                                                                        }
        {     Substituição Tributária - F                                        }
        {                                                                        }
        {************************************************************************}
        Reg60A := TRegistro60A.Create;
        with Reg60A do
        begin
          Emissao    := Fieldbyname('rdz_data_mov').AsDateTime;
          NumSerie   := Fieldbyname('ifc_numfabricacao').AsString;
          StAliquota := 'F';
          Valor      := Fieldbyname('rdz_sticms').AsCurrency;
        end;
        Device.Registros60A.Add(Reg60A);

        {************************************************************************}
        {                                                                        }
        {     Isento - I                                                         }
        {                                                                        }
        {************************************************************************}
        Reg60A := TRegistro60A.Create;
        with Reg60A do
        begin
          Emissao    := Fieldbyname('rdz_data_mov').AsDateTime;
          NumSerie   := Fieldbyname('ifc_numfabricacao').AsString;
          StAliquota := 'I';
          Valor      := Fieldbyname('rdz_isentoicms').AsCurrency;
        end;
        Device.Registros60A.Add(Reg60A);
        Application.ProcessMessages;
        {************************************************************************}
        {                                                                        }
        {     Não-incidência - N                                                 }
        {                                                                        }
        {************************************************************************}
        Reg60A := TRegistro60A.Create;
        with Reg60A do
        begin
          Emissao    := Fieldbyname('rdz_data_mov').AsDateTime;
          NumSerie   := Fieldbyname('ifc_numfabricacao').AsString;
          StAliquota := 'N';
          Valor      := Fieldbyname('rdz_naotribicms').AsCurrency;
        end;
        Device.Registros60A.Add(Reg60A);

        {************************************************************************}
        {                                                                        }
        {     Cancelamentos - CANC                                               }
        {                                                                        }
        {************************************************************************}
        Reg60A := TRegistro60A.Create;
        with Reg60A do
        begin
          Emissao    := Fieldbyname('rdz_data_mov').AsDateTime;
          NumSerie   := Fieldbyname('ifc_numfabricacao').AsString;
          StAliquota := 'CANC';
          Valor      := Fieldbyname('rdz_cancelamentoicms').AsCurrency;
        end;
        Device.Registros60A.Add(Reg60A);

        {************************************************************************}
        {                                                                        }
        {     Descontos - DESC                                                   }
        {                                                                        }
        {************************************************************************}
        Reg60A := TRegistro60A.Create;
        with Reg60A do
        begin
          Emissao    := Fieldbyname('rdz_data_mov').AsDateTime;
          NumSerie   := Fieldbyname('ifc_numfabricacao').AsString;
          StAliquota := 'DESC';
          Valor      := Fieldbyname('rdz_descontoicms').AsCurrency;
        end;
        Device.Registros60A.Add(Reg60A);

        {************************************************************************}
        {                                                                        }
        {     ISSQN - ISS                                                        }
        {                                                                        }
        {************************************************************************}
        Reg60A := TRegistro60A.Create;
        with Reg60A do
        begin
          Emissao    := Fieldbyname('rdz_data_mov').AsDateTime;
          NumSerie   := Fieldbyname('ifc_numfabricacao').AsString;
          StAliquota := 'ISS';
          Valor      := Fieldbyname('rdz_totalissqn').AsCurrency;
        end;
        Device.Registros60A.Add(Reg60A);

        {************************************************************************}
        {                                                                        }
        {     ICMS                                                               }
        {                                                                        }
        {************************************************************************}
        QrReg60AICMS.Close;
        QrReg60AICMS.ParamByName('id_redz').AsInteger := QrReg60A.fieldbyname('id_redz').AsInteger;
        QrReg60AICMS.Open;
        while not QrReg60AICMS.Eof do
        begin
          Reg60A := TRegistro60A.Create;
          with Reg60A do
          begin
            Emissao    := QrReg60A.Fieldbyname('rdz_data_mov').AsDateTime;
            NumSerie   := QrReg60A.Fieldbyname('ifc_numfabricacao').AsString;
            StAliquota := Knt.Str.padL(Knt.Str.RemovePoint(QrReg60AICMS.fieldbyname('rcm_aliq').AsString),4,'0');
            Valor      := QrReg60AICMS.Fieldbyname('rcm_total').AsCurrency;
          end;
          Device.Registros60A.Add(Reg60A);
          QrReg60AICMS.Next;
          Application.ProcessMessages;
        end;

        {**********************************************************************}
        {                                                                      }
        {     ISSQN                                                            }
        {                                                                      }
        {**********************************************************************}
        QrReg60AISSQN.Close;
        QrReg60AISSQN.ParamByName('id_redz').AsInteger := QrReg60A.fieldbyname('id_redz').AsInteger;
        QrReg60AISSQN.Open;
        while not QrReg60AISSQN.Eof do
        begin
          Reg60A := TRegistro60A.Create;
          with Reg60A do
          begin
            Emissao    := QrReg60A.Fieldbyname('rdz_data_mov').AsDateTime;
            NumSerie   := QrReg60A.Fieldbyname('ifc_numfabricacao').AsString;
            StAliquota := Knt.Str.padL(Knt.Str.RemovePoint(QrReg60AISSQN.fieldbyname('rqn_aliq').AsString),4,'0');
            Valor      := QrReg60AISSQN.Fieldbyname('rqn_total').AsCurrency;
          end;
          Device.Registros60A.Add(Reg60A);
          QrReg60AICMS.Next;
          Application.ProcessMessages;
        end;

        Next;
      end;
    end;

  finally
    FreeAndNil(QrReg60A);
    FreeAndNil(QrReg60AICMS);
    FreeAndNil(QrReg60AISSQN);
    EcfDm.ProgressFrm.Hide;
    //Não pode finalizar os registros
    //FreeAndNil(Reg60A);
  end;


end;

procedure TSintegra.registro60D;
var QrReg60D : TSqlQuery;
    Reg60D   : TRegistro60D;
    Aliq     : string;
begin
  if Cancelado then
  begin
    exit;
  end;

  QrReg60D := UtilsU.TabelaCreate(
  ' SELECT '+
  '   CASE cad_cst.cst_classificacao '+
  '   WHEN 0 THEN '+
  '      REPLACE( cast(cad_tributacao_produto.tri_icms_aliquota as varchar),''.'','''') '+
  '   WHEN 1 THEN '+
  '      '+QuotedStr('I')+
  '   WHEN 2 THEN '+
  '      '+QuotedStr('F')+
  '   WHEN 3 THEN   '+
  '      REPLACE( cast(cad_tributacao_produto.tri_icms_aliquota as varchar),''.'','''') '+
  '   WHEN 4 THEN '+
  '      '+QuotedStr('N')+
  '   ELSE '+QuotedStr('NC')+
  '   END as cst_cod_cst,  '+
  '   fat_cf_item.id_produto, '+
  '   CAST(fat_cf.cf_data AS DATE) as data_emissao, '+
  '   cad_impfiscal.ifc_numfabricacao, '+
  '   sum(fat_cf_item.cfit_quantidade) as quant, '+
  '   sum(fat_cf_item.cfit_preco_venda-fat_cf_item.cfit_desconto_item) as valorliq, '+
  '   sum(((fat_cf_item.cfit_preco_venda-fat_cf_item.cfit_desconto_item)*fat_cf_item.cfit_quantidade)) as basecalc, '+
  '   sum(((fat_cf_item.cfit_preco_venda-fat_cf_item.cfit_desconto_item)*fat_cf_item.cfit_quantidade)* COALESCE(cad_tributacao_produto.tri_icms_aliquota,0 )/100)  as valorimp '+
  ' FROM fat_cf_item '+
  ' JOIN fat_cf ON fat_cf.id_cf = fat_cf_item.id_cf '+
  ' JOIN cad_impfiscal ON cad_impfiscal.id_impfiscal = fat_cf.id_impfiscal '+
  ' JOIN cad_produtos on cad_produtos.id_produto = fat_cf_item.id_produto '+
  ' JOIN cad_cst ON cad_produtos.id_cst = cad_cst.id_cst '+
  ' LEFT JOIN cad_tributacao_produto ON cad_produtos.id_produto = cad_tributacao_produto.id_produto '+
  ' WHERE fat_cf.cf_data BETWEEN :dinicio AND :dfinal '+
  ' GROUP BY 1,2,3,4');

  try
    with QrReg60D do
    begin
      ParamByName('dinicio').AsDateTime := DataInicio;
      ParamByName('dfinal').AsDateTime := DataFim;

      Open;

      EcfDm.ProgressFrm.InitValues(0,RecordCount,1,0,'Gerando arquivo - 60D','Por favor aguarde');
      EcfDm.ProgressFrm.Show;

      while not Eof do
      begin
        Application.ProcessMessages;

        Reg60D := TRegistro60D.Create;

        with Reg60D do
        begin
          Emissao     := fieldbyname('data_emissao').AsDateTime;
          NumSerie    := fieldbyname('ifc_numfabricacao').AsString;
          Codigo      := fieldbyname('id_produto').AsString;
          Quantidade  := fieldbyname('quant').AsCurrency;
          Valor       := fieldbyname('valorliq').AsCurrency;
          BaseDeCalculo := fieldbyname('basecalc').AsCurrency;

          if fieldbyname('cst_cod_cst').AsString[1] in ['N','I','F'] then
          begin
            Aliq :=fieldbyname('cst_cod_cst').AsString;
          end
          else
          begin
            Aliq :=Knt.Str.padL(Knt.Str.RemovePoint(fieldbyname('cst_cod_cst').AsString),4,'0');
          end;
          StAliquota  := Aliq;

          ValorIcms   := fieldbyname('valorimp').AsCurrency;
        end;
        Device.Registros60D.Add(Reg60D);
        Next;
      end;
    end;
  finally
    FreeAndNil(QrReg60D);
    EcfDm.ProgressFrm.Hide;
    //Não pode finalizar os registros
    //FreeAndNil(Reg60D);
  end;

end;

procedure TSintegra.registro60M;
var QrReg60M : TSqlQuery;
    Reg60M : TRegistro60M;
begin
  if Cancelado then
  begin
    exit;
  end;

  QrReg60M := UtilsU.tabelaCreate(
    ' SELECT '+
    '   fat_cf_redz.rdz_data_mov, cad_impfiscal.ifc_numfabricacao, '+
    '   cad_impfiscal.id_impfiscal,  fat_cf_redz.rdz_coo_inicial, '+
    '   fat_cf_redz.rdz_coo, fat_cf_redz.rdz_crz, '+
    '   fat_cf_redz.rdz_cro, fat_cf_redz.rdz_vendabruta, fat_cf_redz.rdz_grandetotal '+
    ' FROM fat_cf_redz '+
    ' JOIN cad_impfiscal ON fat_cf_redz.id_impfiscal = fat_cf_redz.id_impfiscal '+
    ' WHERE fat_cf_redz.rdz_data_mov between :dinicio and :dfinal');

  try
    with QrReg60M do
    begin
      ParamByName('dinicio').AsDateTime := DataInicio;
      ParamByName('dfinal').AsDateTime  := DataFim;

      Open;
      EcfDm.ProgressFrm.InitValues(0,RecordCount,1,0,'Gerando arquivo - 60M','Por favor aguarde');
      EcfDm.ProgressFrm.Show;
      while not Eof do
      begin
        Application.ProcessMessages;
        EcfDm.ProgressFrm.Position := EcfDm.ProgressFrm.Position + 1;

        Reg60M := TRegistro60M.Create;
        with Reg60M do
        begin
          Emissao     := FieldByName('rdz_data_mov').AsDateTime;
          NumSerie    := FieldByName('ifc_numfabricacao').AsString;
          NumOrdem    := FieldByName('id_impfiscal').AsInteger;
          ModeloDoc   := '2D';//FieldByName('').AsString;
          CooInicial  := FieldByName('rdz_coo_inicial').AsInteger;
          CooFinal    := FieldByName('rdz_coo').AsInteger;
          CRZ         := FieldByName('rdz_crz').AsInteger;
          CRO         := FieldByName('rdz_cro').AsInteger;
          VendaBruta  := FieldByName('rdz_vendabruta').AsCurrency;
          ValorGT     := FieldByName('rdz_grandetotal').AsCurrency;
        end;
        Device.Registros60M.Add(Reg60M);
        Next;
        Application.ProcessMessages;
      end;
    end;
  finally
    FreeAndNil(QrReg60M);
    EcfDm.ProgressFrm.Hide;
    //Não pode finalizar os registros
    //FreeAndNil(Reg60M);
  end;
end;

procedure TSintegra.registro75;
var QrReg75 : TSqlQuery;
    Reg75   : TRegistro75;
begin
  if Cancelado then
  begin
    exit;
  end;

  QrReg75 := UtilsU.TabelaCreate(
    ' SELECT '+
    '   DISTINCT cad_produtos.id_produto, '+
    '   cad_produtos.pro_descricao, '+
    '   cad_produtos.pro_ncm   , '+
    '   cad_unidade.und_sigla, '+
    '   COALESCE(cad_tributacao_produto.tri_icms_aliquota,0) AS tri_icms_aliquota, '+
    '   COALESCE(cad_tributacao_produto.tri_perc_ipi ,0) AS tri_perc_ipi ,'+
    '   COALESCE(cad_tributacao_produto.tri_icms_perc_reducao ,0) AS tri_icms_perc_reducao, '+
    '   COALESCE(cad_tributacao_produto.tri_icms_st_perc_reducao ,0) AS tri_icms_st_perc_reducao '+
    ' FROM '+
    ' fat_cf '+
    ' JOIN fat_cf_item on fat_cf.id_cf = fat_cf_item.id_cf '+
    ' JOIN cad_produtos  on fat_cf_item.id_produto =  cad_produtos.id_produto '+
    ' LEFT JOIN cad_tributacao_produto ON cad_produtos.id_produto = cad_tributacao_produto.id_produto '+
    ' LEFT join cad_unidade on cad_produtos.id_unidade_comercial = cad_unidade.id_unidade '+
    ' WHERE '+
    ' (fat_cf.cf_data BETWEEN :dinicio AND :dfinal) AND '+
    ' fat_cf.cf_datacancelamento is null '+
    ' order by cad_produtos.id_produto ');
  try
    with QrReg75 do
    begin
      ParamByName('dinicio').AsDateTime := DataInicio;
      ParamByName('dfinal').AsDateTime := DataFim;

      Open;
      EcfDm.ProgressFrm.InitValues(0,RecordCount,1,0,'Gerando arquivo - 75','Por favor aguarde');
      EcfDm.ProgressFrm.Show;
      while not Eof do
      begin
        Reg75 :=TRegistro75.Create;
        EcfDm.ProgressFrm.Position := EcfDm.ProgressFrm.Position + 1;

        with Reg75 do
        begin
          DataInicial := DataInicio; //fieldbyname('').AsDateTime;
          DataFinal   := DataFim;//fieldbyname('').AsDateTime;
          Codigo      := fieldbyname('id_produto').AsString;
          NCM         := fieldbyname('pro_ncm').AsString;
          Descricao   := fieldbyname('pro_descricao').AsString;
          Unidade     := fieldbyname('und_sigla').AsString;
          AliquotaIpi := fieldbyname('tri_perc_ipi').AsCurrency;
          AliquotaICMS := fieldbyname('tri_icms_aliquota').AsCurrency;
          Reducao     := fieldbyname('tri_icms_perc_reducao').AsCurrency;
          BaseST      := fieldbyname('tri_icms_st_perc_reducao').AsCurrency;
        end;
        Device.Registros75.Add(Reg75);
        Next;
        Application.ProcessMessages;
      end;
    end;
  finally
    FreeAndNil(QrReg75);
    EcfDm.ProgressFrm.Hide;
  end;

end;

procedure TSintegra.setDataFim(const dData: TDateTime);
begin
  FDataFim := StrToDateTime( FormatDateTime(ShortDateFormat,dData)+' 23:59:59');
end;

procedure TSintegra.setDataInicio(const dData: TDateTime);
begin
  FDataInicio := StrToDateTime( FormatDateTime(ShortDateFormat,dData)+' 00:00:00');
end;

constructor TSPEDFiscal.Create(var SPED: TACBrSPEDFiscal);
begin
  FDevice := SPED;
end;


{ TSPEDFiscal }

procedure TSPEDFiscal.bloco0;
var
  Qr0000 : TSQLQuery;
  Qr0100 : TSQLQuery;
  Qr0190 : TSQLQuery;
  Qr0200 : TSQLQuery;
  TipoItem : integer;
begin
  if Cancelado then
  begin
    exit;
  end;
  Qr0000 := UtilsU.TabelaCreate(
  ' select  '+
  '   cad_filial.fil_nome, '+
  '   cad_detalhe_filial_fisica.dff_cpf, cad_detalhe_filial_juridica.dfj_cnpj, '+
  '   cad_detalhe_filial_juridica.dfj_ie,cad_detalhe_filial_juridica.dfj_im, '+
  '   cad_cidade.cida_ibge, cad_filial.fil_suframa, cad_filial.fil_email,'+
  '   cad_filial.fil_fantasia,cad_logradouro.logra_cep, cad_logradouro.logra_tipo, '+
  '   cad_logradouro.logra_nome, cad_filial.fil_num_endereco,cad_filial.fil_complemento, '+
  '   cad_filial.fil_telefone,cad_filial.fil_fax, cad_estado.est_sigla, cad_bairro.bai_nome, '+
  '   cad_filial.fil_fax '+
  ' from cad_filial '+
  ' LEFT JOIN cad_detalhe_filial_fisica ON cad_filial.id_filial =cad_detalhe_filial_fisica.id_filial '+
  ' LEFT JOIN cad_detalhe_filial_juridica ON cad_filial.id_filial =cad_detalhe_filial_juridica.id_filial '+
  ' JOIN cad_logradouro ON cad_filial.id_cep = cad_logradouro.id_logradouro '+
  ' JOIN cad_bairro ON cad_logradouro.id_bairro = cad_bairro.id_bairro '+
  ' JOIN cad_cidade ON cad_bairro.id_cidade = cad_cidade.id_cidade '+
  ' JOIN cad_estado ON cad_cidade.id_estado =  cad_estado.id_estado ');


  Qr0100 := UtilsU.TabelaCreate(
    ' SELECT '+
    '   id_contador,cont_nome, cont_cpf,cont_crc,cont_cnpj_escritorio, '+
    '   id_cep,cont_complemento,cont_fone,cont_fax,cont_email, '+
    '   cad_logradouro.logra_cep, cad_logradouro.logra_tipo, '+
    '   cad_logradouro.logra_nome, cad_bairro.bai_nome, '+
    '   cad_cidade.cida_ibge,cad_contador.cont_num_endereco '+
    ' FROM cad_contador '+
    ' JOIN cad_logradouro ON cad_contador.id_cep = cad_logradouro.id_logradouro '+
    ' JOIN cad_bairro ON cad_logradouro.id_bairro = cad_bairro.id_bairro '+
    ' JOIN cad_cidade ON cad_bairro.id_cidade = cad_cidade.id_cidade '+
    ' JOIN cad_estado ON cad_cidade.id_estado = cad_estado.id_estado '+
    ' WHERE cad_contador.id_contador = :idContador');


  Qr0190 := UtilsU.TabelaCreate(
    ' SELECT cad_unidade.und_sigla,cad_unidade.und_descricao '+
    ' FROM cad_unidade '+
    ' WHERE '+
    ' cad_unidade.id_unidade '+
    ' IN '+
    ' ( '+
    '   SELECT distinct fat_cf_item.id_unidade '+
    '   FROM fat_cf_item '+
    '   JOIN fat_cf ON fat_cf_item.id_cf = fat_cf.id_cf '+
    '   WHERE '+
    '     fat_cf.cf_datacancelamento IS NULL AND '+
    '     fat_cf.cf_data between :dinicio AND :dfinal '+
    ' ) ');
  //Qr0190.ParamByName('dtinicio')
  Qr0190.ParamByName('dInicio').AsDateTime := DataInicio;
  Qr0190.ParamByName('dFinal').AsDateTime  := DataFim;


   Qr0200 := UtilsU.TabelaCreate(
    ' SELECT '+
    ' cad_produtos.id_produto,cad_produtos.pro_descricao, '+
    ' ( SELECT dpr_codigo_ean '+
    '   FROM cad_detalhes_produtos '+
    '   WHERE cad_detalhes_produtos.id_produto = cad_produtos.id_produto AND trim(dpr_codigo_ean) <> '''' limit 1) as dpr_codigo_ean, '+
    ' '''' as codantitem, '+
    ' cad_unidade.und_sigla, '+
    ' cad_produtos.pro_ncm,     '+
    ' cad_tributacao_produto.tri_icms_aliquota, '+
    ' cad_produtos.pro_tipoitem, '+
    ' cad_classific_fiscal.clfs_excecao '+
    ' FROM cad_produtos '+
    ' LEFT JOIN cad_unidade ON cad_produtos.id_unidade_comercial = cad_unidade.id_unidade '+
    ' LEFT JOIN cad_tributacao_produto ON cad_produtos.id_produto = cad_tributacao_produto.id_produto '+
    ' LEFT JOIN cad_classific_fiscal ON cad_produtos.id_classific_fiscal = cad_classific_fiscal.id_classific_fiscal '+
    ' WHERE '+
    ' cad_produtos.id_produto '+
    ' IN '+
    ' ( '+
    '   SELECT distinct fat_cf_item.id_produto '+
    '   FROM fat_cf_item '+
    '   JOIN fat_cf ON fat_cf_item.id_cf = fat_cf.id_cf '+
    '   WHERE '+
    '     fat_cf.cf_data between :dinicio AND :dfinal '+
    ' ) ');

  if ConfirmacaoDadosSPEDFiscalFrm = nil then Application.CreateForm(TConfirmacaoDadosSPEDFiscalFrm, ConfirmacaoDadosSPEDFiscalFrm);
  Cancelado := ConfirmacaoDadosSPEDFiscalFrm.ShowModal = mrCancel;

  if Cancelado then
  begin
    exit;
  end;

  Qr0200.ParamByName('dinicio').AsDateTime := DataInicio;
  Qr0200.ParamByName('dfinal').AsDateTime  := DataFim;
  Qr0200.Open;

  Qr0100.ParamByName('idContador').AsInteger := ConfirmacaoDadosSPEDFiscalFrm.IDContador;
  Qr0100.Open;

  Device.DT_INI := DataInicio;
  Device.DT_FIN := DataFim;
  {
  ================================================================================================
  BLOCO 0
  ================================================================================================
  }
  try
    Qr0000.Open;
    with Device.Bloco_0 do
      begin
      with Registro0000New do
      begin
        COD_VER    := TACBrVersaoLeiaute(2);//ACBrEFDBlocos.vlVersao102 ;
        COD_FIN    := TACBrCodFinalidade(ConfirmacaoDadosSPEDFiscalFrm.rdGrpTipoArquivo.ItemIndex);//ACBrEFDBlocos.raOriginal;
        NOME       := Qr0000.fieldByName('fil_nome').AsString;
        CNPJ       := Qr0000.fieldByName('dfj_cnpj').AsString;
        //CPF        := '00000000000'; // Deve ser uma informação valida
        UF         := Qr0000.fieldByName('est_sigla').AsString;
        IE         := Qr0000.fieldByName('dfj_ie').AsString;
        COD_MUN    := StrToIntDef(Qr0000.fieldByName('cida_ibge').AsString,0);
        IM         := Qr0000.fieldByName('dfj_im').AsString;
        SUFRAMA    := Qr0000.fieldByName('fil_suframa').AsString;
        IND_PERFIL := TACBrPerfil(ConfirmacaoDadosSPEDFiscalFrm.rdGrpPerfilArqFiscal.ItemIndex);//pfPerfilA;
        Perfil :=TACBrPerfil(ConfirmacaoDadosSPEDFiscalFrm.rdGrpPerfilArqFiscal.ItemIndex);//pfPerfilA;
        IND_ATIV   := TACBrAtividade(ConfirmacaoDadosSPEDFiscalFrm.rdGrpAtividade.ItemIndex);//atOutros;

      end;

      with Registro0001New do
      begin
        IND_MOV := imComDados;
        with Registro0005New do
        begin
          FANTASIA  := Qr0000.fieldByName('fil_fantasia').AsString;
          CEP       := Qr0000.fieldByName('logra_cep').AsString;
          ENDERECO  := Qr0000.fieldByName('logra_tipo').AsString + ' '+Qr0000.fieldByName('logra_nome').AsString;
          NUM       := Qr0000.fieldByName('fil_num_endereco').AsString;
          COMPL     := Qr0000.fieldByName('fil_complemento').AsString;
          BAIRRO    := Qr0000.fieldByName('bai_nome').AsString;
          FONE      := Qr0000.fieldByName('fil_telefone').AsString;
          FAX       := Qr0000.fieldByName('fil_fax').AsString;
          EMAIL     := Qr0000.fieldByName('fil_email').AsString;
        end;

        With Registro0100New do
        begin
          NOME  := Qr0100.fieldbyname('cont_nome').AsString;
          CPF   := Qr0100.fieldbyname('cont_cpf').AsString;
          CRC   := Qr0100.fieldbyname('cont_crc').AsString;
          CNPJ  := Qr0100.fieldbyname('cont_cnpj_escritorio').AsString;
          CEP   := Qr0100.fieldbyname('logra_cep').AsString;
          ENDERECO := Qr0100.fieldbyname('logra_tipo').AsString + ' '+Qr0100.fieldbyname('logra_nome').AsString;
          NUM   := Qr0100.fieldbyname('cont_num_endereco').AsString;
          COMPL := Qr0100.fieldbyname('cont_complemento').AsString;
          BAIRRO:= Qr0100.fieldbyname('bai_nome').AsString;
          FONE  := Qr0100.fieldbyname('cont_fone').AsString;
          FAX   := Qr0100.fieldbyname('cont_fax').AsString;
          EMAIL := Qr0100.fieldbyname('cont_fax').AsString;
          COD_MUN := StrToIntDef(Qr0100.fieldbyname('cida_ibge').AsString,0);
        end;

        Qr0190.Open;
        with Qr0190 do
        begin
          while not Eof do
          begin
            With Registro0190New do
            begin
              UNID  := fieldbyname('und_sigla').AsString;
              DESCR := fieldbyname('und_descricao').AsString;
            end;
            Next;
          end;
        end;

        Qr0200.Open;
        with Qr0200 do
        begin

          EcfDm.ProgressFrm.InitValues(0,RecordCount,1,0,'Gerando arquivo - 0200','Por favor aguarde');
          EcfDm.ProgressFrm.Show;
          while not Eof do
          begin
            Application.ProcessMessages;
            EcfDm.ProgressFrm.Position := EcfDm.ProgressFrm.Position + 1;

            With Registro0200New do
            begin
              COD_ITEM      := fieldbyname('id_produto').AsString;
              DESCR_ITEM    := fieldbyname('pro_descricao').AsString;
              COD_BARRA     := fieldbyname('dpr_codigo_ean').AsString;
              //COD_ANT_ITEM  := ''; //fieldbyname('und_sigla').AsString;
              UNID_INV      := fieldbyname('und_sigla').AsString;

              TipoItem := Knt.Str.CaseStr(
                fieldbyname('pro_tipoitem').AsString,
                ['00','01','02','03','04','05','06','07','08','09','10','99']);
              if TipoItem >= 0 then
              begin
                //TIPO_ITEM     := fieldbyname('pro_tipoitem').AsString;
                TIPO_ITEM := TACBrTipoItem(TipoItem);
              end;
              COD_NCM       := fieldbyname('pro_ncm').AsString;
              EX_IPI        := fieldbyname('clfs_excecao').AsString;
              //COD_GEN       := Somente para compra produtos primários
              //COD_LST       := Código de serviço
              ALIQ_ICMS     := fieldbyname('tri_icms_aliquota').AsCurrency;
            end;
            Next;
          end;
        end;

      end;
    end;
  finally
    FreeAndNil(Qr0000);
    FreeAndNil(Qr0100);
    FreeAndNil(Qr0190);
    FreeAndNil(Qr0200);
    FreeAndNil(ConfirmacaoDadosSPEDFiscalFrm);
    EcfDm.ProgressFrm.Hide;
  end;
  {
  ================================================================================================
  FIM BLOCO 0
  ================================================================================================
  }

end;

procedure TSPEDFiscal.blocoC;
var
  QrC400 : TSQLQuery;
  QrC405 : TSQLQuery;
  QrC420ICMS  : TSQLQuery;
  QrC420ISSQN : TSQLQuery;
  QrC425 : TSQLQuery;
  QrC460 : TSQLQuery;
  QrC470 : TSQLQuery;
  QrC490 : TSQLQuery;
  AliqFormat : string;
  SqlC425 : String;
  PodeGerarFilhoC425 : boolean;
  SemValores : boolean;
begin
  if Cancelado then
  begin
    exit;
  end;
  {
  ================================================================================================
  BLOCO C
  ================================================================================================
  }
  QrC400 := UtilsU.TabelaCreate(
    ' SELECT cad_impfiscal.ifc_modeloecf, '+
    ' cad_impfiscal.ifc_caixa, '+
    ' cad_impfiscal.id_impfiscal, '+
    ' cad_impfiscal.ifc_numfabricacao '+
    ' FROM cad_impfiscal '+
    ' WHERE '+
    ' cad_impfiscal.id_impfiscal in '+
    ' ( '+
    '  SELECT distinct fat_cf.id_impfiscal FROM fat_cf '+
    '  WHERE fat_cf.cf_data between :dinicio AND :dfinal ) ');

  QrC400.ParamByName('dinicio').AsDateTime := DataInicio;
  QrC400.ParamByName('dfinal').AsDateTime  := DataFim;
  QrC400.Open;

  QrC405 := UtilsU.TabelaCreate(
    ' SELECT '+
    '   fat_cf_redz.id_redz, fat_cf_redz.id_impfiscal,    fat_cf_redz.rdz_data_imp, '+
    '   fat_cf_redz.rdz_coo_inicial, fat_cf_redz.rdz_loja, fat_cf_redz.rdz_num_ecf, '+
    '   fat_cf_redz.rdz_data_mov,    fat_cf_redz.rdz_coo,rdz_gnf, '+
    '   fat_cf_redz.rdz_cro,		     fat_cf_redz.rdz_crz,  fat_cf_redz.rdz_ccf, '+
    '   fat_cf_redz.rdz_cfd,         fat_cf_redz.rdz_cdc, '+
    '   fat_cf_redz.rdz_grg,  		   fat_cf_redz.rdz_gnfc, '+
    '   fat_cf_redz.rdz_cfc,  		   fat_cf_redz.rdz_grandetotal,  fat_cf_redz.rdz_vendabruta, '+
    '   fat_cf_redz.rdz_cancelamentoicms,    fat_cf_redz.rdz_descontoicms,  fat_cf_redz.rdz_totalissqn, '+
    '   fat_cf_redz.rdz_cancelamentoissqn,   fat_cf_redz.rdz_descontoissqn, '+
    '   fat_cf_redz.rdz_vendaliquida,        fat_cf_redz.rdz_acrescimoicms, fat_cf_redz.rdz_acrescimoissqn, '+
    '   fat_cf_redz.rdz_sticms,  			       fat_cf_redz.rdz_isentoicms,    fat_cf_redz.rdz_naotribicms, '+
    '   fat_cf_redz.rdz_stissqn,  			     fat_cf_redz.rdz_isentoissqn,   fat_cf_redz.rdz_naotribissqn, '+
    '   fat_cf_redz.rdz_totoperacaonaofiscal,fat_cf_redz.rdz_tottroco,fat_cf_redz.id_filial '+
    ' FROM '+
    '   fat_cf_redz '+
    ' WHERE  '+
    '   fat_cf_redz.rdz_data_mov between :dinicio and :dfinal AND fat_cf_redz.id_impfiscal =:id_impfiscal');


  QrC420ICMS  := UtilsU.TabelaCreate(
    ' SELECT  '+
    '   rcm_indice,  rcm_aliq,  rcm_total '+
    ' FROM '+
    '   fat_cf_redz_icms '+
    ' WHERE '+
    '   fat_cf_redz_icms.id_redz = :id_redz');

  QrC420ISSQN := UtilsU.TabelaCreate(
    ' SELECT  '+
    '   rqn_indice, rqn_aliq, rqn_total '+
    ' FROM '+
    '   fat_cf_redz_issqn '+
    ' WHERE '+
    '   fat_cf_redz_issqn.id_redz = :id_redz');

  QrC425 := nil;
  SqlC425 :=
    ' SELECT '+
    '   cad_produtos.id_produto, '+
    '   cad_unidade.und_sigla, '+
    '   cad_cst.cst_classificacao, '+
    '   sum(fat_cf_item.cfit_quantidade - fat_cf_item.cfit_desconto_item) as valoritem, '+
    '   sum(fat_cf_item.cfit_quantidade) as cfit_quantidade '+
    ' FROM fat_cf_item '+
    ' JOIN fat_cf ON fat_cf_item.id_cf = fat_cf.id_cf '+
    ' JOIN cad_produtos ON  fat_cf_item.id_produto = cad_produtos.id_produto '+
    ' JOIN cad_unidade ON fat_cf_item.id_unidade = cad_unidade.id_unidade '+
    ' JOIN cad_cst ON cad_produtos.id_cst = cad_cst.id_cst '+
    ' LEFT JOIN cad_tributacao_produto ON cad_produtos.id_produto = cad_tributacao_produto.id_produto '+
    ' WHERE '+
    '   fat_cf.cf_datacancelamento IS NULL AND '+
    '   fat_cf.cf_data between :dinicio AND :dfinal '+
    '   #CWHEREC425# '+
    ' GROUP BY 1,2,3';


  QrC460 := UtilsU.TabelaCreate(
    ' SELECT '+
    '  fat_cf.id_cf, fat_cf.cf_coo,fat_cf.cf_data,fat_cf.cf_total-fat_cf.cf_desconto as vl_doc, '+
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
    ' WHERE fat_cf.cf_data BETWEEN :dInicio and :dFinal');

  QrC470 := UtilsU.TabelaCreate(
    ' SELECT '+
    '   cad_produtos.id_produto, fat_cf_item.cfit_quantidade,cad_unidade.und_sigla, '+
    '   (cad_produtos.pro_preco_venda- fat_cf_item.cfit_desconto_item) as vl_item, '+
    '   cad_cst.cst_classificacao, cad_cst.cst_origem || cad_cst.cst_cod_cst as cst_icms, '+
    '   cad_cfop.cfo_codigo, cad_tributacao_produto.tri_icms_aliquota '+
    ' FROM '+
    '   fat_cf_item '+
    ' LEFT JOIN cad_cfop ON fat_cf_item.id_cfop =cad_cfop.id_cfop '+
    ' LEFT JOIN cad_produtos ON cad_produtos.id_produto = fat_cf_item.id_produto '+
    ' LEFT JOIN cad_unidade ON cad_produtos.id_unidade_comercial = cad_unidade.id_unidade '+
    ' LEFT JOIN cad_cst ON cad_produtos.id_cst = cad_cst.id_cst '+
    ' LEFT JOIN cad_tributacao_produto ON cad_produtos.id_produto = cad_tributacao_produto.id_produto '+
    ' WHERE fat_cf_item.id_cf = :id_cf '+
    '  ');

  QrC490 := UtilsU.TabelaCreate(
    ' SELECT cad_cst.cst_origem||cad_cst.cst_cod_cst as cst,cad_cfop.cfo_codigo, cad_cst.cst_classificacao,'+
    '   fat_cf_item.cfit_aliqoperacao, '+
    '   sum((fat_cf_item.cfit_preco_venda -fat_cf_item.cfit_desconto_item)  *fat_cf_item.cfit_quantidade) as vl_opr, '+
    '   sum((fat_cf_item.cfit_preco_venda -fat_cf_item.cfit_desconto_item)  *fat_cf_item.cfit_quantidade) as vl_bc_icms, '+
    '   fat_cf_item.cfit_aliqoperacao/100 * sum((fat_cf_item.cfit_preco_venda -fat_cf_item.cfit_desconto_item)  *fat_cf_item.cfit_quantidade) as vl_icms '+
    ' FROM fat_cf_item '+
    ' LEFT JOIN fat_cf ON fat_cf.id_cf = fat_cf_item.id_cf '+
    ' LEFT JOIN cad_cst ON fat_cf_item.id_cst = cad_cst.id_cst '+
    ' LEFT JOIN cad_cfop ON fat_cf_item.id_cfop = cad_cfop.id_cfop '+
    ' WHERE fat_cf.cf_data BETWEEN :dInicio and :dFinal  '+
    ' GROUP BY 1,2,3,4');

  try
    with Device.Bloco_C do
    begin
      with RegistroC001New do
      begin
        IND_MOV := imComDados;

        EcfDm.ProgressFrm.InitValues(0,QrC400.RecordCount,1,0,'Gerando arquivo - C400','Por favor aguarde');
        EcfDm.ProgressFrm.Show;
        while not QrC400.Eof do
        begin
          Application.ProcessMessages;
          EcfDm.ProgressFrm.Position := EcfDm.ProgressFrm.Position + 1;
          with RegistroC400New do
          begin
            COD_MOD := '2D';
            ECF_MOD := QrC400.fieldbyname('ifc_modeloecf').AsString;
            ECF_FAB := QrC400.fieldbyname('ifc_numfabricacao').AsString;
            ECF_CX  := QrC400.fieldbyname('ifc_caixa').AsString;

            QrC405.Close;
            QrC405.ParamByName('id_impfiscal').AsInteger := QrC400.fieldbyname('id_impfiscal').AsInteger;
            QrC405.ParamByName('dInicio').AsDateTime := DataInicio;
            QrC405.ParamByName('dFinal').AsDateTime  := DataFim;
            QrC405.Open;

            while not QrC405.Eof do
            begin
              with RegistroC405New do
              begin
                DT_DOC := QrC405.fieldbyname('rdz_data_mov').AsDateTime;
                CRO := QrC405.fieldbyname('rdz_cro').AsInteger;
                CRZ := QrC405.fieldbyname('rdz_crz').AsInteger;
                NUM_COO_FIN := QrC405.fieldbyname('rdz_coo_inicial').AsInteger;
                GT_FIN := QrC405.fieldbyname('rdz_grandetotal').AsCurrency;
                VL_BRT := QrC405.fieldbyname('rdz_vendabruta').AsCurrency;
                PodeGerarFilhoC425 := QrC405.fieldbyname('rdz_vendabruta').AsCurrency > 0;

                if PodeGerarFilhoC425 then
                begin
                  //dMovInicio := StrToDateTime( FormatDateTime(ShortDateFormat,DT_DOC)+' 00:00:00');
                  //dMovFinal  := StrToDateTime( FormatDateTime(ShortDateFormat,DT_DOC)+' 23:59:59');

                  ///////////////////////////////////////////////////////////////////////////////////
                  ///////////////////////////////////////////////////////////////////////////////////
                  //REGISTRO C420: REGISTRO DOS TOTALIZADORES PARCIAIS DA REDUÇÃO Z (COD 02 e 2D)
                  ///////////////////////////////////////////////////////////////////////////////////
                  ///////////////////////////////////////////////////////////////////////////////////
                  QrC420ICMS.Close;
                  QrC420ICMS.ParamByName('id_redz').AsInteger := QrC405.fieldbyname('id_redz').AsInteger;
                  QrC420ICMS.Open;

                  while not QrC420ICMS.Eof do
                  begin
                    with RegistroC420New do
                    begin
                      //xxTnnnn = Exemplo: 01T1800 (totalizador 01 com alíquota de18,00% de ICMS)]
                      AliqFormat  := Knt.Str.padL(Knt.Str.RemovePoint(QrC420ICMS.fieldbyname('rcm_aliq').AsString),4,'0');
                      COD_TOT_PAR  := QrC420ICMS.fieldbyname('rcm_indice').AsString+'T'+AliqFormat;
                      NR_TOT       := QrC420ICMS.fieldbyname('rcm_indice').AsInteger;
                      VLR_ACUM_TOT := QrC420ICMS.fieldbyname('rcm_total').AsCurrency;

                      if Perfil <> pfPerfilA then
                      begin
                        //cad_cst.cst_classificacao = 0 OU 3
                        if QrC425 <> nil then
                        begin
                          QrC425.Close;
                        end;
                        QrC425 := UtilsU.TabelaCreate(
                          Knt.Str.Replace(
                            SqlC425,'#CWHEREC425#',
                            ' AND (cad_cst.cst_classificacao = 0 OR cad_cst.cst_classificacao =3) '+
                            ' AND cad_tributacao_produto.tri_icms_aliquota ='+QrC420ICMS.fieldbyname('rcm_aliq').AsString)
                          ) ;
                        QrC425.ParamByName('dInicio').AsDateTime := DataInicio; //dMovInicio;
                        QrC425.ParamByName('dFinal').AsDateTime  := DataFim; //dMovFinal;
                        QrC425.Open;

                        while not QrC425.Eof do
                        begin
                          with RegistroC425New do
                          begin
                            COD_ITEM  := QrC425.fieldbyname('id_produto').AsString;
                            QTD       := QrC425.fieldbyname('cfit_quantidade').AsCurrency;
                            UNID      := QrC425.fieldbyname('und_sigla').AsString;
                            VL_ITEM   := QrC425.fieldbyname('valoritem').AsCurrency;
                            //VL_PIS    := QrC425.fieldbyname('').AsString;
                            //VL_COFINS := QrC425.fieldbyname('').AsString;
                          end;
                          QrC425.Next;
                        end;
                      end;
                    end;
                    QrC420ICMS.Next;
                    //////////////////////////////////////////////////////////////////////////////////////////////
                    //////////////////////////////////////////////////////////////////////////////////////////////
                    //FIM - REGISTRO C420: REGISTRO DOS TOTALIZADORES PARCIAIS DA REDUÇÃO Z (COD 02 e 2D)
                    //////////////////////////////////////////////////////////////////////////////////////////////
                    //////////////////////////////////////////////////////////////////////////////////////////////
                  end;

                  Application.ProcessMessages;

                  ///////////////////////////////////////////////////////////////////////////////////
                  ///////////////////////////////////////////////////////////////////////////////////
                  //REGISTRO C420: REGISTRO DOS TOTALIZADORES PARCIAIS DA REDUÇÃO Z (COD 02 e 2D)
                  ///////////////////////////////////////////////////////////////////////////////////
                  ///////////////////////////////////////////////////////////////////////////////////
                  QrC420ISSQN.Close;
                  QrC420ISSQN.ParamByName('id_redz').AsInteger := QrC405.fieldbyname('id_redz').AsInteger;
                  QrC420ISSQN.Open;
                  while not QrC420ISSQN.Eof do
                  begin
                    with RegistroC420New do
                    begin
                      //xxTnnnn = Exemplo: 01S0500 (totalizador 01 com alíquota de05,00% de ISSQN]
                      AliqFormat  := Knt.Str.padL(Knt.Str.RemovePoint(QrC420ISSQN.fieldbyname('rqn_aliq').AsString),4,'0');
                      COD_TOT_PAR  :=QrC420ISSQN.fieldbyname('rqn_indice').AsString+'S'+AliqFormat;
                      NR_TOT       :=QrC420ISSQN.fieldbyname('rqn_indice').AsInteger;
                      VLR_ACUM_TOT :=QrC420ISSQN.fieldbyname('rqn_total').AsCurrency;

                    end;
                    QrC420ISSQN.Next;
                  end;

                  //Fn - Substituição Tributária - ICMS
                  //Valores de operações sujeitas ao ICMS, tributadas por Substituição Tributária, onde “n” representa o número do totalizador.
                  with RegistroC420New do
                  begin
                    COD_TOT_PAR  :='F1';
                    VLR_ACUM_TOT := QrC405.fieldbyname('rdz_sticms').AsCurrency;

                    if Perfil <> pfPerfilA then
                    begin
                      //Rafael Rocha - 28/09/2010
                      //cad_cst.cst_classificacao = 2
                      if QrC425 <> nil then
                      begin
                        QrC425.Close;
                      end;
                      QrC425 := UtilsU.TabelaCreate(
                        Knt.Str.Replace(
                          SqlC425,'#CWHEREC425#',
                          ' AND cad_cst.cst_classificacao = 2')
                        );
                      QrC425.ParamByName('dInicio').AsDateTime := DataInicio; //dMovInicio;
                      QrC425.ParamByName('dFinal').AsDateTime  := DataFim; //dMovFinal;
                      QrC425.Open;

                      while not QrC425.Eof do
                      begin
                        with RegistroC425New do
                        begin
                          COD_ITEM  := QrC425.fieldbyname('id_produto').AsString;
                          QTD       := QrC425.fieldbyname('cfit_quantidade').AsCurrency;
                          UNID      := QrC425.fieldbyname('und_sigla').AsString;
                          VL_ITEM   := QrC425.fieldbyname('valoritem').AsCurrency;
                          //VL_PIS    := QrC425.fieldbyname('').AsString;
                          //VL_COFINS := QrC425.fieldbyname('').AsString;
                        end;
                        QrC425.Next;
                      end;
                    end;
                  end;

                  //In - Isento - ICMS
                  //Valores de operações Isentas do ICMS, onde “n” representa o número do totalizador.
                  with RegistroC420New do
                  begin
                    COD_TOT_PAR  :='I1';
                    VLR_ACUM_TOT := QrC405.fieldbyname('rdz_isentoicms').AsCurrency;

                    if Perfil <> pfPerfilA then
                    begin
                      //Rafael Rocha - 28/09/2010
                      //cad_cst.cst_classificacao = 1
                      if QrC425 <> nil then
                      begin
                        QrC425.Close;
                      end;
                      QrC425 := UtilsU.TabelaCreate(Knt.Str.Replace(SqlC425,
                        '#CWHEREC425#', ' AND cad_cst.cst_classificacao = 1'));

                      QrC425.ParamByName('dInicio').AsDateTime := DataInicio ;//dMovInicio;
                      QrC425.ParamByName('dFinal').AsDateTime  := DataFim ;//dMovFinal;
                      QrC425.Open;

                      while not QrC425.Eof do
                      begin
                        with RegistroC425New do
                        begin
                          COD_ITEM  := QrC425.fieldbyname('id_produto').AsString;
                          QTD       := QrC425.fieldbyname('cfit_quantidade').AsCurrency;
                          UNID      := QrC425.fieldbyname('und_sigla').AsString;
                          VL_ITEM   := QrC425.fieldbyname('valoritem').AsCurrency;
                          //VL_PIS    := QrC425.fieldbyname('').AsString;
                          //VL_COFINS := QrC425.fieldbyname('').AsString;
                        end;
                        QrC425.Next;
                      end;
                    end;
                  end;

                  //Nn - Não-incidência - ICMS
                  //Valores de operações com Não Incidência do ICMS, onde “n” representa o número do totalizador.
                  with RegistroC420New do
                  begin
                    COD_TOT_PAR  :='N1';
                    VLR_ACUM_TOT := QrC405.fieldbyname('rdz_naotribicms').AsCurrency;

                    if Perfil <> pfPerfilA then
                    begin
                      //Rafael Rocha - 28/09/2010
                      //cad_cst.cst_classificacao = 4
                      if QrC425 <> nil then
                      begin
                        QrC425.Close;
                      end;
                      QrC425 := UtilsU.TabelaCreate(Knt.Str.Replace(SqlC425,
                        '#CWHEREC425#', ' AND cad_cst.cst_classificacao = 4'));
                      QrC425.ParamByName('dInicio').AsDateTime := DataInicio; //dMovInicio;
                      QrC425.ParamByName('dFinal').AsDateTime  := DataFim;  //dMovFinal;
                      QrC425.Open;

                      while not QrC425.Eof do
                      begin
                        with RegistroC425New do
                        begin
                          COD_ITEM  := QrC425.fieldbyname('id_produto').AsString;
                          QTD       := QrC425.fieldbyname('cfit_quantidade').AsCurrency;
                          UNID      := QrC425.fieldbyname('und_sigla').AsString;
                          VL_ITEM   := QrC425.fieldbyname('valoritem').AsCurrency;
                          //VL_PIS    := QrC425.fieldbyname('').AsString;
                          //VL_COFINS := QrC425.fieldbyname('').AsString;
                        end;
                        QrC425.Next;
                      end;
                    end;
                  end;

                  //FSn - Substituição Tributária - ISSQN
                  //Valores de operações sujeitas ao ISSQN, tributadas por Substituição Tributária, onde “n” representa o número do totalizador.
                  with RegistroC420New do
                  begin
                    COD_TOT_PAR  :='FS1';
                    VLR_ACUM_TOT := QrC405.fieldbyname('rdz_stissqn').AsCurrency;
                  end;

                  //Isn - Isento - ISSQN
                  //Valores de operações Isentas do ISSQN, onde “n” representa o número do totalizador.
                  with RegistroC420New do
                  begin
                    COD_TOT_PAR  :='IS1';
                    VLR_ACUM_TOT := QrC405.fieldbyname('rdz_isentoissqn').AsCurrency;
                  end;

                  //NSn - Não-incidência - ISSQN
                  //Valores de operações com Não Incidência do ISSQN, onde “n” representa o número do totalizador.
                  with RegistroC420New do
                  begin
                    COD_TOT_PAR  :='NS1';
                    VLR_ACUM_TOT := QrC405.fieldbyname('rdz_naotribissqn').AsCurrency;
                  end;

                  //OPNF - Operações Não Fiscais
                  //Somatório dos valores acumulados nos totalizadores relativos às Operações Não Fiscais registradas no ECF.
                  with RegistroC420New do
                  begin
                    COD_TOT_PAR  :='OPNF';
                    VLR_ACUM_TOT := QrC405.fieldbyname('rdz_totoperacaonaofiscal').AsCurrency;
                  end;

                  //DT - Desconto - ICMS
                  //Valores relativos a descontos incidentes sobre operações sujeitas ao ICMS
                  with RegistroC420New do
                  begin
                    COD_TOT_PAR  :='DT';
                    VLR_ACUM_TOT := QrC405.fieldbyname('rdz_descontoicms').AsCurrency;
                  end;

                  //DS - Desconto - ISSQN
                  //Valores relativos a descontos incidentes sobre operações sujeitas ao ISSQN
                  with RegistroC420New do
                  begin
                    COD_TOT_PAR  := 'DS';
                    VLR_ACUM_TOT := QrC405.fieldbyname('rdz_descontoissqn').AsCurrency;
                  end;

                  //AT - Acréscimo - ICMS
                  //Valores relativos a acréscimos incidentes sobre operações sujeitas ao ICMS
                  with RegistroC420New do
                  begin
                    COD_TOT_PAR  :='AT';
                    VLR_ACUM_TOT := QrC405.fieldbyname('rdz_acrescimoicms').AsCurrency;
                  end;

                  //AS - Acréscimo - ISSQN
                  //Valores relativos a acréscimos incidentes sobre operações sujeitas ao ISSQN
                  with RegistroC420New do
                  begin
                    COD_TOT_PAR  :='AS';
                    VLR_ACUM_TOT := QrC405.fieldbyname('rdz_acrescimoissqn').AsCurrency;
                  end;

                  //Can-T - Cancelamento - ICMS
                  //Valores das operações sujeitas ao ICMS, canceladas.
                  with RegistroC420New do
                  begin
                    COD_TOT_PAR  :='Can-T';
                    VLR_ACUM_TOT := QrC405.fieldbyname('rdz_cancelamentoicms').AsCurrency;
                  end;

                  //Can-S - Cancelamento - ISSQN
                  //Valores das operações sujeitas ao ISSQN, canceladas.
                  with RegistroC420New do
                  begin
                    COD_TOT_PAR  :='Can-S';
                    VLR_ACUM_TOT := QrC405.fieldbyname('rdz_cancelamentoissqn').AsCurrency;
                  end;
                  ////////////////////////////////////////////////////////////////////////////////////////////
                  ////////////////////////////////////////////////////////////////////////////////////////////
                  //FIM - REGISTRO C420: REGISTRO DOS TOTALIZADORES PARCIAIS DA REDUÇÃO Z (COD 02 e 2D)
                  ////////////////////////////////////////////////////////////////////////////////////////////
                  ////////////////////////////////////////////////////////////////////////////////////////////


                  ////////////////////////////////////////////////////////////////////////
                  ////////////////////////////////////////////////////////////////////////
                  //REGISTRO C460: DOCUMENTO FISCAL EMITIDO POR ECF (CÓDIGO 02 e 2D).
                  ////////////////////////////////////////////////////////////////////////
                  ////////////////////////////////////////////////////////////////////////
                  if Perfil <> pfPerfilB then
                  begin
                    QrC460.Close ;
                    QrC460.ParamByName('dInicio').AsDateTime := DataInicio; //dMovInicio;
                    QrC460.ParamByName('dFinal').AsDateTime  := DataFim; //dMovFinal;
                    QrC460.Open;
                    while not QrC460.Eof do
                    begin
                      with RegistroC460New do
                      begin
                        COD_MOD   := '2D';
                        NUM_DOC   := QrC460.fieldbyname('cf_coo').AsString;
                        if QrC460.fieldbyName('cancelou').AsString = 'S' then
                        begin
                          COD_SIT   := sdCancelado;
                        end
                        else
                        begin
                          COD_SIT   := sdRegular;
                          DT_DOC    := QrC460.fieldbyname('cf_data').AsDateTime;
                          VL_DOC    := QrC460.fieldbyname('vl_doc').AsCurrency;
                          //VL_PIS    := QrC460.fieldbyname('und_sigla').AsString;
                          //VL_COFINS := QrC460.fieldbyname('und_sigla').AsString;
                          if UpperCase(QrC460.fieldbyname('cli_nome').AsString) <>'CONSUMIDOR FINAL' then
                          begin
                            CPF_CNPJ  := QrC460.fieldbyName('dcf_cpf').AsString+QrC460.fieldbyName('dcj_cnpj').AsString;
                            NOM_ADQ   := QrC460.fieldbyname('cli_nome').AsString;
                          end;

                          QrC470.close;
                          QrC470.ParamByName('id_cf').AsInteger  := QrC460.fieldbyName('id_cf').AsInteger;
                          QrC470.Open;

                          while not QrC470.Eof do
                          begin
                            with registroC470New do
                            begin
                              COD_ITEM  := QrC470.fieldbyname('id_produto').AsString;
                              QTD       := QrC470.fieldbyname('cfit_quantidade').AsCurrency;
                              QTD_CANC  := 0;
                              UNID      := QrC470.fieldbyname('und_sigla').AsString;
                              VL_ITEM   := QrC470.fieldbyname('vl_item').AsCurrency;
                              CST_ICMS  := QrC470.fieldbyname('cst_icms').AsString;
                              CFOP      := QrC470.fieldbyname('cfo_codigo').AsString;
                              ALIQ_ICMS := QrC470.fieldbyname('tri_icms_aliquota').AsCurrency;
                              //VL_PIS    := 0;
                              //VL_COFINS := 0;
                            end;

                            QrC470.Next;
                          end;
                        end;
                      end;
                      QrC460.Next;
                    end;//Fim -  while QrC460 do
                  end; //Fim - if Perfil <> pfPerfilB then
                  ////////////////////////////////////////////////////////////////////////
                  ////////////////////////////////////////////////////////////////////////
                  //FIM - REGISTRO C460: DOCUMENTO FISCAL EMITIDO POR ECF (CÓDIGO 02 e 2D).
                  ////////////////////////////////////////////////////////////////////////
                  ////////////////////////////////////////////////////////////////////////
                  with QrC490 do
                  begin
                    Close;
                    ParamByName('dInicio').AsDateTime := DataInicio; //dMovInicio;
                    ParamByName('dFinal').AsDateTime  := DataFim; //dMovFinal;
                    Open;
                    while not Eof do
                    begin
                      with RegistroC490New do
                      begin
                        SemValores := fieldbyname('cst_classificacao').AsInteger in [1,2,4];
                        CST_ICMS    := fieldbyname('cst').AsString;
                        CFOP        := fieldbyname('cfo_codigo').AsString;
                        ALIQ_ICMS   := IfThen(SemValores,0, fieldbyname('cfit_aliqoperacao').AsCurrency);
                        VL_OPR      := fieldbyname('vl_opr').AsCurrency;
                        VL_BC_ICMS  := IfThen(SemValores,0, fieldbyname('vl_bc_icms').AsCurrency);
                        VL_ICMS     := IfThen(SemValores,0, fieldbyname('vl_icms').AsCurrency);
                        //COD_OBS     := '';
                      end;
                      Next;
                    end;//FIM - while not Eof do
                  end;//FIM - with QrC490 do
                end;//FIM - if PodeGerarFilhoC425 then
              end;
              QrC405.Next;
            end;//FIM - while not QrC405.Eof do
          end;//FIM - with RegistroC400New do
          QrC400.Next;
        end;//FIM - while not QrC400.Eof do
      end;//FIM - with RegistroC001New do
    end;//FIM - Device.Bloco_C
  finally
    FreeAndNil(QrC400);
    FreeAndNil(QrC405);
    FreeAndNil(QrC420ICMS);
    FreeAndNil(QrC420ISSQN);
    FreeAndNil(QrC425);
    FreeAndNil(QrC460);
    FreeAndNil(QrC470);
    FreeAndNil(QrC490);
    EcfDm.ProgressFrm.Hide;
  end;
  {
  ================================================================================================
  FIM BLOCO C
  ================================================================================================
  }
end;

procedure TSPEDFiscal.blocoH;
var
  QrH005 : TSQLQuery;
  QrH010 : TSQLQuery;
begin
  if Cancelado then
  begin
    exit;
  end;

  QrH005 := UtilsU.TabelaCreate(
    ' SELECT '+
    ' SUM(est_inventario.inv_valorunit) AS valor, '+
    ' CAST(est_inventario.inv_data AS DATE) AS inv_data '+
    ' FROM est_inventario '+
    ' WHERE est_inventario.inv_data BETWEEN :dinicio AND :dfim '+
    ' GROUP BY 2 '+
    ' ORDER BY 2 ');
  QrH010 := UtilsU.TabelaCreate(
    ' SELECT '+
    '   est_inventario.id_produto,est_inventario.inv_quant, '+
    '   est_inventario.inv_valorunit,est_inventario.inv_valoritem,est_inventario.inv_propriedade, '+
    '   est_inventario.inv_codparticipante,est_inventario.inv_txtcomplementar,est_inventario.inv_contacontabil, '+
    '   cad_unidade.und_sigla '+
    ' FROM est_inventario '+
    ' JOIN cad_produtos ON est_inventario.id_produto = cad_produtos.id_produto '+
    ' JOIN cad_unidade ON cad_produtos.id_unidade_comercial = cad_unidade.id_unidade '+
    ' WHERE est_inventario.inv_data BETWEEN :dinicio AND :dfim '+
    ' ORDER BY est_inventario.inv_data ');

  {
  ================================================================================================
  BLOCO H
  ================================================================================================
  }
  try
    with Device.Bloco_H do
    begin
      with RegistroH001New do
      begin
        QrH005.open;
        if not QrH005.Eof then
        begin
          IND_MOV := imComDados;
          with QrH005 do
          begin
            while not Eof do
            begin
              with RegistroH005New do
              begin
                DT_INV := fieldbyname('inv_data').AsDateTime;
                VL_INV := fieldbyname('valor').AsCurrency;

                QrH010.Close;
                QrH010.ParamByName('dinicio').AsDateTime := StrToDateTime(FormatDateTime(ShortDateFormat, fieldbyname('inv_data').AsDateTime)+' 00:00:00');
                QrH010.ParamByName('dfim').AsDateTime    := StrToDateTime(FormatDateTime(ShortDateFormat, fieldbyname('inv_data').AsDateTime)+' 23:59:59');
                QrH010.Open;
                with RegistroH010New do
                begin
                  COD_ITEM  := QrH010.fieldbyname('id_produto').AsString;
                  UNID      := QrH010.fieldbyname('und_sigla').AsString;
                  QTD       := QrH010.fieldbyname('inv_quant').AsCurrency;
                  VL_UNIT   := QrH010.fieldbyname('inv_valorunit').AsCurrency;
                  VL_ITEM   := QrH010.fieldbyname('inv_valoritem').AsCurrency;
                  IND_PROP  := TACBrPosseItem(QrH010.fieldbyname('inv_propriedade').AsInteger);
                  COD_PART  := QrH010.fieldbyname('inv_codparticipante').AsString;
                  TXT_COMPL := QrH010.fieldbyname('inv_txtcomplementar').AsString;
                  COD_CTA   := QrH010.fieldbyname('inv_contacontabil').AsString;
                end;
                QrH010.Next;
              end;//Fim - with RegistroH005New do
              QrH005.Next;
            end;//FIM - while not Eof do
          end;//Fim - with QrH005 do
        end;//Fim - if not QrH005.Eof do
      end;//Fim - with RegistroH001New do
    end;
  finally

  end;
   {
  ================================================================================================
  FIM BLOCO H
  ================================================================================================
  }

end;

procedure TSPEDFiscal.GerarArquivo;
begin
  if Cancelado then
  begin
    exit;
  end;
  try
    Device.Path := Diretorio;///ExtractFilePath(Application.ExeName)+'\sped';
    Device.Arquivo := Arquivo; //cLaudo+FormatDateTime('ddmmyyyyhhnnss',Now)+'.txt';
    Device.SaveFileTXT;

    Knt.UserDlg.WarningOK('O arquivo '+Device.Arquivo);
  except
    on E : Exception do
      Knt.UserDlg.ErrorOK(E.ClassName+': '+E.Message);
  end;
end;

procedure TSPEDFiscal.GerarRegistros;
begin
  bloco0;
  blocoC;
  blocoH;
  GerarArquivo;
end;

procedure TSPEDFiscal.setDataFim(const dData: TDateTime);
begin
  FDataFim := StrToDateTime( FormatDateTime(ShortDateFormat,dData)+' 23:59:59');
end;

procedure TSPEDFiscal.setDataInicio(const dData: TDateTime);
begin
  FDataInicio := StrToDateTime( FormatDateTime(ShortDateFormat,dData)+' 00:00:00');
end;

procedure TCFRedZ.BuscarPorID(const ID: integer);
var Str : String;
begin
  Str := FSql +
    ' WHERE cad_operacao_cfop.id_operacao_cfop='+IntToStr(ID);
  PreencherPropriedades(Str);
end;

constructor TCFRedZ.create;
begin
  inherited;
  FTabela := 'fat_cf_redz';
end;

function TCFRedZ.existeObj: boolean;
var Sql : string;
begin

  Sql :=
    ' SELECT fat_cf_redz.id_redz'+
    ' FROM fat_cf_redz'+
    ' WHERE fat_cf_redz.id_impfiscal = :nidImpfiscal AND '+
    '   fat_cf_redz.rdz_data_mov =:dDataMov AND ' +
    '   fat_cf_redz.rdz_coo = :rdzcoo AND '+
    '   fat_cf_redz.rdz_coo_inicial = :cCOOInicial '+
    ' limit 1';
//    '   fat_cf_redz.rdz_data_mov =:dDataMov AND '
  tblCreate(Sql);

  with FQr do
  begin
    try
      ParamByName('nidImpfiscal').AsInteger := idImpfiscal;
      ParamByName('dDataMov').AsDateTime    := DataMovimentacao;
      ParamByName('rdzcoo').AsString        := COO;
      ParamByName('cCOOInicial').AsString   := COOInicial;
      Open;
      ID := FieldByName('id_redz').AsInteger;
    except
      ID := -1 ;
    end;
  end;
  Result := ID > 0;
end;

function TCFRedZ.GravarTbl: boolean;
var Sql : string;
    EhInsert : boolean;
begin

  EhInsert := not existeObj ;
  if EhInsert then
  begin
    Sql :=
      'INSERT INTO '+FTabela+
      ' (id_impfiscal, rdz_data_imp, ' +
      ' rdz_coo_inicial,  rdz_loja,          rdz_num_ecf,            rdz_data_mov,   rdz_coo, rdz_gnf, ' +
      ' rdz_cro,          rdz_crz,           rdz_ccf,                rdz_cfd,        rdz_cdc, rdz_grg,  rdz_gnfc, ' +
      ' rdz_cfc,          rdz_grandetotal,   rdz_vendabruta,         rdz_cancelamentoicms, ' +
      ' rdz_descontoicms, rdz_totalissqn,    rdz_cancelamentoissqn,  rdz_descontoissqn, ' +
      ' rdz_vendaliquida, rdz_acrescimoicms, rdz_acrescimoissqn,     rdz_sticms,          rdz_isentoicms, ' +
      ' rdz_naotribicms,  rdz_stissqn,       rdz_isentoissqn,        rdz_naotribissqn,    rdz_totoperacaonaofiscal, ' +
      ' rdz_tottroco,id_filial) VALUES '+
      ' (:id_impfiscal,:rdz_data_imp, '  +
      ' :rdz_coo_inicial, :rdz_loja,         :rdz_num_ecf,           :rdz_data_mov, :rdz_coo, :rdz_gnf, ' +
      ' :rdz_cro,         :rdz_crz,          :rdz_ccf,               :rdz_cfd,      :rdz_cdc, :rdz_grg,  :rdz_gnfc, ' +
      ' :rdz_cfc,         :rdz_grandetotal,  :rdz_vendabruta,        :rdz_cancelamentoicms, ' +
      ' :rdz_descontoicms,:rdz_totalissqn,   :rdz_cancelamentoissqn, :rdz_descontoissqn, ' +
      ' :rdz_vendaliquida,:rdz_acrescimoicms,:rdz_acrescimoissqn,    :rdz_sticms,         :rdz_isentoicms, ' +
      ' :rdz_naotribicms, :rdz_stissqn,      :rdz_isentoissqn,       :rdz_naotribissqn,   :rdz_totoperacaonaofiscal, ' +
      ' :rdz_tottroco,:nFilial)';
  end
  else
  begin
    Sql :=
      'UPDATE fat_cf_redz SET '+
      ' id_impfiscal= :id_impfiscal, rdz_data_imp=:rdz_data_imp, ' +
      ' rdz_coo_inicial=:rdz_coo_inicial, rdz_loja=:rdz_loja, '+
      ' rdz_num_ecf=:rdz_num_ecf, rdz_data_mov=:rdz_data_mov, ' +
      ' rdz_coo=:rdz_coo,rdz_gnf=:rdz_gnf, ' +
      ' rdz_cro=:rdz_cro,rdz_crz=:rdz_crz,  rdz_ccf=:rdz_ccf,  '+
      ' rdz_cfd=:rdz_cfd,  rdz_cdc=:rdz_cdc,  rdz_grg=:rdz_grg,  rdz_gnfc=:rdz_gnfc, ' +
      ' rdz_cfc=:rdz_cfc,  rdz_grandetotal=:rdz_grandetotal,  '+
      ' rdz_vendabruta=:rdz_vendabruta,  rdz_cancelamentoicms=:rdz_cancelamentoicms, ' +
      ' rdz_descontoicms=:rdz_descontoicms,  rdz_totalissqn=:rdz_totalissqn,  '+
      ' rdz_cancelamentoissqn=:rdz_cancelamentoissqn,  rdz_descontoissqn=:rdz_descontoissqn, ' +
      ' rdz_vendaliquida=:rdz_vendaliquida,  rdz_acrescimoicms=:rdz_acrescimoicms, '+
      ' rdz_acrescimoissqn=:rdz_acrescimoissqn,  rdz_sticms=:rdz_sticms,  rdz_isentoicms=:rdz_isentoicms, ' +
      ' rdz_naotribicms=:rdz_naotribicms,   rdz_stissqn=:rdz_stissqn,  rdz_isentoissqn=:rdz_isentoissqn,'+
      ' rdz_naotribissqn=:rdz_naotribissqn,  rdz_totoperacaonaofiscal= :rdz_totoperacaonaofiscal, ' +
      ' rdz_tottroco=:rdz_tottroco, id_filial=:nfilial '+
      ' WHERE id_redz =:nID';

  end;

  tblCreate(Sql);

  try
    with FQr do
    begin
      if not EhInsert then
      begin
        ParamByName('nID').AsCurrency := ID;
      end;
      ParamByName('id_impfiscal').AsCurrency := idImpfiscal;
      ParamByName('rdz_data_imp').asdatetime := DataImp;
      ParamByName('rdz_coo_inicial').AsString := COOInicial;
      ParamByName('rdz_loja').AsString := loja;
      ParamByName('rdz_num_ecf').AsString := NumeroECF;
      ParamByName('rdz_data_mov').AsDateTime := DataMovimentacao;
      ParamByName('rdz_coo').AsString := COO;
      ParamByName('rdz_gnf').AsString := GNF;
      ParamByName('rdz_cro').AsString := CRO;
      ParamByName('rdz_crz').AsString := CRZ;
      ParamByName('rdz_ccf').AsString := CCF;
      ParamByName('rdz_cfd').AsString := CFD;
      ParamByName('rdz_cdc').AsString := CDC;
      ParamByName('rdz_grg').AsString := GRG;
      ParamByName('rdz_gnfc').AsString := GNFC;
      ParamByName('rdz_cfc').AsString := CFC;
      ParamByName('rdz_grandetotal').AsCurrency := Grandetotal;
      ParamByName('rdz_vendabruta').AsCurrency := Vendabruta;
      ParamByName('rdz_cancelamentoicms').AsCurrency := Cancelamentoicms;
      ParamByName('rdz_descontoicms').AsCurrency := Descontoicms;
      ParamByName('rdz_totalissqn').AsCurrency := Totalissqn;
      ParamByName('rdz_cancelamentoissqn').AsCurrency := Cancelamentoissqn;
      ParamByName('rdz_descontoissqn').AsCurrency := Descontoissqn;
      ParamByName('rdz_vendaliquida').AsCurrency := Vendaliquida;
      ParamByName('rdz_acrescimoicms').AsCurrency := Acrescimoicms;
      ParamByName('rdz_acrescimoissqn').AsCurrency := Acrescimoissqn;
      ParamByName('rdz_sticms').AsCurrency := STicms;
      ParamByName('rdz_isentoicms').AsCurrency := Isentoicms;
      ParamByName('rdz_naotribicms').AsCurrency := NaoTribicms;
      ParamByName('rdz_stissqn').AsCurrency := stissqn;
      ParamByName('rdz_isentoissqn').AsCurrency := isentoissqn;
      ParamByName('rdz_naotribissqn').AsCurrency := Naotribissqn;
      ParamByName('rdz_totoperacaonaofiscal').AsCurrency := Totoperacaonaofiscal;
      ParamByName('rdz_tottroco').AsCurrency := Tottroco;

      ExecSQL;

      result := RowsAffected > 0;
    end;
    result := result and existeObj;
  except
    result := false;
  end;
end;

function TCFRedZ.InserirICMS(const Indice, Tipo: string; const Aliquota, Total:
    currency): boolean;
var sql : string;
  EhInsert : boolean;
  IDICM  : integer;

begin

  EhInsert := not
    existeObjAux(
      'id_ricm',
      'fat_cf_redz_icms',
      'id_redz='+IntToStr(ID)+' AND '+
      'rcm_indice='+QuotedStr(Indice)+' AND '+
      'rcm_tipo='+QuotedStr(Tipo),IDICM);

  if not EhInsert then
  begin
    sql :=
      'UPDATE fat_cf_redz_icms SET '+
      ' id_redz=:nID, rcm_indice=:cIndice,'+
      ' rcm_tipo=:cTipo,rcm_aliq=:nAliquota, '+
      ' rcm_total=:nTotal '+
      ' WHERE id_ricm=:nIDicm';
  end
  else
  begin
    sql :=
      'INSERT INTO fat_cf_redz_icms '+
      ' (id_redz,rcm_indice,'+
      '  rcm_tipo,rcm_aliq,rcm_total) VALUES '+
      ' (:nID,:cIndice,:cTipo,:nAliquota ,:nTotal)';
  end;

  tblCreate(sql);

  try
    with FQr do
    begin
      if not EhInsert then
      begin
        ParamByName('nIDicm').AsInteger    := IDICM;
      end;
      ParamByName('nID').AsInteger    := ID;
      ParamByName('cIndice').AsString := Indice;
      ParamByName('cTipo').AsString   := Tipo;
      ParamByName('nAliquota').AsCurrency := Aliquota;
      ParamByName('nTotal').AsCurrency := Total;
      ExecSQL;

      result := RowsAffected > 0;
    end;
    result := result;
  except
    result := false;
  end;

end;

function TCFRedZ.InserirISSQN(const Indice, Tipo: string; const Aliquota,
    Total: currency): boolean;
var sql : string;
  EhInsert : boolean;
  nIDIss  : integer;

begin

  EhInsert := not
    existeObjAux(
      'id_rissq',
      'fat_cf_redz_issqn',
      'id_redz='+IntToStr(ID)+' AND '+
      'rqn_indice='+QuotedStr(Indice)+' AND '+
      'rqn_tipo='+QuotedStr(Tipo),nIDIss);

  if not EhInsert then
  begin
    sql :=
      'UPDATE fat_cf_redz_issqn SET '+
      ' id_redz=:nID, rqn_indice=:cIndice,'+
      ' rqn_tipo=:cTipo,rqn_aliq=:nAliquota, '+
      ' rqn_total=:nTotal '+
      ' WHERE id_rissq=:nIDIss';
  end
  else
  begin
    sql :=
    'INSERT INTO fat_cf_redz_issqn '+
    ' (id_redz,rqn_indice,'+
    '  rqn_tipo,rqn_aliq,rqn_total) VALUES '+
    ' (:nID,:cIndice,:cTipo,:nAliquota ,:nTotal)';
  end;
  tblCreate(sql);

  try
    with FQr do
    begin
      if not EhInsert then
      begin
        ParamByName('nIDIss').AsInteger    := nIDIss;
      end;
      ParamByName('nID').AsInteger    := ID;
      ParamByName('cIndice').AsString := Indice;
      ParamByName('cTipo').AsString   := Tipo;
      ParamByName('nAliquota').AsCurrency := Aliquota;
      ParamByName('nTotal').AsCurrency := Total;
      ExecSQL;

      result := RowsAffected > 0;
    end;
    result := result;
  except
    result := false;
  end;
end;

function TCFRedZ.InserirTotalizador(const Indice, Descricao, FormaPagamento:
    string; const Total: currency; const EhFiscal: boolean): boolean;
var
  sql : string;
 EhInsert : boolean;
  nIDTot  : integer;

begin

  EhInsert := not
    existeObjAux(
      'id_rdztotal',
      'fat_cf_redz_totaliza',
      ' id_redz='+IntToStr(ID)+' AND rttl_indice='+QuotedStr(Indice)+
      ' AND rttl_descricao='+QuotedStr(Descricao)+
      ' AND rttl_formapagto='+QuotedStr(FormaPagamento),
      nIDTot)  ;

  if not EhInsert then
  begin
    sql :=
      'UPDATE fat_cf_redz_totaliza SET '+
      ' id_redz=:nID, rttl_indice=:cIndice,'+
      ' rttl_descricao=:cDescricao,rttl_formapagto=:cFormaPagamento,'+
      ' rttl_total=:nTotal,rttl_tipo=:ntipo '+
      ' WHERE id_rdztotal=:nIDTot';
  end
  else
  begin
    sql :=
    'INSERT INTO fat_cf_redz_totaliza '+
    ' (id_redz,rttl_indice,'+
    '  rttl_descricao,rttl_formapagto,rttl_total,rttl_tipo) VALUES '+
    ' (:nID,:cIndice,:cDescricao,:cFormaPagamento,:nTotal,:ntipo)';
  end;

  tblCreate(sql);

  try
    with FQr do
    begin
      if not EhInsert then
      begin
        ParamByName('nIDTot').AsInteger    := nIDTot;
      end;

      ParamByName('nID').AsInteger    := ID;
      ParamByName('cIndice').AsString := Indice;
      ParamByName('cDescricao').AsString   := Descricao;
      ParamByName('cFormaPagamento').AsString := FormaPagamento;
      ParamByName('nTotal').AsCurrency := Total;
      ParamByName('ntipo').AsInteger := IfThen(EhFiscal,0,1);

      ExecSQL;

      result := RowsAffected > 0;
    end;
    result := result;
  except
    result := false;
  end;
end;

procedure TCFRedZ.PegarDadosQry;
begin

end;

initialization

end.
