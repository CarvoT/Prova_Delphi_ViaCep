unit ucpComboBoxValue;

interface

uses
  System.Classes, Vcl.StdCtrls;

type
  TComboBoxValue = Class(TComboBox)
  private
    FValores: TStringList;
    procedure SetValores(const Value: TStringList);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Valores: TStringList read FValores write SetValores;
    function ValorSelecionado: string;
  End;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('ComponentesParticulares', [TComboBoxValue]);
end;

{ TComboBoxValue }

constructor TComboBoxValue.Create(AOwner: TComponent);
begin
  inherited;
  FValores := TStringList.Create;
end;

destructor TComboBoxValue.Destroy;
begin
  FValores.Free;
  inherited;
end;

procedure TComboBoxValue.SetValores(const Value: TStringList);
begin
  FValores.Assign(Value);
end;

function TComboBoxValue.ValorSelecionado: string;
begin
  if itemindex < 0 then
    Result := ''
  else if FValores.Count > itemindex then
    Result := FValores[ItemIndex]
  else
    Result := '';
end;

end.
