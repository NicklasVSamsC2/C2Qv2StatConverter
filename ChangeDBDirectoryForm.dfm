object ChangeDBDirectory: TChangeDBDirectory
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Change Directory'
  ClientHeight = 65
  ClientWidth = 210
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ConfirmButton: TButton
    Left = 8
    Top = 35
    Width = 75
    Height = 25
    Caption = 'Confirm'
    ModalResult = 1
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 127
    Top = 35
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object DirectoryPath: TEdit
    Left = 8
    Top = 8
    Width = 194
    Height = 21
    TabOrder = 2
    Text = 'New directory'
  end
end
