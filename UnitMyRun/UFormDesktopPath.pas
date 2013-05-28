unit UFormDesktopPath;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, VirtualTrees;

type
  TfrmDesktopPath = class(TForm)
    vstPath: TVirtualStringTree;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure vstPathGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstPathGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure vstPathChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstPathPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
  private
    { Private declarations }
  public
    function ReadImport( OldPathList : TStringList ): Boolean;
    function ReadPathList : TStringList;
  end;

    // 数据结构
  TVstDesktopPathData = record
  public
    FilePath : WideString;
    ShowName, ShowDir : WideString;
    ShowIcon : Integer;
  public
    IsSelectAll : Boolean;
  end;
  PVstDesktopPathData = ^TVstDesktopPathData;

var
  DesktopShow_All : string = '全部';
  DesktopShow_ImportCompleted : string = '路径已经全部导入';

var
  frmDesktopPath: TfrmDesktopPath;

implementation

uses UMyIcon, UMyUtil;

{$R *.dfm}

procedure TfrmDesktopPath.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmDesktopPath.btnOKClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

procedure TfrmDesktopPath.FormCreate(Sender: TObject);
begin
  vstPath.NodeDataSize := SizeOf( TVstDesktopPathData );
  vstPath.Images := MyIcon.getSysIcon;
end;

procedure TfrmDesktopPath.FormShow(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TfrmDesktopPath.ReadImport( OldPathList : TStringList ): Boolean;
var
  HasNewPath : Boolean;
  PathList : TStringList;
  i: Integer;
  FilePath, FileName, FileDIr : string;
  PathNode : PVirtualNode;
  NodeData : PVstDesktopPathData;
begin
  vstPath.Clear;

  HasNewPath := False;
  PathList := MyShellFile.ReadDesktopList;
  for i := 0 to PathList.Count - 1 do
  begin
    FilePath := PathList[i];
    if OldPathList.IndexOf( FilePath ) >= 0 then  // 路径已存在
      Continue;
    if OldPathList.IndexOf( MyFilePath.getLinkPath( FilePath ) ) >= 0 then  // 路径已存在
      Continue;
    FileName := MyFilePath.getName( FilePath );
    if FileName = FilePath then
      FileDIr := ''
    else
      FileDIr := ExtractFileDir( FilePath );
    PathNode := vstPath.AddChild( vstPath.RootNode );
    vstPath.CheckType[ PathNode ] := ctTriStateCheckBox;
    vstPath.CheckState[ PathNode ] := csCheckedNormal;
    NodeData := vstPath.GetNodeData( PathNode );
    NodeData.FilePath := FilePath;
    NodeData.ShowName := FileName;
    NodeData.ShowDir := FileDIr;
    NodeData.ShowIcon := MyIcon.getPathIcon( FilePath, FileExists( FilePath ) );
    NodeData.IsSelectAll := False;
    HasNewPath := True;
  end;
  if PathList.Count >= 5 then
  begin
    PathNode := vstPath.InsertNode( vstPath.RootNode, amAddChildFirst );
    vstPath.CheckType[ PathNode ] := ctTriStateCheckBox;
    vstPath.CheckState[ PathNode ] := csCheckedNormal;
    vstPath.NodeHeight[ PathNode ] := vstPath.NodeHeight[ PathNode ] + 5;
    NodeData := vstPath.GetNodeData( PathNode );
    NodeData.ShowName := DesktopShow_All;
    NodeData.ShowDir := '';
    NodeData.ShowIcon := -1;
    NodeData.IsSelectAll := True;
  end;
  PathList.Free;

    // 没有再多的路径
  if not HasNewPath then
  begin
    MyMessageForm.ShowInformation( DesktopShow_ImportCompleted );
    Result := False;
    Exit;
  end;

    // 等待用户选择
  Result := ShowModal = mrOk;
end;

function TfrmDesktopPath.ReadPathList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstDesktopPathData;
begin
  Result := TStringList.Create;
  SelectNode := vstPath.GetFirstChecked;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstPath.GetNodeData( SelectNode );
    if not NodeData.IsSelectAll then
      Result.Add( NodeData.FilePath );
    SelectNode := vstPath.GetNextChecked( SelectNode );
  end;
end;

procedure TfrmDesktopPath.vstPathChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  NodeData : PVstDesktopPathData;
  SelectNode : PVirtualNode;
  cs : TCheckState;
begin
  NodeData := Sender.GetNodeData( Node );
  if not NodeData.IsSelectAll then
    Exit;
  cs := Sender.CheckState[ Node ];
  SelectNode := Sender.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    Sender.CheckState[ SelectNode ] := cs;
    SelectNode := SelectNode.NextSibling;
  end;
end;

procedure TfrmDesktopPath.vstPathGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstDesktopPathData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TfrmDesktopPath.vstPathGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstDesktopPathData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.ShowName
  else
  if Column = 1 then
    CellText := NodeData.ShowDir;
end;

procedure TfrmDesktopPath.vstPathPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  NodeData : PVstDesktopPathData;
begin
  NodeData := Sender.GetNodeData( Node );
  if NodeData.IsSelectAll then
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
end;

end.
