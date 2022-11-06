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
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure AjustarColunas(DBGrid: TDBgrid);
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

//  GrAcesso.DataSource := dmPrincipal.dsTodos;
  AjustarColunas(GrAcesso);

end;

procedure TfrExcessoes.AjustarColunas(DBGrid : TDBgrid);
var
  ColumnCount, RowCount : integer;
  DataSetTemp : TDataSet;
  DataSourceTemp : TDataSource;
  contCol, contRow : integer;
  AValue : integer;
  MStrValue, AStrValue : string;
begin
  {$REGION 'Ajustar Colunas'}

    //captura colunas do dbgrid
    ColumnCount := DBGrid.Columns.Count;
    //verifica se existem colunas
    if (ColumnCount = 0) then Exit;
    //verifica se o TDataSet do DataSource referenciado no DBGrid est� ativo (haha)
    if not DBGrid.DataSource.DataSet.Active  then Exit;

    //captura em vari�veis tempor�rias o dataset e datasource, e tamb�m a quantidade de linhas que sua query retornou no record count
    DataSetTemp := DBGrid.DataSource.DataSet;
    DataSourceTemp := DBGrid.DataSource;
    //esta instru��o foi feita para evitar que o usu�rio veja o processo de redimensionamento do dbgrid.
    DBGrid.DataSource := nil;
    RowCount := DataSetTemp.RecordCount;

    //varre todas as colunas do dbgrid
    for contCol := 0 to ColumnCount-1 do
    begin
      AValue := 0;
      AStrValue := '';

      DataSetTemp.First;
      //Seta o primeiro valor como o T�TULO da coluna para evitar que os campos fiquem "invis�veis", quando n�o houver campo preenchido.
      MStrValue := DBGrid.Columns[contCol].Title.Caption;
      while not DataSetTemp.Eof do
      begin
      //captura valor e o length do campo atual
        AValue := Length(DataSetTemp.FieldByName(DBGrid.Columns[contCol].FieldName).AsString);
        AStrValue := DataSetTemp.FieldByName(DBGrid.Columns[contCol].FieldName).AsString;
        DataSetTemp.Next;

        //verifica se a pr�xima vari�vel � maior que a anterior
        //e mant�m a maior.
        if length(MStrValue) < AValue then
          MStrValue := AStrValue;
      end;

      //seta a largura atual com o tamanho do campo maior capturado
      //anteriormente (Observe que h� uma convers�o de texto para Width,
      //isto � para capturar o valor real da largura do texto.)
      DBGrid.Columns[contCol].Width := DBGrid.Canvas.TextWidth(MStrValue)+35;
    end;

    //DataSource novamente referenciado, para evitar Acess Violation.
    DBGrid.DataSource := DataSourceTemp;
  {$ENDREGION}
end;

procedure TfrExcessoes.btnCancelarClick(Sender: TObject);
begin
  edtAnterior.Clear;
  edtDepois.Clear;
  edtAnterior.SetFocus;
  edtAnterior.SelectAll;
end;

procedure TfrExcessoes.btnExcluirClick(Sender: TObject);
begin
//  dmPrincipal.vQuery.Connection := dmPrincipal.conn;
//  dmPrincipal.vQuery.Close;
//  dmPrincipal.vQuery.Sql.Clear;
//  dmPrincipal.vQuery.Sql.Add('DELETE FROM CONVERSAO WHERE id = ' + GrAcesso.SelectedRows );
//  dmPrincipal.vQuery.ExecSQL;
end;

procedure TfrExcessoes.btnGravarClick(Sender: TObject);
var
  vProximoNumero : Integer;
begin

  dmPrincipal.vQuery.Connection := dmPrincipal.conn;
  dmPrincipal.vQuery.Close;
  dmPrincipal.vQuery.Sql.Clear;
  dmPrincipal.vQuery.Sql.Add('SELECT max(id) + 1 AS proximonumero FROM conversao;');
  dmPrincipal.vQuery.Open();

  vProximoNumero := dmPrincipal.vQuery.FieldByName('proximonumero').AsInteger;

  dmPrincipal.vQuery.Close;
  dmPrincipal.vQuery.Sql.Clear;
  dmPrincipal.vQuery.Sql.Add('INSERT INTO CONVERSAO(ID, ANTES, DEPOIS) VALUES (:ID, :ANTES, :DEPOIS);');
  dmPrincipal.vQuery.ParamByName('ID').AsInteger    := vProximoNumero;
  dmPrincipal.vQuery.ParamByName('ANTES').AsString  := Trim(edtAnterior.Text);
  dmPrincipal.vQuery.ParamByName('DEPOIS').AsString := Trim(edtDepois.Text);
  dmPrincipal.vQuery.ExecSQL;

  FormShow(nil);
end;

end.
