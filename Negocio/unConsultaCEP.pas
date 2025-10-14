unit unConsultaCEP;

interface

uses ucpConsultaViaCep, SysUtils, dmConsultaCep, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Controls;

type

  TNotificacao = (tnAviso, tnPergunta, tnErro);

  INotificacao = Interface
    function Notificar(tipo: TNotificacao; mensagem: string): TModalResult;
  End;

  TParametrosConsulta = class
  private
    FFormaConsulta: TFormaConsulta;
  public
    property FormaConsulta: TFormaConsulta read FFormaConsulta write FFormaConsulta;
  end;

  TEnderecoCompleto = Class(TParametrosConsulta)
  private
    FLogradouro: String;
    FUF: String;
    FCidade: String;
  public
    property UF: String read FUF write FUF;
    property Cidade: String read FCidade write FCidade;
    property Logradouro: String read FLogradouro write FLogradouro;
  End;

  TCep = Class(TParametrosConsulta)
  private
    FCEP: String;
  public
    property CEP: String read FCEP write FCEP;
  End;


  TNegocioConsultaCEP = Class
  private
    FcpConsultaViaCep: TcpConsultaViaCep;
    FConsultaCEPDM: TdmdConsultaCep;
    Proprietario: INotificacao;

    function ParametrosValidos(Parametros: TParametrosConsulta): Boolean;
    function BuscouDaBase(Parametros: TParametrosConsulta): Boolean;
    procedure Consultar(Parametros: TParametrosConsulta);

  public
    constructor Create(AOwner: INotificacao);
    destructor Destroy; override;

    procedure ConsultarPorCEP(Parametros: TCep);
    procedure ConsultarPorEnderecoCompleto(Parametros: TEnderecoCompleto);
    function ListarEnderecosSemFiltro: TFDQuery;
  End;


implementation

{ TNegocioConsultaCEP }

procedure TNegocioConsultaCEP.Consultar(Parametros: TParametrosConsulta);
var
  oResultadoConsulta: TConsultaViaCepResposta;
  rEnderecoPesquisado: TtblEndereco;
  bConsultarAPI, bAtualizarRegistro: Boolean;
  I: Integer;
begin
  bConsultarAPI := False;
  bAtualizarRegistro := False;
  FcpConsultaViaCep.FormaConsulta := Parametros.FormaConsulta;

  if ParametrosValidos(Parametros) then
  begin
    if not BuscouDaBase(Parametros) then
    begin
      bConsultarAPI := True;
    end
    else
    begin
      if Proprietario.Notificar(tnPergunta, 'Deseja atualizar as informações do endereço pesquisado?') = mrYes then
      begin
        bConsultarAPI := True;
        bAtualizarRegistro := True;
      end;
    end;

    if bConsultarAPI then
    begin

      if Parametros is TCep then
        oResultadoConsulta := FcpConsultaViaCep.ConsultarPorCEP(TCep(Parametros).CEP)
      else
        oResultadoConsulta := FcpConsultaViaCep.ConsultarPorEnderecoCompleto(
                                                  TEnderecoCompleto(Parametros).UF,
                                                  TEnderecoCompleto(Parametros).FCidade,
                                                  TEnderecoCompleto(Parametros).Logradouro);

      if oResultadoConsulta.Sucesso then
      begin
        for I := Low(oResultadoConsulta.Dados) to High(oResultadoConsulta.Dados) do
        begin
          rEnderecoPesquisado.CEP := oResultadoConsulta.Dados[I].CEP;
          rEnderecoPesquisado.Logradouro := oResultadoConsulta.Dados[I].Logradouro;
          rEnderecoPesquisado.Complemento := oResultadoConsulta.Dados[I].Complemento;
          rEnderecoPesquisado.Bairro := oResultadoConsulta.Dados[I].Bairro;
          rEnderecoPesquisado.Localidade := oResultadoConsulta.Dados[I].Localidade;
          rEnderecoPesquisado.UF := oResultadoConsulta.Dados[I].UF;

          if bAtualizarRegistro then
          begin
            FConsultaCEPDM.AtualizarEndereco(rEnderecoPesquisado);
          end
          else
            FConsultaCEPDM.AdicionarEndereco(rEnderecoPesquisado);
        end;

        if bAtualizarRegistro and (Parametros is TEnderecoCompleto) then
        begin
          FConsultaCEPDM.ConsultarEndereco(TEnderecoCompleto(Parametros).UF,
                                           TEnderecoCompleto(Parametros).Cidade,
                                           TEnderecoCompleto(Parametros).Logradouro)
        end;
      end
      else
        Proprietario.Notificar(tnErro, oResultadoConsulta.Mensagem);
    end;
  end;
end;

procedure TNegocioConsultaCEP.ConsultarPorCEP(Parametros: TCep);
begin
  Consultar(Parametros);
end;

procedure TNegocioConsultaCEP.ConsultarPorEnderecoCompleto(Parametros: TEnderecoCompleto);
begin
  Consultar(Parametros);
end;

constructor TNegocioConsultaCEP.Create(AOwner: INotificacao);
begin
  if not Assigned(AOwner) then
    raise Exception.Create('Necessário informar um proprietário para o objeto de negócio.');

  Proprietario := AOwner;

  FConsultaCEPDM := TdmdConsultaCEP.Create(nil);
  FcpConsultaViaCep := TcpConsultaViaCep.Create(nil);
end;

destructor TNegocioConsultaCEP.Destroy;
begin
  FcpConsultaViaCep.Free;
  inherited;
end;

function TNegocioConsultaCEP.BuscouDaBase(Parametros: TParametrosConsulta): Boolean;

  procedure ExisteCep;
  begin
    Result := not TFDQuery(FConsultaCEPDM.ConsultarCEP(TCep(Parametros).CEP)).IsEmpty;
  end;

  procedure ExisteEndereco;
  begin
    Result := not TFDQuery(FConsultaCEPDM.ConsultarEndereco(
                                            TEnderecoCompleto(Parametros).UF,
                                            TEnderecoCompleto(Parametros).Cidade,
                                            TEnderecoCompleto(Parametros).Logradouro)).IsEmpty;
  end;

begin
  if Parametros is TCep then
    ExisteCep
  else if Parametros is TEnderecoCompleto then
    ExisteEndereco;

end;

function TNegocioConsultaCEP.ListarEnderecosSemFiltro: TFDQuery;
begin
  Result := FConsultaCEPDM.ConsultaEnderecoSemFiltro;
end;

function TNegocioConsultaCEP.ParametrosValidos(Parametros: TParametrosConsulta): Boolean;
var
  mensagem: string;

  procedure AddMensagem(sAviso: string);
  begin
    if mensagem = EmptyStr then
      mensagem := sAviso
    else
      mensagem := mensagem + sLineBreak + sAviso;
  end;

  procedure ValidarCEP;
  begin
    if Length(Trim(StringReplace(TCEP(Parametros).Cep, '-', '', [rfReplaceAll]))) <> 8 then
       AddMensagem('O CEP informado deve possuir 8 dígitos.');
  end;

  procedure ValidarEndereco;
  begin
    if Length(Trim(TEnderecoCompleto(Parametros).UF)) <> 2 then
        AddMensagem('O estado deve ser informado.');

    if Length(Trim(TEnderecoCompleto(Parametros).Cidade)) < 3 then
        AddMensagem('O campo cidade informado deve possuir ao menos 3 caracteres.');

    if Length(Trim(TEnderecoCompleto(Parametros).Logradouro)) < 3 then
        AddMensagem('O campo logradouro informado deve possuir ao menos 3 caracteres.');
  end;

begin
  Result := True;

  if Parametros is TCep then
    ValidarCEP
  else if Parametros is TEnderecoCompleto then
    ValidarEndereco
  else
    raise Exception.Create('Parâmetros de consulta inválidos.');

  if mensagem <> EmptyStr then
  begin
    Proprietario.Notificar(tnAviso, mensagem);
    Result := False;
  end;

end;

end.
