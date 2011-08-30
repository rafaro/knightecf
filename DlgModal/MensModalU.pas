unit MensModalU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TMensModalFrm = class(TForm)
    pnlMensagem: TPanel;
    pnlMensagemCliente: TPanel;
    Label11: TLabel;
    lblMensagemCliente: TLabel;
    pnlMensagemOperador: TPanel;
    Label10: TLabel;
    lblMensagemOperador: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MensModalFrm: TMensModalFrm;

implementation

{$R *.dfm}

end.
