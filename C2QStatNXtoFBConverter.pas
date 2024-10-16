unit C2QStatNXtoFBConverter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, nxllComponent, nxdb, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Data.DB, nxsdServerEngine, nxseAllEngines, nxsrServerEngine, Vcl.StdCtrls, DateUtils,
  nxsrSqlEngineBase, nxsqlEngine, nxreRemoteServerEngine, nxllTransport,
  nxptBasePooledTransport, nxtwWinsockTransport, ChangeDBDirectoryForm;

type
  TMainForm = class(TForm)
    // Firebird component
    FirebirdConnection: TFDConnection;
    FirebirdTicketQuery: TFDQuery;

    // Nexus component
    nxSqlEngine1: TnxSqlEngine;
    nxSession1: TnxSession;
    NexusTransport: TnxWinsockTransport;
    NexusRemoteEngine: TnxRemoteServerEngine;
    NexusDatabase: TnxDatabase;
    NexusDepartmentInfoQuery: TnxQuery;
    NexusTicketMasterArchiveQuery: TnxQuery;

    // Button
    ConvertButton: TButton;
    ButtonFirebirdChangeDB: TButton;
    ButtonNexusChangeDB: TButton;

    // Dropdown
    DropDownYears: TComboBox;

    // Static text
    StaticText1: TStaticText;
    StaticText2: TStaticText;

    // Label
    FBDirLabel: TLabel;
    NXDirLabel: TLabel;

    // Edit box
    EditBoxIPAddress: TEdit;

    // Procedure declarations
    procedure FormCreate(Sender: TObject);
    procedure TransferTickets(NexusDBConnection: TnxDatabase; FirebirdConnection: TFDConnection);
    procedure ConvertButtonClick(Sender: TObject);
    procedure DropDownYearsChange(Sender: TObject);
    procedure ButtonFirebirdChangeDBClick(Sender: TObject);
    procedure ButtonNexusChangeDBClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  var
    YearCount: Integer;
    IPAddress: string;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.DropDownYearsChange(Sender: TObject);
begin
  YearCount := StrToInt(DropDownYears.Items[DropDownYears.ItemIndex]);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    // Add items to drop down box
    DropDownYears.Items.Add('1');
    DropDownYears.Items.Add('2');
    DropDownYears.Items.Add('3');
    DropDownYears.Items.Add('4');
    DropDownYears.Items.Add('5');
    DropDownYears.ItemIndex := 0;

    // Variables for the form
    YearCount := 1;
    IPAddress := '';

    // Label captions
    FBDirLabel.Caption := FirebirdConnection.Params.Values['Database'];
    NXDirLabel.Caption := NexusDatabase.AliasPath;
end;

// If RETURN is pressed, the ConvertButton click event will fire
procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ConvertButton.Click;
  end;
end;

// When the main form is loaded, focus the IP Address field
procedure TMainForm.FormShow(Sender: TObject);
begin
    EditBoxIpAddress.SetFocus();
end;

// Main functionality of the program
// Will pull out data from the Nexus Database and convert it to be inserted into the Firebird database
procedure TMainForm.TransferTickets(NexusDBConnection: TnxDatabase; FirebirdConnection: TFDConnection);
var
    QueueModelId: Integer;
    YearsAgo: TDate;
begin
  try
    // Calculate the date for X years ago
    YearsAgo := IncYear(Date, -YearCount);

    // Initialize NexusDB query to select data from TicketMasterArchive
    NexusTicketMasterArchiveQuery := TnxQuery.Create(nil);
    try
      NexusTicketMasterArchiveQuery.Database := NexusDBConnection;
      NexusTicketMasterArchiveQuery.SQL.Text := 'SELECT TicketNumber, TicketOut, TicketCall, TicketDone, DeptNumber, CashierNumber ' +
                             'FROM TicketMasterArchive ' +
                             'WHERE TicketOut >= :YearsAgo'; // Filter for tickets less than X year old
      NexusTicketMasterArchiveQuery.Params.ParamByName('YearsAgo').AsDateTime := YearsAgo;
      NexusTicketMasterArchiveQuery.Open;

      // Initialize Firebird query to insert data into C2QTicket table
      FirebirdTicketQuery := TFDQuery.Create(nil);
      try
        FirebirdTicketQuery.Connection := FirebirdConnection;

        // Insert new data into the database if the ticket doesn't already exist
        // This allows to add more years after first conversion and avoids duplicate entries
        FirebirdTicketQuery.SQL.Text := 'INSERT INTO C2QTicket (TicketNumber, PosNumber, TicketDrawn, TicketCalled, TicketFinished, DepartmentId, QueueModelId) ' +
                                'SELECT :TicketNumber, :PosNumber, :TicketDrawn, :TicketCalled, :TicketFinished, :DepartmentId, :QueueModelId ' +
                                'FROM RDB$DATABASE ' +
                                'WHERE NOT EXISTS (SELECT 1 FROM C2QTicket WHERE TicketNumber = :TicketNumber)';

        // Initialize Department query to map DeptText
        NexusDepartmentInfoQuery := TnxQuery.Create(nil);

        try
          NexusDepartmentInfoQuery.Database := NexusDBConnection;
          NexusDepartmentInfoQuery.SQL.Text := 'SELECT DeptText FROM DepartmentInfo WHERE DeptNumber = :DeptNumber';

          // Loop through each record in the NexusDB query
          while not NexusTicketMasterArchiveQuery.Eof do
          begin
            // Set the DeptNumber parameter for the department query
            NexusDepartmentInfoQuery.Params.ParamByName('DeptNumber').AsInteger := NexusTicketMasterArchiveQuery.FieldByName('DeptNumber').AsInteger;

            NexusDepartmentInfoQuery.Open;

            // Determine the QueueModelId based on DeptText
            // WARNING: This might fail if we encounter incorrect spelling.
            if not NexusDepartmentInfoQuery.IsEmpty then
            begin
              if NexusDepartmentInfoQuery.FieldByName('DeptText').AsString = 'Recept' then
                QueueModelId := 2
              else
                QueueModelId := 1; // Default value
            end
            else
              QueueModelId := 1; // Default if DeptNumber not found

            NexusDepartmentInfoQuery.Close;

            // Set Firebird query parameters
            FirebirdTicketQuery.Params.ParamByName('TicketNumber').AsInteger := NexusTicketMasterArchiveQuery.FieldByName('TicketNumber').AsInteger;
            FirebirdTicketQuery.Params.ParamByName('PosNumber').AsInteger := NexusTicketMasterArchiveQuery.FieldByName('CashierNumber').AsInteger;
            FirebirdTicketQuery.Params.ParamByName('TicketDrawn').AsDateTime := NexusTicketMasterArchiveQuery.FieldByName('TicketOut').AsDateTime;
            FirebirdTicketQuery.Params.ParamByName('TicketCalled').AsDateTime := NexusTicketMasterArchiveQuery.FieldByName('TicketCall').AsDateTime;
            FirebirdTicketQuery.Params.ParamByName('TicketFinished').AsDateTime := NexusTicketMasterArchiveQuery.FieldByName('TicketDone').AsDateTime;
            FirebirdTicketQuery.Params.ParamByName('DepartmentId').AsInteger := 999999999; // Default value for main department
            FirebirdTicketQuery.Params.ParamByName('QueueModelId').AsInteger := QueueModelId;

            // Execute the insert query
            FirebirdTicketQuery.ExecSQL;

            // Move to the next record in the NexusDB query
            NexusTicketMasterArchiveQuery.Next;
          end;

        finally
          NexusDepartmentInfoQuery.Free; // Free the department query
        end;

      finally
        FirebirdTicketQuery.Free; // Free the Firebird query
      end;

    finally
      NexusTicketMasterArchiveQuery.Free; // Free the NexusDB query
    end;

    ShowMessage('Data transfer on ' + IPAddress + ' completed.');
  except
    on E: Exception do
      ShowMessage('An error occurred: ' + E.Message);
  end;
end;

// Modal unit shown to change the directory where the database files are
// The default values should be sufficient, but this was implemented in case we ran into issues
procedure TMainForm.ButtonFirebirdChangeDBClick(Sender: TObject);
var
    ChangeForm: TChangeDBDirectory;
begin
  ChangeForm := TChangeDBDirectory.Create(Self);
  ChangeForm.DirectoryPath.Text := NXDirLabel.Caption;

  try
    // Show the form modally
    if ChangeForm.ShowModal = mrOk then
    begin
      // Map the new directory to the label and Firebird Connection
      FBDirLabel.Caption := ChangeForm.DirectoryPath.Text;
      FirebirdConnection.Params.Values['Database'] := ChangeForm.DirectoryPath.Text;
    end
  finally
    ChangeForm.Free;
  end;
  // Refocus the IP Address field
  EditBoxIpAddress.SetFocus();
end;

// See comments on above procedure (Yes, this should probably be refactored into one function)
procedure TMainForm.ButtonNexusChangeDBClick(Sender: TObject);
var
    ChangeForm: TChangeDBDirectory;
begin
  ChangeForm := TChangeDBDirectory.Create(Self);
  ChangeForm.DirectoryPath.Text := NXDirLabel.Caption;

  try
    if ChangeForm.ShowModal = mrOk then
    begin
      NXDirLabel.Caption := ChangeForm.DirectoryPath.Text;
      NexusDatabase.AliasPath := ChangeForm.DirectoryPath.Text;
    end
  finally
    ChangeForm.Free;
  end;
  EditBoxIpAddress.SetFocus();
end;

// Sets IP Address for server connections and runs the TransferTickets procedure
procedure TMainForm.ConvertButtonClick(Sender: TObject);
  begin
    IPAddress := EditBoxIPAddress.Text;
  
    if IPAddress <> '' then
        try
          NexusTransport.ServerName := IPAddress;
          FirebirdConnection.Params.Values['Server'] := IPAddress;
        finally
          TransferTickets(NexusDatabase, FirebirdConnection);
        end
    else
      ShowMessage('Connection to database could not be created.');  
  end;
end.
