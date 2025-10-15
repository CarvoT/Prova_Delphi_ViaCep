unit dmConsultaCep;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.IOUtils;

type

  TtblEndereco = record
    CEP: string;
    Logradouro: string;
    Complemento: string;
    Bairro: string;
    Localidade: string;
    UF: string;
  end;

  TdmdConsultaCEP = class(TDataModule)
    fdcSQLLite: TFDConnection;
    fdqInicializarBase: TFDQuery;
    fdqEnderecos: TFDQuery;
    fdqEnderecosCODIGO: TFDAutoIncField;
    fdqEnderecosCEP: TStringField;
    fdqEnderecosLOGRADOURO: TStringField;
    fdqEnderecosCOMPLEMENTO: TStringField;
    fdqEnderecosBAIRRO: TStringField;
    fdqEnderecosLOCALIDADE: TStringField;
    fdqEnderecosUF: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure InicializarBase;
  public
    { Public declarations }
    function ConsultaEnderecoSemFiltro: TFDQuery;
    function ConsultarCEP(Cep: String): TFDQuery;
    function ConsultarEndereco(UF, Cidade, Logradouro: String): TFDQuery;

    procedure AdicionarEndereco(Endereco: TtblEndereco);
    procedure AtualizarEndereco(Endereco: TtblEndereco);
  end;

var
  dmdConsultaCEP: TdmdConsultaCEP;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmdConsultaCEP.AdicionarEndereco(Endereco: TtblEndereco);
begin
  fdqEnderecos.Append;
  fdqEnderecosCEP.AsString := Endereco.CEP;
  fdqEnderecosLOGRADOURO.AsString := Endereco.Logradouro;
  fdqEnderecosCOMPLEMENTO.AsString := Endereco.Complemento;
  fdqEnderecosBAIRRO.AsString := Endereco.Bairro;
  fdqEnderecosLOCALIDADE.AsString := Endereco.Localidade;
  fdqEnderecosUF.AsString := Endereco.UF;
  fdqEnderecos.Post;
  fdqEnderecos.ApplyUpdates;
  fdqEnderecos.CommitUpdates;
end;

procedure TdmdConsultaCEP.AtualizarEndereco(Endereco: TtblEndereco);
begin
  ConsultarCEP(Endereco.CEP);

  if fdqEnderecos.IsEmpty then
    fdqEnderecos.Insert
  else
    fdqEnderecos.Edit;

  fdqEnderecosCEP.AsString := Endereco.CEP;
  fdqEnderecosLOGRADOURO.AsString := Endereco.Logradouro;
  fdqEnderecosCOMPLEMENTO.AsString := Endereco.Complemento;
  fdqEnderecosBAIRRO.AsString := Endereco.Bairro;
  fdqEnderecosLOCALIDADE.AsString := Endereco.Localidade;
  fdqEnderecosUF.AsString := Endereco.UF;
  fdqEnderecos.Post;
  fdqEnderecos.ApplyUpdates;
end;

function TdmdConsultaCEP.ConsultaEnderecoSemFiltro: TFDQuery;
begin
  fdqEnderecos.Close;
  fdqEnderecos.MacroByName('M_WHERE').AsString := '';
  fdqEnderecos.Open;

  Result := fdqEnderecos;
end;

function TdmdConsultaCEP.ConsultarCEP(Cep: String): TFDQuery;
begin
  fdqEnderecos.Close;
  fdqEnderecos.MacroByName('M_WHERE').AsRaw := 'WHERE CEP = ''' + Cep + '''';
  fdqEnderecos.Prepare;
  fdqEnderecos.Open;

  Result := fdqEnderecos;
end;

function TdmdConsultaCEP.ConsultarEndereco(UF, Cidade,
  Logradouro: String): TFDQuery;
begin
  fdqEnderecos.Close;
  fdqEnderecos.MacroByName('M_WHERE').AsRaw := 'WHERE UF = ''' + UF + ''' ' +
    ' AND LOCALIDADE LIKE ( ''%' + Cidade + '%'') ' +
    ' AND LOGRADOURO LIKE ( ''%' + Logradouro + '%'')';

  fdqEnderecos.Open;

  Result := fdqEnderecos;
end;

procedure TdmdConsultaCEP.DataModuleCreate(Sender: TObject);
begin
  InicializarBase;
end;

procedure TdmdConsultaCEP.InicializarBase;
var
  CaminhoExe, CaminhoDB: string;
begin
  CaminhoExe := ExtractFilePath(ParamStr(0));
  CaminhoDB := TDirectory.GetParent(TDirectory.GetParent(TDirectory.GetParent(CaminhoExe)));
  CaminhoDB := CaminhoDB + '\DB\';

  fdcSQLLite.Params.Database :=  CaminhoDB + 'ConsultaCEP.db';

  fdcSQLLite.Connected := True;
  fdqInicializarBase.ExecSQL;
end;


end.
