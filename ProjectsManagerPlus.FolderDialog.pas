unit ProjectsManagerPlus.FolderDialog;

interface

uses
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls;

type
  TFolderSelectionDialog = class(TForm)
    lblFolder: TLabel;
    edtFolder: TEdit;
    btnBrowse: TButton;
    chkIncludeSubfolders: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnBrowseClick(Sender: TObject);
  private
    function _GetSelectedFolder: string;
    function _GetIncludeSubfolders: Boolean;
  public
    class function Execute(const AInitialDir: string; out AFolder: string; out AIncludeSubfolders: Boolean): Boolean;
    property SelectedFolder: string read _GetSelectedFolder;
    property IncludeSubfolders: Boolean read _GetIncludeSubfolders;
  end;

implementation

uses
  System.SysUtils,
  Vcl.FileCtrl;

{$R *.dfm}

class function TFolderSelectionDialog.Execute(const AInitialDir: string; out AFolder: string;
  out AIncludeSubfolders: Boolean): Boolean;
var
  LDialog: TFolderSelectionDialog;
begin
  Result := False;
  AFolder := '';
  AIncludeSubfolders := False;

  LDialog := TFolderSelectionDialog.Create(nil);
  try
    LDialog.edtFolder.Text := AInitialDir;
    if LDialog.ShowModal = mrOk then
    begin
      AFolder := LDialog.SelectedFolder;
      AIncludeSubfolders := LDialog.IncludeSubfolders;
      Result := True;
    end;
  finally
    LDialog.Free;
  end;
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
