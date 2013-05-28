unit UFrameMyComputer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzTabs,
  VirtualTrees, Vcl.ImgList;

type
  TFrameMyComputer = class(TFrame)
    plMain: TPanel;
    plLeft: TPanel;
    plCenter: TPanel;
    vstDriver: TVirtualStringTree;
    PcMain: TRzPageControl;
    Splitter1: TSplitter;
    il16: TImageList;
    procedure vstDriverGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstDriverGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstDriverMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    procedure IniFrame;
    procedure UniniFrame;
  end;

{$Region ' 硬盘 ' }

    // 数据结构
  TVstDriverData = record
  public
    DriverPath : WideString;
    DriverIcon : Integer;
  end;
  PVstDriverData = ^TVstDriverData;

    // 硬盘 操作
  VstDriverUtil = class
  public
    class procedure RefreshDriverList;
  private
    class function ReadDriverList : TStringList;
    class function GetDriveString(FDriveStrings: string;Index: Integer): string;
    class function ReadDriverExist( Path : string ): Boolean;
  end;

{$EndRegion}

{$Region ' 多个文件夹 ' }

  TPcExplorerData = class
  public
    Path : string;
  public
    constructor Create( _Path : string );
  end;

  TPageExplorerAddHandle = class
  private
    Path : string;
    PcMain : TRzPageControl;
  public
    constructor Create( _Path : string );
    procedure Update;
  private
    function ReadPageIndex : Integer;
    procedure AddPage;
  end;

    // 多页面操作
  PcExplorerUtil = class
  public
    class procedure AddPath( Path : string );
  end;

{$EndRegion}

var
  Frame_vstDriver : TVirtualStringTree;
  Frame_PcExplorer : TRzPageControl;

implementation

uses UMainForm;

{$R *.dfm}

{ TFrameMyComputer }

procedure TFrameMyComputer.IniFrame;
begin
  Frame_vstDriver := vstDriver;
  Frame_PcExplorer := PcMain;

  vstDriver.NodeDataSize := SizeOf( TVstDriverData );
  vstDriver.Images := MyIcon.getSysIcon32;
  VstDriverUtil.RefreshDriverList;
end;

procedure TFrameMyComputer.UniniFrame;
begin

end;

procedure TFrameMyComputer.vstDriverGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstDriverData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.DriverIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TFrameMyComputer.vstDriverGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstDriverData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.DriverPath
  else
    CellText := '';
end;

procedure TFrameMyComputer.vstDriverMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  SelectNode : PVirtualNode;
  NodeData : PVstDriverData;
begin
  SelectNode := vstDriver.GetNodeAt( x, y );
  if Assigned( SelectNode ) then
  begin
    NodeData := vstDriver.GetNodeData( SelectNode );
    PcExplorerUtil.AddPath( NodeData.DriverPath );
  end;
end;

{ MainFormUtil }

class function VstDriverUtil.GetDriveString(FDriveStrings: string;
  Index: Integer): string;
var
  Head, Tail: PChar;
begin
  Head := PChar(FDriveStrings);
  Result := '';
  repeat
    Tail := Head;
    while Tail^ <> #0 do
      Inc(Tail);
    if Index = 0 then
    begin
      SetString(Result, Head, Tail - Head);
      Break;
    end;
    Dec(Index);
    Head := Tail + 1;
  until Head^ = #0;
end;

class procedure VstDriverUtil.RefreshDriverList;
var
  vstDriver : TVirtualStringTree;
  DriverList : TStringList;
  DriverPath : string;
  DriverNode : PVirtualNode;
  NodeData : PVstDriverData;
  i: Integer;
begin
  vstDriver := Frame_vstDriver;
  vstDriver.Clear;

  DriverList := ReadDriverList;
  for i := 0 to DriverList.Count - 1 do
  begin
    DriverPath := DriverList[i];
    DriverNode := vstDriver.AddChild( vstDriver.RootNode );
    NodeData := vstDriver.GetNodeData( DriverNode );
    NodeData.DriverPath := DriverPath;
    NodeData.DriverIcon := MyIcon.getIconByFilePath( DriverPath );
  end;
  DriverList.Free;
end;

class function VstDriverUtil.ReadDriverExist(Path: string): Boolean;
var
  NotUsed, VolFlags: DWORD;
  Buf: array[0..MAX_PATH] of Char;
begin
  try
    Result := GetVolumeInformation(PChar(Path), Buf, sizeof(Buf), nil, NotUsed, VolFlags, nil, 0);
  except
    Result := False;
  end;
end;

class function VstDriverUtil.ReadDriverList: TStringList;
var
  i, Count, DriverCount: Integer;
  DriveMap, Mask: Cardinal;
  FDriveStrings: string;
  DriverPath : string;
begin
  Result := TStringList.Create;

  try
    // Fill root level of image tree. Determine which drives are mapped.
    DriverCount := 0;
    DriveMap := GetLogicalDrives;
    Mask := 1;
    for i := 0 to 25 do
    begin
      if (DriveMap and Mask) <> 0 then
        Inc(DriverCount);
      Mask := Mask shl 1;
    end;

      // Determine drive strings which are used in the initialization process.
    Count := GetLogicalDriveStrings(0, nil);
    SetLength(FDriveStrings, Count);
    GetLogicalDriveStrings(Count, PChar(FDriveStrings));

    for i := 0 to DriverCount - 1 do
    begin
      DriverPath := GetDriveString(FDriveStrings,i);
      if not ReadDriverExist( DriverPath ) then
        Continue;
      Result.Add( DriverPath );
    end;
  except
  end;
end;


{ PcExplorerUtil }

class procedure PcExplorerUtil.AddPath(Path: string);
var
  PageExplorerAddHandle : TPageExplorerAddHandle;
begin
  PageExplorerAddHandle := TPageExplorerAddHandle.Create( Path );
  PageExplorerAddHandle.Update;
  PageExplorerAddHandle.Free;
end;

{ TPageExplorerAddHandle }

procedure TPageExplorerAddHandle.AddPage;
var
  NewPage : TRzTabSheet;
begin
  NewPage := TRzTabSheet.Create( PcMain );
  NewPage.Parent := PcMain;
  NewPage.PageControl := PcMain;
  NewPage.Data := TPcExplorerData.Create( Path );
  NewPage.Caption := Path;
  NewPage.ImageIndex := 0;
  PcMain.ActivePage := NewPage;
end;

constructor TPageExplorerAddHandle.Create(_Path: string);
begin
  Path := _Path;
  PcMain := Frame_PcExplorer;
end;

function TPageExplorerAddHandle.ReadPageIndex: Integer;
var
  i : Integer;
  PageData : TPcExplorerData;
begin
  Result := -1;
  for i := 0 to PcMain.PageCount - 1 do
  begin
    PageData := PcMain.Pages[i].Data;
    if PageData.Path = Path then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TPageExplorerAddHandle.Update;
var
  PageIndex : Integer;
begin
  PageIndex := ReadPageIndex;
  if PageIndex >= 0 then
    PcMain.ActivePageIndex := PageIndex
  else
    AddPage;
end;

{ TPcExplorerData }

constructor TPcExplorerData.Create(_Path: string);
begin
  Path := _Path;
end;

end.
