unit UFormDestination;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ComCtrls, RzTreeVw,
  RzShellCtrls, Vcl.ExtCtrls, RzListVw, Vcl.StdCtrls, Generics.Collections, IOUtils,
  Vcl.Menus, IniFiles, Vcl.ImgList;

type

    // 窗口信息
  TfrmDestination = class(TForm)
    plMain: TPanel;
    plLeft: TPanel;
    vstHistory: TVirtualStringTree;
    slMain: TSplitter;
    Splitter2: TSplitter;
    plBottom: TPanel;
    vstDriver: TVirtualStringTree;
    plCenter: TPanel;
    Panel2: TPanel;
    vstFileList: TVirtualStringTree;
    plButtonLeft: TPanel;
    plButtonCenter: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    edtPath: TButtonedEdit;
    il16: TImageList;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vstDriverGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstDriverGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstHistoryGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstHistoryGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure FormDestroy(Sender: TObject);
    procedure vstDriverInitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vstFileListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstFileListGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstFileListPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure vstHistoryMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vstFileListChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure vstFileListDblClick(Sender: TObject);
    procedure vstFileListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vstDriverFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure vstHistoryFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
  public
    PlLeftWidth : Integer;
    procedure SaveIni;
    procedure LoadIni;
  private
    procedure IniForm;
    procedure UniniForm;
  public       // 入口信息
    InputPathList : TStringList;
    function ReadDesPath : string;
    function ReadInputAcion( FilePath : string ): string;
  end;

{$Region ' 界面数据 ' }

    // 磁盘 数据
  TVstDesDriverData = record
  public
    FolderPath : WideString;
  public
    ShowName : WideString;
    ShowIcon : Integer;
  end;
  PVstDesDriverData = ^TVstDesDriverData;

    // 历史 数据
  TVstDesHistoryFolderData = record
  public
    FolderPath : WideString;
  public
    ShowName, ShowDir : WideString;
    ShowIcon : Integer;
  end;
  PVstDesHistoryFolderData = ^TVstDesHistoryFolderData;

    // 文件列表 数据
  TVstDesFileListData = record
  public
    FilePath : WideString;
    IsFolder : Boolean;
    IsAdd : Boolean;
    ActionType : WideString;
  public
    ShowName, ActionName : WideString;
    ShowIcon, ActionIcon : Integer;
  end;
  PVstDesFileListData = ^TVstDesFileListData;

{$EndRegion}

{$Region ' 界面接口 ' }

    // 窗口 接口
  TFaceDesFormApi = class
  private
    InputPathList : TStringList;
  public
    constructor Create;
  public
    procedure ClearInputs;
    procedure AddInput( Path : string );
    function ReadInputExistName( FileName : string ): string;
  public
    procedure SetActionType( ActionType : string );
    procedure ShowDesPath( Path : string );
  end;

    // 磁盘 接口
  TFaceDesDriverApi = class
  private
    vstDriver : TVirtualStringTree;
  public
    constructor Create;
  public
    procedure ClearDrivers;
    procedure AddDriver( ParentPath, Path : string; HasChild : Boolean );overload;
    procedure AddDriver( ParentPath, Path, ShowName : string; HasChild : Boolean );overload;
    procedure ExpandDriver( Path : string );
  private
    function ReadNode( Path : string ): PVirtualNode;
  end;

    // 历史 接口
  TFaceDesHistoryFolderApi = class
  private
    vstHistory : TVirtualStringTree;
  public
    constructor Create;
  public
    procedure ClearHistorys;
    procedure AddHistory( Path : string );
  end;

    // 文件列表接口
  TFaceDesFileListApi = class
  private
    vstFileList : TVirtualStringTree;
  public
    constructor Create;
  public
    procedure ClearFileList;
    procedure AddFile( FilePath : string; IsFolder, IsAdd : Boolean );
  public
    procedure SetFileConfliect( FilePath : string );
    function ReadFileAction( FilePath : string ): string;
  private
    function ReadNode( FilePath : string ): PVirtualNode;
    function ReadAcionName( FileAction : string ): string;
    function ReadActionIcon( FileAction : string ): Integer;
    procedure AddChildAction( SelectNode : PVirtualNode; FileAction : string );
  end;

{$EndRegion}

{$Region ' 用户接口 ' }

    // 窗口 接口
  UserFormDesPathApi = class
  public
    class procedure HideFileList;
    class procedure ShowFileList;
  end;

    // 文件列表 接口
  UserDesFileListApi = class
  public
    class procedure EnterFolder( Path : string );
    class procedure AddFile( FilePath : string; IsFolder : Boolean );
  end;

{$EndRegion}

var
  TitleShow_Copy : string = '复制到...';
  TitleShow_Move : string = '移动到...';

var
  ActionShowItem_Paste : string = '粘贴';
  ActionShowItem_Confliect : string = '文件冲突';

  ActionShowItem_Replace : string = '复制和替换：替换目标文件夹的文件';
  ActionShowItem_Rename : string = '重命名：正在复制的文件将重命名';
  ActionShowItem_Cancel : string = '取消：将不会更改任何文件';

const
  Ini_DesForm = 'DesForm';
  Ini_DesFormWidth = 'DesFormWidth';
  Ini_DesFormHeigh = 'DesFormHeigh';
  Ini_DesFormLeftWidth = 'DesFormLeftWidth';
  Ini_DesFormBottomHeigh = 'DesFormBottomHeigh';

const
  ActionType_Copy = 'Copy';
  ActionType_Move = 'Move';

const
  FileAction_Paste = 'Paste';
  FileAction_Replace = 'Replace';
  FileAction_Rename = 'Rename';
  FileAction_Cancel = 'Cancel';

var
  FaceDesFormApi : TFaceDesFormApi;
  FaceDesDriverApi : TFaceDesDriverApi;
  FaceDesHistoryFolderApi : TFaceDesHistoryFolderApi;
  FaceDesFileListApi : TFaceDesFileListApi;


var
  frmDestination: TfrmDestination;

implementation

uses UMyIcon, UMyUtil, UMyFaceThread;

{$R *.dfm}

procedure TfrmDestination.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmDestination.btnOKClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

procedure TfrmDestination.FormCreate(Sender: TObject);
begin
  IniForm;
end;

procedure TfrmDestination.FormDestroy(Sender: TObject);
begin
  UniniForm;
end;

procedure TfrmDestination.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ( ssCtrl in Shift ) and ( Key = Integer( 'V' ) ) and btnOK.Enabled then
    btnOK.Click;
end;

procedure TfrmDestination.FormResize(Sender: TObject);
begin
  plButtonLeft.Width := ( plBottom.Width - plButtonCenter.Width ) div 2;
end;

procedure TfrmDestination.FormShow(Sender: TObject);
begin
  ModalResult := mrCancel;
  UserFormDesPathApi.HideFileList;
end;

procedure TfrmDestination.IniForm;
begin
  InputPathList := TStringList.Create;

  FaceDesFormApi := TFaceDesFormApi.Create;
  FaceDesDriverApi := TFaceDesDriverApi.Create;
  FaceDesHistoryFolderApi := TFaceDesHistoryFolderApi.Create;
  FaceDesFileListApi := TFaceDesFileListApi.Create;

  LoadIni;
end;

procedure TfrmDestination.LoadIni;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create( MyAppData.getConfigPath );
  try
    Self.Width := IniFile.ReadInteger( Ini_DesForm, Ini_DesFormWidth, Self.Width );
    Self.Height := IniFile.ReadInteger( Ini_DesForm, Ini_DesFormHeigh, Self.Height );
    plLeft.Width := IniFile.ReadInteger( Ini_DesForm, Ini_DesFormLeftWidth, plLeft.Width );
    vstHistory.Height := IniFile.ReadInteger( Ini_DesForm, Ini_DesFormBottomHeigh, vstHistory.Height );
  except
  end;
  IniFile.Free;
end;

function TfrmDestination.ReadDesPath: string;
begin
  Result := '';
  if ShowModal <> mrOk then
    Exit;
  Result := edtPath.Text;
end;

function TfrmDestination.ReadInputAcion(FilePath: string): string;
begin
  Result := FaceDesFileListApi.ReadFileAction( FilePath );
end;

procedure TfrmDestination.SaveIni;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create( MyAppData.getConfigPath );
  try
    IniFile.WriteInteger( Ini_DesForm, Ini_DesFormWidth, Self.Width );
    IniFile.WriteInteger( Ini_DesForm, Ini_DesFormHeigh, Self.Height );
    IniFile.WriteInteger( Ini_DesForm, Ini_DesFormLeftWidth, plLeft.Width );
    IniFile.WriteInteger( Ini_DesForm, Ini_DesFormBottomHeigh, vstHistory.Height );
  except
  end;
  IniFile.Free;
end;

procedure TfrmDestination.UniniForm;
begin
  SaveIni;

  FaceDesFileListApi.Free;
  FaceDesHistoryFolderApi.Free;
  FaceDesDriverApi.Free;
  FaceDesFormApi.Free;

  InputPathList.Free;
end;

procedure TfrmDestination.vstFileListChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  NodeData, ParentData : PVstDesFileListData;
begin
  if Assigned( Node ) and Assigned( Node.Parent ) and ( Node.Parent <> Sender.RootNode ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ParentData := Sender.GetNodeData( Node.Parent );
    ParentData.ActionType := NodeData.ActionType;
  end;
end;

procedure TfrmDestination.vstFileListDblClick(Sender: TObject);
var
  NodeData : PVstDesFileListData;
begin
  if not Assigned( vstFileList.FocusedNode ) then
    Exit;
  NodeData := vstFileList.GetNodeData( vstFileList.FocusedNode );
  if NodeData.IsFolder and not NodeData.IsAdd then
    UserDesFileListApi.EnterFolder( NodeData.FilePath );
end;

procedure TfrmDestination.vstFileListGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstDesFileListData;
begin
  if (Kind = ikNormal) or (Kind = ikSelected) then
  begin
    NodeData := Sender.GetNodeData( Node );
    if Column = 0 then
      ImageIndex := NodeData.ShowIcon
    else
    if Column = 1 then
      ImageIndex := NodeData.ActionIcon
    else
      ImageIndex := -1;
  end
  else
    ImageIndex := -1;
end;

procedure TfrmDestination.vstFileListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstDesFileListData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.ShowName
  else
  if Column = 1 then
    CellText := NodeData.ActionName
  else
    CellText := '';
end;

procedure TfrmDestination.vstFileListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Path : string;
begin
  if Button <> mbRight then
    Exit;

  Path := edtPath.Text;
  if MyFilePath.getIsRoot( Path ) then
    Exit;
  Path := ExtractFileDir( Path );
  UserDesFileListApi.EnterFolder( Path );
end;

procedure TfrmDestination.vstFileListPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  NodeData : PVstDesFileListData;
begin
  NodeData := Sender.GetNodeData( Node );
  if NodeData.IsAdd then
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
end;

procedure TfrmDestination.vstDriverFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  NodeData : PVstDesDriverData;
begin
  if not Assigned( Node ) then
    Exit;
  NodeData := Sender.GetNodeData( Node );
  UserDesFileListApi.EnterFolder( NodeData.FolderPath );
end;

procedure TfrmDestination.vstDriverGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstDesDriverData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TfrmDestination.vstDriverGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstDesDriverData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.ShowName
  else
    CellText := '';
end;

procedure TfrmDestination.vstDriverInitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);
var
  NodeData : PVstDesDriverData;
begin
  NodeData := Sender.GetNodeData( Node );
  MyFaceJobHandler.ExpandDesDriver( NodeData.FolderPath );
end;

procedure TfrmDestination.vstHistoryFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  NodeData : PVstDesHistoryFolderData;
begin
  if not Assigned( Node ) then
    Exit;
  NodeData := Sender.GetNodeData( Node );
  UserDesFileListApi.EnterFolder( NodeData.FolderPath );
end;

procedure TfrmDestination.vstHistoryGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstDesHistoryFolderData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TfrmDestination.vstHistoryGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstDesHistoryFolderData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.ShowName
  else
  if Column = 1 then
    CellText := NodeData.ShowDir
  else
    CellText := '';
end;

procedure TfrmDestination.vstHistoryMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;

{ TFaceDesDriverApi }

procedure TFaceDesDriverApi.AddDriver(ParentPath,Path: string; HasChild : Boolean);
begin
  AddDriver( ParentPath, Path, MyFilePath.getName( Path ), HasChild );
end;

procedure TFaceDesDriverApi.AddDriver(ParentPath, Path, ShowName: string;
  HasChild: Boolean);
var
  ParentNode, DriverNode : PVirtualNode;
  NodeData : PVstDesDriverData;
begin
    // 父节点
  if ParentPath = '' then
    ParentNode := vstDriver.RootNode
  else
  begin
    ParentNode := ReadNode( ParentPath );
    if not Assigned( ParentNode ) then
      ParentNode := vstDriver.RootNode;
  end;

    // 创建节点
  DriverNode := vstDriver.AddChild( ParentNode );
  vstDriver.HasChildren[ DriverNode ] := HasChild;

    // 初始化节点数据
  NodeData := vstDriver.GetNodeData( DriverNode );
  NodeData.FolderPath := Path;
  NodeData.ShowName := ShowName;
  NodeData.ShowIcon := MyIcon.getFolderIcon( Path );
end;

procedure TFaceDesDriverApi.ClearDrivers;
begin
  vstDriver.Clear;
end;

constructor TFaceDesDriverApi.Create;
begin
  vstDriver := frmDestination.vstDriver;
  vstDriver.NodeDataSize := SizeOf( TVstDesDriverData );
  vstDriver.Images := MyIcon.getSysIcon;
end;

procedure TFaceDesDriverApi.ExpandDriver(Path: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadNode( Path );
  if not Assigned( SelectNode ) then
    Exit;
  vstDriver.Expanded[ SelectNode ] := True;
end;

function TFaceDesDriverApi.ReadNode(Path: string): PVirtualNode;
var
  SelectNode : PVirtualNode;
  NodeData : PVstDesDriverData;
begin
  Result := nil;

  SelectNode := vstDriver.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstDriver.GetNodeData( SelectNode );
    if NodeData.FolderPath = Path then
    begin
      Result := SelectNode;
      Break;
    end
    else
    if Pos( String( NodeData.FolderPath ), Path ) > 0 then
      SelectNode := SelectNode.FirstChild
    else
      SelectNode := SelectNode.NextSibling;
  end;
end;

{ TFaceDesHistoryFolderApi }

procedure TFaceDesHistoryFolderApi.AddHistory(Path: string);
var
  HistoryNode : PVirtualNode;
  NodeData : PVstDesHistoryFolderData;
begin
  HistoryNode := vstHistory.AddChild( vstHistory.RootNode );
  NodeData := vstHistory.GetNodeData( HistoryNode );
  NodeData.FolderPath := Path;
  NodeData.ShowName := MyFilePath.getName( Path );
  NodeData.ShowIcon := MyIcon.getFolderIcon( Path );
  NodeData.ShowDir := ExtractFileDir( Path );
  if NodeData.ShowDir = NodeData.ShowName then
    NodeData.ShowDir := '';
end;

procedure TFaceDesHistoryFolderApi.ClearHistorys;
begin
  vstHistory.Clear;
end;

constructor TFaceDesHistoryFolderApi.Create;
begin
  vstHistory := frmDestination.vstHistory;
  vstHistory.NodeDataSize := SizeOf( TVstDesHistoryFolderData );
  vstHistory.Images := MyIcon.getSysIcon;
end;

{ TFaceDesFormApi }

procedure TFaceDesFormApi.AddInput(Path: string);
begin
  InputPathList.Add( Path );
end;

procedure TFaceDesFormApi.ClearInputs;
begin
  InputPathList.Clear;
end;

constructor TFaceDesFormApi.Create;
begin
  InputPathList := frmDestination.InputPathList;
end;

function TFaceDesFormApi.ReadInputExistName(FileName : string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to InputPathList.Count - 1 do
    if MyFilePath.getName( InputPathList[i] ) = FileName then
    begin
      Result := InputPathList[i];
      Break;
    end;
end;

procedure TFaceDesFormApi.SetActionType(ActionType: string);
var
  FrmIcon : Integer;
begin
  if ActionType = ActionType_Copy then
    frmDestination.Caption := TitleShow_Copy
  else
  if ActionType = ActionType_Move then
    frmDestination.Caption := TitleShow_Move;
end;

procedure TFaceDesFormApi.ShowDesPath(Path: string);
begin
  frmDestination.edtPath.Text := Path;
end;

{ UserFormDesPathApi }

class procedure UserFormDesPathApi.HideFileList;
begin
    // 已隐藏
  if frmDestination.plLeft.Align = alClient then
    Exit;

  with frmDestination do
  begin
    PlLeftWidth := plLeft.Width;

    btnOK.Enabled := False;
    plCenter.Align := alRight;
    plCenter.Visible := False;
    slMain.Visible := False;
    plLeft.Align := alClient;

    vstHistory.Header.Columns[1].Options := vstHistory.Header.Columns[1].Options + [coVisible];
    vstHistory.Header.AutoSizeIndex := 1;
    vstHistory.Header.Columns[0].Width := vstHistory.Width div 2;
  end;
end;

class procedure UserFormDesPathApi.ShowFileList;
begin
  with frmDestination do
  begin
    vstHistory.Header.Columns[1].Options := vstHistory.Header.Columns[1].Options - [coVisible];
    vstHistory.Header.AutoSizeIndex := 0;

    btnOK.Enabled := True;
    plCenter.Visible := True;
    plLeft.Align := alLeft;
    plCenter.Align := alClient;
    slMain.Left := plCenter.Left + 10;
    slMain.Visible := True;

    plLeft.Width := PlLeftWidth;
  end;
end;

{ TFaceDesFileListApi }

procedure TFaceDesFileListApi.AddChildAction(SelectNode: PVirtualNode;
  FileAction: string);
var
  ChildNode : PVirtualNode;
  NodeData : PVstDesFileListData;
begin
  ChildNode := vstFileList.AddChild( SelectNode );
  vstFileList.CheckType[ ChildNode ] := ctRadioButton;
  if FileAction = FileAction_Replace then
    vstFileList.CheckState[ ChildNode ] := csCheckedNormal;
  NodeData := vstFileList.GetNodeData( ChildNode );
  NodeData.ActionType := FileAction;
  NodeData.ShowName := ReadAcionName( FileAction );
  NodeData.ShowIcon := ReadActionIcon( FileAction );
  NodeData.ActionName := '';
  NodeData.ActionIcon := -1;
end;

procedure TFaceDesFileListApi.AddFile(FilePath: string; IsFolder,
  IsAdd: Boolean);
var
  FileNode : PVirtualNode;
  NodeData : PVstDesFileListData;
  ActionName : string;
  ActionIcon : Integer;
  ActionType : string;
begin
  if IsAdd then
  begin
    ActionName := ActionShowItem_Paste;
    ActionIcon := My16IconUtil.getPaste;
    ActionType := FileAction_Paste;
  end
  else
  begin
    ActionName := '';
    ActionIcon := -1;
    ActionType := '';
  end;

  FileNode := vstFileList.AddChild( vstFileList.RootNode );
  NodeData := vstFileList.GetNodeData( FileNode );
  NodeData.FilePath := FilePath;
  NodeData.IsFolder := IsFolder;
  NodeData.IsAdd := IsAdd;
  NodeData.ShowName := MyFilePath.getName( FilePath );
  NodeData.ShowIcon := MyIcon.getPathIcon( FilePath, not IsFolder );
  NodeData.ActionName := ActionName;
  NodeData.ActionIcon := ActionIcon;
  NodeData.ActionType := ActionType;
end;

procedure TFaceDesFileListApi.ClearFileList;
begin
  vstFileList.Clear;
end;

constructor TFaceDesFileListApi.Create;
begin
  vstFileList := frmDestination.vstFileList;
  vstFileList.NodeDataSize := SizeOf( TVstDesFileListData );
  vstFileList.Images := MyIcon.getSysIcon;
end;

procedure TFaceDesFileListApi.SetFileConfliect(FilePath: string);
var
  SelectNode : PVirtualNode;
  NodeData : PVstDesFileListData;
begin
  SelectNode := ReadNode( FilePath );
  if not Assigned( SelectNode ) then
    Exit;

  NodeData := vstFileList.GetNodeData( SelectNode );
  NodeData.ActionType := FileAction_Replace;
  NodeData.ActionName := ActionShowItem_Confliect;
  NodeData.ActionIcon := My16IconUtil.getWarnning;

  AddChildAction( SelectNode, FileAction_Replace );
  AddChildAction( SelectNode, FileAction_Rename );
  AddChildAction( SelectNode, FileAction_Cancel );

  vstFileList.Expanded[ SelectNode ] := True;
end;

function TFaceDesFileListApi.ReadAcionName(FileAction: string): string;
begin
  if FileAction = FileAction_Paste then
    Result := ActionShowItem_Paste
  else
  if FileAction = FileAction_Replace then
    Result := ActionShowItem_Replace
  else
  if FileAction = FileAction_Rename then
    Result := ActionShowItem_Rename
  else
  if FileAction = FileAction_Cancel then
    Result := ActionShowItem_Cancel
end;

function TFaceDesFileListApi.ReadActionIcon(FileAction: string): Integer;
begin
  if FileAction = FileAction_Paste then
    Result := My16IconUtil.getPaste
  else
  if FileAction = FileAction_Replace then
    Result := My16IconUtil.getReplace
  else
  if FileAction = FileAction_Rename then
    Result := My16IconUtil.getRename
  else
  if FileAction = FileAction_Cancel then
    Result := My16IconUtil.getStop
end;

function TFaceDesFileListApi.ReadFileAction(FilePath: string): string;
var
  SelectNode : PVirtualNode;
  NodeData : PVstDesFileListData;
begin
  SelectNode := ReadNode( FilePath );
  if not Assigned( SelectNode ) then
    Exit;
  NodeData := vstFileList.GetNodeData( SelectNode );
  Result := NodeData.ActionType;
end;

function TFaceDesFileListApi.ReadNode(FilePath: string): PVirtualNode;
var
  SelectNode : PVirtualNode;
  NodeData : PVstDesFileListData;
begin
  Result := nil;

  SelectNode := vstFileList.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFileList.GetNodeData( SelectNode );
    if NodeData.FilePath = FilePath then
    begin
      Result := SelectNode;
      Break;
    end;
    SelectNode := SelectNode.NextSibling;
  end;
end;

{ UserFileListApi }

class procedure UserDesFileListApi.AddFile(FilePath: string; IsFolder: Boolean);
var
  ExistInputPath : string;
begin
  ExistInputPath := FaceDesFormApi.ReadInputExistName( MyFilePath.getName( FilePath ) );
  if ExistInputPath <> '' then
    FaceDesFileListApi.SetFileConfliect( ExistInputPath );

  FaceDesFileListApi.AddFile( FilePath, IsFolder, False );
end;

class procedure UserDesFileListApi.EnterFolder(Path: string);
var
  PathList : TStringList;
  i : Integer;
  IsFolder : Boolean;
begin
    // 清空旧信息
  FaceDesFileListApi.ClearFileList;
  PathList := frmDestination.InputPathList;
  for i := 0 to PathList.Count - 1 do
  begin
    IsFolder :=  TDirectory.Exists( PathList[i] );
    FaceDesFileListApi.AddFile( PathList[i], IsFolder, True );
  end;

    // 显示目录
  FaceDesFormApi.ShowDesPath( Path );

    // 搜索文件
  MyFaceJobHandler.ReadDesFileList( Path );

    // 打开文件列表
  if not frmDestination.btnOK.Enabled then
    UserFormDesPathApi.ShowFileList;
end;

end.
