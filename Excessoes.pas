unit Excessoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids;

type
  TfrExcessoes = class(TForm)
    edtAnterior: TEdit;
    edtDepois: TEdit;
    btnGravar: TButton;
    btnExcluir: TButton;
    btnCancelar: TButton;
    GrAcesso: TDBGrid;
    lblAnteriorE: TLabel;
    lblDepoisE: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frExcessoes: TfrExcessoes;

implementation

uses
  DataModule;

{$R *.dfm}

procedure TfrExcessoes.FormShow(Sender: TObject);
begin
  dmPrincipal.vQueryTodos.Connection := dmPrincipal.conn;
  dmPrincipal.vQueryTodos.Close;
  dmPrincipal.vQueryTodos.Sql.Clear;
  dmPrincipal.vQueryTodos.Sql.Add('SELECT * FROM CONVERSAO');
  dmPrincipal.vQueryTodos.Open;
  dmPrincipal.vQueryTodos.First;

  GrAcesso.DataSource := dmPrincipal.dsTodos;

end;

end.
