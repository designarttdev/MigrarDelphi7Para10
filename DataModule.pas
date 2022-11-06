unit DataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.SQLiteWrapper.Stat;

type
  TdmPrincipal = class(TDataModule)
    conn: TFDConnection;
    vQuery: TFDQuery;
    vQueryTodos: TFDQuery;
    vQueryTodosANTES: TStringField;
    vQueryTodosDEPOIS: TStringField;
    dsTodos: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DiretorioBanco : String;
  end;

var
  dmPrincipal: TdmPrincipal;

implementation

uses
  Vcl.Forms, Excessoes, Principal;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmPrincipal.DataModuleCreate(Sender: TObject);
begin
  with conn do
  begin
    Params.Values['DriverID'] := 'SQLite';

    Params.Values['DataBase'] := System.SysUtils.GetCurrentDir + '\Banco\Banco.db';

    try
      Connected := True;
    except on e:Exception do
      raise Exception.Create('Erro de conexão com o banco de dados: ' + e.Message);
    end;
  end;
end;

end.
