unit UFrameChildPicture;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, jpeg, GIFImg, pngimage,
  Winapi.GDIPOBJ, Winapi.GDIPAPI, Winapi.GDIPUTIL, ActiveX;

type
  TFrameChildPicture = class(TFrame)
    plPicture: TPanel;
    imgPreview: TImage;
  private
    { Private declarations }
  public
    procedure LoadPicture( PicturePath : string );
    procedure SetEnable( IsEnable : Boolean );
  end;

implementation

uses UFramePicturePreivew;

{$R *.dfm}

{ TFrameChildPicture }

procedure TFrameChildPicture.LoadPicture(PicturePath: string);
var
  Img : TImage;
  PreviewStream : TStream;
  GdiGraphics: TGPGraphics;
  GdiBrush : TGPSolidBrush;
  GdiStream : IStream;
  GdiImg : TGPImage;
  InpuParams : TInputParams;
  OutputParams : TOutputParams;
begin
    // ͼƬ
  Img := imgPreview;
  Img.Picture := nil;

    // ͼƬ��
  PreviewStream := MyPictureUtil.getPreviewStream( PicturePath, img.Height, img.Width );

    // ��ֽ
  GdiGraphics := TGPGraphics.Create( Img.Canvas.Handle );

    // ��䱳����ɫ
  GdiBrush := TGPSolidBrush.Create( MakeColor( 255, 255, 255 ) );
  GdiGraphics.FillRectangle( GdiBrush, 0, 0, Img.Width, Img.Height );
  GdiBrush.Free;

    // ����ͼƬ
  PreviewStream.Position := 0;
  GdiStream := TStreamAdapter.Create( PreviewStream );
  GdiImg := TGPImage.Create( GdiStream );

    // ��ͼƬ
  GdiGraphics.DrawImage( GdiImg, 0, 0, Img.Width, Img.Height );
  GdiImg.Free;

  GdiGraphics.Free;

  PreviewStream.Free;
end;

procedure TFrameChildPicture.SetEnable(IsEnable: Boolean);
begin
  if IsEnable then
    plPicture.BevelKind := bkTile
  else
    plPicture.BevelOuter := bvRaised;
end;

end.
