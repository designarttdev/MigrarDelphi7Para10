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
    btnInserir: TButton;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GrAcessoCellClick(Column: TColumn);
    procedure GrAcessoDblClick(Sender: TObject);
  private
    vId : Integer;
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
    //verifica se o TDataSet do DataSource referenciado no DBGrid está ativo (haha)
    if not DBGrid.DataSource.DataSet.Active  then Exit;

    //captura em variáveis temporárias o dataset e datasource, e também a quantidade de linhas que sua query retornou no record count
    DataSetTemp := DBGrid.DataSource.DataSet;
    DataSourceTemp := DBGrid.DataSource;
    //esta instrução foi feita para evitar que o usuário veja o processo de redimensionamento do dbgrid.
    DBGrid.DataSource := nil;
    RowCount := DataSetTemp.RecordCount;

    //varre todas as colunas do dbgrid
    for contCol := 0 to ColumnCount-1 do
    begin
      AValue := 0;
      AStrValue := '';

      DataSetTemp.First;
      //Seta o primeiro valor como o TÍTULO da coluna para evitar que os campos fiquem "invisíveis", quando não houver campo preenchido.
      MStrValue := DBGrid.Columns[contCol].Title.Caption;
      while not DataSetTemp.Eof do
      begin
      //captura valor e o length do campo atual
        AValue := Length(DataSetTemp.FieldByName(DBGrid.Columns[contCol].FieldName).AsString);
        AStrValue := DataSetTemp.FieldByName(DBGrid.Columns[contCol].FieldName).AsString;
        DataSetTemp.Next;

        //verifica se a próxima variável é maior que a anterior
        //e mantém a maior.
        if length(MStrValue) < AValue then
          MStrValue := AStrValue;
      end;

      //seta a largura atual com o tamanho do campo maior capturado
      //anteriormente (Observe que há uma conversão de texto para Width,
      //isto é para capturar o valor real da largura do texto.)
      DBGrid.Columns[contCol].Width := DBGrid.Canvas.TextWidth(MStrValue)+35;
    end;

    //DataSource novamente referenciado, para evitar Acess Violation.
    DBGrid.DataSource := DataSourceTemp;
  {$ENDREGION}
end;

procedure TfrExcessoes.btnCancelarClick(Sender: TObject);
begin
  btnInserir.Enabled := True;

  edtAnterior.Clear;
  edtDepois.Clear;
  edtAnterior.SetFocus;
  edtAnterior.SelectAll;
end;

procedure TfrExcessoes.btnExcluirClick(Sender: TObject);
var
  i, id : Integer;
begin
  try
    dmPrincipal.vQuery.Connection := dmPrincipal.conn;
    dmPrincipal.vQuery.Close;
    dmPrincipal.vQuery.Sql.Clear;
    dmPrincipal.vQuery.Sql.Add('DELETE FROM CONVERSAO WHERE id = :ID');
    dmPrincipal.vQuery.ParamByName('ID').AsInteger := vId;
    dmPrincipal.vQuery.ExecSQL;
    FormShow(Nil);
  except on E:Exception do
    begin
      Application.MessageBox('Não foi possível excluir.', 'Atenção!', MB_OK +
        MB_ICONSTOP);
      Exit;
    end;
  end;
end;

procedure TfrExcessoes.btnGravarClick(Sender: TObject);
begin

  try
    dmPrincipal.vQuery.Close;
    dmPrincipal.vQuery.Sql.Clear;
    dmPrincipal.vQuery.Sql.Add('UPDATE CONVERSAO SET ANTES = :ANTES, DEPOIS = :DEPOIS WHERE ID = :ID');
    dmPrincipal.vQuery.ParamByName('ID').AsInteger    := dmPrincipal.vQueryTodosID.AsInteger;
    dmPrincipal.vQuery.ParamByName('ANTES').AsString  := Trim(edtAnterior.Text);
    dmPrincipal.vQuery.ParamByName('DEPOIS').AsString := Trim(edtDepois.Text);
    dmPrincipal.vQuery.ExecSQL;

    FormShow(nil);
    btnInserir.Enabled := True;
  except on E:Exception do
    begin
      Application.MessageBox('Não foi possível alterar.', 'Atenção!', MB_OK +
        MB_ICONSTOP);
      btnCancelarClick(nil);
      Exit;
    end;
  end;

end;

procedure TfrExcessoes.btnInserirClick(Sender: TObject);
var
  vProximoNumero : Integer;
begin

  dmPrincipal.vQuery.Connection := dmPrincipal.conn;
  dmPrincipal.vQuery.Close;
  dmPrincipal.vQuery.Sql.Clear;
  dmPrincipal.vQuery.Sql.Add('SELECT max(id) + 1 AS proximonumero FROM conversao;');
  dmPrincipal.vQuery.Open();

  vProximoNumero := dmPrincipal.vQuery.FieldByName('proximonumero').AsInteger;

  try
    dmPrincipal.vQuery.Close;
    dmPrincipal.vQuery.Sql.Clear;
    dmPrincipal.vQuery.Sql.Add('INSERT INTO CONVERSAO(ID, ANTES, DEPOIS) VALUES (:ID, :ANTES, :DEPOIS);');
    dmPrincipal.vQuery.ParamByName('ID').AsInteger    := vProximoNumero;
    dmPrincipal.vQuery.ParamByName('ANTES').AsString  := Trim(edtAnterior.Text);
    dmPrincipal.vQuery.ParamByName('DEPOIS').AsString := Trim(edtDepois.Text);
    dmPrincipal.vQuery.ExecSQL;

    FormShow(nil);

    edtAnterior.Clear;
    edtDepois.Clear;
    edtAnterior.SetFocus;
  except on E:Exception do
    begin
      Application.MessageBox('Não foi possível Inserir.', 'Atenção!', MB_OK +
        MB_ICONSTOP);
      Exit;
    end;
  end;
end;

procedure TfrExcessoes.GrAcessoCellClick(Column: TColumn);
begin
  vId := dmPrincipal.vQueryTodosID.AsInteger;
end;

procedure TfrExcessoes.GrAcessoDblClick(Sender: TObject);
begin
  btnInserir.Enabled := False;

  edtAnterior.Text := Trim(dmPrincipal.vQueryTodosANTES.AsString);
  edtDepois.Text   := Trim(dmPrincipal.vQueryTodosDEPOIS.AsString);
end;

end.
