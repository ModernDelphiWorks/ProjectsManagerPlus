object FolderSelectionDialog: TFolderSelectionDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Select Folder'
  ClientHeight = 150
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 13
  object lblFolder: TLabel
    Left = 16
    Top = 16
    Width = 34
    Height = 13
    Caption = 'Folder:'
  end
  object edtFolder: TEdit
    Left = 16
    Top = 35
    Width = 345
    Height = 21
    TabOrder = 0
  end
  object btnBrowse: TButton
    Left = 367
    Top = 33
    Width = 75
    Height = 25
    Caption = 'Browse...'
    TabOrder = 1
    OnClick = btnBrowseClick
  end
  object chkIncludeSubfolders: TCheckBox
    Left = 16
    Top = 70
    Width = 150
    Height = 17
    Caption = 'Include subfolders'
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 286
    Top = 110
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 367
    Top = 110
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
