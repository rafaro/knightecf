unit ProdutoPesquisaU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, ExtCtrls, ComCtrls, Grids, DBGrids, JvExDBGrids,
  JvDBGrid, JvDBUltimGrid, SqlExpr, FMTBcd;

type
  TProdutoPesquisaFrm = class(TForm)
    pgcPrincipal: TPageControl;
    tbsPesquisa: TTabSheet;
    oPesq: TEdit;
    btnPesquisa: TButton;
    grdProdutos: TJvDBUltimGrid;
    stbRodape: TStatusBar;
    pnlPrincipal: TPanel;
    rdbDescricao: TRadioButton;
    rdbCodigo: TRadioButton;
    dsPesq: TDataSource;
    qryPesq: TSQLQuery;
  private
    FCodigo: string;
    FDescricao: string;
    FEhProduzido: Boolean;
    FidCST: Integer;
    FidProduto: Integer;
    FidUnidade: Integer;
    FProAliqICMS: currency;
    FProPrecoVenda: currency;
    FUnidComer: string;
    procedure PreencherRetorno;
    { Private declarations }
    function  retornaSentenca(const Where: string =''; const Order: string =''): string;
  public
    procedure Pesquisar;
    procedure PesquisarExterna;
    property Codigo: string read FCodigo write FCodigo;
    property Descricao: string read FDescricao write FDescricao;
    property EhProduzido: Boolean read FEhProduzido write FEhProduzido;
    property idCST: Integer read FidCST write FidCST;
    property idProduto: Integer read FidProduto write FidProduto;
    property idUnidade: Integer read FidUnidade write FidUnidade;
    property ProAliqICMS: currency read FProAliqICMS write FProAliqICMS;
    property ProPrecoVenda: currency read FProPrecoVenda write FProPrecoVenda;
    property UnidComer: string read FUnidComer write FUnidComer;
  end;

var
  ProdutoPesquisaFrm: TProdutoPesquisaFrm;

implementation

uses
  knight;

{$R *.dfm}

procedure TProdutoPesquisaFrm.Pesquisar;
var
  Str : String ;
begin
  //with qPesq do
  Str := retornaSentenca(
    ' and trim(Upper(cad_produtos.pro_descricao_resumida)) like '+
    #39 + '%' + UpperCase(trim(oPesq.Text)) + '%' + #39);
  if rdbCodigo.Checked then
    Str := retornaSentenca(' and trim(Upper(cad_produtos.pro_codigo)) like '  + #39 + '%' + UpperCase(trim(oPesq.Text)) + '%' + #39 );

  if trim(oPesq.Text) = '' then
    Str := retornaSentenca();

  qryPesq.sql.Clear ;
  qryPesq.sql.Append(Str);
  qryPesq.open ;

  if not eof then
    grdProdutos.SetFocus ;
end;

procedure TProdutoPesquisaFrm.PesquisarExterna;
var Str : string;
begin
  with qryPesq do
  begin
    //Str :=
    //  ' select cad_produtos.*,cad_unidade.und_sigla  '+
    //  ' from cad_produtos '+
    //  ' left join cad_unidade on cad_produtos.id_unidade_comercial = cad_unidade.id_unidade '+
    //  ' where cad_produtos.id_filial =' + inttostr(Filial) + ' and Upper(trim(pro_codigo)) like ''%'  + UpperCase(trim(cCodigo))+ '%''' ;
    Str := retornaSentenca(' and Upper(trim(pro_codigo)) ='  + QuotedStr( UpperCase(trim(Codigo))));

    qryPesq.sql.Clear ;
    qryPesq.sql.Append(Str);
    qryPesq.open ;

    PreencherRetorno;
  end;
end;

procedure TProdutoPesquisaFrm.PreencherRetorno;
begin
  idProduto := 0  ;
  Descricao := '' ;
  Codigo := '' ;
  UnidComer := '' ;
  ProPrecoVenda := 0;
  idCST := 0  ;

  if not qryPesq.eof then
  begin
    idProduto := qryPesq.fieldbyname('id_produto').AsInteger ;
    Descricao := qryPesq.fieldbyname('pro_descricao').AsString ;
    Codigo := qryPesq.fieldbyname('pro_codigo').AsString ;
    UnidComer := qryPesq.fieldbyname('und_sigla').AsString ;
    idUnidade := qryPesq.fieldbyname('id_unidade_comercial').asinteger  ;
    idCST := qryPesq.fieldbyname('id_cst').AsInteger ;
    ProPrecoVenda := qryPesq.fieldbyname('pro_preco_venda').AsCurrency ;
    ProAliqICMS := qryPesq.fieldbyname('tri_icms_aliquota').AsCurrency ;
    EhProduzido := qryPesq.fieldbyname('pro_produzido').AsInteger = 1 ;
  end
  else
    knt.UserDlg.WarningOK('Nenhum produto encontrado!') ;
end;

function TProdutoPesquisaFrm.retornaSentenca(const Where,
  Order: string): string;
begin
  {Result :=
    ' SELECT cad_produtos.*,cad_unidade.und_sigla, '+
    '   cad_tributacao_produto.tri_icms_aliquota '+
    ' FROM cad_produtos '+
    ' LEFT JOIN cad_unidade ON cad_produtos.id_unidade_comercial = cad_unidade.id_unidade '+
    ' LEFT JOIN cad_tributacao_produto ON cad_produtos.id_produto = cad_tributacao_produto.id_produto '+
    ' WHERE cad_produtos.id_filial =' + inttostr(cls.nFilial)+' '+
    cWhere ;  }
//' COALESCE(cad_cst.cst_cod_cst, '+QuotedStr('NC')+') as cst_cod_cst, '
  Result :=
   ' SELECT '+
   ' cad_produtos.pro_codigo, '+
   ' cad_produtos.pro_descricao, '+
   ' cad_unidade.und_sigla, '+
   ' '+QuotedStr('A')+' as indicadorAT, '+
   ' CASE cad_cst.cst_classificacao '+
   '     WHEN 0 THEN '+
   '        REPLACE( cast(cad_tributacao_produto.tri_icms_aliquota as varchar),''.'','','') '+
   '     WHEN 1 THEN '+
   '        ''II'' '+
   '     WHEN 2 THEN '+
   '        ''FF'' '+
   '     WHEN 3 THEN '+
   '        REPLACE( cast(cad_tributacao_produto.tri_icms_aliquota as varchar),''.'','','') '+
   '     WHEN 4 THEN '+
   '        ''NN'' '+
   '     ELSE ''NC'' '+
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
   ' LEFT JOIN cad_cst ON cad_produtos.id_cst = cad_cst.id_cst '+
   ' WHERE '+
    Where ;

  if Order = EmptyStr then
    Result := Result + ' order by cad_produtos.pro_descricao limit 200'
  else
    Result := Result + Order;
end;

end.
