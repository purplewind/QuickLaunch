unit UFormFix;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.ComCtrls;

type
  TfrmFix = class(TForm)
    Image1: TImage;
    tmrIng: TTimer;
    procedure tmrIngTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  end;

var
  FixShow_Title : string = 'Repairing';
  FixShow_Error : string = 'Failure to repair,Please install the programme again';

var
  frmFix: TfrmFix;

implementation

uses UMainForm, UMultiLanguage;

{$R *.dfm}

procedure TfrmFix.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tmrIng.Enabled := False;
end;

procedure TfrmFix.FormCreate(Sender: TObject);
var
  ShowStr : string;
begin
  LanguageUtil.StartLoad;
  ShowStr := FixFormLanguage.getTitle;
  if ShowStr <> '' then
    FixShow_Title := ShowStr;
  ShowStr := FixFormLanguage.getErrorStr;
  if ShowStr <> '' then
    FixShow_Error := ShowStr;
  LanguageUtil.StopLoad;
end;

procedure TfrmFix.FormShow(Sender: TObject);
begin
  tmrIng.Enabled := True;
end;

procedure TfrmFix.tmrIngTimer(Sender: TObject);
var
  ShowStr : string;
  i: Integer;
begin
  tmrIng.Tag := tmrIng.Tag + 1;
  if tmrIng.Tag > 3 then
    tmrIng.Tag := 0;
  ShowStr := FixShow_Title;
  for i := 0 to tmrIng.Tag - 1 do
    ShowStr := ShowStr + '.';
  Caption := ShowStr;
end;

end.
