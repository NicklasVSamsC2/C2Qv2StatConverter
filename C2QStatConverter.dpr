program C2QStatConverter;

uses
  Vcl.Forms,
  C2QStatNXtoFBConverter in 'C2QStatNXtoFBConverter.pas' {MainForm},
  ChangeDBDirectoryForm in 'ChangeDBDirectoryForm.pas' {ChangeDBDirectory};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TChangeDBDirectory, ChangeDBDirectory);
  Application.Run;
end.
