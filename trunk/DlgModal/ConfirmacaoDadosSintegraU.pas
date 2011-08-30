unit ConfirmacaoDadosSintegraU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TConfirmacaoDadosSintegraFrm = class(TForm)
    pnlPrincipal: TPanel;
    btnCancelar: TButton;
    btnOk: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cmbCodIdentConv: TComboBox;
    cmbNatOpInf: TComboBox;
    cmbFinalidadeArq: TComboBox;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    edtResponsavel: TEdit;
    GroupBox3: TGroupBox;
    edtDtFim: TDateTimePicker;
    edtDtInicio: TDateTimePicker;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfirmacaoDadosSintegraFrm: TConfirmacaoDadosSintegraFrm;

implementation

{$R *.dfm}

end.
