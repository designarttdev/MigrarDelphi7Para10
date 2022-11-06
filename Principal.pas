unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXCtrls,
  Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FileCtrl;

type
  TfrPrincipal = class(TForm)
    lblOrigem: TLabel;
    edtDiretorio: TEdit;
    chkSub: TCheckBox;
    lblArquivos: TLabel;
    memLista: TMemo;
    btnListar: TButton;
    memoArquivos: TMemo;
    btnSelecionaPasta: TButton;
    btnAdicionar: TButton;
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure btnSelecionaPastaClick(Sender: TObject);
  private
    procedure ReplaceMemo;
    { Private declarations }
  public
    { Public declarations }
    procedure ListarArquivos(Diretorio : String; Sub:Boolean);
    function TemAtributo(Attr, Val: Integer): Boolean;
  end;

var
  frPrincipal: TfrPrincipal;

implementation

uses
  DataModule, Excessoes;

{$R *.dfm}

procedure TfrPrincipal.btnAdicionarClick(Sender: TObject);
begin
  frExcessoes := TfrExcessoes.Create(Self);
  frExcessoes.ShowModal;
  frExcessoes.Release;
end;

procedure TfrPrincipal.btnListarClick(Sender: TObject);
begin
  memLista.Lines.Clear;

  ListarArquivos(edtDiretorio.Text, chkSub.Checked);
end;

procedure TfrPrincipal.btnSelecionaPastaClick(Sender: TObject);
var
  selDir : String;
begin
  //tem que declarar na Uses do projeto a Unit "FileCtrl"
  SelectDirectory('Selecione uma pasta', '', selDir);
  edtDiretorio.Text := selDir;
end;

procedure TfrPrincipal.ListarArquivos(Diretorio : String; Sub:Boolean);
var
  F: TSearchRec;
  Ret: Integer;
  TempNome: string;
  ArqTxt : TextFile;
  sLinha, vHoraFim : String;
  fArq : TStrings;
  I : Integer;
  vHoraIni : TDateTime;
begin

  vHoraIni             := Now;
  edtDiretorio.Enabled := False;
  btnListar.Enabled    := False;
  lblArquivos.Caption  := 'Aguarde até o final do processo';

  dmPrincipal.vQuery.Connection := dmPrincipal.conn;
  dmPrincipal.vQuery.Close;
  dmPrincipal.vQuery.Sql.Clear;
  dmPrincipal.vQuery.Sql.Add('SELECT * FROM CONVERSAO');
  dmPrincipal.vQuery.Open;

  {$REGION 'Processo conversão'}
    Ret := FindFirst(Diretorio+'\*.*', faAnyFile, F);

    try

      while Ret = 0 do
      begin
        Application.ProcessMessages;

        if TemAtributo(F.Attr, faDirectory) then
        begin
          if (F.Name <> '.') And (F.Name <> '..') then
            if Sub = True then
            begin
              TempNome := Diretorio+'\' + F.Name;
              ListarArquivos(TempNome, True);
            end;
        end
        else
        begin
          memLista.Lines.Add(Diretorio+'\'+F.Name);

          if (pos('.pas', Diretorio+'\'+F.Name) > 0) or (pos('.dfm', Diretorio+'\'+F.Name) > 0) then
          begin

            AssignFile(ArqTxt, Diretorio+'\'+F.Name);
            Reset(ArqTxt);
            fArq := TStringList.Create;
            fArq.Clear;

            fArq.BeginUpdate;
            memoArquivos.Lines.Clear;
            while not eof(ArqTxt) do
            begin
              Application.ProcessMessages;
              ReadLn(ArqTxt, sLinha);
              fArq.Add(sLinha);
              memoArquivos.Lines.Add(sLinha);
            end;

            CloseFile(ArqTxt);
            fArq.EndUpdate;

            {$Region 'Comentado'}

//              memoArquivos.Lines.Text := memoArquivos.Lines.Text
//                                        .Replace('TStringField', 'TWideStringField')
//                                        .Replace('IntegerField', 'TWideIntegerField')
//                                        .Replace('Classes', 'System.Classes')
//                                        .Replace('SysUtils', 'System.SysUtils')
//                                        .Replace('ToolEdit', 'TWideStringField')
//                                        .Replace('TTable', 'TFDTable')
//                                        .Replace('TQuery', 'TFDQuery')
//                                        .Replace('DBTables', 'FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, ' + sLineBreak
//                                                              + 'FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Db, FireDac.UI.Intf, FireDac.Stan.def, FireDac.Stan.Pool')
//                                        .Replace('DataBaseName', 'Connection')
//                                        .Replace('Session', 'FDManager')
//                                        .Replace('TIBDatabase', 'TFDConnection')
//                                        .Replace('AliasName', 'ConnectionDefName')
//                                        .Replace('DeleteAlias', 'DeleteConnectionDef')
//                                        .Replace('IsAlias', 'IsConnectionDef')
//                                        .Replace('AddAlias', 'AddConnectionDef')
//                                        .Replace('ModifyAlias', 'ModifyConnectionDef')
//                                        .Replace('SaveConfigFile', 'SaveConnectionDefFile')
//                                        .Replace('TTWideIntegerField', 'TIntegerField')
//                                        .Replace('TWideStringField', 'TStringField')
//                                        .Replace('HKEY_System.Classes_ROOT', 'HKEY_CLASSES_ROOT')
//                                        .Replace('RegistryHive_System.ClassesRoot = $80000000;', '//RegistryHive_System.ClassesRoot = $80000000;')
//                                        .Replace('TypeLibImporterFlags_SerializableValueSystem.Classes = $00000020;', '//TypeLibImporterFlags_SerializableValueSystem.Classes = $00000020;')
//                                        .Replace('InpuTFDQuery', 'InputQuery');

            {$EndRegion}

            ReplaceMemo;

            if not DirectoryExists(Diretorio + '\Convertido') then
              CreateDir(Diretorio + '\Convertido');

            memoArquivos.Lines.SaveToFile(Diretorio + '\Convertido\' + F.Name);
            memoArquivos.Lines.Clear;

            fArq.Free;
          end;
        end;
          Ret := FindNext(F);
      end;

    finally
      begin
        FindClose(F);
      end;
    end;
  {$ENDREGION}

  edtDiretorio.Enabled := True;
  btnListar.Enabled    := True;
  lblArquivos.Caption := 'Arquivos - Concluído';
  vHoraFim := FormatDateTime('hh:MM:ss', (Now - vHoraIni));
  Application.MessageBox(pWideChar('Concluído em '+vHoraFim+' min ! ☺'), 'Atenção!', MB_OK + MB_ICONWARNING);

end;

function TFrPrincipal.TemAtributo(Attr, Val : Integer): Boolean;
begin
  Result := Attr and Val = Val;
end;

procedure TfrPrincipal.ReplaceMemo;
var
  I : Integer;
begin
  try
    dmPrincipal.vQuery.First;
    for I := 0 to dmPrincipal.vQuery.RecordCount - 1 do
    begin
      Application.ProcessMessages;
      memoArquivos.Lines.Text := memoArquivos.Lines.Text.Replace(dmPrincipal.vQuery.FieldByName('ANTES').AsString, dmPrincipal.vQuery.FieldByName('DEPOIS').AsString);
      dmPrincipal.vQuery.Next;
    end;
  except on e:Exception do
    begin
      ShowMessage('Deu erro aqui');
    end;
  end;
end;

end.
