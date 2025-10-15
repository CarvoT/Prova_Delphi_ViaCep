unit ucpConsultaViaCep;

interface

uses
  System.SysUtils, System.Classes, System.net.HttpClient, System.JSON, Xml.XMLDoc, Xml.XMLIntf,
  System.Generics.Collections;

const
   PARAM_FCXML = 'xml';
   PARAM_FCJSON = 'json';
   NAO_LOCALIZADO = 'Endereço não localizado.';
   BAD_REQUEST = 'Parâmetro de consulta inválido.';

type
  TEnderecoViaCep = record
    CEP: string;
    Logradouro: string;
    Complemento: string;
    Unidade: string;
    Bairro: string;
    Localidade: string;
    UF: string;
    Estado: string;
    Regiao: string;
    IBGE: string;
    GIA: string;
    DDD: string;
    SIAFI: string;
    Erro: boolean;
  end;

  TConsultaViaCepResposta = record
    Sucesso: boolean;
    Mensagem: string;
    Dados: TArray<TEnderecoViaCep>;
  end;


  TFormaConsulta = (fcJSON = 0, fcXML = 1);

  TcpConsultaViaCep = class(TComponent)
  private
    // propriedades do componente
    FURLServicoViacep: string;
    FFormaConsulta: TFormaConsulta;

    //variaveis internas de consulta
    FUf, FCidade, FLogradouro, FCEP: string;

    procedure SetFormaConsulta(const Value: TFormaConsulta);

    //métodos internos de consulta por cep
    procedure TratarCEP;
    function ValidaCEP: boolean;
    function ConsultarAPICEP: TConsultaViaCepResposta;

    //métodos internos de consulta por endereço completo
    function ValidaEnderecoCompleto: boolean;
    function ConsultarAPIEnderecoCompleto: TConsultaViaCepResposta;

    //tratamentos de retorno
    function DeserializarJsonEndereco(sJson: string): TEnderecoViaCep;
    function DeserializarJsonEnderecos(sJson: string): TArray<TEnderecoViaCep>;
    function DeserializarXMLEndereco(sXml: string): TEnderecoViaCep;
    function DeserializarXMLEnderecos(sXml: string): TArray<TEnderecoViaCep>;

  protected
    { Protected declarations }

  public
    { Public declarations }
    constructor Create(Aowner: TComponent); override;
    function ConsultarPorCEP(sCep: string): TConsultaViaCepResposta;
    function ConsultarPorEnderecoCompleto(sUf, sCidade, sLogradouro: string): TConsultaViaCepResposta;

    Destructor Destroy; override;
  published
    { Published declarations }
    property URLServicoViacep: String read FURLServicoViacep write FURLServicoViacep;
    property FormaConsulta: TFormaConsulta read FFormaConsulta write SetFormaConsulta default fcXML;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('ComponentesParticulares', [TcpConsultaViaCep]);
end;

{ TcpConsultaViaCep }

function TcpConsultaViaCep.ConsultarAPICEP: TConsultaViaCepResposta;
var
  oClient: THTTPClient;
  oResponse: IHTTPResponse;
  sUrl: string;
begin
  oClient := THTTPClient.Create;
  try

    sUrl := URLServicoViacep + FCEP + '/';

    if FormaConsulta = fcXML then
      sUrl := sUrl + PARAM_FCXML
    else
      sUrl := sUrl + PARAM_FCJSON;

    sUrl := sUrl + '/';

    oResponse := oClient.Get(sUrl);
    if oResponse.StatusCode = 200 then
    begin
      Result.Sucesso := True;
      Result.Mensagem := '';

      SetLength(Result.Dados, 1);

      if FormaConsulta = fcXML then
        Result.Dados[0] := DeserializarXMLEndereco(oResponse.ContentAsString)
      else
        Result.Dados[0] := DeserializarJsonEndereco(oResponse.ContentAsString);

      if Result.Dados[0].Erro then
      begin
        Result.Sucesso := False;
        Result.Mensagem := NAO_LOCALIZADO;
      end;
    end
    else
    begin
      Result.Sucesso := False;
      Result.Mensagem := oResponse.StatusText;
    end;

  finally
    oClient.free;
  end;
end;

function TcpConsultaViaCep.ConsultarAPIEnderecoCompleto: TConsultaViaCepResposta;
var
  oClient: THTTPClient;
  oResponse: IHTTPResponse;
  sUrl: string;
begin
  oClient := THTTPClient.Create;
  try

    sUrl := URLServicoViacep + FUF + '/' + FCidade + '/' + FLogradouro + '/';

    if FormaConsulta = fcXML then
      sUrl := sUrl + PARAM_FCXML
    else
      sUrl := sUrl + PARAM_FCJSON;

    sUrl := sUrl + '/';

    oResponse := oClient.Get(sUrl);
    if oResponse.StatusCode = 200 then
    begin
      Result.Sucesso := True;
      Result.Mensagem := '';

      if FormaConsulta = fcXML then
        Result.Dados := DeserializarXMLEnderecos(oResponse.ContentAsString)
      else
        Result.Dados := DeserializarJsonEnderecos(oResponse.ContentAsString);

      if Length(Result.Dados) = 0 then
      begin
        Result.Sucesso := False;
        Result.Mensagem := NAO_LOCALIZADO;
      end;
    end
    else if oResponse.StatusCode = 400 then
    begin
      Result.Sucesso := False;
      Result.Mensagem := BAD_REQUEST;
    end
    else
    begin
      Result.Sucesso := False;
      Result.Mensagem := oResponse.StatusText;
    end;

  finally
    oClient.free;
  end;
end;

function TcpConsultaViaCep.ConsultarPorCEP(sCEP: string): TConsultaViaCepResposta;
begin
  FCEP := sCEP;
  TratarCEP;
  if ValidaCEP then
    Result := ConsultarAPICEP;
end;

function TcpConsultaViaCep.ConsultarPorEnderecoCompleto(
  sUf, sCidade, sLogradouro: string): TConsultaViaCepResposta;
begin
  FUf := sUf;
  FCidade := sCidade;
  FLogradouro := sLogradouro;

  if ValidaEnderecoCompleto then
    Result := ConsultarAPIEnderecoCompleto;
end;

constructor TcpConsultaViaCep.Create(Aowner: TComponent);
begin
  inherited;
  FUrlServicoViacep := 'https://viacep.com.br/ws/';
end;

function TcpConsultaViaCep.DeserializarJsonEndereco(
  sJson: string): TEnderecoViaCep;
var
  oJson: TJSONObject;
begin
  Result.Erro := True;
  oJson := TJSONObject.ParseJSONValue(sJson) as TJSONObject;
  try
    if oJson = nil then
      exit;

    if Assigned(oJson.Get('erro')) then
      exit;

    Result.CEP := oJson.GetValue('cep').Value;
    Result.Logradouro := oJson.GetValue('logradouro').Value;
    Result.Complemento := oJson.GetValue('complemento').Value;
    Result.Unidade := oJson.GetValue('unidade').Value;
    Result.Bairro := oJson.GetValue('bairro').Value;
    Result.Localidade := oJson.GetValue('localidade').Value;
    Result.UF := oJson.GetValue('uf').Value;
    Result.Estado := oJson.GetValue('estado').Value;
    Result.Regiao := oJson.GetValue('regiao').Value;
    Result.IBGE := oJson.GetValue('ibge').Value;
    Result.GIA := oJson.GetValue('gia').Value;
    Result.DDD := oJson.GetValue('ddd').Value;
    Result.SIAFI := oJson.GetValue('siafi').Value;
    Result.Erro := False;
  finally
    oJson.Free;
  end;
end;

function TcpConsultaViaCep.DeserializarJsonEnderecos(
  sJson: string): TArray<TEnderecoViaCep>;
var
  oJsonArr: TJSONArray;
  I: Integer;
begin
  oJsonArr := TJSONObject.ParseJSONValue(sJson) as TJSONArray;
  if oJsonArr = nil then
    Exit;

  SetLength(Result, oJsonArr.Count);

  for I := 0 to oJsonArr.Count - 1 do
    Result[I] := DeserializarJsonEndereco(oJsonArr.Items[I].ToString);
end;

function TcpConsultaViaCep.DeserializarXMLEndereco(
  sXml: string): TEnderecoViaCep;
var
  oXML: IXMLDocument;
  oNode: IXMLNode;
begin
  oXML := TXMLDocument.Create(nil);
  try
    oXML.LoadFromXML(sXml);
    oXML.Active := True;

    oNode := oXML.DocumentElement;

    if Assigned(oNode) then
    begin
      Result.CEP := oNode.ChildNodes['cep'].Text;
      Result.Logradouro := oNode.ChildNodes['logradouro'].Text;
      Result.Complemento := oNode.ChildNodes['complemento'].Text;
      Result.Unidade := oNode.ChildNodes['unidade'].Text;
      Result.Bairro := oNode.ChildNodes['bairro'].Text;
      Result.Localidade := oNode.ChildNodes['localidade'].Text;
      Result.UF := oNode.ChildNodes['uf'].Text;
      Result.Estado := oNode.ChildNodes['estado'].Text;
      Result.Regiao := oNode.ChildNodes['regiao'].Text;
      Result.IBGE := oNode.ChildNodes['ibge'].Text;
      Result.GIA := oNode.ChildNodes['gia'].Text;
      Result.DDD := oNode.ChildNodes['ddd'].Text;
      Result.SIAFI := oNode.ChildNodes['siafi'].Text;
    end;
  finally
    oXML := nil;
  end;
end;

function TcpConsultaViaCep.DeserializarXMLEnderecos(
  sXml: string): TArray<TEnderecoViaCep>;
var
  oXML: IXMLDocument;
  oxmlcep, oenderecos, oendereco: IXMLNode;
  I: Integer;
begin
  oXML := TXMLDocument.Create(nil);
  try
    oXML.LoadFromXML(sXml);
    oXML.Active := True;

    oxmlcep := oXML.DocumentElement;
    if not Assigned(oxmlcep) then
      Exit;

    oenderecos := oxmlcep.ChildNodes.FindNode('enderecos');
    if not Assigned(oenderecos) then
      Exit;


    SetLength(Result,oenderecos.ChildNodes.Count);


    for I := 0 to oenderecos.ChildNodes.Count -1 do
    begin
      oendereco := oenderecos.ChildNodes[I];
      Result[I] := DeserializarXMLEndereco(oendereco.XML);
    end;
  finally
    oXML := nil;
  end;
end;

destructor TcpConsultaViaCep.Destroy;
begin
  inherited;
end;

procedure TcpConsultaViaCep.SetFormaConsulta(const Value: TFormaConsulta);
begin
  FFormaConsulta := Value;
end;

procedure TcpConsultaViaCep.TratarCEP;
begin
  FCEP := Trim(StringReplace(FCEP,'-','',[rfReplaceAll]));
end;

function TcpConsultaViaCep.ValidaCEP: boolean;
begin
  Result := True;

  if length(FCEP) < 8 then
    Result := False;
end;

function TcpConsultaViaCep.ValidaEnderecoCompleto: boolean;
begin
  Result := True;

  if (length(FUF) < 2) then
    Result := False;

  if (length(FCidade) < 3) then
    Result := False;

  if (length(FLogradouro) < 3) then
    Result := False;
end;

end.
