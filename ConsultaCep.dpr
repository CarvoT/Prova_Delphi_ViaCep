program ConsultaCep;

uses
  Vcl.Forms,
  fConsultaCep in 'fConsultaCep.pas' {frmConsultaCep},
  ucpConsultaViaCep in 'Componentes\ucpConsultaViaCep.pas',
  ucpComboBoxValue in 'Componentes\ucpComboBoxValue.pas',
  dmConsultaCep in 'DB\dmConsultaCep.pas' {dmdConsultaCEP: TDataModule},
  unConsultaCEP in 'Negocio\unConsultaCEP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmConsultaCep, frmConsultaCep);
  Application.Run;
end.
