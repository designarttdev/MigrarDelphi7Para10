program MigrarDelphi7Para10;

uses
  Vcl.Forms,
  Principal in 'Principal.pas' {frPrincipal},
  DataModule in 'DataModule.pas' {dmPrincipal: TDataModule},
  Excessoes in 'Excessoes.pas' {frExcessoes};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmPrincipal, dmPrincipal);
  Application.CreateForm(TfrPrincipal, frPrincipal);
  Application.Run;
end.
