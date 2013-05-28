unit UFormPreview;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TfrmPreview = class(TForm)
    ilPreview: TImage;
  private
    { Private declarations }
  public
    procedure ShowPicture( PicturePath : string );
    procedure ClosePicture;
  end;

var
  frmPreview: TfrmPreview;

implementation

uses UMyUtil;

{$R *.dfm}

{ TfrmPreview }

procedure TfrmPreview.ClosePicture;
begin
  ilPreview.Picture := nil;
  Close;
end;

procedure TfrmPreview.ShowPicture(PicturePath: string);
begin
  MyPriviewUtil.SetPicture( ilPreview, PicturePath );
end;

end.
