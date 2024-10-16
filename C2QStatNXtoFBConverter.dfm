object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'C2Q Ticket Converter'
  ClientHeight = 185
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object FBDirLabel: TLabel
    Left = 103
    Top = 128
    Width = 71
    Height = 13
    Caption = 'PLACEHOLDER'
  end
  object NXDirLabel: TLabel
    Left = 103
    Top = 168
    Width = 71
    Height = 13
    Caption = 'PLACEHOLDER'
  end
  object ConvertButton: TButton
    Left = 200
    Top = 8
    Width = 145
    Height = 94
    Caption = 'Convert data'
    TabOrder = 0
    OnClick = ConvertButtonClick
  end
  object DropDownYears: TComboBox
    Left = 8
    Top = 81
    Width = 145
    Height = 21
    TabOrder = 1
    OnChange = DropDownYearsChange
  end
  object StaticText2: TStaticText
    Left = 8
    Top = 58
    Width = 175
    Height = 17
    Caption = 'Choose number of years to convert'
    TabOrder = 2
  end
  object EditBoxIPAddress: TEdit
    Left = 8
    Top = 31
    Width = 145
    Height = 21
    TabOrder = 3
  end
  object StaticText1: TStaticText
    Left = 8
    Top = 8
    Width = 184
    Height = 17
    Caption = 'Input IP address of server to convert'
    TabOrder = 4
  end
  object ButtonFirebirdChangeDB: TButton
    Left = 8
    Top = 108
    Width = 89
    Height = 33
    Caption = 'Change FB dir'
    TabOrder = 5
    OnClick = ButtonFirebirdChangeDBClick
  end
  object ButtonNexusChangeDB: TButton
    Left = 8
    Top = 147
    Width = 89
    Height = 34
    Caption = 'Change NX dir'
    TabOrder = 6
    OnClick = ButtonNexusChangeDBClick
  end
  object FirebirdConnection: TFDConnection
    Params.Strings = (
      'DriverID=FB'
      'Database=D:\C2Data\CITO.FDB'
      'User_Name=C2APP'
      'Port=3050'
      'Password=C1t00wns'
      'OSAuthent=No'
      'RoleName=C2APP')
    Left = 315
    Top = 65
  end
  object NexusDatabase: TnxDatabase
    Session = nxSession1
    AliasPath = 'D:\Data\C2Q'
    Left = 283
    Top = 97
  end
  object FirebirdTicketQuery: TFDQuery
    Connection = FirebirdConnection
    Left = 283
    Top = 65
  end
  object NexusDepartmentInfoQuery: TnxQuery
    Left = 251
    Top = 145
  end
  object NexusTicketMasterArchiveQuery: TnxQuery
    Left = 251
    Top = 97
  end
  object NexusRemoteEngine: TnxRemoteServerEngine
    Transport = NexusTransport
    Left = 315
    Top = 97
  end
  object nxSqlEngine1: TnxSqlEngine
    StmtLogging = False
    StmtLogTableName = 'QueryLog'
    UseFieldCache = False
    Left = 283
    Top = 145
  end
  object nxSession1: TnxSession
    ServerEngine = NexusRemoteEngine
    Left = 219
    Top = 145
  end
  object NexusTransport: TnxWinsockTransport
    DisplayCategory = 'Transports'
    Left = 315
    Top = 145
  end
end
