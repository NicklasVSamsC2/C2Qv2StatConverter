object ChangeDirBox: TChangeDirBox
  Left = 0
  Top = 0
  Caption = 'Change Directory'
  ClientHeight = 75
  ClientWidth = 200
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ConfirmButton: TButton
    Left = 3
    Top = 35
    Width = 75
    Height = 25
    Caption = 'Confirm'
    ModalResult = 1
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 117
    Top = 35
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 3
    Top = 8
    Width = 189
    Height = 21
    TabOrder = 2
    Text = 'New directory'
  end
end
