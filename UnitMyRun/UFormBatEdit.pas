unit UFormBatEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, VirtualTrees,
  Vcl.Buttons, shellapi;

type
  TfrmBatEdit = class(TForm)
    vstPath: TVirtualStringTree;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Panel2: TPanel;
    edtPath: TEdit;
    Label1: TLabel;
    sbAdd: TSpeedButton;
    plDelete: TPanel;
    sbDelete: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure vstPathGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstPathGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbAddClick(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
    procedure vstPathChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    procedure DropFiles(var Msg: TMessage); message WM_DROPFILES;
  public
    function ReadEdit: Boolean;
    function ReadPathList : TStringList;
  public
    procedure ClearList;
    procedure AddPath( Path : string );
  end;

    // 数据结构
  TVstBatEditPathData = record
  public
    FilePath : WideString;
    FileName, FileDir : WideString;
    ShowIcon : Integer;
  end;
  PVstInputPathData = ^TVstBatEditPathData;

      // 拖动文件
  TDropBatFilesHandle = class
  public
    Msg: TMessage;
    FileList : TStringList;
  public
    constructor Create( _Msg: TMessage );
    procedure Update;
    destructor Destroy; override;
  end;

var
  frmBatEdit: TfrmBatEdit;

implementation

uses UMyIcon, UMyUtil;

{$R *.dfm}

procedure TfrmBatEdit.AddPath(Path: string);
var
  i: Integer;
  FolderName, FolderDir : string;
  PathNode : PVirtualNode;
  NodeData : PVstInputPathData;
begin
  if vstPath.RootNodeCount >= 5 then
  begin
    ShowMessage( '最多同时运行5个程序' );
    Exit;
  end;

  FolderName := MyFilePath.getName( Path );
  if FolderName = Path then
    FolderDir := ''
  else
    FolderDir := ExtractFileDir( Path );
  PathNode := vstPath.AddChild( vstPath.RootNode );
  NodeData := vstPath.GetNodeData( PathNode );
  NodeData.FilePath := Path;
  NodeData.FileName := FolderName;
  NodeData.FileDir := FolderDir;
  NodeData.ShowIcon := MyIcon.getPathIcon( Path, FileExists( Path ) );
end;

procedure TfrmBatEdit.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmBatEdit.btnOKClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

procedure TfrmBatEdit.ClearList;
begin
  vstPath.Clear;
end;

procedure TfrmBatEdit.DropFiles(var Msg: TMessage);
var
  DropBatFilesHandle : TDropBatFilesHandle;
begin
  DropBatFilesHandle := TDropBatFilesHandle.Create( Msg );
  DropBatFilesHandle.Update;
  DropBatFilesHandle.Free;
end;

procedure TfrmBatEdit.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, True);  // 设置需要处理文件 WM_DROPFILES 拖放消息

  vstPath.NodeDataSize := SizeOf( TVstBatEditPathData );
  vstPath.Images := MyIcon.getSysIcon;
end;

procedure TfrmBatEdit.FormShow(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TfrmBatEdit.ReadEdit: Boolean;
begin
  Result := ShowModal = mrOk;
end;

function TfrmBatEdit.ReadPathList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstInputPathData;
begin
  Result := TStringList.Create;
  SelectNode := vstPath.GetFirst;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstPath.GetNodeData( SelectNode );
    Result.Add( NodeData.FilePath );
    SelectNode := vstPath.GetNext( SelectNode );
  end;
end;

procedure TfrmBatEdit.sbAddClick(Sender: TObject);
var
  Path : string;
begin
  Path := edtPath.Text;
  if FileExists( Path ) or DirectoryExists( Path  ) then
    AddPath( Path )
  else
    ShowMessage( '路径不存在' );
end;

procedure TfrmBatEdit.sbDeleteClick(Sender: TObject);
begin
  vstPath.DeleteSelectedNodes;
end;

procedure TfrmBatEdit.vstPathChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  plDelete.Visible := Sender.SelectedCount > 0;
end;

procedure TfrmBatEdit.vstPathGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstInputPathData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TfrmBatEdit.vstPathGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstInputPathData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.FileName
  else
  if Column = 1 then
    CellText := NodeData.FileDir;
end;

{ TDropBatFilesHandle }

constructor TDropBatFilesHandle.Create(_Msg: TMessage);
var
  FilesCount: Integer; // 文件总数
  i: Integer;
  FileName: array [0 .. 255] of Char;
  FilePath: string;
begin
  Msg := _Msg;
  FileList := TStringList.Create;

  // 获取文件总数
  FilesCount := DragQueryFile(Msg.WParam, $FFFFFFFF, nil, 0);
  try
    // 获取文件名
    for i := 0 to FilesCount - 1 do
    begin
      DragQueryFile(Msg.WParam, i, FileName, 256);
      FilePath := FileName;
      FileList.Add(FilePath);
    end;
  except
  end;
  DragFinish(Msg.WParam); // 释放
end;

destructor TDropBatFilesHandle.Destroy;
begin
  FileList.Free;
  inherited;
end;

procedure TDropBatFilesHandle.Update;
var
  i: Integer;
begin
  for i := 0 to FileList.Count - 1 do
    frmBatEdit.AddPath( FileList[i] );
end;

end.
