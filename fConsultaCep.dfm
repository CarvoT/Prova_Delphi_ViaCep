object frmConsultaCep: TfrmConsultaCep
  Left = 0
  Top = 0
  Caption = 'Consulta de endere'#231'os'
  ClientHeight = 361
  ClientWidth = 784
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlEnderecos: TPanel
    Left = 0
    Top = 153
    Width = 784
    Height = 208
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 0
    ExplicitWidth = 686
    ExplicitHeight = 174
    object dbgEnderecos: TDBGrid
      Left = 8
      Top = 8
      Width = 768
      Height = 192
      Align = alClient
      DataSource = dsEnderecos
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnKeyDown = dbgEnderecosKeyDown
    end
  end
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 153
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 1
    ExplicitWidth = 686
    object pgcConsulta: TPageControl
      Left = 8
      Top = 8
      Width = 634
      Height = 137
      ActivePage = tsConsultaCep
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 536
      object tsConsultaCep: TTabSheet
        Caption = 'Consulta por CEP'
        ImageIndex = 1
        object lblCep: TLabel
          Left = 8
          Top = 8
          Width = 21
          Height = 15
          Caption = 'CEP'
        end
        object meCEP: TMaskEdit
          Left = 8
          Top = 29
          Width = 120
          Height = 23
          EditMask = '99999-999'
          MaxLength = 9
          TabOrder = 0
          Text = '     -   '
        end
      end
      object tsConsultaEndereco: TTabSheet
        Caption = 'Consulta por endere'#231'o'
        DesignSize = (
          626
          107)
        object lblEstado: TLabel
          Left = 8
          Top = 8
          Width = 35
          Height = 15
          Caption = 'Estado'
        end
        object lblCidade: TLabel
          Left = 159
          Top = 8
          Width = 37
          Height = 15
          Caption = 'Cidade'
        end
        object lblLogradouro: TLabel
          Left = 8
          Top = 58
          Width = 62
          Height = 15
          Caption = 'Logradouro'
        end
        object edtCidade: TEdit
          Left = 159
          Top = 29
          Width = 464
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          ExplicitWidth = 366
        end
        object edtLogradouro: TEdit
          Left = 8
          Top = 79
          Width = 615
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          ExplicitWidth = 517
        end
        object cbbEstado: TComboBoxValue
          Left = 8
          Top = 29
          Width = 145
          Height = 23
          Style = csDropDownList
          TabOrder = 0
          Items.Strings = (
            'Acre'
            'Alagoas'
            'Amap'#225
            'Amazonas'
            'Bahia'
            'Cear'#225
            'Distrito Federal'
            'Esp'#237'rito Santo'
            'Goi'#225's'
            'Maranh'#227'o'
            'Mato Grosso'
            'Mato Grosso do Sul'
            'Minas Gerais'
            'Par'#225
            'Para'#237'ba'
            'Paran'#225
            'Pernambuco'
            'Piau'#237
            'Rio de Janeiro'
            'Rio Grande do Norte'
            'Rio Grande do Sul'
            'Rond'#244'nia'
            'Roraima'
            'Santa Catarina'
            'S'#227'o Paulo'
            'Sergipe'
            'Tocantins')
          Valores.Strings = (
            'AC'
            'AL'
            'AP'
            'AM'
            'BA'
            'CE'
            'DF'
            'ES'
            'GO'
            'MA'
            'MT'
            'MS'
            'MG'
            'PA'
            'PB'
            'PR'
            'PE'
            'PI'
            'RJ'
            'RN'
            'RS'
            'RO'
            'RR'
            'SC'
            'SP'
            'SE'
            'TO')
        end
      end
    end
    object pnlBotoes: TPanel
      Left = 642
      Top = 8
      Width = 134
      Height = 137
      Align = alRight
      BevelOuter = bvNone
      BorderWidth = 8
      TabOrder = 1
      ExplicitLeft = 544
      DesignSize = (
        134
        137)
      object btnBuscar: TButton
        Left = 8
        Top = 80
        Width = 118
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = '&Buscar'
        TabOrder = 0
        OnClick = btnBuscarClick
      end
      object btnLimpar: TButton
        Left = 8
        Top = 111
        Width = 118
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = '&Limpar'
        TabOrder = 1
        OnClick = btnLimparClick
      end
      object rgFormaConsulta: TRadioGroup
        Left = 8
        Top = 14
        Width = 118
        Height = 60
        Caption = ' Forma de consulta '
        ItemIndex = 0
        Items.Strings = (
          'JSON'
          'XML')
        TabOrder = 2
      end
    end
  end
  object dsEnderecos: TDataSource
    Left = 496
    Top = 201
  end
end
