unit UFrameMyRun;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.ComCtrls, RzListVw, VirtualTrees, Vcl.StdCtrls, Generics.Collections;

type
  TFrameMyRun = class(TFrame)
    plLeft: TPanel;
    plCenter: TPanel;
    Splitter1: TSplitter;
    lvApps: TRzListView;
    plFile: TPanel;
    plFolder: TPanel;
    Splitter2: TSplitter;
    vstFile: TVirtualStringTree;
    vstFolder: TVirtualStringTree;
    plInformation: TPanel;
    plDropHit: TPanel;
    Image1: TImage;
    Panel1: TPanel;
    Image2: TImage;
    lbDragdrop: TLabel;
    lbInput: TLinkLabel;
    plAllRemove: TPanel;
    plAllLeft: TPanel;
    plAllCenter: TPanel;
    btnRemoveApp: TButton;
    btnCancelApp: TButton;
    plFileRemove: TPanel;
    plFileRemoveLeft: TPanel;
    plFileRemoveCenter: TPanel;
    btnFileRemove: TButton;
    btnFileCancel: TButton;
    plFolderRemove: TPanel;
    plFolderRemoveLeft: TPanel;
    plFolderRemoveCenter: TPanel;
    btnFolderRemove: TButton;
    btnFolderRemoveCancel: TButton;
    tmrFolderSelect: TTimer;
    tmrFileSelect: TTimer;
    Panel2: TPanel;
    Image3: TImage;
    lbImport: TLinkLabel;
    plBat: TPanel;
    vstBat: TVirtualStringTree;
    plRemoveBat: TPanel;
    plRemoveBatLeft: TPanel;
    plRemoveBatCenter: TPanel;
    btnRemoveBat: TButton;
    btnRemoveBatCancel: TButton;
    slBat: TSplitter;
    tmrBatCreate: TTimer;
    tmrBatSelect: TTimer;
    Panel3: TPanel;
    ChkHideForm: TCheckBox;
    procedure lvAppsDeletion(Sender: TObject; Item: TListItem);
    procedure vstFileGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstFileGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure vstFolderGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstFolderGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure lvAppsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure vstFileMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lvAppsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vstFileMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vstFolderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vstFolderMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LinkLabel1LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure Splitter1Moved(Sender: TObject);
    procedure btnCancelAppClick(Sender: TObject);
    procedure btnRemoveAppClick(Sender: TObject);
    procedure lvAppsItemChecked(Sender: TObject; Item: TListItem);
    procedure btnFileCancelClick(Sender: TObject);
    procedure btnFileRemoveClick(Sender: TObject);
    procedure vstFileChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure btnFolderRemoveCancelClick(Sender: TObject);
    procedure btnFolderRemoveClick(Sender: TObject);
    procedure vstFolderChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure lvAppsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvAppsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tmrFolderSelectTimer(Sender: TObject);
    procedure tmrFileSelectTimer(Sender: TObject);
    procedure lbInputLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure tmrBatCreateTimer(Sender: TObject);
    procedure vstBatGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstBatGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure vstBatMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure vstBatMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnRemoveBatCancelClick(Sender: TObject);
    procedure btnRemoveBatClick(Sender: TObject);
    procedure vstBatChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure tmrBatSelectTimer(Sender: TObject);
  private
    BatList : TStringList;
    procedure AddBat( Path : string );
  private
    procedure AppManagerEnter;
    procedure AppManagerLeave;
    procedure FileManagerEnter;
    procedure FileManagerLeave;
    procedure FolderManagerEnter;
    procedure FolderManagerLeave;
    procedure BatManagerEnter;
    procedure BatManagerLeave;
    procedure CheckHideForm;
  public
    procedure SaveIni;
    procedure LoadIni;
  public
    procedure IniFrame;
    procedure UniniFrame;
  public
    procedure AddPath( Path : string );
  end;

{$Region ' 界面数据 ' }

    // 运行程序 数据
  TLvRunAppData = class
  public
    FilePath : string;
  public
    constructor Create( _FilePath : string );
  end;

    // 打开文件 数据
  TVstRunFileData = record
  public
    FilePath : WideString;
  public
    ShowName, ShowDir : WideString;
    ShowIcon : Integer;
  end;
  PVstRunFileData = ^TVstRunFileData;

    // 打开目录 数据
  TVstRunFolderData = record
  public
    FolderPath : WideString;
  public
    ShowName, ShowDir : WideString;
    ShowIcon : Integer;
  end;
  PVstRunFolderData = ^TVstRunFolderData;

    // 打开批运行 数据
  TVstRunBatData = record
  public
    PathCount : Integer;
    FolderPath1, FolderPath2, FolderPath3, FolderPath4, FolderPath5: WideString;
  public
    ShowName1, ShowName2, ShowName3, ShowName4, ShowName5 : WideString;
    ShowIcon1, ShowIcon2, ShowIcon3, ShowIcon4, ShowIcon5 : Integer;
  end;
  PVstRunBatData = ^TVstRunBatData;



{$EndRegion}

{$Region ' 界面操作 ' }

    // 运行程序 Api
  TFaceAppRunApi = class
  public
    lvApp : TRzListView;
  public
    constructor Create;
  public
    function ReadAppExist( Path : string ): Boolean;
    procedure AddApp( Path : string );
    procedure RemoveApp( Path : string );
    function ReadAppList : TStringList;
    function ReadCheckAppList : TStringList;
  private
    function ReadAppIndex( Path : string ) : Integer;
  end;

    // 打开文件 Api
  TFaceFileRunApi = class
  public
    vstFile : TVirtualStringTree;
  public
    constructor Create;
  public
    function ReadFileExist( Path : string ): Boolean;
    procedure AddFile( Path : string );
    procedure RemoveFile( Path : string );
    procedure MoveToTop( Path : string );
  public
    function ReadFileList : TStringList;
    function ReadCheckFileList : TStringList;
  private
    function ReadFileNode( Path : string ): PVirtualNode;
  end;

    // 打开目录 Api
  TFaceFolderRunApi = class
  public
    vstFolder : TVirtualStringTree;
  public
    constructor Create;
  public
    function ReadFolderExist( Path : string ): Boolean;
    procedure AddFolder( Path : string );
    procedure RemoveFolder( Path : string );
  public
    procedure MoveToTop( Path : string );
    function ReadFolderList : TStringList;
    function ReadCheckFileList : TStringList;
  private
    function ReadFolderNode( Path : string ): PVirtualNode;
  end;

    // 批信息
  TBatInfo = class
  public
    PathList : TStringList;
  public
    constructor Create;
    procedure AddPath( Path : string );
    destructor Destroy; override;
  end;
  TBatList = class( TObjectList<TBatInfo> );

    // 批运行 Api
  TFaceBatRunApi = class
  public
    vstBat : TVirtualStringTree;
  public
    constructor Create;
  public
    function ReadBatExist( BatPathList : TStringList ): Boolean;
    procedure AddBat( BatPathList : TStringList );
    procedure RemoveBat( BatPathList : TStringList );
    procedure RemoveLastBat;
  public
    function ReadBatList : TBatList;
    function ReadCheckBatList : TBatList;
    function ReadBatCount : Integer;
  private
    function ReadBstNode( BatPathList : TStringList ): PVirtualNode;
    function ReadPathList( Node : PVirtualNode ): TStringList;
  end;

{$EndRegion}

{$Region ' 用户操作 ' }

    // 运行程序 Api
  UserAppRunApi = class
  public
    class procedure AddApp( Path : string );
    class procedure RemoveApp( Path : string );
  end;

    // 打开文件 Api
  UserFileRunApi = class
  public
    class procedure AddFile( Path : string );
    class procedure RemoveFile( Path : string );
  end;

    // 打开目录 Api
  UserFolderRunApi = class
  public
    class procedure AddFolder( Path : string );
    class procedure RemoveFolder( Path : string );
  end;

    // 批运行 Api
  UserBatRunApi = class
  public
    class procedure ShowBatPanel;
    class procedure HideBatPanel;
  public
    class procedure AddBat( BatPathList : TStringList );
    class procedure RemoveBat( BatPathList : TStringList );
  end;

{$EndRegion}

const
  Ini_FrameMyRun = 'FrameMyRun';
  Ini_AppWidth = 'AppWidth';
  Ini_FileHeight = 'FileHeight';
  Ini_BatHeight = 'BatHeight';
  Ini_AppCount = 'AppCount';
  Ini_AppPath = 'AppPath';
  Ini_FileCount = 'FileCount';
  Ini_FilePath = 'FilePath';
  Ini_FolderCount = 'FolderCount';
  Ini_FolderPath = 'FolderPath';
  Ini_FrameMyRun_Bat = 'FrameMyRun_Bat';
  Ini_FrameMyRun_BatCount = 'FrameMyRun_BatCount';
  Ini_FrameMyRun_BatPath = 'FrameMyRun_BatPath';
  Ini_RunHide = 'RunHide';

var
  MyRunInputShow_Title : string = '输入需要添加的路径';
  MyRunInputShow_Name : string = '路径';
  MyRunInputShow_NotExist : string = '路径不存在';


var
  IsManage_App : Boolean = False;
  IsManage_File : Boolean = False;
  IsManage_Folder : Boolean = False;
  IsManage_Bat : Boolean = False;

var
  Frame_MyRun : TFrameMyRun;
  FaceAppRunApi : TFaceAppRunApi;
  FaceFileRunApi : TFaceFileRunApi;
  FaceFolderRunApi : TFaceFolderRunApi;
  FaceBatRunApi : TFaceBatRunApi;

implementation

uses UMyIcon, UMyUtil, IniFiles, UFormDesktopPath, ClipBrd, UFormBatRun, UMainForm;

{$R *.dfm}

{ TLvRunAppData }

constructor TLvRunAppData.Create(_FilePath: string);
begin
  FilePath := _FilePath;
end;

{ TFaceAppRunApi }

procedure TFaceAppRunApi.AddApp(Path: string);
begin
  with lvApp.Items.Add do
  begin
    Caption := ExtractFileName( Path );
    SubItems.Add( ExtractFileDir( Path ) );
    Data := TLvRunAppData.Create( Path );
    ImageIndex := MyIcon.getFileIcon( Path );
  end;
end;

constructor TFaceAppRunApi.Create;
begin
  lvApp := Frame_MyRun.lvApps;
  lvApp.LargeImages := MyIcon.getSysIcon32;
  lvApp.SmallImages := MyIcon.getSysIcon;
end;

function TFaceAppRunApi.ReadAppExist(Path: string): Boolean;
begin
  Result := ReadAppIndex( Path ) >= 0;
end;

function TFaceAppRunApi.ReadAppIndex(Path: string): Integer;
var
  i: Integer;
  ItemData : TLvRunAppData;
begin
  Result := -1;
  for i := 0 to lvApp.Items.Count - 1 do
  begin
    ItemData := lvApp.Items[i].Data;
    if ItemData.FilePath = Path then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TFaceAppRunApi.ReadAppList: TStringList;
var
  i: Integer;
  ItemData : TLvRunAppData;
begin
  Result := TStringList.Create;
  for i := 0 to lvApp.Items.Count - 1 do
  begin
    ItemData := lvApp.Items[i].Data;
    Result.Add( ItemData.FilePath );
  end;
end;

function TFaceAppRunApi.ReadCheckAppList: TStringList;
var
  i: Integer;
  ItemData : TLvRunAppData;
begin
  Result := TStringList.Create;
  for i := 0 to lvApp.Items.Count - 1 do
  begin
    if not lvApp.Items[i].Checked then
      Continue;
    ItemData := lvApp.Items[i].Data;
    Result.Add( ItemData.FilePath );
  end;
end;

procedure TFaceAppRunApi.RemoveApp(Path: string);
var
  AppIndex : Integer;
begin
  AppIndex := ReadAppIndex( Path );
  if AppIndex < 0 then
    Exit;
  lvApp.Items.Delete( AppIndex );
end;

procedure TFrameMyRun.AddBat(Path: string);
begin
  tmrBatCreate.Enabled := False;
  tmrBatCreate.Enabled := True;
  BatList.Add( Path );
end;

procedure TFrameMyRun.AddPath(Path: string);
var
  OrigiPath : string;
begin
    // 可能是一个快捷方式
  if MyFilePath.getIsLinkFile( Path ) then
    OrigiPath := MyFilePath.getLinkPath( Path )
  else
    OrigiPath := Path;

    // 分类添加
  if MyFilePath.getIsExeFile( OrigiPath ) then
    UserAppRunApi.AddApp( Path )
  else
  if DirectoryExists( OrigiPath ) then
    UserFolderRunApi.AddFolder( OrigiPath )
  else
  if FileExists( OrigiPath ) then
    UserFileRunApi.AddFile( OrigiPath );
end;

procedure TFrameMyRun.AppManagerEnter;
var
  i: Integer;
begin
  for i := 0 to lvApps.Items.Count - 1 do
    lvApps.Items[i].Checked := False;

  lvApps.Checkboxes := True;
  btnRemoveApp.Enabled := False;
  plAllRemove.Visible := True;
  plAllLeft.Width := ( plAllRemove.Width - plAllCenter.Width ) div 2;
  IsManage_App := True;
  lvApps.Cursor := crDefault;
  lvApps.DragMode := dmAutomatic;
end;

procedure TFrameMyRun.AppManagerLeave;
begin
  lvApps.Checkboxes := False;
  plAllRemove.Visible := False;
  IsManage_App := False;
  lvApps.DragMode := dmManual;
end;

procedure TFrameMyRun.BatManagerEnter;
var
  SelectNode : PVirtualNode;
  i: Integer;
begin
  SelectNode := vstBat.GetFirstChecked;
  while Assigned( SelectNode ) do
  begin
    vstBat.CheckState[ SelectNode ] := csUncheckedNormal;
    SelectNode := vstBat.GetNextChecked( SelectNode );
  end;

  vstBat.TreeOptions.MiscOptions := vstBat.TreeOptions.MiscOptions + [toCheckSupport];
  btnRemoveBat.Enabled := False;
  plRemoveBat.Visible := True;
  plRemoveBatLeft.Width := ( plRemoveBat.Width - plRemoveBatCenter.Width ) div 2;
  IsManage_Bat := True;
  vstBat.Cursor := crDefault;
end;

procedure TFrameMyRun.BatManagerLeave;
begin
  vstBat.TreeOptions.MiscOptions := vstBat.TreeOptions.MiscOptions - [toCheckSupport];
  plRemoveBat.Visible := False;
  IsManage_Bat := False;
end;

procedure TFrameMyRun.btnCancelAppClick(Sender: TObject);
begin
  AppManagerLeave;
end;

procedure TFrameMyRun.btnFileCancelClick(Sender: TObject);
begin
  FileManagerLeave;
end;

procedure TFrameMyRun.btnFileRemoveClick(Sender: TObject);
var
  PathList : TStringList;
  i: Integer;
begin
  PathList := FaceFileRunApi.ReadCheckFileList;
  for i := 0 to PathList.Count - 1 do
    FaceFileRunApi.RemoveFile( PathList[i] );
  PathList.Free;

  FileManagerLeave;
end;

procedure TFrameMyRun.btnFolderRemoveCancelClick(Sender: TObject);
begin
  FolderManagerLeave;
end;

procedure TFrameMyRun.btnFolderRemoveClick(Sender: TObject);
var
  PathList : TStringList;
  i: Integer;
begin
  PathList := FaceFolderRunApi.ReadCheckFileList;
  for i := 0 to PathList.Count - 1 do
    FaceFolderRunApi.RemoveFolder( PathList[i] );
  PathList.Free;

  FolderManagerLeave;
end;

procedure TFrameMyRun.btnRemoveAppClick(Sender: TObject);
var
  PathList : TStringList;
  i: Integer;
begin
  PathList := FaceAppRunApi.ReadCheckAppList;
  for i := 0 to PathList.Count - 1 do
    FaceAppRunApi.RemoveApp( PathList[i] );
  PathList.Free;

  AppManagerLeave;
end;

procedure TFrameMyRun.btnRemoveBatCancelClick(Sender: TObject);
begin
  BatManagerLeave;
end;

procedure TFrameMyRun.btnRemoveBatClick(Sender: TObject);
var
  BatList : TBatList;
  PathList : TStringList;
  i: Integer;
begin
  BatList := FaceBatRunApi.ReadCheckBatList;
  for i := 0 to BatList.Count - 1 do
    UserBatRunApi.RemoveBat( BatList[i].PathList );
  BatList.Free;

  BatManagerLeave;
end;

procedure TFrameMyRun.CheckHideForm;
begin
  if ChkHideForm.Checked then  // 最少化窗口
    frmMain.WindowState := wsMinimized;
end;

procedure TFrameMyRun.FileManagerEnter;
var
  SelectNode : PVirtualNode;
  i: Integer;
begin
  SelectNode := vstFile.GetFirstChecked;
  while Assigned( SelectNode ) do
  begin
    vstFile.CheckState[ SelectNode ] := csUncheckedNormal;
    SelectNode := vstFile.GetNextChecked( SelectNode );
  end;

  vstFile.TreeOptions.MiscOptions := vstFile.TreeOptions.MiscOptions + [toCheckSupport];
  btnFileRemove.Enabled := False;
  plFileRemove.Visible := True;
  plFileRemoveLeft.Width := ( plFileRemove.Width - plFileRemoveCenter.Width ) div 2;
  IsManage_File := True;
  vstFile.Cursor := crDefault;
end;


procedure TFrameMyRun.FileManagerLeave;
begin
  vstFile.TreeOptions.MiscOptions := vstFile.TreeOptions.MiscOptions - [toCheckSupport];
  plFileRemove.Visible := False;
  IsManage_File := False;
end;

procedure TFrameMyRun.FolderManagerEnter;
var
  SelectNode : PVirtualNode;
  i: Integer;
begin
  SelectNode := vstFolder.GetFirstChecked;
  while Assigned( SelectNode ) do
  begin
    vstFolder.CheckState[ SelectNode ] := csUncheckedNormal;
    SelectNode := vstFolder.GetNextChecked( SelectNode );
  end;

  vstFolder.TreeOptions.MiscOptions := vstFolder.TreeOptions.MiscOptions + [toCheckSupport];
  btnFolderRemove.Enabled := False;
  plFolderRemove.Visible := True;
  plFolderRemoveLeft.Width := ( plFolderRemove.Width - plFolderRemoveCenter.Width ) div 2;
  IsManage_Folder := True;
  vstFolder.Cursor := crDefault;
end;


procedure TFrameMyRun.FolderManagerLeave;
begin
  vstFolder.TreeOptions.MiscOptions := vstFolder.TreeOptions.MiscOptions - [toCheckSupport];
  plFolderRemove.Visible := False;
  IsManage_Folder := False;
end;

procedure TFrameMyRun.IniFrame;
begin
  BatList := TStringList.Create;

  Frame_MyRun := Self;
  FaceAppRunApi := TFaceAppRunApi.Create;
  FaceFileRunApi := TFaceFileRunApi.Create;
  FaceFolderRunApi := TFaceFolderRunApi.Create;
  FaceBatRunApi := TFaceBatRunApi.Create;

  LoadIni;
end;

procedure TFrameMyRun.lbInputLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
var
  FilePath : string;
begin
  FilePath := Clipboard.AsText;
  if not FileExists( FilePath ) and not DirectoryExists( FilePath ) then
    FilePath := '';
  while InputQuery( MyRunInputShow_Title, MyRunInputShow_Name, FilePath ) do
  begin
    if not DirectoryExists( FilePath ) and not FileExists( FilePath ) then
    begin
      MyMessageForm.ShowWarnning( MyRunInputShow_NotExist );
      Continue;
    end;
    AddPath( FilePath );
    Break;
  end;
end;

procedure TFrameMyRun.LinkLabel1LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
var
  OldPathList : TStringList;
  PathList : TStringList;
  i: Integer;
begin
  OldPathList := TStringList.Create;

    // 所有 App 路径
  PathList := FaceAppRunApi.ReadAppList;
  MyFilePath.Merge( OldPathList, PathList );
  PathList.Free;

    // 所有文件路径
  PathList := FaceFileRunApi.ReadFileList;
  MyFilePath.Merge( OldPathList, PathList );
  PathList.Free;

    // 所有目录路径
  PathList := FaceFolderRunApi.ReadFolderList;
  MyFilePath.Merge( OldPathList, PathList );
  PathList.Free;

    // 用户选择路径
  if frmDesktopPath.ReadImport( OldPathList ) then
  begin
    PathList := frmDesktopPath.ReadPathList;
    for i := 0 to PathList.Count - 1 do
      AddPath( PathList[i] );
    PathList.Free;
  end;

  OldPathList.Free;
end;

procedure TFrameMyRun.LoadIni;
var
  IniFile : TIniFile;
  PathCount, i : Integer;
  Path : string;
  BatCount : Integer;
  PathList : TStringList;
  j: Integer;
begin
  IniFile := TIniFile.Create( MyAppData.getConfigPath );
  try
      // 读取 Frame 布局
    plLeft.Width := IniFile.ReadInteger( Ini_FrameMyRun, Ini_AppWidth, plLeft.Width );
    plFile.Height := IniFile.ReadInteger( Ini_FrameMyRun, Ini_FileHeight, plFile.Height );
    plBat.Height := IniFile.ReadInteger( Ini_FrameMyRun, Ini_BatHeight, plBat.Height );
    ChkHideForm.Checked := IniFile.ReadBool( Ini_FrameMyRun, Ini_RunHide, ChkHideForm.Checked );

      // 读取 程序列表
    PathCount := IniFile.ReadInteger( Ini_FrameMyRun, Ini_AppCount, 0 );
    for i := 0 to PathCount - 1 do
    begin
      Path := IniFile.ReadString( Ini_FrameMyRun, Ini_AppPath + IntToStr(i), '' );
      if Path <> '' then
        UserAppRunApi.AddApp( Path );
    end;

      // 读取 文件列表
    PathCount := IniFile.ReadInteger( Ini_FrameMyRun, Ini_FileCount, 0 );
    for i := PathCount - 1 downto 0 do
    begin
      Path := IniFile.ReadString( Ini_FrameMyRun, Ini_FilePath + IntToStr(i), '' );
      if Path <> '' then
        UserFileRunApi.AddFile( Path );
    end;

      // 读取 目录列表
    PathCount := IniFile.ReadInteger( Ini_FrameMyRun, Ini_FolderCount, 0 );
    for i := PathCount - 1 downto 0 do
    begin
      Path := IniFile.ReadString( Ini_FrameMyRun, Ini_FolderPath + IntToStr(i), '' );
      if Path <> '' then
        UserFolderRunApi.AddFolder( Path );
    end;

      // 读取 批运行
    BatCount := IniFile.ReadInteger( Ini_FrameMyRun_Bat, Ini_FrameMyRun_BatCount, 0 );
    for i := BatCount - 1 downto 0 do
    begin
      PathCount := IniFile.ReadInteger( Ini_FrameMyRun_Bat + IntToStr(i), Ini_FrameMyRun_BatCount, 0 );
      PathList := TStringList.Create;
      for j := 0 to PathCount - 1 do
      begin
        Path := IniFile.ReadString( Ini_FrameMyRun_Bat + IntToStr(i), Ini_FrameMyRun_BatPath + IntToStr(j), '' );
        if Path <> '' then
          PathList.Add( Path );
      end;
      if PathList.Count > 0 then
        UserBatRunApi.AddBat( PathList );
      PathList.Free;
    end;
  except
  end;
  IniFile.Free;
end;

procedure TFrameMyRun.lvAppsDeletion(Sender: TObject; Item: TListItem);
var
  ItemData : TObject;
begin
  ItemData := Item.Data;
  ItemData.Free;
end;

procedure TFrameMyRun.lvAppsDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  SelectItem : TListItem;
  i, MoveIndex, MoveToIndex : Integer;
  MovePath : string;
  PathList : TStringList;
  ItemData : TLvRunAppData;
begin
    // 移动的目标
  SelectItem := lvApps.GetItemAt( X, Y );
  if not Assigned( SelectItem ) then
  begin
    SelectItem := lvApps.GetItemAt( X + 20, Y );
    if not Assigned( SelectItem ) then
    begin
      SelectItem := lvApps.GetItemAt( X - 20, Y );
      if not Assigned( SelectItem ) then
        Exit;
    end;
  end;
  MoveToIndex := SelectItem.Index;

    // 移动的源
  MovePath := '';
  for i := 0 to lvApps.Items.Count - 1 do
    if lvApps.Items[i].Selected and ( lvApps.Items[i] <> SelectItem ) then
    begin
      ItemData := lvApps.Items[i].Data;
      MovePath := ItemData.FilePath;
      Break;
    end;
  if MovePath = '' then
    Exit;

    // 刷新列表
  PathList := FaceAppRunApi.ReadAppList;
  i := PathList.IndexOf( MovePath );
  if i >= 0 then
    PathList.Delete( i );
  lvApps.Clear;
  for i := 0 to PathList.Count - 1 do
  begin
    if i = MoveToIndex then
      FaceAppRunApi.AddApp( MovePath );
    FaceAppRunApi.AddApp( PathList[i] );
  end;
  PathList.Free;

    // 进入管理模式
  AppManagerEnter;
end;

procedure TFrameMyRun.lvAppsDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source = lvApps;
end;

procedure TFrameMyRun.lvAppsItemChecked(Sender: TObject; Item: TListItem);
begin
  if Item.Checked then
    btnRemoveApp.Enabled := True;
end;

procedure TFrameMyRun.lvAppsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  SelectItem : TListItem;
  ItemData : TLvRunAppData;
begin
    // 管理模式
  if IsManage_App then
  begin
    if Button = mbRight then // 退出管理模式
      AppManagerLeave;
    Exit;
  end;

    // 进入管理模式
  if Button = mbRight then
  begin
    if lvApps.Items.Count > 0 then
      AppManagerEnter;
    Exit;
  end;

    // 快速启动模式
  SelectItem := lvApps.GetItemAt( X, Y );
  if Assigned( SelectItem ) then
  begin
    ItemData := SelectItem.Data;
    lvApps.Cursor := crHourGlass;
    MyExplorer.RunFile( ItemData.FilePath );
    lvApps.Cursor := crDefault;
    AddBat( ItemData.FilePath );
    CheckHideForm;
  end;
end;

procedure TFrameMyRun.lvAppsMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  SelectItem : TListItem;
begin
    // 管理模式
  if IsManage_App then
    Exit;

    // 快速启动模式
  SelectItem := lvApps.GetItemAt( X, Y );
  if Assigned( SelectItem ) then
    lvApps.Cursor := crHandPoint
  else
    lvApps.Cursor := crDefault;
end;

procedure TFrameMyRun.SaveIni;
var
  IniFile : TIniFile;
  PathList : TStringList;
  i: Integer;
  BatList : TBatList;
  j: Integer;
begin
  IniFile := TIniFile.Create( MyAppData.getConfigPath );
  try
      // 保存 Frame 布局
    IniFile.WriteInteger( Ini_FrameMyRun, Ini_AppWidth, plLeft.Width );
    IniFile.WriteInteger( Ini_FrameMyRun, Ini_FileHeight, plFile.Height );
    IniFile.WriteInteger( Ini_FrameMyRun, Ini_BatHeight, plBat.Height );
    IniFile.WriteBool( Ini_FrameMyRun, Ini_RunHide, ChkHideForm.Checked );

      // 保存程序列表
    PathList := FaceAppRunApi.ReadAppList;
    IniFile.WriteInteger( Ini_FrameMyRun, Ini_AppCount, PathList.Count );
    for i := 0 to PathList.Count - 1 do
      IniFile.WriteString( Ini_FrameMyRun, Ini_AppPath + IntToStr(i), PathList[i] );
    PathList.Free;

      // 保存文件列表
    PathList := FaceFileRunApi.ReadFileList;
    IniFile.WriteInteger( Ini_FrameMyRun, Ini_FileCount, PathList.Count );
    for i := 0 to PathList.Count - 1 do
      IniFile.WriteString( Ini_FrameMyRun, Ini_FilePath + IntToStr(i), PathList[i] );
    PathList.Free;

      // 保存目录列表
    PathList := FaceFolderRunApi.ReadFolderList;
    IniFile.WriteInteger( Ini_FrameMyRun, Ini_FolderCount, PathList.Count );
    for i := 0 to PathList.Count - 1 do
      IniFile.WriteString( Ini_FrameMyRun, Ini_FolderPath + IntToStr(i), PathList[i] );
    PathList.Free;

      // 保存批运行
    BatList := FaceBatRunApi.ReadBatList;
    IniFile.WriteInteger( Ini_FrameMyRun_Bat, Ini_FrameMyRun_BatCount, BatList.Count );
    for i := 0 to BatList.Count - 1 do
    begin
      IniFile.WriteInteger( Ini_FrameMyRun_Bat + IntToStr(i), Ini_FrameMyRun_BatCount, BatList[i].PathList.Count );
      for j := 0 to BatList[i].PathList.Count - 1 do
        IniFile.WriteString( Ini_FrameMyRun_Bat + IntToStr(i), Ini_FrameMyRun_BatPath + IntToStr(j), BatList[i].PathList[j] );
    end;
    BatList.Free;
  except
  end;
  IniFile.Free;
end;

procedure TFrameMyRun.Splitter1Moved(Sender: TObject);
var
  PathList : TStringList;
  i : Integer;
begin
  PathList := FaceAppRunApi.ReadAppList;
  lvApps.Clear;
  for i := 0 to PathList.Count - 1 do
    FaceAppRunApi.AddApp( PathList[i] );
  PathList.Free;
end;

procedure TFrameMyRun.tmrBatCreateTimer(Sender: TObject);
var
  i: Integer;
begin
  tmrBatCreate.Enabled := False;
  for i := BatList.Count - 1 downto 5 do
    BatList.Delete( i );
  if BatList.Count > 1 then
    UserBatRunApi.AddBat( BatList );
  BatList.Clear;
end;

procedure TFrameMyRun.tmrBatSelectTimer(Sender: TObject);
var
  SelectNode, FirstChildNode : PVirtualNode;
begin
  tmrBatSelect.Enabled := False;
  SelectNode := vstBat.GetFirstSelected;
  FirstChildNode := vstBat.RootNode.FirstChild;
  if not Assigned( SelectNode ) or not Assigned( FirstChildNode ) then
    Exit;
  vstBat.Selected[ SelectNode ] := False;
  vstBat.Selected[ FirstChildNode ] := True;
  vstBat.FocusedNode := FirstChildNode;
end;

procedure TFrameMyRun.tmrFileSelectTimer(Sender: TObject);
var
  SelectNode, FirstChildNode : PVirtualNode;
begin
  tmrFileSelect.Enabled := False;
  SelectNode := vstFile.GetFirstSelected;
  FirstChildNode := vstFile.RootNode.FirstChild;
  if not Assigned( SelectNode ) or not Assigned( FirstChildNode ) then
    Exit;
  vstFile.Selected[ SelectNode ] := False;
  vstFile.Selected[ FirstChildNode ] := True;
  vstFile.FocusedNode := FirstChildNode;
end;

procedure TFrameMyRun.tmrFolderSelectTimer(Sender: TObject);
var
  SelectNode, FirstChildNode : PVirtualNode;
begin
  tmrFolderSelect.Enabled := False;
  SelectNode := vstFolder.GetFirstSelected;
  FirstChildNode := vstFolder.RootNode.FirstChild;
  if not Assigned( SelectNode ) or not Assigned( FirstChildNode ) then
    Exit;
  vstFolder.Selected[ SelectNode ] := False;
  vstFolder.Selected[ FirstChildNode ] := True;
  vstFolder.FocusedNode := FirstChildNode;
end;

{ UserAppRunApi }

class procedure UserAppRunApi.AddApp(Path: string);
begin
  if not FaceAppRunApi.ReadAppExist( Path ) then
    FaceAppRunApi.AddApp( Path );
end;

class procedure UserAppRunApi.RemoveApp(Path: string);
begin
  FaceAppRunApi.RemoveApp( Path );
end;

{ TFaceFileRunApi }

procedure TFaceFileRunApi.AddFile(Path: string);
var
  NewNode : PVirtualNode;
  NodeData : PVstRunFileData;
begin
  NewNode := vstFile.InsertNode( vstFile.RootNode, amAddChildFirst );
  vstFile.CheckType[ NewNode ] := ctTriStateCheckBox;
  vstFile.CheckState[ NewNode ] := csUncheckedNormal;
  NodeData := vstFile.GetNodeData( NewNode );
  NodeData.FilePath := Path;
  NodeData.ShowName := ExtractFileName( Path );
  NodeData.ShowDir := ExtractFileDir( Path );
  NodeData.ShowIcon := MyIcon.getFileIcon( Path );
end;

constructor TFaceFileRunApi.Create;
begin
  vstFile := Frame_MyRun.vstFile;
  vstFile.NodeDataSize := SizeOf( TVstRunFileData );
  vstFile.Images := MyIcon.getSysIcon;
end;

procedure TFaceFileRunApi.MoveToTop(Path: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadFileNode( Path );
  if not Assigned( SelectNode ) then
    Exit;
  vstFile.MoveTo( SelectNode, vstFile.RootNode, amAddChildFirst, False );
end;

function TFaceFileRunApi.ReadCheckFileList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstRunFileData;
begin
  Result := TStringList.Create;
  SelectNode := vstFile.GetFirstChecked;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFile.GetNodeData( SelectNode );
    Result.Add( NodeData.FilePath );
    SelectNode := vstFile.GetNextChecked( SelectNode );
  end;
end;

function TFaceFileRunApi.ReadFileExist(Path: string): Boolean;
begin
  Result := Assigned( ReadFileNode( Path ) );
end;

function TFaceFileRunApi.ReadFileList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstRunFileData;
begin
  Result := TStringList.Create;
  SelectNode := vstFile.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFile.GetNodeData( SelectNode );
    Result.Add( NodeData.FilePath );
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceFileRunApi.ReadFileNode(Path: string): PVirtualNode;
var
  SelectNode : PVirtualNode;
  NodeData : PVstRunFileData;
begin
  Result := nil;
  SelectNode := vstFile.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFile.GetNodeData( SelectNode );
    if NodeData.FilePath = Path then
    begin
      Result := SelectNode;
      Break;
    end;
    SelectNode := SelectNode.NextSibling;
  end;
end;

procedure TFaceFileRunApi.RemoveFile(Path: string);
var
  RemoveNode : PVirtualNode;
begin
  RemoveNode := ReadFileNode( Path );
  if Assigned( RemoveNode ) then
    vstFile.DeleteNode( RemoveNode );
end;

{ UserFileRunApi }

class procedure UserFileRunApi.AddFile(Path: string);
begin
  if not FaceFileRunApi.ReadFileExist( Path ) then
    FaceFileRunApi.AddFile( Path )
  else
    FaceFileRunApi.MoveToTop( Path );
end;

class procedure UserFileRunApi.RemoveFile(Path: string);
begin
  FaceFileRunApi.RemoveFile( Path );
end;

{ TFaceFolderRunApi }

procedure TFaceFolderRunApi.AddFolder(Path: string);
var
  NewNode : PVirtualNode;
  NodeData : PVstRunFolderData;
begin
  NewNode := vstFolder.InsertNode( vstFolder.RootNode, amAddChildFirst );
  vstFolder.CheckType[ NewNode ] := ctTriStateCheckBox;
  vstFolder.CheckState[ NewNode ] := csUncheckedNormal;
  NodeData := vstFolder.GetNodeData( NewNode );
  NodeData.FolderPath := Path;
  NodeData.ShowName := ExtractFileName( Path );
  NodeData.ShowDir := ExtractFileDir( Path );
  NodeData.ShowIcon := MyIcon.getFolderIcon( Path );
end;

constructor TFaceFolderRunApi.Create;
begin
  vstFolder := Frame_MyRun.vstFolder;
  vstFolder.NodeDataSize := SizeOf( TVstRunFolderData );
  vstFolder.Images := MyIcon.getSysIcon;
end;

procedure TFaceFolderRunApi.MoveToTop(Path: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadFolderNode( Path );
  if not Assigned( SelectNode ) then
    Exit;
  vstFolder.MoveTo( SelectNode, vstFolder.RootNode, amAddChildFirst, False );
end;

function TFaceFolderRunApi.ReadCheckFileList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstRunFolderData;
begin
  Result := TStringList.Create;
  SelectNode := vstFolder.GetFirstChecked;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFolder.GetNodeData( SelectNode );
    Result.Add( NodeData.FolderPath );
    SelectNode := vstFolder.GetNextChecked( SelectNode );
  end;
end;

function TFaceFolderRunApi.ReadFolderExist(Path: string): Boolean;
begin
  Result := Assigned( ReadFolderNode( Path ) );
end;

function TFaceFolderRunApi.ReadFolderList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstRunFolderData;
begin
  Result := TStringList.Create;
  SelectNode := vstFolder.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFolder.GetNodeData( SelectNode );
    Result.Add( NodeData.FolderPath );
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceFolderRunApi.ReadFolderNode(Path: string): PVirtualNode;
var
  SelectNode : PVirtualNode;
  NodeData : PVstRunFolderData;
begin
  Result := nil;
  SelectNode := vstFolder.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFolder.GetNodeData( SelectNode );
    if NodeData.FolderPath = Path then
    begin
      Result := SelectNode;
      Break;
    end;
    SelectNode := SelectNode.NextSibling;
  end;
end;

procedure TFaceFolderRunApi.RemoveFolder(Path: string);
var
  RemoveNode : PVirtualNode;
begin
  RemoveNode := ReadFolderNode( Path );
  if Assigned( RemoveNode ) then
    vstFolder.DeleteNode( RemoveNode );
end;

{ UserFolderRunApi }

class procedure UserFolderRunApi.AddFolder(Path: string);
begin
  if not FaceFolderRunApi.ReadFolderExist( Path ) then
    FaceFolderRunApi.AddFolder( Path )
  else
    FaceFolderRunApi.MoveToTop( Path );
end;

class procedure UserFolderRunApi.RemoveFolder(Path: string);
begin
  FaceFolderRunApi.RemoveFolder( Path );
end;

procedure TFrameMyRun.UniniFrame;
begin
  SaveIni;

  FaceBatRunApi.Free;
  FaceAppRunApi.Free;
  FaceFileRunApi.Free;
  FaceFolderRunApi.Free;

  BatList.Free;
end;

procedure TFrameMyRun.vstBatChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  btnRemoveBat.Enabled := Sender.CheckedCount > 0;
end;

procedure TFrameMyRun.vstBatGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstRunBatData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    if Column = 0 then
      ImageIndex := NodeData.ShowIcon1
    else
    if Column = 1 then
      ImageIndex := NodeData.ShowIcon2
    else
    if Column = 2 then
      ImageIndex := NodeData.ShowIcon3
    else
    if Column = 3 then
      ImageIndex := NodeData.ShowIcon4
    else
    if Column = 4 then
      ImageIndex := NodeData.ShowIcon5
  end
  else
    ImageIndex := -1;
end;

procedure TFrameMyRun.vstBatGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstRunBatData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.ShowName1
  else
  if Column = 1 then
    CellText := NodeData.ShowName2
  else
  if Column = 2 then
    CellText := NodeData.ShowName3
  else
  if Column = 3 then
    CellText := NodeData.ShowName4
  else
  if Column = 4 then
    CellText := NodeData.ShowName5;
end;

procedure TFrameMyRun.vstBatMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  SelectNode : PVirtualNode;
  NodeData : PVstRunBatData;
  i: Integer;
  SelectPath : string;
  PathList : TStringList;
begin
    // 管理模式
  if IsManage_Bat then
  begin
    if Button = mbRight then // 离开管理模式
      BatManagerLeave;
    Exit;
  end;

    // 进入管理模式
  if Button = mbRight then
  begin
    BatManagerEnter;
    Exit;
  end;

    // 快速启动模式
  SelectNode := vstBat.GetNodeAt( X, Y );
  if not Assigned( SelectNode ) then
    Exit;

    // 启动多个程序
  NodeData := vstBat.GetNodeData( SelectNode );
  frmBatRun.ClearList;
  for i := 1 to NodeData.PathCount do
  begin
    if i = 1 then
      SelectPath := NodeData.FolderPath1
    else
    if i = 2 then
      SelectPath := NodeData.FolderPath2
    else
    if i = 3 then
      SelectPath := NodeData.FolderPath3
    else
    if i = 4 then
      SelectPath := NodeData.FolderPath4
    else
    if i = 5 then
      SelectPath := NodeData.FolderPath5;
    frmBatRun.AddPath( SelectPath );
  end;

    // 已取消
  if not frmBatRun.ReadRun then
    Exit;

    // 批运行
  vstBat.Cursor := crHourGlass;
  PathList := frmBatRun.ReadPathList;
  for i := 0 to PathList.Count - 1 do
  begin
    if DirectoryExists( PathList[i] ) then
      MyExplorer.ShowFolder( PathList[i] )
    else
    if FileExists( PathList[i] ) then
      MyExplorer.RunFile( PathList[i] );
  end;
  PathList.Free;
  vstBat.Cursor := crDefault;

    // 移到顶部
  vstBat.MoveTo( SelectNode, vstBat.RootNode, amAddChildFirst, False );
  tmrBatSelect.Enabled := True;

  CheckHideForm;
end;

procedure TFrameMyRun.vstBatMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  SelectNode : PVirtualNode;
begin
    // 管理模式
  if IsManage_Bat then
    Exit;

    // 快速启动模式
  SelectNode := vstBat.GetNodeAt( X, Y );
  if Assigned( SelectNode ) then
    vstBat.Cursor := crHandPoint
  else
    vstBat.Cursor := crDefault;
end;

procedure TFrameMyRun.vstFileChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  btnFileRemove.Enabled := Sender.CheckedCount > 0;
end;

procedure TFrameMyRun.vstFileGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstRunFileData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TFrameMyRun.vstFileGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstRunFileData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.ShowName
  else
  if Column = 1 then
    CellText := NodeData.ShowDir;
end;

procedure TFrameMyRun.vstFileMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  SelectNode : PVirtualNode;
  NodeData : PVstRunFileData;
begin
    // 管理模式
  if IsManage_File then
  begin
    if Button = mbRight then // 退出管理模式
      FileManagerLeave;
    Exit;
  end;

    // 进入管理模式
  if Button = mbRight then
  begin
    if vstFile.RootNodeCount > 0 then
      FileManagerEnter;
    Exit;
  end;

    // 快速启动模式
  SelectNode := vstFile.GetNodeAt( X, Y );
  if Assigned( SelectNode ) then
  begin
    NodeData := vstFile.GetNodeData( SelectNode );
    vstFile.Cursor := crHourGlass;
    MyExplorer.RunFile( NodeData.FilePath );
    vstFile.Cursor := crDefault;
    FaceFileRunApi.MoveToTop( NodeData.FilePath );
    tmrFileSelect.Enabled := True;
    AddBat( NodeData.FilePath );
    CheckHideForm;
  end;
end;

procedure TFrameMyRun.vstFileMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  SelectNode : PVirtualNode;
begin
    // 管理模式
  if IsManage_File then
    Exit;

    // 快速启动模式
  SelectNode := vstFile.GetNodeAt( X, Y );
  if Assigned( SelectNode ) then
    vstFile.Cursor := crHandPoint
  else
    vstFile.Cursor := crDefault;
end;

procedure TFrameMyRun.vstFolderChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  btnFolderRemove.Enabled := Sender.CheckedCount > 0;
end;

procedure TFrameMyRun.vstFolderGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstRunFolderData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TFrameMyRun.vstFolderGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstRunFolderData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.ShowName
  else
  if Column = 1 then
    CellText := NodeData.ShowDir;
end;

procedure TFrameMyRun.vstFolderMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  SelectNode : PVirtualNode;
  NodeData : PVstRunFolderData;
begin
    // 管理模式
  if IsManage_Folder then
  begin
    if Button = mbRight then // 退出管理模式
      FolderManagerLeave;
    Exit;
  end;

    // 进入管理模式
  if Button = mbRight then
  begin
    if vstFolder.RootNodeCount > 0 then
      FolderManagerEnter;
    Exit;
  end;

    // 快速启动模式
  SelectNode := vstFolder.GetNodeAt( X, Y );
  if Assigned( SelectNode ) then
  begin
    NodeData := vstFolder.GetNodeData( SelectNode );
    vstFolder.Cursor := crHourGlass;
    MyExplorer.ShowFolder( NodeData.FolderPath );
    vstFolder.Cursor := crDefault;
    FaceFolderRunApi.MoveToTop( NodeData.FolderPath );
    tmrFolderSelect.Enabled := True;
    AddBat( NodeData.FolderPath );
    CheckHideForm;
  end;
end;

procedure TFrameMyRun.vstFolderMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  SelectNode : PVirtualNode;
begin
    // 管理模式
  if IsManage_Folder then
    Exit;

    // 快速启动模式
  SelectNode := vstFolder.GetNodeAt( X, Y );
  if Assigned( SelectNode ) then
    vstFolder.Cursor := crHandPoint
  else
    vstFolder.Cursor := crDefault;
end;

{ UserBatRunApi }

class procedure UserBatRunApi.AddBat(BatPathList: TStringList);
begin
  if not FaceBatRunApi.ReadBatExist( BatPathList ) then
  begin
      // 只保存十个历史
    if FaceBatRunApi.ReadBatCount >= 10 then
      FaceBatRunApi.RemoveLastBat;

      // 添加
    FaceBatRunApi.AddBat( BatPathList );
    if FaceBatRunApi.ReadBatCount = 1 then  // 第一个 Item
      ShowBatPanel;
  end;
end;

class procedure UserBatRunApi.HideBatPanel;
begin
  with Frame_MyRun do
  begin
    plBat.Visible := False;
    slBat.Visible := False;
  end;
end;

class procedure UserBatRunApi.RemoveBat(BatPathList : TStringList);
begin
  FaceBatRunApi.RemoveBat( BatPathList );
  if FaceBatRunApi.ReadBatCount = 0 then  // 第一个 Item
    HideBatPanel;
end;

class procedure UserBatRunApi.ShowBatPanel;
begin
  with Frame_MyRun do
  begin
    plBat.Visible := True;
    slBat.Top := 0;
    slBat.Visible := True;
  end;
end;

{ TFaceBatRunApi }

procedure TFaceBatRunApi.AddBat(BatPathList: TStringList);
var
  NewNode : PVirtualNode;
  NodeData : PVstRunBatData;
  i: Integer;
  FolderPath, ShowName : string;
  ShowIcon : Integer;
begin
  NewNode := vstBat.InsertNode( vstBat.RootNode, amAddChildFirst );
  vstBat.CheckType[ NewNode ] := ctTriStateCheckBox;
  vstBat.CheckState[ NewNode ] := csUncheckedNormal;
  NodeData := vstBat.GetNodeData( NewNode );
  NodeData.PathCount := BatPathList.Count;
  for i := 0 to 4 do
  begin
    if BatPathList.Count > i then
    begin
      FolderPath := BatPathList[i];
      ShowName := MyFilePath.getName( FolderPath );
      ShowIcon := MyIcon.getPathIcon( FolderPath, FileExists( FolderPath ) );
    end
    else
    begin
      ShowName := '';
      ShowIcon := -1;
    end;
    if i = 0 then
    begin
      NodeData.FolderPath1 := FolderPath;
      NodeData.ShowName1 := ShowName;
      NodeData.ShowIcon1 := ShowIcon;
    end
    else
    if i = 1 then
    begin
      NodeData.FolderPath2 := FolderPath;
      NodeData.ShowName2 := ShowName;
      NodeData.ShowIcon2 := ShowIcon;
    end
    else
    if i = 2 then
    begin
      NodeData.FolderPath3 := FolderPath;
      NodeData.ShowName3 := ShowName;
      NodeData.ShowIcon3 := ShowIcon;
    end
    else
    if i = 3 then
    begin
      NodeData.FolderPath4 := FolderPath;
      NodeData.ShowName4 := ShowName;
      NodeData.ShowIcon4 := ShowIcon;
    end
    else
    if i = 4 then
    begin
      NodeData.FolderPath5 := FolderPath;
      NodeData.ShowName5 := ShowName;
      NodeData.ShowIcon5 := ShowIcon;
    end;
  end;
end;

constructor TFaceBatRunApi.Create;
begin
  vstBat := Frame_MyRun.vstBat;
  vstBat.NodeDataSize := SizeOf( TVstRunBatData );
  vstBat.Images := MyIcon.getSysIcon;
end;

function TFaceBatRunApi.ReadBatCount: Integer;
begin
  Result := vstBat.RootNodeCount;
end;

function TFaceBatRunApi.ReadBatExist(BatPathList: TStringList): Boolean;
begin
  Result := Assigned( ReadBstNode( BatPathList ) );
end;

function TFaceBatRunApi.ReadBatList: TBatList;
var
  BatInfo : TBatInfo;
  SelectNode : PVirtualNode;
  i: Integer;
  PathList : TStringList;
begin
  Result := TBatList.Create;
  SelectNode := vstBat.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    BatInfo := TBatInfo.Create;
    PathList := ReadPathList( SelectNode );
    for i := 0 to PathList.Count - 1 do
      BatInfo.AddPath( PathList[i] );
    PathList.Free;
    Result.Add( BatInfo );

    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceBatRunApi.ReadBstNode(BatPathList: TStringList): PVirtualNode;
var
  PathCount : Integer;
  SelectNode : PVirtualNode;
  NodeData : PVstRunBatData;
  i: Integer;
  SelectPath : string;
  IsMatch : Boolean;
begin
  Result := nil;
  PathCount := BatPathList.Count;
  SelectNode := vstBat.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstBat.GetNodeData( SelectNode );
    if PathCount = NodeData.PathCount then
    begin
      IsMatch := True;
      for i := 1 to PathCount do
      begin
        if i = 1 then
          SelectPath := NodeData.FolderPath1
        else
        if i = 2 then
          SelectPath := NodeData.FolderPath2
        else
        if i = 3 then
          SelectPath := NodeData.FolderPath3
        else
        if i = 4 then
          SelectPath := NodeData.FolderPath4
        else
        if i = 5 then
          SelectPath := NodeData.FolderPath5;
        if BatPathList.IndexOf( SelectPath ) < 0 then
        begin
          IsMatch := False;
          Break;
        end;
      end;
      if IsMatch then
      begin
        Result := SelectNode;
        Break;
      end;
    end;
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceBatRunApi.ReadCheckBatList: TBatList;
var
  BatInfo : TBatInfo;
  SelectNode : PVirtualNode;
  i: Integer;
  PathList : TStringList;
begin
  Result := TBatList.Create;
  SelectNode := vstBat.GetFirstChecked;
  while Assigned( SelectNode ) do
  begin
    BatInfo := TBatInfo.Create;
    PathList := ReadPathList( SelectNode );
    for i := 0 to PathList.Count - 1 do
      BatInfo.AddPath( PathList[i] );
    PathList.Free;
    Result.Add( BatInfo );

    SelectNode := vstBat.GetNextChecked( SelectNode );
  end;
end;

function TFaceBatRunApi.ReadPathList(Node: PVirtualNode): TStringList;
var
  NodeData : PVstRunBatData;
  i : Integer;
  SelectPath : string;
begin
  Result := TStringList.Create;
  NodeData := vstBat.GetNodeData( Node );
  for i := 1 to NodeData.PathCount do
  begin
    if i = 1 then
      SelectPath := NodeData.FolderPath1
    else
    if i = 2 then
      SelectPath := NodeData.FolderPath2
    else
    if i = 3 then
      SelectPath := NodeData.FolderPath3
    else
    if i = 4 then
      SelectPath := NodeData.FolderPath4
    else
    if i = 5 then
      SelectPath := NodeData.FolderPath5;
    Result.Add( SelectPath );
  end;
end;

procedure TFaceBatRunApi.RemoveBat(BatPathList: TStringList);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadBstNode( BatPathList );
  if not Assigned( SelectNode ) then
    Exit;
  vstBat.DeleteNode( SelectNode );
end;

procedure TFaceBatRunApi.RemoveLastBat;
begin
  if Assigned( vstBat.RootNode.LastChild ) then
    vstBat.DeleteNode( vstBat.RootNode.LastChild );
end;

{ TBatList }

procedure TBatInfo.AddPath(Path: string);
begin
  PathList.Add( Path );
end;

constructor TBatInfo.Create;
begin
  PathList := TStringList.Create;
end;

destructor TBatInfo.Destroy;
begin
  PathList.Free;
  inherited;
end;

end.
