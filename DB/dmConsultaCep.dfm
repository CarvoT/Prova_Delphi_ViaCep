object dmdConsultaCEP: TdmdConsultaCEP
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object fdcSQLLite: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      
        'Database=C:\Users\Lucas\Documents\Repos\Prova_Delphi_ViaCep\DB\C' +
        'onsultaCEP.db')
    LoginPrompt = False
    Left = 40
    Top = 24
  end
  object fdqInicializarBase: TFDQuery
    Connection = fdcSQLLite
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS ENDERECOS ('
      '  CODIGO INTEGER PRIMARY KEY AUTOINCREMENT,'
      '  CEP VARCHAR(9),'
      '  LOGRADOURO VARCHAR(250),'
      '  COMPLEMENTO VARCHAR(100),'
      '  BAIRRO VARCHAR(100),'
      '  LOCALIDADE VARCHAR(100),'
      '  UF VARCHAR(2)'
      ')  '
      '  ')
    Left = 40
    Top = 96
  end
  object fdqEnderecos: TFDQuery
    CachedUpdates = True
    Connection = fdcSQLLite
    SQL.Strings = (
      'SELECT  '
      '  CODIGO,'
      '  CEP,'
      '  LOGRADOURO,'
      '  COMPLEMENTO,'
      '  BAIRRO,'
      '  LOCALIDADE,'
      '  UF'
      'FROM '
      '  ENDERECOS'
      '&M_WHERE')
    Left = 40
    Top = 160
    MacroData = <
      item
        Value = ''
        Name = 'M_WHERE'
        DataType = mdString
      end>
    object fdqEnderecosCODIGO: TFDAutoIncField
      DisplayLabel = 'C'#243'digo'
      DisplayWidth = 9
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object fdqEnderecosCEP: TStringField
      DisplayWidth = 9
      FieldName = 'CEP'
      Origin = 'CEP'
      Size = 9
    end
    object fdqEnderecosUF: TStringField
      DisplayWidth = 5
      FieldName = 'UF'
      Origin = 'UF'
      Size = 2
    end
    object fdqEnderecosLOCALIDADE: TStringField
      DisplayLabel = 'Localidade'
      DisplayWidth = 25
      FieldName = 'LOCALIDADE'
      Origin = 'LOCALIDADE'
      Size = 100
    end
    object fdqEnderecosBAIRRO: TStringField
      DisplayLabel = 'Bairro'
      DisplayWidth = 25
      FieldName = 'BAIRRO'
      Origin = 'BAIRRO'
      Size = 100
    end
    object fdqEnderecosLOGRADOURO: TStringField
      DisplayLabel = 'Logradouro'
      DisplayWidth = 25
      FieldName = 'LOGRADOURO'
      Origin = 'LOGRADOURO'
      Size = 250
    end
    object fdqEnderecosCOMPLEMENTO: TStringField
      DisplayLabel = 'Complemento'
      DisplayWidth = 10
      FieldName = 'COMPLEMENTO'
      Origin = 'COMPLEMENTO'
      Size = 100
    end
  end
end
