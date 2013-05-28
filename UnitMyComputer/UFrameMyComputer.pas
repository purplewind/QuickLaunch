unit UFrameMyComputer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzTabs,
  VirtualTrees, Vcl.ImgList, UFrameExplorer, Vcl.Menus, IOUtils, Types, Generics.Collections;

type
  TFrameMyComputer = class(TFrame)
    plMain: TPanel;
    plLeft: TPanel;
    plCenter: TPanel;
    vstDriver: TVirtualStringTree;
    slMain: TSplitter;
    pmTab: TPopupMenu;
    miCloseOther: TMenuItem;
    miCloseLeft: TMenuItem;
    miCloseRight: TMenuItem;
    vstHistory: TVirtualStringTree;
    slHistory: TSplitter;
    miAddFavorite: TMenuItem;
    miSplit1: TMenuItem;
    miRemoveFavorite: TMenuItem;
    vstFileMove: TVirtualStringTree;
    PcMain: TRzPageControl;
    Image16: TImageList;
    miAddPath: TMenuItem;
    procedure vstDriverGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstDriverGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstDriverMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PcMainClose(Sender: TObject; var AllowClose: Boolean);
    procedure miCloseOtherClick(Sender: TObject);
    procedure miCloseLeftClick(Sender: TObject);
    procedure miCloseRightClick(Sender: TObject);
    procedure vstHistoryGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstHistoryGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstHistoryMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pmTabPopup(Sender: TObject);
    procedure miAddFavoriteClick(Sender: TObject);
    procedure miRemoveFavoriteClick(Sender: TObject);
    procedure vstFileMoveGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstFileMoveGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure miInputClick(Sender: TObject);
    procedure PcMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PcMainDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure vstHistoryMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure miAddPathClick(Sender: TObject);
  public       // 配置的读写
    procedure SaveIni;
    procedure LoadIni;
  public        // 初始化/释放资源
    procedure IniFrame;
    procedure UniniFrame;
  end;

{$Region ' 直接复制文件 ' }

    // 复制信息
  TCopyPathInfo = class
  public
    SourcePath, DesPath : string;
  public
    constructor Create( _SourcePath, _DesPath : string );
  end;
  TCopyPathList = class( TObjectList<TCopyPathInfo> )end;

    // 复制父类处理
  TUserCopyBaseHandle = class
  public
    SourceFileList : TStringList;
    DesFolder : string;
  public
    CopyPathList : TCopyPathList;
  public
    constructor Create( _SourceFileList : TStringList; _DesFolder : string );
    procedure Update;
    destructor Destroy; override;
  private
    function IsExistConflict : Boolean;
    function ConfirmConflict : Boolean;
    procedure FileHandle;virtual;abstract;
  end;

    // 复制处理
  TUserCopyHandle = class( TUserCopyBaseHandle )
  private
    procedure FileHandle;override;
  end;

    // 移动处理
  TUserMoveHandle = class( TUserCopyBaseHandle )
  private
    procedure FileHandle;override;
  end;

    // 用户操作
  UserCopyUtil = class
  public
    class procedure Copy( SourceFileList : TStringList; DesFolder : string );
    class procedure Move( SourceFileList : TStringList; DesFolder : string );
  end;

{$EndRegion}


{$Region ' 界面 数据 ' }

    // 磁盘数据
  TVstDriverData = record
  public
    DriverPath : WideString;
  public
    DriverName : WideString;
    DriverIcon : Integer;
  end;
  PVstDriverData = ^TVstDriverData;

    // 文件夹页面数据
  TTsFolderData = class
  public
    Path : string;
    FrameExplorer : TFrameExplorer;
  end;

    // 文件夹历史
  TVstFolderHistoryData = record
  public
    FolderPath : WideString;
    IsFavorite : Boolean;
  public
    ShowName : WideString;
    ShowIcon, FavoriteIcon : Integer;
  end;
  PVstFolderHistoryData = ^TVstFolderHistoryData;

    // 文件移动
  TVstFileMoveData = record
  public
    FilePath : WideString;
    ActionType, DesFilePath : WideString;
  public
    ShowName, ActionName : WideString;
    ShowIcon, ActionIcon : Integer;
  public
    ActionID : WideString;
  end;
  PVstFileMoveData = ^TVstFileMoveData;

{$EndRegion}

{$Region ' 界面 接口 ' }

    // Driver 界面接口
  TFaceDriverApi = class
  private
    VstDriver : TVirtualStringTree;
  public
    constructor Create;
  public
    procedure ClearDrivers;  // 清空磁盘
    procedure AddDriver( Path : string ); // 添加磁盘
    procedure AddOther( Path, ShowName : string; ShowIcon : Integer ) ; // 添加特殊路径
  public
    function ReadDriverList : TStringList; // 读取磁盘列表
  end;

    // 目录页面 界面接口
  TFaceFolderPageApi = class
  private
    PcMain : TRzPageControl;
    LastControlPage : string;
  public
    constructor Create;
  public
    procedure AddPage( Path : string );  // 添加页面
    procedure RemovePage( Path : string );  // 删除页面
    function ActivatePage( Path : string ): Boolean;  // 激活页面
    procedure EnterPage( OldPath, NewPath : string ); // 页面替换
  public
    procedure MoveActivatePage; // 移动激活的页面
    function ReadPageCount : Integer;  // 读取页面数
    function ControlPage( Path : string ): Boolean; // 控制某一页面
  public
    function ReadActivatePath : string;  // 获取选择页面的路径
    function ReadOtherPageList( Path : string ): TStringList; // 读取其他页面
    function ReadLeftPageList( Path : string ): TStringList;  // 读取左边页面
    function ReadRightPageList( Path : string ): TStringList; // 读取右边页面
    function ReadPageList : TStringList; // 读取所有页面
  private
    function ReadPage( Path : string ): TRzTabSheet;  // 获取页面
  end;

    // 历史记录置顶
  THistoryMoveToTopHandle = class
  public
    vstHistory : TVirtualStringTree;
    HistoryNode : PVirtualNode;
  public
    constructor Create( _HistoryNode : PVirtualNode );
    procedure SetVstHistory( _vstHistory : TVirtualStringTree );
    procedure Update;
  private
    function ReadLastFavorite : PVirtualNode;
  end;

    // 历史记录最大值确认
  THistoryConfirmMaxCountHandle = class
  public
    VstHistory : TVirtualStringTree;
  public
    constructor Create( _VstHistory : TVirtualStringTree );
    procedure Update;
  private
    function ReadFavoriteCount : Integer;
  end;

    // 历史记录 界面接口
  TFaceHistoryFolderApi = class
  private
    VstHistory : TVirtualStringTree;
  public
    constructor Create;
  public
    procedure AddHistory( Path : string ); // 添加历史记录
    procedure RemoveHistory( Path : string ); // 添加历史记录
    procedure SetFavorite( Path : string; IsFavorite : Boolean );  // 设置我的最爱
  public
    function ReadIsExist( Path : string ): Boolean;  // 是否存在历史
    procedure MoveToTop( Path : string );  // 移到最顶
    procedure ConfirmMaxCount; // 如果超过历史记录最大值，则删除部分节点
    function ReadIsFavorite( Path : string ): Boolean; // 是否收藏
    function ReadHistoryCount : Integer; // 读取历史记录数目
    function ReadHistoryList : TStringList; // 读取历史列表
    function ReadFavoriteList : TStringList; // 读取收藏列表
    function ReadNotFavoriteList : TStringList; // 读取非收藏列表
  private
    function ReadNode( Path : string ): PVirtualNode; // 获取节点
    function ReadFavoriteIcon( IsFavorite : Boolean ): Integer;  // 获取图标
  end;

  TFileMoveAddParams = record
  public
    FilePath, ActionType : string;
    DesFilePath : string;
  public
    ActionID : string;
  end;

    // 文件移动 界面接口
  TFaceFileMoveApi = class
  public
    vstFileMove : TVirtualStringTree;
    AcionIDNow : Integer;
  public
    constructor Create;
  public
    procedure AddWaiting( Params : TFileMoveAddParams );
    procedure RemoveWaiting( ActionID : string );
    function ReadActionID : string;
    function ReadAcionCount : Integer;
  private
    function ReadNode( AcionID : string ): PVirtualNode;
    function ReadActionName( ActionType : string ): string;
    function ReadActionIcon( ActionType : string ): Integer;
  end;

{$EndRegion}

{$Region ' 用户 接口 ' }

    // Frame 界面操作
  UserMyComputerFrameApi = class
  public   // 显示/隐藏 文件夹页面
    class procedure ShowFolderPage;
    class procedure HideFolderPage;
  public   // 显示/隐藏 历史界面
    class procedure ShowHistoryPanel;
    class procedure HideHistoryPanel;
  public   // 显示/隐藏 文件移动界面
    class procedure ShowFileMovePanel;
    class procedure HideFileMovePanel;
  end;

    // 硬盘 操作
  UserDriverApi = class
  public            // 刷新磁盘
    class procedure RefreshDriverList;
  public
    class procedure InputPath;
  end;

    // 文件夹页面 操作
  UserFolderPageApi = class
  public
    class procedure AddPage( Path : string );  // 添加页面
    class procedure EnterPage( OldPath, NewPath : string ); // 页面替换
  public
    class procedure RemovaActivatePage; // 删除当前页
    class procedure RemoveOtherPage;  // 删除其他页面
    class procedure RemoveLeftPage;   // 删除左边页面
    class procedure RemoveRightPage;  // 删除右边页面
    class procedure RefreshPage; // 移除不存在的页面
  private
    class procedure RemovePage( Path : string );  // 删除页面
  end;

    // 历史文件夹 操作
  UserHistoryFolderApi = class
  public
    class procedure AddHistory( Path : string ); // 添加历史
    class procedure RemoveHistory( Path : string ); // 删除历史
    class procedure SetFavorite( Path : string; IsFavorite : Boolean );  // 设置收藏
  public
    class procedure HistoryManager; // 管理历史记录
  end;

    // 文件移动 操作
  UserFileMoveApi = class
  public
    class procedure FileCopy( FilePath, DesFilePath : string );
    class procedure FileMove( FilePath, DesFilePath : string );
    class procedure FileDelete( FilePath : string );
  public
    class procedure FileZip( FileList : TStringList; ZipPath : string );
    class procedure File7Zip( FileList : TStringList; ZipPath : string );
    class procedure FileUnzip( ZipPath, FolderPath : string );
  public
    class procedure RemoveAction( ActionID : string );
  private
    class function AddFaceNode( FilePath, DesFilePath, ActionType : string ): string;
  end;

{$EndRegion}

var
  Show_Desktop : string = '桌面';

  FileAcionStatusShow_Waiting : string = '等待';
  FileAcionShow_Copy : string = '复制';
  FileAcionShow_Move : string = '移动';
  FileAcionShow_Delete : string = '删除';
  FileAcionShow_Zip : string = '压缩';
  FileAcionShow_UnZip : string = '解压';

  NewTab_Title : string = '输入要打开的目录';
  NewTab_Name : string = '目录路径';
  NewTab_NotExist : string = '目录不存在';

  Rename_Title : string = '重命名';
  Rename_Name : string = '输入文件名';
  Rename_Exist : string = '路径已存在';

  NewFolder_Title : string = '新建文件夹';
  NewFolder_Name : string = '输入文件夹名';
  NewFolder_DefaultName : string = '新建文件夹';

  DeleteFile_Comfirm : string = '删除确认';

const
  FileAction_Copy = 'Copy';
  FileAction_Move = 'Move';
  FileAction_Delete = 'Delete';
  FileAction_Zip = 'Zip';
  FileAction_Unzip = 'Unzip';

const
  HistoryCount_Max = 20;

const
  Ini_FrameMyComputer = 'FrameMyComputer';

    // 文件夹页面
  Ini_FolderPageCount = 'FolderPageCount';
  Ini_FolderPage = 'FolderPage';
  Ini_FolderPageActivate = 'FolderPageActivate';

    // 历史记录
  Ini_HistoryFolderCount = 'HistoryFolderCount';
  Ini_HistoryFolder = 'HistoryFolder';

    // 收藏记录
  Ini_FavoriteFolderCount = 'FavoriteFolderCount';
  Ini_FavoriteFolder = 'FavoriteFolder';

    // 控件位置
  Ini_PanelLeftWidth = 'PanelLeftWidth';
  Ini_HistoryHeight = 'HistoryHeight';

const
  VstFileMove_FileName = 0;
  VstFileMove_FileAction = 1;

var
  FaceDriverApi : TFaceDriverApi;  // 磁盘界面接口
  FaceFolderPageApi : TFaceFolderPageApi; // 文件夹页面接口
  FaceHistoryFolderApi : TFaceHistoryFolderApi; // 历史记录接口
  FaceFileMoveApi : TFaceFileMoveApi; // 文件移动接口

var
  Frame_MyComputer : TFrameMyComputer;

implementation

uses UMyIcon, UMyFaceThread, UMyUtil, IniFiles, UFormDestination, UFileThread,
     ClipBrd, UFormHistoryManage, UFormConflict;

{$R *.dfm}

{ TFrameMyComputer }

procedure TFrameMyComputer.IniFrame;
begin
    // 设置全局变量
  Frame_MyComputer := Self;

    // 创建界面接口
  FaceDriverApi := TFaceDriverApi.Create;
  FaceFolderPageApi := TFaceFolderPageApi.Create;
  FaceHistoryFolderApi := TFaceHistoryFolderApi.Create;
  FaceFileMoveApi := TFaceFileMoveApi.Create;

    // 创建界面接口
  FaceFrameExplorerApi := TFaceFrameExplorerApi.Create;
  FaceFileListApi := TFaceFileListApi.Create;
  FaceFileFilterApi := TFaceFileFilterApi.Create;
  FacePreviewApi := TFacePreviewApi.Create;
  FacePreviewExtApi := TFacePreviewExtApi.Create;

    // 读取配置信息
  LoadIni;

    // 刷新磁盘列表
  UserDriverApi.RefreshDriverList;
end;

procedure TFrameMyComputer.LoadIni;
var
  IniFile : TIniFile;
  PathCount, i: Integer;
  Path : string;
begin
  IniFile := TIniFile.Create( MyAppData.getConfigPath );
  try
      // 读取 位置
    plLeft.Width := IniFile.ReadInteger( Ini_FrameMyComputer, Ini_PanelLeftWidth, plLeft.Width );

      // 读取 历史的位置
    vstHistory.Height := IniFile.ReadInteger( Ini_FrameMyComputer, Ini_HistoryHeight, vstHistory.Height );

      // 读取 文件夹页面
    PathCount := IniFile.ReadInteger( Ini_FrameMyComputer, Ini_FolderPageCount, 0 );
    for i := 0 to PathCount - 1 do
    begin
      Path := IniFile.ReadString( Ini_FrameMyComputer, Ini_FolderPage + IntToStr(i), '' );
      if Path <> '' then
        UserFolderPageApi.AddPage( Path );
    end;

      // 读取当前激活路径
    Path := IniFile.ReadString( Ini_FrameMyComputer, Ini_FolderPageActivate, '' );
    if Path <> '' then
      FaceFolderPageApi.ActivatePage( Path );

      // 不存在任何页面
    if PathCount = 0 then
      UserMyComputerFrameApi.HideFolderPage;

      // 读取 历史文件夹
    PathCount := IniFile.ReadInteger( Ini_FrameMyComputer, Ini_HistoryFolderCount, 0 );
    for i := PathCount - 1 downto 0 do
    begin
      Path := IniFile.ReadString( Ini_FrameMyComputer, Ini_HistoryFolder + IntToStr(i), '' );
      if Path <> '' then
        UserHistoryFolderApi.AddHistory( Path );
    end;

      // 不存在任何历史
    if PathCount = 0 then
      UserMyComputerFrameApi.HideHistoryPanel;

      // 读取 收藏夹
    PathCount := IniFile.ReadInteger( Ini_FrameMyComputer, Ini_FavoriteFolderCount, 0 );
    for i := PathCount - 1 downto 0 do
    begin
      Path := IniFile.ReadString( Ini_FrameMyComputer, Ini_FavoriteFolder + IntToStr(i), '' );
      if Path <> '' then
        UserHistoryFolderApi.SetFavorite( Path, True );
    end;
  except
  end;
  IniFile.Free;
end;

procedure TFrameMyComputer.miAddFavoriteClick(Sender: TObject);
var
  PagaData : TTsFolderData;
begin
  if not Assigned( PcMain.ActivePage ) then
    Exit;
  PagaData := PcMain.ActivePage.Data;
  UserHistoryFolderApi.SetFavorite( PagaData.Path, True );
end;

procedure TFrameMyComputer.miAddPathClick(Sender: TObject);
begin
  UserDriverApi.InputPath;
end;

procedure TFrameMyComputer.miCloseLeftClick(Sender: TObject);
begin
  UserFolderPageApi.RemoveLeftPage;
end;

procedure TFrameMyComputer.miCloseOtherClick(Sender: TObject);
begin
  UserFolderPageApi.RemoveOtherPage;
end;

procedure TFrameMyComputer.miCloseRightClick(Sender: TObject);
begin
  UserFolderPageApi.RemoveRightPage;
end;

procedure TFrameMyComputer.miRemoveFavoriteClick(Sender: TObject);
var
  PagaData : TTsFolderData;
begin
  if not Assigned( PcMain.ActivePage ) then
    Exit;
  PagaData := PcMain.ActivePage.Data;
  UserHistoryFolderApi.SetFavorite( PagaData.Path, False );
end;

procedure TFrameMyComputer.miInputClick(Sender: TObject);
var
  FolderPath : string;
begin
  try
    FolderPath := Clipboard.AsText;
    if FileExists( FolderPath ) then
      FolderPath := ExtractFileDir( FolderPath )
    else
    if not DirectoryExists( FolderPath ) then
      FolderPath := '';
  except
    FolderPath := '';
  end;
  while InputQuery( NewTab_Title, NewTab_Name, FolderPath ) do
  begin
    if not DirectoryExists( FolderPath ) then
    begin
      MyMessageForm.ShowWarnning( NewTab_NotExist );
      Continue;
    end;
    UserFolderPageApi.AddPage( FolderPath );
    Break;
  end;
end;

procedure TFrameMyComputer.PcMainClose(Sender: TObject;
  var AllowClose: Boolean);
begin
  AllowClose := False;

    // 删除
  UserFolderPageApi.RemovaActivatePage;
end;

procedure TFrameMyComputer.PcMainDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  TabIndex : Integer;
  PageData, SourceData : TTsFolderData;
  SourceFolder, TargeFolder : string;
begin
    // 源目录
  SourceData := PcMain.ActivePage.Data;
  SourceFolder := SourceData.Path;

    // 目标位置
  TabIndex := PcMain.TabAtPos( x, y );
  if TabIndex < 0 then  // 没有明确的目标，打开目录
  begin
    UserFileListApi.OpenSelected( SourceFolder );
    Exit;
  end;

    // 复制到目标位置
  PageData := PcMain.Pages[ TabIndex ].Data;
  TargeFolder := PageData.Path;  // 目标目录

    // 复制选择的文件
  UserFileListApi.CopySelected( SourceFolder, TargeFolder );

    // 切换页面
  PcMain.ActivePageIndex := TabIndex;
end;

procedure TFrameMyComputer.PcMainMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  TabIndex : Integer;
  IsFocuse : Boolean;
begin
  if Button <> mbRight then
    Exit;

  TabIndex := PcMain.TabAtPos( x, y );
  IsFocuse := TabIndex >= 0;

  miCloseOther.Visible := IsFocuse;
  miCloseLeft.Visible := IsFocuse;
  miCloseRight.Visible := IsFocuse;
  miSplit1.Visible := IsFocuse;
  miAddFavorite.Visible := IsFocuse;
  miRemoveFavorite.Visible := IsFocuse;
  miAddPath.Visible := not IsFocuse;
end;

procedure TFrameMyComputer.pmTabPopup(Sender: TObject);
var
  PagaData : TTsFolderData;
  IsFavorite : Boolean;
begin
  if not Assigned( PcMain.ActivePage ) then
    Exit;
  if not miAddFavorite.Visible then
    Exit;

  miCloseOther.Visible := PcMain.PageCount > 1;
  miCloseLeft.Visible := PcMain.ActivePageIndex <> 0;
  miCloseRight.Visible := PcMain.ActivePageIndex <> PcMain.PageCount - 1;

  PagaData := PcMain.ActivePage.Data;
  IsFavorite := FaceHistoryFolderApi.ReadIsFavorite( PagaData.Path );
  miAddFavorite.Visible := not IsFavorite and not MyFilePath.getIsRoot( PagaData.Path );
  miRemoveFavorite.Visible := IsFavorite;
end;

procedure TFrameMyComputer.SaveIni;
var
  IniFile : TIniFile;
  i: Integer;
  PathList : TStringList;
begin
  IniFile := TIniFile.Create( MyAppData.getConfigPath );
  try
      // 保存主页位置
    if plLeft.Align <> alClient then
      IniFile.WriteInteger( Ini_FrameMyComputer, Ini_PanelLeftWidth, plLeft.Width );

      // 保存历史的位置
    IniFile.WriteInteger( Ini_FrameMyComputer, Ini_HistoryHeight, vstHistory.Height );

      // 保存 页面
    PathList := FaceFolderPageApi.ReadPageList;
    IniFile.WriteInteger( Ini_FrameMyComputer, Ini_FolderPageCount, PathList.Count );
    for i := 0 to PathList.Count - 1 do
      IniFile.WriteString( Ini_FrameMyComputer, Ini_FolderPage + IntToStr(i), PathList[i] );
    PathList.Free;

      // 当前激活的路径
    IniFile.WriteString( Ini_FrameMyComputer, Ini_FolderPageActivate, FaceFolderPageApi.ReadActivatePath );

      // 保存 历史
    PathList := FaceHistoryFolderApi.ReadHistoryList;
    IniFile.WriteInteger( Ini_FrameMyComputer, Ini_HistoryFolderCount, PathList.Count );
    for i := 0 to PathList.Count - 1 do
      IniFile.WriteString( Ini_FrameMyComputer, Ini_HistoryFolder + IntToStr(i), PathList[i] );
    PathList.Free;

      // 保存 收藏
    PathList := FaceHistoryFolderApi.ReadFavoriteList;
    IniFile.WriteInteger( Ini_FrameMyComputer, Ini_FavoriteFolderCount, PathList.Count );
    for i := 0 to PathList.Count - 1 do
      IniFile.WriteString( Ini_FrameMyComputer, Ini_FavoriteFolder + IntToStr(i), PathList[i] );
    PathList.Free;
  except
  end;
  IniFile.Free;
end;

procedure TFrameMyComputer.UniniFrame;
var
  i: Integer;
  ObjData : TObject;
begin
    // 保存配置信息
  SaveIni;

    // 释放资源
  for i := 0 to PcMain.PageCount - 1 do
  begin
    ObjData := PcMain.Pages[i].Data;
    ObjData.Free;
  end;

    // 删除接口
  FacePreviewExtApi.Free;
  FacePreviewApi.Free;
  FaceFileListApi.Free;
  FaceFileFilterApi.Free;
  FaceFrameExplorerApi.Free;

    // 删除接口
  FaceFileMoveApi.Free;
  FaceHistoryFolderApi.Free;
  FaceFolderPageApi.Free;
  FaceDriverApi.Free;
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
    CellText := NodeData.DriverName
  else
    CellText := '';
end;

procedure TFrameMyComputer.vstDriverMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  SelectNode : PVirtualNode;
  NodeData : PVstDriverData;
begin
    // 右键
  if Button = mbRight then
  begin
      // 刷新磁盘
    UserDriverApi.RefreshDriverList;
    Exit;
  end;

  SelectNode := vstDriver.GetNodeAt( x, y );
  if not Assigned( SelectNode ) then
    Exit;
  NodeData := vstDriver.GetNodeData( SelectNode );

  UserFolderPageApi.AddPage( NodeData.DriverPath );
end;

procedure TFrameMyComputer.vstFileMoveGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstFileMoveData;
begin
  if (Kind = ikNormal) or (Kind = ikSelected) then
  begin
    NodeData := Sender.GetNodeData( Node );
    if Column = VstFileMove_FileName then
      ImageIndex := NodeData.ShowIcon
    else
    if Column = VstFileMove_FileAction then
      ImageIndex := NodeData.ActionIcon
    else
      ImageIndex := -1;
  end
  else
    ImageIndex := -1;
end;

procedure TFrameMyComputer.vstFileMoveGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstFileMoveData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = VstFileMove_FileName then
    CellText := NodeData.ShowName
  else
  if Column = VstFileMove_FileAction then
    CellText := NodeData.ActionName
  else
    CellText := '';
end;

procedure TFrameMyComputer.vstHistoryGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstFolderHistoryData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    if Column = 0 then
      ImageIndex := NodeData.ShowIcon
    else
    if Column = 1 then
      ImageIndex := NodeData.FavoriteIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TFrameMyComputer.vstHistoryGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstFolderHistoryData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.ShowName
  else
    CellText := '';
end;

procedure TFrameMyComputer.vstHistoryMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  SelectNode : PVirtualNode;
  NodeData : PVstFolderHistoryData;
begin
  if Button = mbRight then
  begin
    UserHistoryFolderApi.HistoryManager;
    Exit;
  end;

  SelectNode := vstHistory.GetNodeAt( X, Y );
  if not Assigned( SelectNode ) then
    Exit;

  NodeData := vstHistory.GetNodeData( SelectNode );

  if DirectoryExists( NodeData.FolderPath ) then
    UserFolderPageApi.AddPage( NodeData.FolderPath )
  else
    MyMessageForm.ShowWarnning( NewTab_NotExist );
end;

procedure TFrameMyComputer.vstHistoryMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  ShowHintStr : string;
  SelectNode : PVirtualNode;
  NodeData : PVstFolderHistoryData;
begin
  SelectNode := vstHistory.GetNodeAt( x, y );
  if Assigned( SelectNode ) then
  begin
    NodeData := vstHistory.GetNodeData( SelectNode );
    ShowHintStr := NodeData.FolderPath;
  end
  else
    ShowHintStr := '';
  if vstHistory.Hint <> ShowHintStr then
  begin
    vstHistory.Hint := ShowHintStr;
    Application.ActivateHint(Mouse.CursorPos);
  end;
end;

{ MainFormUtil }

class procedure UserDriverApi.InputPath;
var
  FolderPath : string;
begin
  try
    FolderPath := Clipboard.AsText;
    if FileExists( FolderPath ) then
      FolderPath := ExtractFileDir( FolderPath )
    else
    if not DirectoryExists( FolderPath ) then
      FolderPath := '';
  except
    FolderPath := '';
  end;
  while InputQuery( NewTab_Title, NewTab_Name, FolderPath ) do
  begin
    if FileExists( FolderPath ) then
      FolderPath := ExtractFileDir( FolderPath )
    else
    if not TDirectory.Exists( FolderPath ) then
    begin
      MyMessageForm.ShowWarnning( NewTab_NotExist );
      Continue;
    end;
    UserFolderPageApi.AddPage( FolderPath );
    Break;
  end;
end;

class procedure UserDriverApi.RefreshDriverList;
var
  DriverList : TStringDynArray;
  i: Integer;
begin
    // 清空界面
  FaceDriverApi.ClearDrivers;

    // 添加桌面
  FaceDriverApi.AddOther( MyFilePath.getDesktopPath, Show_Desktop, My32IconUtil.getDesktop );

    // 添加驱动器
  DriverList := TDirectory.GetLogicalDrives;
  for i := 0 to Length( DriverList ) - 1 do
    if MyFilePath.getDriverExist( DriverList[i] ) then
      FaceDriverApi.AddDriver( DriverList[i] );
end;

{ MyDriverControl }

class procedure UserMyComputerFrameApi.ShowFileMovePanel;
begin
  Frame_MyComputer.vstFileMove.Visible := True;
end;

class procedure UserMyComputerFrameApi.ShowFolderPage;
begin
  with Frame_MyComputer do
  begin
    plCenter.Visible := True;
    plLeft.Align := alLeft;
    plCenter.Align := alClient;
    slMain.Left := plLeft.Left + 100;
    slMain.Visible := True;
  end;
end;

class procedure UserMyComputerFrameApi.HideFileMovePanel;
begin
  Frame_MyComputer.vstFileMove.Visible := False;
end;

class procedure UserMyComputerFrameApi.HideFolderPage;
begin
  with Frame_MyComputer do
  begin
    slMain.Visible := False;
    plCenter.Align := alRight;
    plLeft.Align := alClient;
    plCenter.Visible := False;
  end;
end;

class procedure UserMyComputerFrameApi.HideHistoryPanel;
begin
  with Frame_MyComputer do
  begin
    vstHistory.Visible := False;
    slHistory.Visible := False;
  end;
end;

class procedure UserMyComputerFrameApi.ShowHistoryPanel;
begin
  with Frame_MyComputer do
  begin
    vstHistory.Visible := True;
    slHistory.Top := 0;
    slHistory.Visible := True;
  end;
end;

{ TFolderHistoryMoveUp }

constructor THistoryMoveToTopHandle.Create(_HistoryNode: PVirtualNode);
begin
  HistoryNode := _HistoryNode;
end;

function THistoryMoveToTopHandle.ReadLastFavorite: PVirtualNode;
var
  NodeData : PVstFolderHistoryData;
  SelectNode : PVirtualNode;
begin
  Result := nil;

    // 寻找最后一个收藏夹
  SelectNode := vstHistory.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstHistory.GetNodeData( SelectNode );
    if NodeData.IsFavorite then
      Result := SelectNode;
    SelectNode := SelectNode.NextSibling;
  end;
end;

procedure THistoryMoveToTopHandle.SetVstHistory(
  _vstHistory: TVirtualStringTree);
begin
  vstHistory := _vstHistory;
end;

procedure THistoryMoveToTopHandle.Update;
var
  NodeData : PVstFolderHistoryData;
  LastFavoriteNode : PVirtualNode;
begin
  vstHistory := Frame_MyComputer.vstHistory;
  NodeData := vstHistory.GetNodeData( HistoryNode );

    // 收藏夹
  if NodeData.IsFavorite then
    vstHistory.MoveTo( HistoryNode, vstHistory.RootNode, amAddChildFirst, False )
  else   // 历史记录
  begin
    LastFavoriteNode := ReadLastFavorite;
    if Assigned( LastFavoriteNode ) then
      vstHistory.MoveTo( HistoryNode, LastFavoriteNode, amInsertAfter, False )
    else
      vstHistory.MoveTo( HistoryNode, vstHistory.RootNode, amAddChildFirst, False );
  end;
end;

{ DriverFaceApi }

procedure TFaceDriverApi.AddDriver(Path: string);
var
  DriverNode : PVirtualNode;
  NodeData : PVstDriverData;
begin
  DriverNode := vstDriver.AddChild( vstDriver.RootNode );
  NodeData := vstDriver.GetNodeData( DriverNode );
  NodeData.DriverPath := Path;
  NodeData.DriverName := MyFilePath.getDriverName( Path );
  NodeData.DriverIcon := MyIcon.getFolderIcon( Path );
end;

procedure TFaceDriverApi.AddOther(Path, ShowName: string;
  ShowIcon : Integer);
var
  DriverNode : PVirtualNode;
  NodeData : PVstDriverData;
begin
  DriverNode := vstDriver.AddChild( vstDriver.RootNode );
  NodeData := vstDriver.GetNodeData( DriverNode );
  NodeData.DriverPath := Path;
  NodeData.DriverName := ShowName;
  NodeData.DriverIcon := ShowIcon;
end;

procedure TFaceDriverApi.ClearDrivers;
begin
  VstDriver.Clear;
end;

constructor TFaceDriverApi.Create;
begin
  VstDriver := Frame_MyComputer.vstDriver;
  vstDriver.NodeDataSize := SizeOf( TVstDriverData );
  vstDriver.Images := MyIcon.getSysIcon32;
end;

function TFaceDriverApi.ReadDriverList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstDriverData;
begin
  Result := TStringList.Create;

  SelectNode := VstDriver.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := VstDriver.GetNodeData( SelectNode );
    Result.Add( NodeData.DriverPath );
    SelectNode := SelectNode.NextSibling;
  end;
end;

{ FolderPageFaceApi }

function TFaceFolderPageApi.ActivatePage(Path: string): Boolean;
var
  Page : TRzTabSheet;
begin
  Page := ReadPage( Path );
  Result := Assigned( Page );
  if Result then
    PcMain.ActivePage := Page;
end;

procedure TFaceFolderPageApi.AddPage(Path: string);
var
  TsFolderData : TTsFolderData;
  NewPage : TRzTabSheet;
  FrameExplorer : TFrameExplorer;
begin
    // 创建 Page
  NewPage := TRzTabSheet.Create( PcMain );
  NewPage.Parent := PcMain;
  NewPage.PageControl := PcMain;
  NewPage.ImageIndex := 0;
  NewPage.Padding.Top := 5;
  NewPage.ShowHint := False;

    // 创建 目录页面的 Frame
  FrameExplorer := TFrameExplorer.Create( NewPage );
  FrameExplorer.Parent := NewPage;
  FrameExplorer.IniFrame;
  FrameExplorer.SetTsFolder( NewPage );

    // Page 数据结构
  TsFolderData := TTsFolderData.Create;
  TsFolderData.Path := Path;
  TsFolderData.FrameExplorer := FrameExplorer;
  NewPage.Data := TsFolderData;
end;

function TFaceFolderPageApi.ControlPage(Path: string): Boolean;
var
  SelectPage : TRzTabSheet;
  PageData : TTsFolderData;
  SelectFrame : TFrameExplorer;
begin
  Result := True;

    // 已存在
  if Path = LastControlPage then
    Exit;

    // 寻找页面
  SelectPage := ReadPage( Path );
  if not Assigned( SelectPage ) then
  begin
    Result := False;
    Exit;
  end;

    // 寻找页面的 Frame
  PageData := SelectPage.Data;
  SelectFrame := PageData.FrameExplorer;

    // 激活 Frame
  FaceFrameExplorerApi.ActivateFrame( SelectFrame );

    // 设置
  LastControlPage := Path;
end;

constructor TFaceFolderPageApi.Create;
begin
  PcMain := Frame_MyComputer.PcMain;
  LastControlPage := '';
end;

function TFaceFolderPageApi.ReadActivatePath: string;
var
  SelectPage : TRzTabSheet;
  PageData : TTsFolderData;
begin
  Result := '';
  SelectPage := PcMain.ActivePage;
  if not Assigned( SelectPage ) then
    Exit;
  PageData := SelectPage.Data;
  Result := PageData.Path;
end;

function TFaceFolderPageApi.ReadLeftPageList(Path: string): TStringList;
var
  i: Integer;
  PageData : TTsFolderData;
begin
  Result := TStringList.Create;
  for i := 0 to PcMain.PageCount - 1 do
  begin
    PageData := PcMain.Pages[i].Data;
    if PageData.Path = Path then
      Break;
    Result.Add( PageData.Path );
  end;
end;

function TFaceFolderPageApi.ReadOtherPageList(Path: string): TStringList;
var
  i: Integer;
  PageData : TTsFolderData;
begin
  Result := TStringList.Create;
  for i := PcMain.PageCount - 1 downto 0 do
  begin
    PageData := PcMain.Pages[i].Data;
    if PageData.Path <> Path then
      Result.Add( PageData.Path );
  end;
end;

function TFaceFolderPageApi.ReadPage(Path: string): TRzTabSheet;
var
  i : Integer;
  PageData : TTsFolderData;
begin
  Result := nil;
  for i := 0 to PcMain.PageCount - 1 do
  begin
    PageData := PcMain.Pages[i].Data;
    if PageData.Path = Path then
    begin
      Result := PcMain.Pages[i];
      Break;
    end;
  end;
end;

function TFaceFolderPageApi.ReadPageCount: Integer;
begin
  Result := PcMain.PageCount;
end;

function TFaceFolderPageApi.ReadPageList: TStringList;
var
  i: Integer;
  PageData : TTsFolderData;
begin
  Result := TStringList.Create;
  for i := 0 to PcMain.PageCount - 1 do
  begin
    PageData := PcMain.Pages[i].Data;
    Result.Add( PageData.Path );
  end;
end;

function TFaceFolderPageApi.ReadRightPageList(Path: string): TStringList;
var
  i: Integer;
  PageData : TTsFolderData;
begin
  Result := TStringList.Create;
  for i := PcMain.PageCount - 1 downto 0 do
  begin
    PageData := PcMain.Pages[i].Data;
    if PageData.Path = Path then
      Break;
    Result.Add( PageData.Path );
  end;
end;

procedure TFaceFolderPageApi.EnterPage(OldPath, NewPath : string);
var
  SelectPage : TRzTabSheet;
  PageData : TTsFolderData;
  FrameExplorer : TFrameExplorer;
begin
    // 读取页面
  SelectPage := ReadPage( OldPath );
  if not Assigned( SelectPage ) then
    Exit;

    // 设置 页面
  SelectPage.Hint := NewPath;
  SelectPage.Caption :=  MyFilePath.getName( NewPath );

    // 设置 页面 数据结构
  PageData := SelectPage.Data;
  PageData.Path := NewPath;

    // 设置 Frame
  FrameExplorer := PageData.FrameExplorer;
  FrameExplorer.SetFolderPath( NewPath );
  FrameExplorer.SetNotifyPath( NewPath );
  FrameExplorer.sbFolderPath.Panels[0].Text := NewPath;
  FrameExplorer.btnCopyPath.Caption := NewPath;

    // 清空旧信息
  FaceFolderPageApi.ControlPage( NewPath );
  FaceFrameExplorerApi.ClearSearchHistory;

    // 读取文件信息
  MyFaceJobHandler.ReadFileList( NewPath );
end;

procedure TFaceFolderPageApi.MoveActivatePage;
var
  ActivateIndex : Integer;
begin
  ActivateIndex := PcMain.ActivePageIndex;
  if ( ActivateIndex - 1 ) >= 0 then // 向左移
    PcMain.ActivePageIndex := ActivateIndex - 1
  else
  if ( ActivateIndex + 1 ) < PcMain.PageCount then  // 向右移
    PcMain.ActivePageIndex := ActivateIndex + 1;
end;

procedure TFaceFolderPageApi.RemovePage(Path: string);
var
  SelectPage : TRzTabSheet;
  PcExplorerData : TTsFolderData;
begin
    // 寻找页面
  SelectPage := ReadPage( Path );
  if not Assigned( SelectPage ) then
    Exit;

    // 删除数据
  PcExplorerData := SelectPage.Data;
  PcExplorerData.Free;

    // 删除页面
  SelectPage.Free;

    // 已删除
  if LastControlPage = Path then
    LastControlPage := '';
end;

{ FolderPageUserApi }

class procedure UserFolderPageApi.AddPage(Path: string);
begin
    // 页面已存在
  if FaceFolderPageApi.ActivatePage( Path ) then
    Exit;

    // 添加页面
  FaceFolderPageApi.AddPage( Path );

    // 激活页面
  FaceFolderPageApi.ActivatePage( Path );

    // 加载页面
  FaceFolderPageApi.EnterPage( Path, Path );

    // 出现了第一个页面，调整 Frame 布局
  if FaceFolderPageApi.ReadPageCount = 1 then
    UserMyComputerFrameApi.ShowFolderPage;
end;

class procedure UserFolderPageApi.EnterPage(OldPath, NewPath: string);
begin
    // 页面已存在
  if FaceFolderPageApi.ActivatePage( NewPath ) then
    Exit;

    // 刷新页面信息
  FaceFolderPageApi.EnterPage( OldPath, NewPath );
end;

class procedure UserFolderPageApi.RefreshPage;
var
  PageList : TStringList;
  i: Integer;
begin
  PageList := FaceFolderPageApi.ReadPageList;
  for i := 0 to PageList.Count - 1 do
    if not DirectoryExists( PageList[i] ) then  // 不存在则删除
      RemovePage( PageList[i] );
  PageList.Free;
end;

class procedure UserFolderPageApi.RemovaActivatePage;
begin
  RemovePage( FaceFolderPageApi.ReadActivatePath );
end;

class procedure UserFolderPageApi.RemoveLeftPage;
var
  Path : string;
  PageList : TStringList;
  i: Integer;
begin
    // 当前路径
  Path := FaceFolderPageApi.ReadActivatePath;

    // 获取当前路径左边
  PageList := FaceFolderPageApi.ReadLeftPageList( Path );
  for i := 0 to PageList.Count - 1 do
    RemovePage( PageList[i] );
  PageList.Free
end;


class procedure UserFolderPageApi.RemoveOtherPage;
var
  Path : string;
  PageList : TStringList;
  i: Integer;
begin
    // 当前路径
  Path := FaceFolderPageApi.ReadActivatePath;

    // 当前路径的其他路径
  PageList := FaceFolderPageApi.ReadOtherPageList( Path );
  for i := 0 to PageList.Count - 1 do
    RemovePage( PageList[i] );
  PageList.Free
end;

class procedure UserFolderPageApi.RemovePage(Path: string);
begin
    // 删除的是一个激活的页面，则先激活其他页面
  if FaceFolderPageApi.ReadActivatePath = Path then
    FaceFolderPageApi.MoveActivatePage;

    // 删除页面
  FaceFolderPageApi.RemovePage( Path );

    // 添加到历史中
  if not MyFilePath.getIsRoot( Path ) and ( Path <> MyFilePath.getDesktopPath ) then
    UserHistoryFolderApi.AddHistory( Path );

    // 不存在文件夹页面
  if FaceFolderPageApi.ReadPageCount = 0 then
    UserMyComputerFrameApi.HideFolderPage;

    // 缓冲一下
  Application.ProcessMessages;
end;

class procedure UserFolderPageApi.RemoveRightPage;
var
  Path : string;
  PageList : TStringList;
  i: Integer;
begin
    // 当前路径
  Path := FaceFolderPageApi.ReadActivatePath;

    // 当前路径的右边路径
  PageList := FaceFolderPageApi.ReadRightPageList( Path );
  for i := 0 to PageList.Count - 1 do
    RemovePage( PageList[i] );
  PageList.Free
end;


{ THistoryFaceApi }

procedure TFaceHistoryFolderApi.AddHistory(Path: string);
var
  SelectNode : PVirtualNode;
  NodeData : PVstFolderHistoryData;
begin
    // 新建节点
  SelectNode := vstHistory.AddChild( vstHistory.RootNode );
  NodeData := vstHistory.GetNodeData( SelectNode );
  NodeData.FolderPath := Path;
  NodeData.IsFavorite := False;
  NodeData.ShowName := MyFilePath.getName( Path );
  NodeData.ShowIcon := MyIcon.getFolderIcon( Path );
  NodeData.FavoriteIcon := ReadFavoriteIcon( False );
end;

procedure TFaceHistoryFolderApi.ConfirmMaxCount;
var
  HistoryConfirmMaxCountHandle : THistoryConfirmMaxCountHandle;
begin
  HistoryConfirmMaxCountHandle := THistoryConfirmMaxCountHandle.Create( VstHistory );
  HistoryConfirmMaxCountHandle.Update;
  HistoryConfirmMaxCountHandle.Free;
end;

constructor TFaceHistoryFolderApi.Create;
begin
  VstHistory := Frame_MyComputer.vstHistory;
  vstHistory.NodeDataSize := SizeOf( TVstFolderHistoryData );
  vstHistory.Images := MyIcon.getSysIcon;
end;

procedure TFaceHistoryFolderApi.MoveToTop(Path: string);
var
  HistoryNode : PVirtualNode;
  HistoryMoveToTopHandle : THistoryMoveToTopHandle;
begin
    // 读取节点
  HistoryNode := ReadNode( Path );
  if not Assigned( HistoryNode ) then
    Exit;

    // 节点置顶
  HistoryMoveToTopHandle := THistoryMoveToTopHandle.Create( HistoryNode );
  HistoryMoveToTopHandle.SetVstHistory( VstHistory );
  HistoryMoveToTopHandle.Update;
  HistoryMoveToTopHandle.Free;
end;

function TFaceHistoryFolderApi.ReadFavoriteIcon(IsFavorite: Boolean): Integer;
begin
  if IsFavorite then
    Result := My16IconUtil.getFavorite
  else
    Result := -1;
end;

function TFaceHistoryFolderApi.ReadFavoriteList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstFolderHistoryData;
begin
  Result := TStringList.Create;

  SelectNode := vstHistory.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstHistory.GetNodeData( SelectNode );
    if NodeData.IsFavorite then
      Result.Add( NodeData.FolderPath );
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceHistoryFolderApi.ReadHistoryCount: Integer;
begin
  Result := VstHistory.RootNode.ChildCount;
end;

function TFaceHistoryFolderApi.ReadHistoryList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstFolderHistoryData;
begin
  Result := TStringList.Create;

  SelectNode := vstHistory.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstHistory.GetNodeData( SelectNode );
    Result.Add( NodeData.FolderPath );
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceHistoryFolderApi.ReadIsExist(Path: string): Boolean;
begin
  Result := Assigned( ReadNode( Path ) );
end;

function TFaceHistoryFolderApi.ReadIsFavorite(Path: string): Boolean;
var
  SelectNode : PVirtualNode;
  NodeData : PVstFolderHistoryData;
begin
  Result := False;
  SelectNode := ReadNode( Path );
  if not Assigned( SelectNode ) then
    Exit;
  NodeData := VstHistory.GetNodeData( SelectNode );
  Result := NodeData.IsFavorite;
end;

function TFaceHistoryFolderApi.ReadNode(Path: string): PVirtualNode;
var
  SelectNode : PVirtualNode;
  NodeData : PVstFolderHistoryData;
begin
  Result := nil;

  SelectNode := vstHistory.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstHistory.GetNodeData( SelectNode );
    if NodeData.FolderPath = Path  then
    begin
      Result := SelectNode;
      Break;
    end;
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceHistoryFolderApi.ReadNotFavoriteList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstFolderHistoryData;
begin
  Result := TStringList.Create;

  SelectNode := vstHistory.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstHistory.GetNodeData( SelectNode );
    if not NodeData.IsFavorite then
      Result.Add( NodeData.FolderPath );
    SelectNode := SelectNode.NextSibling;
  end;
end;

procedure TFaceHistoryFolderApi.RemoveHistory(Path: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadNode( Path );
  if not Assigned( SelectNode ) then
    Exit;
  VstHistory.DeleteNode( SelectNode );
end;

procedure TFaceHistoryFolderApi.SetFavorite(Path: string; IsFavorite: Boolean);
var
  SelectNode : PVirtualNode;
  NodeData : PVstFolderHistoryData;
begin
  SelectNode := ReadNode( Path );
  if not Assigned( SelectNode ) then
    Exit;
  NodeData := VstHistory.GetNodeData( SelectNode );
  NodeData.IsFavorite := IsFavorite;
  NodeData.FavoriteIcon := ReadFavoriteIcon( IsFavorite );
  VstHistory.RepaintNode( SelectNode );
end;

{ THistoryConfirmMaxCountHandle }

constructor THistoryConfirmMaxCountHandle.Create(
  _VstHistory: TVirtualStringTree);
begin
  VstHistory := _VstHistory;
end;

function THistoryConfirmMaxCountHandle.ReadFavoriteCount: Integer;
var
  SelectNode : PVirtualNode;
  NodeData : PVstFolderHistoryData;
begin
  Result := 0;

  SelectNode := vstHistory.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstHistory.GetNodeData( SelectNode );
    if NodeData.IsFavorite then
      Inc( Result );
    SelectNode := SelectNode.NextSibling;
  end;
end;

procedure THistoryConfirmMaxCountHandle.Update;
var
  FavoriteCount, HistoryCount, RemoveCount : Integer;
  SelectNode, RemoveNode : PVirtualNode;
  NodeData : PVstFolderHistoryData;
begin
    // 收藏的文件夹数量
  FavoriteCount := ReadFavoriteCount;
  HistoryCount := vstHistory.RootNode.ChildCount - FavoriteCount;

    // 最大 20 个
  if HistoryCount < HistoryCount_Max then
    Exit;

    // 要删除的个数
  RemoveCount := HistoryCount - HistoryCount_Max + 1;

    // 删除
  SelectNode := vstHistory.RootNode.LastChild;
  while Assigned( SelectNode ) do
  begin
    RemoveNode := SelectNode;
    SelectNode := SelectNode.PrevSibling;

    NodeData := vstHistory.GetNodeData( RemoveNode );
    if not NodeData.IsFavorite then
      vstHistory.DeleteNode( RemoveNode );

    Dec( RemoveCount );
    if RemoveCount <= 0 then
      Break;
  end;
end;

{ HistoryFolderUserApi }

class procedure UserHistoryFolderApi.AddHistory(Path: string);
begin
    // 已存在，则置顶
  if FaceHistoryFolderApi.ReadIsExist( Path ) then
  begin
    FaceHistoryFolderApi.MoveToTop( Path );
    Exit;
  end;

    // 确认最大值
  FaceHistoryFolderApi.ConfirmMaxCount;

    // 添加
  FaceHistoryFolderApi.AddHistory( Path );

    // 置顶
  FaceHistoryFolderApi.MoveToTop( Path );

    // 显示历史面板
  if FaceHistoryFolderApi.ReadHistoryCount = 1 then
    UserMyComputerFrameApi.ShowHistoryPanel;
end;

class procedure UserHistoryFolderApi.HistoryManager;
var
  HistoryList : TStringList;
  HistoryCount : Integer;
  i: Integer;
begin
    // 添加历史记录
  HistoryList := FaceHistoryFolderApi.ReadNotFavoriteList;
  frmHistoryManger.ClearFolders;
  for i := 0 to HistoryList.Count - 1 do
    frmHistoryManger.AddFolder( HistoryList[i] );
  if HistoryList.Count >= 5 then
    frmHistoryManger.AddSelectAll;
  HistoryCount := HistoryList.Count;
  HistoryList.Free;

    // 没有历史记录
  if HistoryCount = 0 then
    Exit;

    // 用户选择
  if not frmHistoryManger.ReadDelete then
    Exit;

    // 删除历史记录
  HistoryList := frmHistoryManger.ReadPathList;
  for i := 0 to HistoryList.Count - 1 do
    RemoveHistory( HistoryList[i] );
  HistoryList.Free;
end;

class procedure UserHistoryFolderApi.RemoveHistory(Path: string);
begin
  FaceHistoryFolderApi.RemoveHistory( Path );
end;

class procedure UserHistoryFolderApi.SetFavorite(Path: string;
  IsFavorite: Boolean);
begin
    // 不存在则先添加
  if not FaceHistoryFolderApi.ReadIsExist( Path ) then
    AddHistory( Path );

    // 设置属性
  FaceHistoryFolderApi.SetFavorite( Path, IsFavorite );

    // 置顶
  FaceHistoryFolderApi.MoveToTop( Path );
end;

{ TFaceFileMoveApi }

procedure TFaceFileMoveApi.AddWaiting(Params: TFileMoveAddParams);
var
  FileMoveNode : PVirtualNode;
  NodeData : PVstFileMoveData;
begin
  FileMoveNode := vstFileMove.AddChild( vstFileMove.RootNode );
  NodeData := vstFileMove.GetNodeData( FileMoveNode );
  NodeData.FilePath := Params.FilePath;
  NodeData.DesFilePath := Params.DesFilePath;
  NodeData.ActionType := Params.ActionType;
  NodeData.ActionID := Params.ActionID;

  NodeData.ShowName := MyFilePath.getName( Params.FilePath );
  NodeData.ActionName := ReadActionName( Params.ActionType );
  NodeData.ShowIcon := MyIcon.getPathIcon( Params.FilePath, FileExists( Params.FilePath ) );
  NodeData.ActionIcon := ReadActionIcon( Params.ActionType );
end;

constructor TFaceFileMoveApi.Create;
begin
  vstFileMove := Frame_MyComputer.vstFileMove;
  vstFileMove.NodeDataSize := SizeOf( TVstFileMoveData );
  vstFileMove.Images := MyIcon.getSysIcon;
  AcionIDNow := 0;
end;

function TFaceFileMoveApi.ReadAcionCount: Integer;
begin
  Result := vstFileMove.RootNode.ChildCount;
end;

function TFaceFileMoveApi.ReadActionIcon(ActionType: string): Integer;
begin
  if ActionType = FileAction_Copy then
    Result := My16IconUtil.getCopy
  else
  if ActionType = FileAction_Move then
    Result := My16IconUtil.getMove
  else
  if ActionType = FileAction_Delete then
    Result := My16IconUtil.getDelete
  else
  if ActionType = FileAction_Zip then
    Result := My16IconUtil.getZip
  else
  if ActionType = FileAction_Unzip then
    Result := My16IconUtil.getZip;
end;

function TFaceFileMoveApi.ReadActionID: string;
begin
  Result := IntToStr( AcionIDNow );
  Inc( AcionIDNow );
end;

function TFaceFileMoveApi.ReadActionName(ActionType: string): string;
var
  ShowStatus, ShowAction : string;
begin
  if ActionType = FileAction_Copy then
    ShowAction := FileAcionShow_Copy
  else
  if ActionType = FileAction_Move then
    ShowAction := FileAcionShow_Move
  else
  if ActionType = FileAction_Delete then
    ShowAction := FileAcionShow_Delete
  else
  if ActionType = FileAction_Zip then
    ShowAction := FileAcionShow_Zip
  else
  if ActionType = FileAction_Unzip then
    ShowAction := FileAcionShow_Unzip;

  Result := FileAcionStatusShow_Waiting + ' ' + ShowAction;
end;

function TFaceFileMoveApi.ReadNode(AcionID: string): PVirtualNode;
var
  SelectNode : PVirtualNode;
  NodeData : PVstFileMoveData;
begin
  Result := nil;

  SelectNode := vstFileMove.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFileMove.GetNodeData( SelectNode );
    if NodeData.ActionID = AcionID  then
    begin
      Result := SelectNode;
      Break;
    end;
    SelectNode := SelectNode.NextSibling;
  end;
end;

procedure TFaceFileMoveApi.RemoveWaiting(ActionID: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadNode( ActionID );
  if not Assigned( SelectNode ) then
    Exit;
  vstFileMove.DeleteNode( SelectNode );
end;

{ UserFileMoveApi }

class function UserFileMoveApi.AddFaceNode(FilePath, DesFilePath,
  ActionType: string): string;
var
  Params : TFileMoveAddParams;
begin
  Result := '';
  if not MyFileJobHandler.ReadIsRunning then
    Exit;

  Result := FaceFileMoveApi.ReadActionID;
  Params.FilePath := FilePath;
  Params.DesFilePath := DesFilePath;
  Params.ActionType := ActionType;
  Params.ActionID := Result;
  FaceFileMoveApi.AddWaiting( Params );

    // 显示 正在等待
  if FaceFileMoveApi.ReadAcionCount = 1 then
    UserMyComputerFrameApi.ShowFileMovePanel;
end;

class procedure UserFileMoveApi.File7Zip(FileList: TStringList;
  ZipPath: string);
var
  ShowPath : string;
  ActionID : string;
begin
    // 界面显示的路径
  if FileList.Count > 0 then
    ShowPath := FileList[0];

    // 添加到界面
  ActionID := AddFaceNode( ShowPath, ZipPath, FileAction_Zip );

    // 添加到复制
  MyFileJobHandler.AddFile7Zip( FileList, ZipPath, ActionID );
end;

class procedure UserFileMoveApi.FileCopy(FilePath, DesFilePath: string);
var
  ActionID : string;
begin
    // 添加到界面
  ActionID := AddFaceNode( FilePath, DesFilePath, FileAction_Copy );

    // 添加到复制
  MyFileJobHandler.AddFleCopy( FilePath, DesFilePath, ActionID );
end;

class procedure UserFileMoveApi.FileDelete(FilePath: string);
var
  ActionID : string;
begin
    // 添加到界面
  ActionID := AddFaceNode( FilePath, '', FileAction_Delete );

    // 添加到移动
  MyFileJobHandler.AddFleDelete( FilePath, ActionID );
end;

class procedure UserFileMoveApi.FileMove(FilePath, DesFilePath: string);
var
  ActionID : string;
begin
    // 添加到界面
  ActionID := AddFaceNode( FilePath, DesFilePath, FileAction_Move );

    // 添加到移动
  MyFileJobHandler.AddFleMove( FilePath, DesFilePath, ActionID );
end;

class procedure UserFileMoveApi.FileUnzip(ZipPath, FolderPath: string);
var
  ActionID : string;
begin
    // 添加到界面
  ActionID := AddFaceNode( ZipPath, FolderPath, FileAction_UnZip );

    // 添加到复制
  MyFileJobHandler.AddFileUnzip( ZipPath, FolderPath, ActionID );
end;


class procedure UserFileMoveApi.FileZip(FileList: TStringList; ZipPath: string);
var
  ShowPath : string;
  ActionID : string;
begin
    // 界面显示的路径
  if FileList.Count > 0 then
    ShowPath := FileList[0];

    // 添加到界面
  ActionID := AddFaceNode( ShowPath, ZipPath, FileAction_Zip );

    // 添加到复制
  MyFileJobHandler.AddFileZip( FileList, ZipPath, ActionID );
end;

class procedure UserFileMoveApi.RemoveAction(ActionID: string);
begin
  if ActionID = '' then
    Exit;

    // 移除
  FaceFileMoveApi.RemoveWaiting( ActionID );

    // 隐藏正在等待
  if FaceFileMoveApi.ReadAcionCount = 0 then
    UserMyComputerFrameApi.HideFileMovePanel;
end;

{ UserCopyUtil }

class procedure UserCopyUtil.Copy(SourceFileList: TStringList;
  DesFolder: string);
var
  UserCopyHandle : TUserCopyHandle;
begin
  UserCopyHandle := TUserCopyHandle.Create( SourceFileList, DesFolder );
  UserCopyHandle.Update;
  UserCopyHandle.Free;
end;

{ UserCopyHandle }

function TUserCopyBaseHandle.ConfirmConflict: Boolean;
var
  i : Integer;
  TargetFolder : string;
  SourcePath, TargetPath : string;
  ActionType, DesPath : string;
begin
    // 处理冲突路径
  frmConflict.ClearConflictPaths;
  TargetFolder := MyFilePath.getPath( DesFolder );
  for i := 0 to SourceFileList.Count - 1 do
  begin
    SourcePath := SourceFileList[i];
    TargetPath := TargetFolder + ExtractFileName( SourcePath );
    if FileExists( TargetPath ) or DirectoryExists( TargetPath ) then
      frmConflict.AddConflictPath( SourcePath );
  end;
  Result := frmConflict.ReadConflict;

    // 取消复制
  if not Result then
    Exit;

    // 生成目标路径
  CopyPathList.Clear;
  for i := 0 to SourceFileList.Count - 1 do
  begin
    SourcePath := SourceFileList[i];
    ActionType := frmConflict.ReadConflictAction( SourcePath );
    if ( ActionType = ConflictAction_None ) or ( ActionType = ConflictAction_Replace ) then
      DesPath := TargetFolder + ExtractFileName( SourcePath )
    else
    if ActionType = ConflictAction_Rename then
    begin
      DesPath := TargetFolder + ExtractFileName( SourcePath );
      DesPath := MyFilePath.getRenamePath(  DesPath, FileExists( SourcePath ) );
    end
    else
    if ActionType = ConflictAction_Cancel then
      Continue;
    CopyPathList.Add( TCopyPathInfo.Create( SourcePath, DesPath ) );
  end;
end;


constructor TUserCopyBaseHandle.Create(_SourceFileList: TStringList;
  _DesFolder: string);
begin
  SourceFileList := _SourceFileList;
  DesFolder := _DesFolder;
  CopyPathList := TCopyPathList.Create;
end;

destructor TUserCopyBaseHandle.Destroy;
begin
  CopyPathList.Free;
  inherited;
end;

function TUserCopyBaseHandle.IsExistConflict: Boolean;
var
  i : Integer;
  TargetFolder : string;
  SourcePath, TargetPath : string;
begin
  Result := False;
  TargetFolder := MyFilePath.getPath( DesFolder );
  for i := 0 to SourceFileList.Count - 1 do
  begin
    SourcePath := SourceFileList[i];
    TargetPath := TargetFolder + ExtractFileName( SourcePath );
    if FileExists( TargetPath ) or DirectoryExists( TargetPath ) then
    begin
      Result := True;
      Break;
    end;
    CopyPathList.Add( TCopyPathInfo.Create( SourcePath, TargetPath ) );
  end;
end;

procedure TUserCopyBaseHandle.Update;
var
  i: Integer;
begin
    // 因冲突取消复制
  if IsExistConflict and not ConfirmConflict then
    Exit;

    // 文件处理
  FileHandle;
end;

class procedure UserCopyUtil.Move(SourceFileList: TStringList;
  DesFolder: string);
var
  UserMoveHandle : TUserMoveHandle;
begin
  UserMoveHandle := TUserMoveHandle.Create( SourceFileList, DesFolder );
  UserMoveHandle.Update;
  UserMoveHandle.Free;
end;


{ TCopyPathInfo }

constructor TCopyPathInfo.Create(_SourcePath, _DesPath: string);
begin
  SourcePath := _SourcePath;
  DesPath := _DesPath;
end;

{ TUserCopyHandle }

procedure TUserCopyHandle.FileHandle;
var
  i: Integer;
begin
    // 复制文件
  for i := 0 to CopyPathList.Count - 1 do
    UserFileMoveApi.FileCopy( CopyPathList[i].SourcePath, CopyPathList[i].DesPath );
end;

{ TUserMoveHandle }

procedure TUserMoveHandle.FileHandle;
var
  i: Integer;
begin
    // 复制文件
  for i := 0 to CopyPathList.Count - 1 do
    UserFileMoveApi.FileMove( CopyPathList[i].SourcePath, CopyPathList[i].DesPath );
end;


end.
