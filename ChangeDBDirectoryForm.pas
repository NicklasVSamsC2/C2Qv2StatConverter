unit ChangeDBDirectoryForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TChangeDBDirectoryForm = class(TForm)
    ConfirmButton: TButton;
    CancelButton: TButton;
    Edit1: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChangeDir: TChangeDBDirectoryForm;

implementation

{$R *.dfm}

end.
