unit UFramePicturePreivew;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, math, jpeg, GIFImg, pngimage,
  Winapi.GDIPOBJ, Winapi.GDIPAPI, Winapi.GDIPUTIL, ActiveX, Vcl.StdCtrls,
  Vcl.Buttons, VirtualTrees, IOUtils, Types;

type
  TFramePicturePreview = class(TFrame)
    plOtherPic: TPanel;
    plPicPreivew: TPanel;
    imgPreview: TImage;
    Button1: TButton;
    plRighttPicture: TPanel;
    vstPicture: TVirtualStringTree;
    spRightPicture: TSplitter;
    procedure Button1Click(Sender: TObject);
    procedure vstPictureGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstPictureGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstPictureFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
  private
    procedure ShowPicture( PicturePath : string );
    procedure ShowFolder( PicturePath : string );
  public
    procedure IniFrame;
    procedure LoadPicture( PicturePath : string );
    procedure UniFrame;
  end;

    // 数据结构
  TVstPictureData = record
  public
    FilePath : WideString;
  public
    ShowName : WideString;
    ShowIcon : Integer;
  end;
  PVstPictureData = ^TVstPictureData;

    // 输入参数
  TInputParams = record
  public
    SourceWidth, SourceHeigh : Integer;
    DesWidth, DesHeigh : Integer;
    IsKeepSpace : Boolean;
  end;

    // 输出参数
  TOutputParams = record
  public
    ShowX, ShowY : Integer;
    ShowWidth, ShowHeigh : Integer;
  end;

    // 图片辅助类
  MyPictureUtil = class
  public
    class function getClass( FilePath : string ): TGraphic;
    class function getIsPictureFile( FilePath : string ): Boolean;
    class procedure FindPreviewPoint( InpuParams : TInputParams; var OutputParams : TOutputParams );
    class function getPreviewStream( FilePath : string; PicHeight, PicWidth : Integer ): TMemoryStream;
  public
    class procedure LoadPicture( img : Timage; PicturePath : string ) ;
  end;

implementation

uses UMyUtil, UMyIcon;

{$R *.dfm}

{ MyPictureUtil }

class procedure MyPictureUtil.FindPreviewPoint(InpuParams: TInputParams;
  var OutputParams: TOutputParams);
var
  SourceWidth, SourceHeigh : Integer;
  DesWidth, DesHeigh : Integer;
  stw1, sth1, stw2, sth2 : Integer;
  ShowX, ShowY : Integer;
  ShowWidth, ShowHeigh : Integer;
  IsWidthStretch, IsHeighStretch : Boolean;
  IsShowWidthStretch, IsShowHeighStretch : Boolean;
  d0, dw, dh : Double;
  CutLength : Integer;
begin
  SourceWidth := InpuParams.SourceWidth;
  SourceHeigh := InpuParams.SourceHeigh;
  DesWidth := InpuParams.DesWidth;
  DesHeigh := InpuParams.DesHeigh;

    // 水平方向拉伸
  if SourceWidth > DesWidth then
  begin
    stw1 := DesWidth;
    sth1 := max( 1, ( SourceHeigh * DesWidth ) div SourceWidth );
  end
  else
  begin
    stw1 := SourceWidth;
    sth1 := SourceHeigh;
  end;
  IsWidthStretch := sth1 <= DesHeigh; // 水平方向拉伸是否成功

    // 垂直方向拉伸
  if SourceHeigh > DesHeigh then
  begin
    sth2 := DesHeigh;
    stw2 := max( 1, ( SourceWidth * DesHeigh ) div SourceHeigh );
  end
  else
  begin
    sth1 := SourceHeigh;
    stw1 := SourceWidth;
  end;
  IsHeighStretch := stw2 <= DesWidth; // 垂直方向拉伸是否成功

    // 水平成功，垂直不成功
  if IsWidthStretch and not IsHeighStretch then
    IsShowWidthStretch := True
  else   // 垂直成功，水平不成功
  if IsHeighStretch and not IsWidthStretch then
    IsShowWidthStretch := False
  else  // 两个都成功，选择比例更接近目标窗口的
  begin
    d0 := DesWidth div DesHeigh;
    dw := stw1 div sth1;
    dh := stw2 div sth2;

    dw := Abs( dw - d0 );
    dh := Abs( dh - d0 );

    IsShowWidthStretch := dw < dh;
  end;

    // 采用那种方式拉伸
  if IsShowWidthStretch then
  begin
    ShowWidth := stw1;
    ShowHeigh := sth1;
  end
  else
  begin
    ShowWidth := stw2;
    ShowHeigh := sth2;
  end;

    // 居中显示
  if DesWidth > ShowWidth then
    ShowX := ( DesWidth - ShowWidth ) div 2
  else
    ShowX := 0;
  if DesHeigh > ShowHeigh then
    ShowY := ( DesHeigh - ShowHeigh ) div 2
  else
    ShowY := 0;

    // 显示时留一点间距
  if InpuParams.IsKeepSpace then
  begin
    CutLength := 20 - ( DesWidth - ShowWidth );
    if CutLength > 0 then
    begin
      ShowWidth := ShowWidth - CutLength;
      ShowX := ShowX + ( CutLength div 2 );
    end;
    CutLength := 20 - ( DesHeigh - ShowHeigh );
    if CutLength > 0 then
    begin
      ShowHeigh := ShowHeigh - CutLength;
      ShowY := ShowY + ( CutLength div 2 );
    end;
  end;

    // 返回参数
  OutputParams.ShowX := ShowX;
  OutputParams.ShowY := ShowY;
  OutputParams.ShowWidth := ShowWidth;
  OutputParams.ShowHeigh := ShowHeigh;
end;


class function MyPictureUtil.getClass(FilePath: string): TGraphic;
var
  ExtName: string;
begin
  ExtName := MyFilePath.getExtName( FilePath );

  if ( ExtName = 'wmf' ) or ( ExtName = 'emf' ) then
    Result := TMetafile.Create
  else
  if ExtName = 'ico' then
    Result := TIcon.Create
  else
  if ( ExtName = 'tiff' ) or ( ExtName = 'tif' ) then
    Result := TWICImage.Create
  else
  if ExtName = 'png' then
    Result := TPngImage.Create
  else
  if ExtName = 'gif' then
    Result := TGIFImage.Create
  else
  if ( ExtName = 'jpeg' ) or ( ExtName = 'jpg' ) then
    Result := TJPEGImage.Create
  else
  if ExtName = 'bmp' then
    Result := TBitmap.Create
  else
    Result := nil;
end;

class function MyPictureUtil.getIsPictureFile(FilePath: string): Boolean;
var
  ExtName: string;
begin
  ExtName := MyFilePath.getExtName( FilePath );

  Result := ( ExtName = 'wmf' ) or ( ExtName = 'emf' ) or ( ExtName = 'ico' ) or
            ( ExtName = 'tiff' ) or ( ExtName = 'tif' ) or ( ExtName = 'png' ) or
            ( ExtName = 'jpeg' ) or ( ExtName = 'jpg' ) or ( ExtName = 'gif' ) or
            ( ExtName = 'bmp' );
end;

class function MyPictureUtil.getPreviewStream(FilePath: string;
  PicHeight, PicWidth : Integer): TMemoryStream;
var
  PreviewWidth, PreviewHeight : Integer;
  InpuParams : TInputParams;
  OutputParams : TOutputParams;
  Img, SmallImg : TGPImage;
  ms : TMemoryStream;
  Stream : IStream;
  ImgGUID :TGUID;
begin
  PreviewHeight := PicHeight;
  PreviewWidth := PicWidth;

  try
    Img := TGPImage.Create( FilePath );

    InpuParams.SourceWidth := Img.GetWidth;
    InpuParams.SourceHeigh := Img.GetHeight;
    InpuParams.DesWidth := PreviewWidth;
    InpuParams.DesHeigh := PreviewHeight;
    InpuParams.IsKeepSpace := False;
    MyPictureUtil.FindPreviewPoint( InpuParams, OutputParams );

    SmallImg := Img.GetThumbnailImage( OutputParams.ShowWidth, OutputParams.ShowHeigh );

    ms := TMemoryStream.Create;
    Stream := TStreamAdapter.Create( ms );
    GetEncoderClsid('image/jpeg', ImgGUID);
    SmallImg.Save( Stream, ImgGUID );
    SmallImg.Free;

    Img.Free;

    Result := ms;
  except
    Result := nil;
  end;
end;

class procedure MyPictureUtil.LoadPicture(img: Timage; PicturePath: string);
var
  PreviewStream : TStream;
  GdiGraphics: TGPGraphics;
  GdiBrush : TGPSolidBrush;
  GdiStream : IStream;
  GdiImg : TGPImage;
  InpuParams : TInputParams;
  OutputParams : TOutputParams;
begin
    // 图片
  Img.Picture := nil;

    // 图片流
  PreviewStream := MyPictureUtil.getPreviewStream( PicturePath, img.Height, img.Width );

    // 画纸
  GdiGraphics := TGPGraphics.Create( Img.Canvas.Handle );

    // 填充背景颜色
  GdiBrush := TGPSolidBrush.Create( MakeColor( 255, 255, 255 ) );
  GdiGraphics.FillRectangle( GdiBrush, 0, 0, Img.Width, Img.Height );
  GdiBrush.Free;

    // 创建图片
  PreviewStream.Position := 0;
  GdiStream := TStreamAdapter.Create( PreviewStream );
  GdiImg := TGPImage.Create( GdiStream );

    // 画图片
  InpuParams.SourceWidth := GdiImg.GetWidth;
  InpuParams.SourceHeigh := GdiImg.GetHeight;
  InpuParams.DesWidth := Img.Width;
  InpuParams.DesHeigh := Img.Height;
  InpuParams.IsKeepSpace := True;
  MyPictureUtil.FindPreviewPoint( InpuParams, OutputParams );
  GdiGraphics.DrawImage( GdiImg, OutputParams.ShowX, OutputParams.ShowY, OutputParams.ShowWidth, OutputParams.ShowHeigh );
  GdiImg.Free;

  GdiGraphics.Free;

  PreviewStream.Free;
end;

{ TFramePicturePreview }

procedure TFramePicturePreview.Button1Click(Sender: TObject);
begin
  IniFrame;
  LoadPicture( 'D:\杂项\新建文件夹\BackupCow_Web\备份\FolderTransfer\images1\ss\000_Backup_Network.PNG' );
end;

procedure TFramePicturePreview.IniFrame;
begin
  vstPicture.NodeDataSize := SizeOf( TVstPictureData );
  vstPicture.Images := MyIcon.getSysIcon;
end;

procedure TFramePicturePreview.LoadPicture(PicturePath: string);
begin
    // 加载目录
  ShowFolder( PicturePath );

    // 显示图片
  ShowPicture( PicturePath );
end;

procedure TFramePicturePreview.ShowFolder(PicturePath: string);
var
  FolderPath, FileName, FilePath : string;
  FileArray : TStringDynArray;
  i: Integer;
  PictureList : TStringList;
  NewNode, PictureNode : PVirtualNode;
  NodeData : PVstPictureData;
begin
  FolderPath := ExtractFileDir( PicturePath );
  FileName := ExtractFileName( PicturePath );

    // 添加目录其他文件
  PictureList := TStringList.Create;
  FileArray := TDirectory.GetFiles( FolderPath );
  for i := 0 to Length( FileArray ) - 1 do
    if MyPictureUtil.getIsPictureFile( FileArray[i] ) then
      PictureList.Add( ExtractFileName( FileArray[i] ) );
  if PictureList.Count > 1 then
  begin
    for i := 0 to PictureList.Count - 1 do
    begin
      NewNode := vstPicture.AddChild( vstPicture.RootNode );
      NodeData := vstPicture.GetNodeData( NewNode );
      FilePath := MyFilePath.getPath( FolderPath ) + PictureList[i];
      NodeData.FilePath := FilePath;
      NodeData.ShowName := ExtractFileName( FilePath );
      NodeData.ShowIcon := MyIcon.getFileIcon( FilePath );
      if FilePath = PicturePath then
        PictureNode := NewNode;
    end;
    if Assigned( PictureNode ) then
    begin
      vstPicture.FocusedNode := PictureNode;
      vstPicture.Selected[ PictureNode ] := True;
    end;
    plRighttPicture.Visible := True;
    spRightPicture.Left := 0;
    spRightPicture.Visible := True;
  end;
  PictureList.Free;
end;

procedure TFramePicturePreview.ShowPicture(PicturePath: string);
begin
  MyPictureUtil.LoadPicture( imgPreview, PicturePath );
end;

procedure TFramePicturePreview.UniFrame;
begin

end;

procedure TFramePicturePreview.vstPictureFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  NodeData : PVstPictureData;
begin
  if not Assigned( Node ) then
    Exit;
  NodeData := Sender.GetNodeData( Node );
  ShowPicture( NodeData.FilePath );
end;

procedure TFramePicturePreview.vstPictureGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstPictureData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TFramePicturePreview.vstPictureGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstPictureData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.ShowName;
end;

end.
