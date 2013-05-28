unit UFormImportPath;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, VirtualTrees;

type
  TfrmImportPath = class(TForm)
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
    function ReadImport: Boolean;
    function ReadPathList : TStringList;
  end;

    // 数据结构
  TVstInputPathData = record
  public
    FolderPath : WideString;
    FolderName, FolderDir : WideString;
    FolderIcon : Integer;
  end;
  PVstInputPathData = ^TVstInputPathData;

var
  frmImportPath: TfrmImportPath;

implementation

uses UMyIcon, UMyUtil;

{$R *.dfm}

procedure TfrmImportPath.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImportPath.btnOKClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

procedure TfrmImportPath.FormCreate(Sender: TObject);
begin
  vstPath.NodeDataSize := SizeOf( TVstInputPathData );
  vstPath.Images := MyIcon.getSysIcon;
end;

procedure TfrmImportPath.FormShow(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TfrmImportPath.ReadImport: Boolean;
var
  PathList : TStringList;
  i: Integer;
  FolderPath, FolderName, FolderDir : string;
  PathNode : PVirtualNode;
  NodeData : PVstInputPathData;
begin
  vstPath.Clear;

  PathList := MyShellFile.ReadOpenFolderList;
  for i := 0 to PathList.Count - 1 do
  begin
    FolderPath := PathList[i];
    FolderName := MyFilePath.getName( FolderPath );
    if FolderName = FolderPath then
      FolderDir := ''
    else
      FolderDir := ExtractFileDir( FolderPath );
    PathNode := vstPath.AddChild( vstPath.RootNode );
    vstPath.CheckType[ PathNode ] := ctTriStateCheckBox;
    vstPath.CheckState[ PathNode ] := csCheckedNormal;
    NodeData := vstPath.GetNodeData( PathNode );
    NodeData.FolderPath := FolderPath;
    NodeData.FolderName := FolderName;
    NodeData.FolderDir := FolderDir;
    NodeData.FolderIcon := MyIcon.getFolderIcon( FolderPath );
  end;
  PathList.Free;

  Result := ShowModal = mrOk;
end;

function TfrmImportPath.ReadPathList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstInputPathData;
begin
  Result := TStringList.Create;
  SelectNode := vstPath.GetFirstChecked;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstPath.GetNodeData( SelectNode );
    Result.Add( NodeData.FolderPath );
    SelectNode := vstPath.GetNextChecked( SelectNode );
  end;
end;

procedure TfrmImportPath.vstPathGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstInputPathData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.FolderIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TfrmImportPath.vstPathGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstInputPathData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.FolderName
  else
  if Column = 1 then
    CellText := NodeData.FolderDir;
end;

end.
