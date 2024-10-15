unit ChangeDBDirectoryForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TChangeDBDirectory = class(TForm)
    ConfirmButton: TButton;
    CancelButton: TButton;
    DirectoryPath: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChangeDBDirectory: TChangeDBDirectory;

implementation

{$R *.dfm}

procedure TChangeDBDirectory.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ConfirmButton.Click;
  end;

  if Key = VK_ESCAPE then
  begin
    CancelButton.Click;
  end;
end;

procedure TChangeDBDirectory.FormShow(Sender: TObject);
begin
  DirectoryPath.SetFocus();
end;

end.
