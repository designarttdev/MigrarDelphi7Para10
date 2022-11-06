object dmPrincipal: TdmPrincipal
  OnCreate = DataModuleCreate
  Height = 277
  Width = 355
  PixelsPerInch = 96
  object conn: TFDConnection
    Params.Strings = (
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    LoginPrompt = False
    Left = 32
    Top = 40
  end
  object vQuery: TFDQuery
    Connection = conn
    Left = 96
    Top = 41
  end
  object vQueryTodos: TFDQuery
    Connection = conn
    Left = 160
    Top = 41
    object vQueryTodosANTES: TStringField
      FieldName = 'ANTES'
      Size = 500
    end
    object vQueryTodosDEPOIS: TStringField
      FieldName = 'DEPOIS'
      Size = 500
    end
  end
  object dsTodos: TDataSource
    DataSet = vQueryTodos
    Left = 248
    Top = 40
  end
end
