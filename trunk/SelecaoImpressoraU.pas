unit SelecaoImpressoraU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids;

type
  TSelecaoImpressoraFrm = class(TForm)
    grdImpFiscais: TStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure grdImpFiscaisKeyPress(Sender: TObject; var Key: Char);
  private
    FIdImpressora: Integer;
    { Private declarations }
  public
    property IdImpressora: Integer read FIdImpressora write FIdImpressora;
    { Public declarations }
  end;

var
  SelecaoImpressoraFrm: TSelecaoImpressoraFrm;

implementation

uses
  SqlExpr, UtilsU;

{$R *.dfm}

procedure TSelecaoImpressoraFrm.FormClose(Sender: TObject; var Action:
    TCloseAction);
begin
  IdImpressora := StrToIntDef( grdImpFiscais.Cells[0, grdImpFiscais.Row], 0);
end;

procedure TSelecaoImpressoraFrm.FormShow(Sender: TObject);
var Qr: TSQLQuery;
    i: Integer;
begin
  Qr := UtilsU.TabelaCreate(
  ' SELECT '+
  '   cad_impfiscal.id_impfiscal,cad_impfiscal.ifc_numfabricacao,'+
  '   cad_impfiscal.ifc_modeloecf '+
  ' FROM cad_impfiscal '+
  ' ORDER BY cad_impfiscal.ifc_cadastro DESC');

  try
    grdImpFiscais.Cells[0, 0] := 'ID';
    grdImpFiscais.Cells[1, 0] := 'N° Serial';
    Qr.Open;

    grdImpFiscais.RowCount := Qr.RecordCount +1;
    i := 0;
    While not Qr.Eof do
    begin
      grdImpFiscais.Cells[0, i+1] := Qr.fieldbyname('id_impfiscal').AsString;
      grdImpFiscais.Cells[1, i+1] := Qr.fieldbyname('ifc_numfabricacao').AsString;
      i := i +1;
      Qr.Next;
    end ;
  finally
    Qr.Free;
  end;

  grdImpFiscais.ColWidths[0] := 0;
end;

procedure TSelecaoImpressoraFrm.grdImpFiscaisKeyPress(Sender: TObject; var Key:
    Char);
begin
  if Key = #13 then
  begin
    Close;
  end;
end;

end.
