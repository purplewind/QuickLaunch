unit UFormBatRun;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, VirtualTrees;

type
  TfrmBatRun = class(TForm)
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
  private
    { Private declarations }
  public
    procedure ClearList;
    procedure AddPath( Path : string );
  public
    function ReadRun: Boolean;
    function ReadPathList : TStringList;
  end;

    // 数据结构
  TVstBatRunData = record
  public
    FilePath : WideString;
    FileName, FileDir : WideString;
    ShowIcon : Integer;
  end;
  PVstInputPathData = ^TVstBatRunData;

var
  frmBatRun: TfrmBatRun;

implementation

uses UMyIcon, UMyUtil;

{$R *.dfm}

procedure TfrmBatRun.AddPath(Path: string);
var
  i: Integer;
  FolderName, FolderDir : string;
  PathNode : PVirtualNode;
  NodeData : PVstInputPathData;
begin
  FolderName := MyFilePath.getName( Path );
  if FolderName = Path then
    FolderDir := ''
  else
    FolderDir := ExtractFileDir( Path );
  PathNode := vstPath.AddChild( vstPath.RootNode );
  vstPath.CheckType[ PathNode ] := ctTriStateCheckBox;
  vstPath.CheckState[ PathNode ] := csCheckedNormal;
  NodeData := vstPath.GetNodeData( PathNode );
  NodeData.FilePath := Path;
  NodeData.FileName := FolderName;
  NodeData.FileDir := FolderDir;
  NodeData.ShowIcon := MyIcon.getPathIcon( Path, FileExists( Path ) );
end;

procedure TfrmBatRun.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmBatRun.btnOKClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

procedure TfrmBatRun.ClearList;
begin
  vstPath.Clear;
end;

procedure TfrmBatRun.FormCreate(Sender: TObject);
begin
  vstPath.NodeDataSize := SizeOf( TVstBatRunData );
  vstPath.Images := MyIcon.getSysIcon;
end;

procedure TfrmBatRun.FormShow(Sender: TObject);
begin
  ModalResult := mrCancel;
  try
    btnOK.SetFocus;
  except
  end;
end;

function TfrmBatRun.ReadRun: Boolean;
begin
  Result := ShowModal = mrOk;
end;

function TfrmBatRun.ReadPathList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstInputPathData;
begin
  Result := TStringList.Create;
  SelectNode := vstPath.GetFirstChecked;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstPath.GetNodeData( SelectNode );
    Result.Add( NodeData.FilePath );
    SelectNode := vstPath.GetNextChecked( SelectNode );
  end;
end;

procedure TfrmBatRun.vstPathGetImageIndex(Sender: TBaseVirtualTree;
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

procedure TfrmBatRun.vstPathGetText(Sender: TBaseVirtualTree;
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

end.
