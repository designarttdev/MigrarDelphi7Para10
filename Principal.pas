unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXCtrls,
  Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FileCtrl, ShellApi, System.ImageList, Vcl.ImgList, IniFiles;

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
    procedure FormShow(Sender: TObject);
  private
    function ReplaceMemo(vString : String) : String;
    function SelectADirectory(Title: string): string;
    procedure SalvarCaminhoPasta(EditCaminho: TEdit);
    procedure CarregarCaminhoPasta(EditCaminho: TEdit);
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
var
  F: TSearchRec;
begin
  if not DirectoryExists(Trim(edtDiretorio.Text)) then
  begin
    Application.MessageBox('Diret\xf3rio inv\xe1lido.', 'Aten\xe7\xe3o!', MB_OK + MB_ICONSTOP);
    Exit;
  end;

  if FindFirst(IncludeTrailingPathDelimiter(edtDiretorio.Text) + '*.dpr', faAnyFile, F) <> 0 then
  begin
    if Application.MessageBox('N\xe3o foi encontrado nenhum arquivo .dpr no diret\xf3rio informado. Deseja continuar assim mesmo?',
      'Aten\xe7\xe3o!', MB_YESNO + MB_ICONQUESTION) = IDNO then
      Exit;
  end
  else
    FindClose(F);

  memLista.Lines.Clear;
  SalvarCaminhoPasta(edtDiretorio);

  ListarArquivos(edtDiretorio.Text, chkSub.Checked);

end;

function TfrPrincipal.SelectADirectory(Title : string) : string;
var
  Pasta : String;
begin
  SelectDirectory(Title, '', Pasta);

  if (Trim(Pasta) <> '') then
    if (Pasta[Length(Pasta)] <> '\') then
      Pasta := Pasta + '\';

  Result := Pasta;
end;

procedure TfrPrincipal.btnSelecionaPastaClick(Sender: TObject);
var
  selDir : String;
begin
  //tem que declarar na Uses do projeto a Unit "FileCtrl"
//  SelectDirectory('Selecione uma pasta', '', selDir);

  with TFileOpenDialog.Create(nil) do
  try
    Options := [fdoPickFolders];
    DefaultFolder := Trim(edtDiretorio.Text);
    if Execute then
    begin
      edtDiretorio.Text := FileName;
      SalvarCaminhoPasta(edtDiretorio);
    end;
  finally
    Free;
  end;


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

  vHoraIni                  := Now;
  edtDiretorio.Enabled      := False;
  btnListar.Enabled         := False;
  btnAdicionar.Enabled      := False;
  btnSelecionaPasta.Enabled := False;
  lblArquivos.Caption       := 'Aguarde até o final do processo';

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

//          if (pos('.pas', Diretorio+'\'+F.Name) > 0) or (pos('.dfm', Diretorio+'\'+F.Name) > 0) then
          if (ExtractFileExt(F.Name) = '.pas') or (ExtractFileExt(F.Name) = '.dfm') then
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
              memoArquivos.Lines.Add(ReplaceMemo(sLinha));
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

//            ReplaceMemo;

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

  edtDiretorio.Enabled      := True;
  btnListar.Enabled         := True;
  btnAdicionar.Enabled      := True;
  btnSelecionaPasta.Enabled := True;
  lblArquivos.Caption       := 'Arquivos - Concluído';
  vHoraFim := FormatDateTime('hh:MM:ss', (Now - vHoraIni));
  Application.MessageBox(pWideChar('Concluído em '+vHoraFim+' min ! ☺'), 'Atenção!', MB_OK + MB_ICONWARNING);

end;

function TFrPrincipal.TemAtributo(Attr, Val : Integer): Boolean;
begin
  Result := Attr and Val = Val;
end;

function TfrPrincipal.ReplaceMemo(vString : String) : String;
var
  I : Integer;
begin

  try
    dmPrincipal.vQuery.First;
    for I := 0 to dmPrincipal.vQuery.RecordCount - 1 do
    begin
      Application.ProcessMessages;
      vString := StringReplace(vString, Trim(dmPrincipal.vQuery.FieldByName('ANTES').AsString), Trim(dmPrincipal.vQuery.FieldByName('DEPOIS').AsString), [rfReplaceAll, rfIgnoreCase]);
      dmPrincipal.vQuery.Next;
    end;
    Result := vString;
  except on e:Exception do
    begin
      Result := '';
      ShowMessage('Deu erro ao usar o replace');
    end;
  end;
end;

procedure TfrPrincipal.SalvarCaminhoPasta(EditCaminho: TEdit);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    Ini.WriteString('Config', 'CaminhoPasta', EditCaminho.Text);
  finally
    Ini.Free;
  end;
end;

procedure TfrPrincipal.CarregarCaminhoPasta(EditCaminho: TEdit);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    EditCaminho.Text := Ini.ReadString('Config', 'CaminhoPasta', '');
  finally
    Ini.Free;
  end;
end;

procedure TfrPrincipal.FormShow(Sender: TObject);
begin
  CarregarCaminhoPasta(edtDiretorio);
end;

end.
