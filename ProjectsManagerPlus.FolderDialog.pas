unit ProjectsManagerPlus.FolderDialog;

interface

uses
  Winapi.Windows, 
  Winapi.Messages, 
  System.SysUtils, 
  System.Variants, 
  System.Classes,
  Vcl.Graphics, 
  Vcl.Controls, 
  Vcl.Forms, 
  Vcl.Dialogs,
  Vcl.StdCtrls, 
  Vcl.FileCtrl,
  Vcl.ExtCtrls;

type
  TFolderSelectionDialog = class(TForm)
    lblFolder: TLabel;
    edtFolder: TEdit;
    btnBrowse: TButton;
    chkIncludeSubfolders: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function _GetSelectedFolder: string;
    function _GetIncludeSubfolders: Boolean;
  public
    property SelectedFolder: string read _GetSelectedFolder;
    property IncludeSubfolders: Boolean read _GetIncludeSubfolders;
    class function Execute(const AInitialDir: string; out AFolder: string; out AIncludeSubfolders: Boolean): Boolean;
  end;

implementation

{$R *.dfm}

class function TFolderSelectionDialog.Execute(const AInitialDir: string; out AFolder: string; out AIncludeSubfolders: Boolean): Boolean;
var
  LDialog: TFolderSelectionDialog;
begin
  Result := False;
  AFolder := '';
  AIncludeSubfolders := False;

  LDialog := TFolderSelectionDialog.Create(nil);
  try
    LDialog.edtFolder.Text := AInitialDir;
    if LDialog.ShowModal = mrOK then
    begin
      AFolder := LDialog.SelectedFolder;
      AIncludeSubfolders := LDialog.IncludeSubfolders;
      Result := True;
    end;
  finally
    LDialog.Free;
  end;
end;

procedure TFolderSelectionDialog.FormCreate(Sender: TObject);
begin
  Caption := 'Select Folder to Add';
  Position := poScreenCenter;
  BorderStyle := bsDialog;
  Width := 450;
  Height := 180;
end;

procedure TFolderSelectionDialog.btnBrowseClick(Sender: TObject);
var
  LFolder: string;
begin
  LFolder := edtFolder.Text;
  if SelectDirectory('Select folder to add units:', '', LFolder) then
    edtFolder.Text := LFolder;
end;

function TFolderSelectionDialog._GetSelectedFolder: string;
begin
  Result := Trim(edtFolder.Text);
end;

function TFolderSelectionDialog._GetIncludeSubfolders: Boolean;
begin
  Result := chkIncludeSubfolders.Checked;
end;

end.