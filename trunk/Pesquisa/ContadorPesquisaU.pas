unit ContadorPesquisaU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMTBcd, DB, SqlExpr, ComCtrls, Grids, DBGrids, JvExDBGrids, JvDBGrid,
  JvDBUltimGrid, StdCtrls;

type
  TContadorPesquisaFrm = class(TForm)
    pgrPrincipal: TPageControl;
    tbsPesquisa: TTabSheet;
    edtPesquisa: TEdit;
    btnPesquisar: TButton;
    grdResultado: TJvDBUltimGrid;
    stbPrincipal: TStatusBar;
    qPesq: TSQLQuery;
    dsPesq: TDataSource;
    procedure btnPesquisarClick(Sender: TObject);
    procedure edtPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure grdResultadoKeyPress(Sender: TObject; var Key: Char);
  private
    FID: Integer;
    FNome: string;
    procedure Pesquisar ;
    procedure limparVariaveis;
    procedure AtribuirVariaveis;
  public
    property ID: Integer read FID write FID;
    property Nome: string read FNome write FNome;
    { Public declarations }
  end;

var
  ContadorPesquisaFrm: TContadorPesquisaFrm;

implementation

uses
  knight;

{$R *.dfm}

{ TContadorPesquisaFrm }

procedure TContadorPesquisaFrm.AtribuirVariaveis;
begin
  ID   := qPesq.Fieldbyname('id_contador').AsInteger;
  Nome := qPesq.Fieldbyname('cont_nome').AsString;
end;

procedure TContadorPesquisaFrm.btnPesquisarClick(Sender: TObject);
begin
  Pesquisar;
end;

procedure TContadorPesquisaFrm.edtPesquisaKeyPress(Sender: TObject; var Key:
    Char);
begin
  if key = #13 then
    Pesquisar;
end;

procedure TContadorPesquisaFrm.FormActivate(Sender: TObject);
begin
  edtPesquisa.SetFocus ;
  limparVariaveis;
  Pesquisar;
end;

procedure TContadorPesquisaFrm.grdResultadoKeyPress(Sender: TObject; var Key:
    Char);
begin
  if key = #13 then
  begin
    limparVariaveis;
    if not qPesq.eof then
    begin
      AtribuirVariaveis;
      close ;
    end;
  end;
end;

procedure TContadorPesquisaFrm.limparVariaveis;
begin
  ID := -1;
  Nome := '';
end;

procedure TContadorPesquisaFrm.Pesquisar;
var Str : string;
begin
  Str :=
    ' SELECT cad_contador.id_contador,cad_contador.cont_nome,cad_contador.cont_fone '+
    ' FROM cad_contador '+
    ' WHERE #WHERE# '+
    ' order by cad_contador.cont_nome '+
    ' limit 200 ';

  if trim(edtPesquisa.Text) <> '' then
  begin
    Str := knt.Str.Replace(Str, '#WHERE#', 'trim(Upper(cont_nome)) like ' +
      QuotedStr('%' + UpperCase(trim(edtPesquisa.Text)) + '%'));
  end;
  Str := knt.Str.Replace(Str,'#WHERE#','1=1');

  qPesq.sql.Clear ;
  qPesq.sql.Append(Str);
  qPesq.open ;
  if not qPesq.eof then
    grdResultado.SetFocus ;
end;

end.
