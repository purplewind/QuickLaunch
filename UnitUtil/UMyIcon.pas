unit UMyIcon;

interface

uses Vcl.Controls, ShellApi, Sysutils, Graphics, windows;

type

    // 保存 Icon 文件
  TSaveMyIconHandle = class
  public
    il : TImageList;
  public
    constructor Create( _il : TImageList );
    procedure Update;
  private
    function ReadIsIconEditionModify : Boolean;
    procedure ResetIconEdition;
  end;

    // 系统图标类
  TMyIcon = class
  private
    SysIcon: TImageList;
    SysIcon32 : TImageList;
  public
    constructor Create;
    destructor Destroy; override;
  public
    function getSysIcon: TImageList;
    function getSysIcon32 : TImageList;
  public
    function getPathIcon( Path : string; IsFile : Boolean ): Integer;
    function getFileIcon( FilePath : string ): Integer;
    function getFolderIcon( FolderPath : string ): Integer;
    function getFileExtIcon( FileName : string ): Integer;
  end;

    // 16 图标辅助类
  My16IconUtil = class
  public
    class function getFile : Integer;
    class function getFolder : Integer;
    class function getFavorite : Integer;
    class function getAllFiles : Integer;
    class function getPaste : Integer;
    class function getCopy : Integer;
    class function getMove : Integer;
    class function getDelete : Integer;
    class function getZip : Integer;
    class function getReplace : Integer;
    class function getRename : Integer;
    class function getCancel : Integer;
    class function getWarnning : Integer;
    class function getBack : Integer;
    class function getStop : Integer;
  public
    class function getIcon( IconIndex : Integer ): Integer;
    class function getIconPath( IconIndex : Integer ): string;
    class function getBasePath : string;
    class procedure Set16IconName( il :  TImageList );
  end;

    // 32 图标辅助类
  My32IconUtil = class
  public
    class function getDesktop : Integer;
    class function getRecycle : Integer;
    class function getInput : Integer;
  public
    class function getIcon( IconIndex : Integer ): Integer;
    class function getBasePath : string;
    class procedure Set32IconName( il :  TImageList );
  end;

const
  IconEdition_Now = 1;

var
  IconName_16 : string = '';
  IconName_32 : string = '';

const
  LocalIcon_File = 0;
  LocalIcon_Folder = 1;
  LocalIcon_Favorite = 2;
  LocalIcon_AllFiles = 3;
  LocalIcon_Paste = 4;
  LocalIcon_Copy = 5;
  LocalIcon_Move = 6;
  LocalIcon_Delete = 7;
  LocalIcon_Zip = 8;
  LocalIcon_Replace = 9;
  LocalIcon_Rename = 10;
  LocalIcon_Cancel = 11;
  LocalIcon_Warnning = 12;
  LocalIcon_Back = 13;
  LocalIcon_Stop = 14;

const
  LocalIcon_Desktop = 0;
  LocalIcon_Recycle = 1;
  LocalIcon_Input = 2;

var
  MyIcon : TMyIcon;

implementation

uses UMyUtil, Inifiles;

{ TMyIcon }

constructor TMyIcon.Create;
var
  SysIL, SysIL32 : THandle;
  SFI, SFI32 : TSHFileInfo;
begin
  try   // 16 * 16 系统图标 创建
    SysIcon := TImageList.Create(nil);
    SysIL := SHGetFileInfo('', 0, SFI, SizeOf(SFI), SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
    if SysIL <> 0 then
    begin
      SysIcon.Handle := SysIL;
      SysIcon.ShareImages := TRUE;
    end;
  except
  end;

  try  // 32 * 32 系统图标 创建
    SysIcon32 := TImageList.Create( nil );
    SysIL32 := SHGetFileInfo('', 0, SFI32, SizeOf(SFI32), SHGFI_SYSICONINDEX or SHGFI_LARGEICON);
    if SysIL32 <> 0 then
    begin
      SysIcon32.Handle := SysIL32;
      SysIcon32.ShareImages := TRUE;
    end;
  except
  end;
end;

destructor TMyIcon.Destroy;
begin
  SysIcon32.Free;
  SysIcon.Free;
  inherited;
end;

function TMyIcon.getFileExtIcon(FileName: string): Integer;
var
  FileInfo: TSHFileInfo;
begin
  try
    FileInfo.iIcon := 0;
    SHGetFileInfo(pchar('*' + ExtractFileExt(FileName)), 0, FileInfo, SizeOf(TSHFileInfo),SHGFI_SYSICONINDEX or SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES);
    DestroyIcon(FileInfo.hIcon);
    Result := FileInfo.iIcon;
  except
    Result := 0;
  end;

    // 获取失败
  if Result = 0 then
    Result := My16IconUtil.getFile;
end;

function TMyIcon.getFileIcon(FilePath: string): Integer;
var
  FileInfo : TSHFileInfo;
begin
    // 文件不存在，取后缀
  if not FileExists( FilePath ) then
  begin
    Result := getFileExtIcon( FilePath );
    Exit;
  end;

  try   // 系统 Api
    FileInfo.iIcon := 0;
    SHGetFileInfo(pchar(FilePath), 0, FileInfo, SizeOf(TSHFileInfo), SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
    DestroyIcon(FileInfo.hIcon);
    Result := FileInfo.iIcon;
  except
    Result := 0
  end;

    // 获取失败
  if Result = 0 then
    Result := getFileExtIcon( FilePath )
end;

function TMyIcon.getFolderIcon(FolderPath: string): Integer;
var
  FileInfo : TSHFileInfo;
begin
    // 目录不存在
  if not DirectoryExists( FolderPath ) then
  begin
    Result := My16IconUtil.getFolder;
    Exit;
  end;

  try    // 系统 Api
    FileInfo.iIcon := 0;
    SHGetFileInfo(pchar(FolderPath), 0, FileInfo, SizeOf(TSHFileInfo), SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
    DestroyIcon(FileInfo.hIcon);
    Result := FileInfo.iIcon;
  except
    Result := 0
  end;

    // 获取失败
  if Result = 0 then
    Result := My16IconUtil.getFolder;
end;

function TMyIcon.getPathIcon(Path: string; IsFile: Boolean): Integer;
begin
  if IsFile then
    Result := getFileIcon( Path )
  else
    Result := getFolderIcon( Path );
end;

function TMyIcon.getSysIcon: TImageList;
begin
  Result := SysIcon;
end;

function TMyIcon.getSysIcon32: TImageList;
begin
  Result := SysIcon32;
end;

{ TSaveMyIconHandle }

constructor TSaveMyIconHandle.Create(_il: TImageList);
begin
  il := _il;
end;

function TSaveMyIconHandle.ReadIsIconEditionModify: Boolean;
var
  iniFile : TIniFile;
begin
  iniFile := TIniFile.Create( MyAppData.getConfigPath );
  try
    Result := iniFile.ReadInteger( 'Icon', 'Edition', 0 ) <> IconEdition_Now;
  except
  end;
  iniFile.Free;
end;

procedure TSaveMyIconHandle.ResetIconEdition;
var
  iniFile : TIniFile;
begin
  iniFile := TIniFile.Create( MyAppData.getConfigPath );
  try
    iniFile.WriteInteger( 'Icon', 'Edition', IconEdition_Now );
  except
  end;
  iniFile.Free;
end;

procedure TSaveMyIconHandle.Update;
var
  IsEditionModify : Boolean;
  i : Integer;
  Icon : TIcon;
  FolderPath, FilePath : string;
begin
    // 程序版本是否发生变化
  IsEditionModify := ReadIsIconEditionModify;

    // 创建图标目录
  FolderPath := MyAppData.getIconFolderPath + il.Name;
  ForceDirectories( FolderPath );

    // 保存文件
  FolderPath := MyFilePath.getPath( FolderPath );
  for i := 0 to il.Count - 1 do
  begin
    FilePath := FolderPath + IntToStr(i) + '.ico';

      // 是否需要重新保存文件
    if FileExists( FilePath ) and not IsEditionModify then
      Continue;

      // 提取图标并保存
    Icon := TIcon.Create;
    il.GetIcon( i, Icon );
    Icon.SaveToFile( FilePath );
    Icon.Free;
  end;

    // 设置已保存最新版本
  ResetIconEdition;
end;

{ MyIconUtil }

class function My16IconUtil.getAllFiles: Integer;
begin
  Result := getIcon( LocalIcon_AllFiles );
end;

class function My16IconUtil.getBack: Integer;
begin
  Result := getIcon( LocalIcon_Back );
end;

class function My16IconUtil.getBasePath: string;
begin
  Result := MyAppData.getIconFolderPath + IconName_16 + '\';
end;

class function My16IconUtil.getCancel: Integer;
begin
  Result := getIcon( LocalIcon_Cancel );
end;

class function My16IconUtil.getCopy: Integer;
begin
  Result := getIcon( LocalIcon_Copy );
end;

class function My16IconUtil.getDelete: Integer;
begin
  Result := getIcon( LocalIcon_Delete );
end;

class function My16IconUtil.getFavorite: Integer;
begin
  Result := getIcon( LocalIcon_Favorite );
end;

class function My16IconUtil.getFile: Integer;
begin
  Result := getIcon( LocalIcon_File );
end;

class function My16IconUtil.getFolder: Integer;
begin
  Result := getIcon( LocalIcon_Folder );
end;

class function My16IconUtil.getIcon(IconIndex: Integer): Integer;
begin
  Result := MyIcon.getFileIcon( getIconPath( IconIndex ) );
end;

class function My16IconUtil.getIconPath(IconIndex: Integer): string;
begin
  Result := getBasePath + IntToStr(IconIndex) + '.ico';
end;

class function My16IconUtil.getMove: Integer;
begin
  Result := getIcon( LocalIcon_Move );
end;

class function My16IconUtil.getPaste: Integer;
begin
  Result := getIcon( LocalIcon_Paste );
end;

class function My16IconUtil.getRename: Integer;
begin
  Result := getIcon( LocalIcon_Rename );
end;

class function My16IconUtil.getReplace: Integer;
begin
  Result := getIcon( LocalIcon_Replace );
end;

class function My16IconUtil.getStop: Integer;
begin
  Result := getIcon( LocalIcon_Stop );
end;

class function My16IconUtil.getWarnning: Integer;
begin
  Result := getIcon( LocalIcon_Warnning );
end;

class function My16IconUtil.getZip: Integer;
begin
  Result := getIcon( LocalIcon_Zip );
end;

class procedure My16IconUtil.Set16IconName(il :  TImageList);
var
  SaveMyIconHandle : TSaveMyIconHandle;
begin
  SaveMyIconHandle := TSaveMyIconHandle.Create( il );
  SaveMyIconHandle.Update;
  SaveMyIconHandle.Free;

  IconName_16 := il.Name;
end;

{ My32IconUtil }

class function My32IconUtil.getBasePath: string;
begin
  Result := MyAppData.getIconFolderPath + IconName_32 + '\';
end;

class function My32IconUtil.getIcon(IconIndex: Integer): Integer;
begin
  Result := MyIcon.getFileIcon( getBasePath + IntToStr(IconIndex) + '.ico' );
end;

class function My32IconUtil.getInput: Integer;
begin
  Result := getIcon( LocalIcon_Input );
end;

class function My32IconUtil.getDesktop: Integer;
begin
  Result := getIcon( LocalIcon_Desktop );
end;

class function My32IconUtil.getRecycle: Integer;
begin
  Result := getIcon( LocalIcon_Recycle );
end;

class procedure My32IconUtil.Set32IconName(il: TImageList);
var
  SaveMyIconHandle : TSaveMyIconHandle;
begin
  SaveMyIconHandle := TSaveMyIconHandle.Create( il );
  SaveMyIconHandle.Update;
  SaveMyIconHandle.Free;

  IconName_32 := il.Name;
end;

end.
