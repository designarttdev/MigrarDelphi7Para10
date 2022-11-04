object dmPrincipal: TdmPrincipal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 277
  Width = 355
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
end
