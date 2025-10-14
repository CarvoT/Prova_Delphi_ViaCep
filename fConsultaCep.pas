{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit fConsultaCep;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ucpConsultaViaCep, unConsultaCEP,
  Vcl.ExtCtrls, ucpComboBoxValue, Vcl.Mask, Vcl.ComCtrls, Vcl.Grids, Data.DB,
  Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmConsultaCep = class(TForm, INotificacao)
    pnlEnderecos: TPanel;
    pnlTopo: TPanel;
    pgcConsulta: TPageControl;
    tsConsultaEndereco: TTabSheet;
    tsConsultaCep: TTabSheet;
    lblEstado: TLabel;
    lblCidade: TLabel;
    edtCidade: TEdit;
    edtLogradouro: TEdit;
    lblLogradouro: TLabel;
    meCEP: TMaskEdit;
    lblCep: TLabel;
    cbbEstado: TComboBoxValue;
    pnlBotoes: TPanel;
    btnBuscar: TButton;
    btnLimpar: TButton;
    rgFormaConsulta: TRadioGroup;
    dbgEnderecos: TDBGrid;
    dsEnderecos: TDataSource;
    procedure btnBuscarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dbgEnderecosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }

    oNegocioConsultaCep: TNegocioConsultaCEP;

    procedure InicializarComponentes;
    function Notificar(tipo: TNotificacao; mensagem: string): TModalResult;

    procedure LimparCampos;
    procedure BuscarPorCep;
    procedure BuscarPorEndereco;
  public
    { Public declarations }
  end;

var
  frmConsultaCep: TfrmConsultaCep;

implementation

{$R *.dfm}

procedure TfrmConsultaCep.btnBuscarClick(Sender: TObject);
begin
  if pgcConsulta.ActivePage = tsConsultaCep then
    BuscarPorCep
  else
    BuscarPorEndereco;
end;

procedure TfrmConsultaCep.btnLimparClick(Sender: TObject);
begin
  LimparCampos;
end;

procedure TfrmConsultaCep.BuscarPorCep;
var
  oParametros: TCep;
begin
  oParametros := TCep.Create;
  oParametros.FormaConsulta := TFormaConsulta(rgFormaConsulta.ItemIndex);
  oParametros.CEP := meCEP.Text;

  oNegocioConsultaCep.ConsultarPorCEP(oParametros);
end;

procedure TfrmConsultaCep.BuscarPorEndereco;
var
  oParametros: TEnderecoCompleto;
begin
  oParametros := TEnderecoCompleto.Create;
  oParametros.FormaConsulta := TFormaConsulta(rgFormaConsulta.ItemIndex);
  oParametros.UF := cbbEstado.ValorSelecionado;
  oParametros.Cidade := edtCidade.Text;
  oParametros.Logradouro := edtLogradouro.Text;

  oNegocioConsultaCep.ConsultarPorEnderecoCompleto(oParametros);
end;

procedure TfrmConsultaCep.dbgEnderecosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [SsCtrl]) and (key = 46) then
    key:=0;
end;

procedure TfrmConsultaCep.FormCreate(Sender: TObject);
begin
  InicializarComponentes;
end;

procedure TfrmConsultaCep.InicializarComponentes;
begin
  oNegocioConsultaCep := TNegocioConsultaCEP.Create(Self);
  dsEnderecos.DataSet  := oNegocioConsultaCep.ListarEnderecosSemFiltro;
  pgcConsulta.ActivePage := tsConsultaCep;
end;

procedure TfrmConsultaCep.LimparCampos;
begin
  meCEP.Clear;
  cbbEstado.ItemIndex := -1 ;
  edtCidade.Clear;
  edtLogradouro.Clear;
  oNegocioConsultaCep.ListarEnderecosSemFiltro;
end;

function TfrmConsultaCep.Notificar(tipo: TNotificacao;
  mensagem: string): TModalResult;
begin
  result := mrNone;

  case tipo of
    tnAviso: Application.MessageBox(Pchar(mensagem), 'Aviso', MB_ICONWARNING);
    tnPergunta: result := Application.MessageBox(Pchar(mensagem), 'Aviso', MB_ICONQUESTION + MB_YESNO);
    tnErro: Application.MessageBox(Pchar(mensagem), 'Erro', MB_ICONERROR);
  end;
end;

end.
