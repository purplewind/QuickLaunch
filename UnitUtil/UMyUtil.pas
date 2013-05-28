unit UMyUtil;

interface

uses StrUtils, SysUtils, Forms, shellapi, windows, shlobj, IOUtils, classes, comobj, ActiveX, Registry,
     idhttp, IdSSLOpenSSL,Vcl.ExtCtrls, Math, GDIPOBJ, GDIPUTIL, GDIPAPI, Dialogs, Controls, ComCtrls,
     grids, DateUtils;

type

  MyFilePath = class
  public
    class function getIsRoot( Path : string ): Boolean;
    class function getPath( Path : string ) : string;
    class function getName( Path : string ) : string;
    class function getHasChild( Path : string ): Boolean;
    class function getHasChildFolder( Path : string ): Boolean;
    class function getRenamePath( Path : string; IsFile : Boolean ): string;
    class function getIsExist( Path : string; IsFile : Boolean ): Boolean;
    class function getLinkPath( Path : string ): string;
    class function getExtName( Path : string ): string;
  public
    class function getDriverExist( Path : string ): Boolean;
    class function getDriverName( DriverPath : string ): string;
    class function getIsFixedDriver( DriverPath : string ): Boolean;
    class function getDesktopPath : string;
  public
    class function getIsZipFile( Path : string ): Boolean;
    class function getIsLinkFile( Path : string ): Boolean;
    class function getIsExeFile( Path : string ): Boolean;
    class function getIsMusicFile( Path : string ): Boolean;
    class function getIsVideoFile( Path : string ): Boolean;
  public
    class procedure Merge( OldPathList, NewPathList : TStringList );
    class function getIsEquals( Path1, Path2 : string ): Boolean;
    class function ReadSameExtList( FolderPath, ExtStr : string ) : TStringList;
  end;

  TInputParams = record
  public
    SourceWidth, SourceHeigh : Integer;
    DesWidth, DesHeigh : Integer;
    IsKeepSpace : Boolean;
  end;

  TOutputParams = record
  public
    ShowX, ShowY : Integer;
    ShowWidth, ShowHeigh : Integer;
  end;

    // 图片预览
  MyPicturePriviewUtil = class
  public
    class procedure FindPreviewPoint( InputParams : TInputParams; var OutputParams : TOutputParams );
    class procedure SetPicture( Picture : Timage; PicPath : string );
    class procedure SetBigPicture( Picture : Timage; PicPath : string );
  public
    class function getIsPictureFile( Path : string ): Boolean;
    class function ReadPictureList( FolderPath : string ): TStringList;
  end;

    // 文本预览
  MyTextPreviewUtil = class
  public
    class function getIsTextPreview( Path : string ): Boolean;
  end;

    // Word 预览
  MyWordPreviewUtil = class
  public
    class function getIsWordPreview( Path : string ): Boolean;
    class procedure SetWord( mmoWord : TRichEdit; DocPath : string );
    class function ReadWordList( FolderPath : string ): TStringList;
  end;

    // Excel 预览
  MyExcelPreviewUtil = class
  public
    class function getIsExcelPreview( Path : string ): Boolean;
    class procedure SetExcel( sgExcel : TStringGrid; ExcelPath : string );
    class function ReadExcelList( FolderPath : string ): TStringList;
  end;

  MyFileInfo = class
  public
    class function getFileSize( Path : string ): Int64;
    class function getFileTime( Path : string ): TDateTime;
    class function getIsHide( Path : string ): Boolean;
  end;

  MySizeUtil = class
  public
    class function getFileSizeStr(FileSize: Int64): string;
  end;

  MyExplorer = class
  public
    class procedure RunFile( FilePath : string );
    class procedure ShowFolder( FolderPath : string );
    class procedure OpenRecycle;
  end;

  MyInternetExplorer = class
  public
    class procedure OpenWeb( Url : string );
  end;

  MyAppData = class
  public
    class function getPath : string;
    class function getLoginPath : string;
    class function getIconFolderPath : string;
    class function getIconPicturePath : string;
    class function getRunPath : string;
  public
    class function getConfigPath : string;
    class function getExplorerHistoryPath : string;
  public
    class function getLanguagePath : string;
    class function get7ZipPath : string;
    class function getRarPath : string;
  public
    class function getPreviewNote : string;
    class function getPreviewWord : string;
    class function getPreviewExcel : string;
    class function getPreviewBack : string;
  end;

  MyShellFile = class
  public
    class function DeleteFile( FilePath : string ): Boolean;
  public
    class function ReadOpenFolderList : TStringList;
    class function ReadDesktopList : TStringList;
  end;

  MyHttpUtl = class
  public
    class function Download( FileUrl, FilePath : string ): Boolean;
  end;

  MyMessageForm = class
  public
    class procedure ShowWarnning( ShowStr : string );
    class procedure ShowError( ShowStr : string );
    class procedure ShowInformation( ShowStr : string );
    class function ShowConfirm( ShowStr : string ): Boolean;
  end;

var
  MessageForm_Error : string = '错误';
  MessageForm_Information : string = '信息';
  MessageForm_Warnning : string = '警告';

const
  ZipExt_Zip = '.zip';
  ZipExt_7z = '.7z';
  ZipExt_Rar = '.rar';

const
  RunFile_Language = 'Language.ini';
  RunFile_Rar = 'Rar.dll';
  RunFile_7Zip = '7Zip.dll';
  PreviewFile_Note = 'Note.png';
  PreviewFile_Word = 'Word.png';
  PreviewFile_Excel = 'Excel.png';
  PreviewFile_Back = 'Back.png';

const
  Ext_Link = '.lnk';
  Ext_Exe = '.exe';

const
  FileSize_B = ' B';
  FileSize_KB = ' KB';
  FileSize_MB = ' MB';
  FileSize_GB = ' GB';

  Size_B: Int64 = 1;
  Size_KB: Int64 = 1024;
  Size_MB: Int64 = 1024 * 1024;
  Size_GB: Int64 = 1024 * 1024 * 1024;

const
  RegKeyPath_AppRun = '\SOFTWARE\Microsoft\windows\CurrentVersion\Run';

implementation

{ MyFilePath }

class function MyFilePath.getDesktopPath: string;
var
  pitem : PITEMIDLIST;
  s: string;
  i : Integer;
begin
  try
    shGetSpecialFolderLocation(0,CSIDL_DESKTOP,pitem);
    setlength(s,100);
    shGetPathFromIDList(pitem,pchar(s));
    s := copy( s, 1, Pos( #0, s ) - 1 );
    Result := s;
  except
    Result := '';
  end;
end;

class function MyFilePath.getDriverExist(Path: string): Boolean;
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

class function MyFilePath.getDriverName(DriverPath: string): string;
var
  FI: TSHFileInfo;
begin
  try
    if SHGetFileInfo( PChar(DriverPath), 0, FI, SizeOf(FI), SHGFI_DISPLAYNAME ) = 0 then
      Result := DriverPath
    else
      Result := FI.szDisplayName;
  except
    Result := DriverPath;
  end;
end;


class function MyFilePath.getExtName(Path: string): string;
var
  ExtName: string;
begin
  ExtName := ExtractFileExt( Path );
  delete( ExtName, 1, 1 );
  Result := LowerCase( ExtName );
end;

class function MyFilePath.getHasChild(Path: string): Boolean;
var
  FileName  : string;
  sch : TSearchRec;
begin
  Result := False;
  if not FileExists( Path ) then
  begin
      // 循环寻找 目录文件信息
    Path := MyFilePath.getPath( Path );
    if FindFirst( Path + '*', faAnyfile, sch ) = 0 then
    begin
      repeat
        FileName := sch.Name;
        if ( FileName <> '.' ) and ( FileName <> '..') then
        begin
          Result := True;
          Break;
        end;
      until FindNext(sch) <> 0;
    end;
    SysUtils.FindClose(sch);
  end;
end;

class function MyFilePath.getHasChildFolder(Path: string): Boolean;
var
  FileName  : string;
  sch : TSearchRec;
begin
  Result := False;
  if DirectoryExists( Path ) then
  begin
      // 循环寻找 目录文件信息
    Path := MyFilePath.getPath( Path );
    if FindFirst( Path + '*', faAnyfile, sch ) = 0 then
    begin
      repeat
        FileName := sch.Name;
        if ( FileName = '.' ) or ( FileName = '..') then
          Continue;
        if DirectoryExists( Path + FileName ) then
        begin
          Result := True;
          Break;
        end;
      until FindNext(sch) <> 0;
    end;
    SysUtils.FindClose(sch);
  end;
end;

class function MyFilePath.getIsEquals(Path1, Path2: string): Boolean;
begin
  if getIsLinkFile( Path1 ) then
    Path1 := getLinkPath( Path1 );
  if getIsLinkFile( Path2 ) then
    Path2 := getLinkPath( Path2 );
  Result := Path1 = Path2;
end;

class function MyFilePath.getIsExeFile(Path: string): Boolean;
var
  ZipExt : string;
begin
  ZipExt := LowerCase( ExtractFileExt( Path ) );
  Result := ZipExt = Ext_Exe;
end;

class function MyFilePath.getIsExist(Path: string; IsFile: Boolean): Boolean;
begin
  if IsFile then
    Result := FileExists( Path )
  else
    Result := DirectoryExists( Path );
end;

class function MyFilePath.getIsFixedDriver(DriverPath: string): Boolean;
begin
  try
    DriverPath := getPath( DriverPath );
    Result := GetDriveType(Pchar(DriverPath)) = DRIVE_FIXED;
  except
    Result := False;
  end;
end;

class function MyFilePath.getIsLinkFile(Path: string): Boolean;
var
  ZipExt : string;
begin
  ZipExt := LowerCase( ExtractFileExt( Path ) );
  Result := ZipExt = Ext_Link;
end;


class function MyFilePath.getIsMusicFile(Path: string): Boolean;
begin

end;

class function MyFilePath.getIsRoot(Path: string): Boolean;
begin
  Result := ExtractFileName( Path ) = '';
end;

class function MyFilePath.getIsVideoFile(Path: string): Boolean;
begin

end;

class function MyFilePath.getIsZipFile(Path: string): Boolean;
var
  ZipExt : string;
begin
  ZipExt := LowerCase( ExtractFileExt( Path ) );
  Result := ( ZipExt = ZipExt_Zip ) or ( ZipExt = ZipExt_7z ) or ( ZipExt = ZipExt_Rar );
end;

class function MyFilePath.getLinkPath(Path: string): string;
const
  IID_IPersistFile:TGUID = '{0000010B-0000-0000-C000-000000000046}';
var
  intfLink : IShellLink;
  IntfPersist : IPersistFile;
  pfd : _WIN32_FIND_DATA;
  bSuccess : Boolean;
  szgetpath : array[0..max_path] of char;
begin
    // 不是快捷方式
  if not getIsLinkFile( Path ) then
  begin
    Result := Path;
    Exit;
  end;

    // 获取真实路径
  Result := '';
  IntfLink := CreateComObject(CLSID_ShellLink) as IShellLink;
  bSuccess := ( IntfLink <> nil ) and SUCCEEDED(IntfLink.QueryInterface(IID_IPersistFile,IntfPersist))
                and SUCCEEDED(IntfPersist.Load(PChar(WideString(Path)),STGM_READ))
                and SUCCEEDED(intfLink.GetPath(szgetpath,MAX_PATH,pfd,SLGP_RAWPATH));
  if bSuccess then
    Result := szgetpath
  else
    Result:= Path;
end;


class function MyFilePath.getName(Path: string): string;
begin
  Result := TPath.GetFileName( Path );
  if Result = '' then
    Result := Path;
end;

class function MyFilePath.getPath(Path: string): string;
begin
  if Path = '' then
    Result := ''
  else
  if RightStr( Path, 1 ) <> '\' then
    Result := Path + '\'
  else
    Result := Path;
end;


class function MyFilePath.getRenamePath(Path: string; IsFile : Boolean): string;
var
  FileNum : Integer;
begin
  FileNum := 1;
  Result := Path;
  if IsFile then
  begin
    while True do
    begin
      if not FileExists( Result ) then
        Break;
      Result := ExtractFilePath( Path ) +  TPath.GetFileNameWithoutExtension( Path ) + '('+ IntToStr(FileNum) + ')' + ExtractFileExt( Path );
      Inc( FileNum );
    end;
  end
  else
  begin
    while True do
    begin
      if not DirectoryExists( Result ) then
        Break;
      Result := Path + '('+ IntToStr(FileNum) + ')';
      Inc( FileNum );
    end;
  end;
end;

class procedure MyFilePath.Merge(OldPathList, NewPathList: TStringList);
var
  i: Integer;
begin
  for i := 0 to NewPathList.Count - 1 do
    if OldPathList.IndexOf( NewPathList[i] ) < 0 then
      OldPathList.Add( NewPathList[i] );
end;

class function MyFilePath.ReadSameExtList(FolderPath, ExtStr: string): TStringList;
var
  FileList : TStringList;
begin
  FileList := TStringList.Create;
  TDirectory.GetFiles( FolderPath,
  function(const Path: string; const SearchRec: TSearchRec): Boolean
  var
    PicturePath : string;
  begin
    if ( ( SearchRec.Attr and SysUtils.faDirectory ) = 0 ) and
       ( ExtractFileExt( SearchRec.Name ) = ExtStr )
    then
    begin
      PicturePath := MyFilePath.getPath( Path ) + SearchRec.Name;
      FileList.add( PicturePath );
    end;
    Result := False;
  end);
  Result := FileList;
end;

{ MySizeUtil }

class function MySizeUtil.getFileSizeStr(FileSize: Int64): string;
const
  FileSizeShowLen: Integer = 3;
var
  FileSizeDouble: Double;
  FileSizeExt: string;
  FileSizeLen: Integer;
  i: Integer;
  a: Integer;
begin
  if FileSize < 0 then
    FileSize := 0;

  if FileSize >= Size_GB then
  begin
    FileSizeDouble := FileSize / Size_GB;
    FileSizeExt := FileSize_GB;
  end
  else
    if FileSize >= Size_MB then
    begin
      FileSizeDouble := FileSize / Size_MB;
      FileSizeExt := FileSize_MB;
    end
    else
      if FileSize >= Size_KB then
      begin
        FileSizeDouble := FileSize / Size_KB;
        FileSizeExt := FileSize_KB;
      end
      else
      begin
        FileSizeDouble := FileSize;
        FileSizeExt := FileSize_B;
      end;

  FileSizeLen := Length(IntToStr(trunc(FileSizeDouble)));
  a := 1;
  for i := 0 to FileSizeShowLen - FileSizeLen - 1 do
    a := a * 10;
  FileSizeDouble := Trunc(FileSizeDouble * a) / a;

  Result := FloatToStr(FileSizeDouble) + FileSizeExt;
end;

{ MyExplorer }

class procedure MyExplorer.OpenRecycle;
begin
  ShellExecute(0, 'open', '::{645FF040-5081-101B-9F08-00AA002F954E}', nil, nil, SW_NORMAL);
end;

class procedure MyExplorer.RunFile(FilePath: string);
begin
  if FileExists( FilePath ) then
    ShellExecute( 0, 'open', Pchar( FilePath ), '', nil, SW_SHOW );
end;

class procedure MyExplorer.ShowFolder(FolderPath: string);
begin
  ShellExecute( 0, 'open', 'explorer.exe', PChar(FolderPath ), nil, SW_SHOW )
end;

{ MyAppData }

class function MyAppData.get7ZipPath: string;
begin
  Result := getRunPath + RunFile_7Zip;
end;

class function MyAppData.getConfigPath: string;
begin
  Result := getLoginPath + 'Config.ini';
end;

class function MyAppData.getExplorerHistoryPath: string;
begin
  Result := getLoginPath + 'History.ini';
end;

class function MyAppData.getIconFolderPath: string;
begin
  Result := getPath + 'Icon\';
end;

class function MyAppData.getIconPicturePath: string;
begin
  Result := getIconFolderPath + 'Picture\';
end;

class function MyAppData.getPath: string;
var
  FilePath: array [0..255] of char;
begin
  try  // 从系统 Api 中获取
    SHGetSpecialFolderPath(0, @FilePath[0], CSIDL_COMMON_APPDATA, True);
    Result := FilePath;
    Result := Result + '\QuickLaunch\';
  except
  end;
end;

class function MyAppData.getPreviewBack: string;
begin
  Result := getIconPicturePath + PreviewFile_Back;
end;

class function MyAppData.getPreviewExcel: string;
begin
  Result := getIconPicturePath + PreviewFile_Excel;
end;

class function MyAppData.getPreviewNote: string;
begin
  Result := getIconPicturePath + PreviewFile_Note;
end;

class function MyAppData.getPreviewWord: string;
begin
  Result := getIconPicturePath + PreviewFile_Word;
end;

class function MyAppData.getRarPath: string;
begin
  Result := getRunPath + RunFile_Rar;
end;

class function MyAppData.getRunPath: string;
begin
  Result := getPath + 'Run\';
end;

class function MyAppData.getLanguagePath: string;
begin
  Result := getRunPath + RunFile_Language;
end;

class function MyAppData.getLoginPath: string;
var
  FStr: PChar;
  FSize: Cardinal;
begin
  try
    FSize := 255;
    GetMem(FStr, FSize);
    GetUserName(FStr, FSize);
    Result := FStr;
    FreeMem(FStr);
  except
    Result := 'Admin';
  end;

  Result := getPath + Result + '\';
end;

{ MyFileInfo }

class function MyFileInfo.getFileSize(Path: string): Int64;
var
  sch: TSearchRec;
begin
  Result := 0;
  try
    if FindFirst( Path , faAnyfile , sch ) = 0 then
      Result := sch.Size;
    SysUtils.FindClose(sch);
  except
  end;
end;

class function MyFileInfo.getFileTime(Path: string): TDateTime;
var
  sch: TSearchRec;
  LastWriteTimeSystem: TSystemTime;
begin
  Result := Now;
  try
    if FindFirst( Path, faAnyFile, sch ) = 0 then
    begin
      FileTimeToSystemTime( sch.FindData.ftLastWriteTime, LastWriteTimeSystem );
      Result := SystemTimeToDateTime(LastWriteTimeSystem);
      Result := TTimeZone.Local.ToLocalTime( Result );
    end;
    SysUtils.FindClose(sch);
  except
  end;
end;

class function MyFileInfo.getIsHide(Path: string): Boolean;
var
  sch: TSearchRec;
begin
  Result := True;
  try
    if FindFirst( Path , faAnyfile , sch ) = 0 then
      Result := ( sch.Attr and faHidden ) > 0;
    SysUtils.FindClose(sch);
  except
  end;
end;


{ MyShellFile }

class function MyShellFile.DeleteFile(FilePath: string): Boolean;
var
  fo: TSHFILEOPSTRUCT;
begin
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := 0;
    wFunc := FO_DELETE;
    pFrom := PChar(FilePath + #0);
    fFlags :=  FOF_ALLOWUNDO or FOF_NOCONFIRMATION;
  end;
  Result := SHFileOperation(fo) = 0;
end;

class function MyShellFile.ReadDesktopList: TStringList;
var
  FolderPath : string;
  DesktopList : TStringList;
begin
  DesktopList := TStringList.Create;
  FolderPath := MyFilePath.getDesktopPath;
  if not DirectoryExists( FolderPath ) then
    Exit;
  try
    TDirectory.GetFileSystemEntries( FolderPath,
      function(const Path: string; const SearchRec: TSearchRec): Boolean
      begin
        if ( SearchRec.Attr and faHidden ) = 0 then
          DesktopList.Add( MyFilePath.getPath( FolderPath ) + SearchRec.Name );
        Result := False;
      end);
  except
  end;

  Result := DesktopList;
end;

class function MyShellFile.ReadOpenFolderList: TStringList;
var
  winhandle: Hwnd;
  winprocess: Dword;
  title:pchar;
begin
  Result := TStringList.Create;
  Getmem( title, 255 );
  winhandle := GetWindow( GetForeGroundWindow, GW_HWNDFIRST );
  while winhandle <> 0 do
  begin
   if ( IsWindowEnabled( winhandle ) and IsWindow( winhandle ) ) then
    begin
    GetWindowText( winhandle, title, 255 );
     if ( length( title ) > 0 ) and DirectoryExists( title ) then
       Result.add(title);
    end;
    winhandle:=GetWindow(winhandle,GW_HWNDNEXT);
  end;
  Freemem(title);
  CloseHandle(winHandle);
end;

{ MyInternetExplorer }

class procedure MyInternetExplorer.OpenWeb(Url: string);
begin
  try
    ShellExecute(0, 'open', pchar( Url ), '', '', SW_Show);
  except
  end;
end;

{ MyHttpUtl }

class function MyHttpUtl.Download(FileUrl, FilePath: string): Boolean;
var
  Http : TIdHTTP;
  fs : TFileStream;
  ssl : TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := False;
  Http := TIdHTTP.Create( nil );
  Http.ConnectTimeout := 60000;
  Http.ReadTimeout := 60000;
  ssl := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  Http.IOHandler := ssl;
  try
    fs := TFileStream.Create( FilePath, fmCreate );
    try
      Http.Get( FileUrl , fs );
      Result := True;
    except
    end;
    fs.Free;
  except
  end;
  ssl.Free;
  Http.Free;
end;

{ MyMessageForm }

class function MyMessageForm.ShowConfirm(ShowStr: string): Boolean;
begin
  Result := MessageDlg( ShowStr, mtConfirmation, [mbYes, mbNo], 0 ) = mrYes;
end;

class procedure MyMessageForm.ShowError(ShowStr: string);
begin
  MessageBox( 0, PChar( ShowStr ), PChar( MessageForm_Error ), MB_ICONERROR );
end;

class procedure MyMessageForm.ShowInformation(ShowStr: string);
begin
  MessageBox( 0, PChar( ShowStr ), PChar( MessageForm_Information ), MB_ICONINFORMATION );
end;

class procedure MyMessageForm.ShowWarnning(ShowStr: string);
begin
  MessageBox( 0, PChar( ShowStr ), PChar( MessageForm_Warnning ), MB_ICONWARNING );
end;

{ MyPriviewUtil }

class procedure MyPicturePriviewUtil.FindPreviewPoint(InputParams: TInputParams;
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
  SourceWidth := InputParams.SourceWidth;
  SourceHeigh := InputParams.SourceHeigh;
  DesWidth := InputParams.DesWidth;
  DesHeigh := InputParams.DesHeigh;

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
    sth2 := SourceHeigh;
    stw2 := SourceWidth;
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
  if InputParams.IsKeepSpace then
  begin
    CutLength := 10 - ( DesWidth - ShowWidth );
    if CutLength > 0 then
    begin
      ShowWidth := ShowWidth - CutLength;
      ShowX := ShowX + ( CutLength div 2 );
    end;
    CutLength := 10 - ( DesHeigh - ShowHeigh );
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

class function MyPicturePriviewUtil.getIsPictureFile(Path: string): Boolean;
var
  ExtName: string;
begin
  ExtName := MyFilePath.getExtName( Path );

  Result := ( ExtName = 'wmf' ) or ( ExtName = 'emf' ) or ( ExtName = 'ico' ) or
            ( ExtName = 'tiff' ) or ( ExtName = 'tif' ) or ( ExtName = 'png' ) or
            ( ExtName = 'jpeg' ) or ( ExtName = 'jpg' ) or ( ExtName = 'gif' ) or
            ( ExtName = 'bmp' );
end;

class function MyPicturePriviewUtil.ReadPictureList(FolderPath: string): TStringList;
var
  PictureList : TStringList;
begin
  PictureList := TStringList.Create;
  TDirectory.GetFiles( FolderPath,
  function(const Path: string; const SearchRec: TSearchRec): Boolean
  var
    PicturePath : string;
  begin
    if ( ( SearchRec.Attr and SysUtils.faDirectory ) = 0 ) and getIsPictureFile( SearchRec.Name )
    then
    begin
      PicturePath := MyFilePath.getPath( Path ) + SearchRec.Name;
      PictureList.add( PicturePath );
    end;
    Result := False;
  end);
  Result := PictureList;
end;

class procedure MyPicturePriviewUtil.SetBigPicture(Picture: Timage;
  PicPath: string);
var
  InpuParams : TInputParams;
  OutputParams : TOutputParams;
  Img : TGPImage;
  ms : TMemoryStream;
  Stream : IStream;
  ImgGUID :TGUID;
  GdiGraphics: TGPGraphics;
  GdiBrush : TGPSolidBrush;
  GdiStream : IStream;
  GdiImg : TGPImage;
begin
  try
    Picture.Picture := nil;

    Img := TGPImage.Create( PicPath );

    InpuParams.SourceWidth := Img.GetWidth;
    InpuParams.SourceHeigh := Img.GetHeight;
    InpuParams.DesWidth := Picture.Width;
    InpuParams.DesHeigh := Picture.Height;
    InpuParams.IsKeepSpace := True;
    FindPreviewPoint( InpuParams, OutputParams );

      // 画纸
    GdiGraphics := TGPGraphics.Create( Picture.Canvas.Handle );

      // 填充背景颜色
    GdiBrush := TGPSolidBrush.Create( MakeColor( 255, 255, 255 ) );
    GdiGraphics.FillRectangle( GdiBrush, 0, 0, Picture.Width, Picture.Height );
    GdiBrush.Free;

    GdiGraphics.DrawImage( Img, OutputParams.ShowX, OutputParams.ShowY, OutputParams.ShowWidth, OutputParams.ShowHeigh );
    GdiGraphics.Free;

    Img.Free;
  except
  end;
end;

class procedure MyPicturePriviewUtil.SetPicture(Picture: Timage; PicPath: string);
var
  InpuParams : TInputParams;
  OutputParams : TOutputParams;
  Img, SmallImg : TGPImage;
  ms : TMemoryStream;
  Stream : IStream;
  ImgGUID :TGUID;
  GdiGraphics: TGPGraphics;
  GdiBrush : TGPSolidBrush;
  GdiStream : IStream;
  GdiImg : TGPImage;
begin
  try
    Picture.Picture := nil;

    Img := TGPImage.Create( PicPath );

    InpuParams.SourceWidth := Img.GetWidth;
    InpuParams.SourceHeigh := Img.GetHeight;
    InpuParams.DesWidth := Picture.Width;
    InpuParams.DesHeigh := Picture.Height;
    InpuParams.IsKeepSpace := True;
    FindPreviewPoint( InpuParams, OutputParams );
    SmallImg := Img.GetThumbnailImage( OutputParams.ShowWidth, OutputParams.ShowHeigh );

      // 画纸
    GdiGraphics := TGPGraphics.Create( Picture.Canvas.Handle );

      // 填充背景颜色
    GdiBrush := TGPSolidBrush.Create( MakeColor( 255, 255, 255 ) );
    GdiGraphics.FillRectangle( GdiBrush, 0, 0, Picture.Width, Picture.Height );
    GdiBrush.Free;

    GdiGraphics.DrawImage( SmallImg, OutputParams.ShowX, OutputParams.ShowY, OutputParams.ShowWidth, OutputParams.ShowHeigh );
    GdiGraphics.Free;

    SmallImg.Free;
    Img.Free;
  except
  end;
end;
{ MyTextPreviewUtil }

class function MyTextPreviewUtil.getIsTextPreview(Path: string): Boolean;
var
  FileSize: Int64;
  StrList : TStringList;
begin
  Result := False;
  FileSize := MyFileInfo.getFileSize( Path );
  if FileSize >= 128 * Size_KB then
    Exit;

  StrList := TStringList.Create;
  try
    StrList.LoadFromFile( Path );
  except
  end;
  Result := ( Length( StrList.Text ) * 3 ) >= FileSize;
  StrList.Free;
end;

{ MyWordPreviewUtil }

class function MyWordPreviewUtil.getIsWordPreview(Path: string): Boolean;
var
  FileSize : Int64;
  ExtName: string;
begin
  Result := False;
  FileSize := MyFileInfo.getFileSize( Path );
  if FileSize >= 128 * Size_KB then
    Exit;
  if MyFileInfo.getIsHide( Path ) then
    Exit;

  ExtName := MyFilePath.getExtName( Path );
  Result := ( ExtName = 'doc' ) or ( ExtName = 'docx' );
end;

class function MyWordPreviewUtil.ReadWordList(FolderPath: string): TStringList;
var
  WordList : TStringList;
begin
  WordList := TStringList.Create;
  TDirectory.GetFiles( FolderPath,
  function(const Path: string; const SearchRec: TSearchRec): Boolean
  var
    WordPath : string;
  begin
    WordPath := MyFilePath.getPath( Path ) + SearchRec.Name;
    if ( ( SearchRec.Attr and SysUtils.faDirectory ) = 0 ) and getIsWordPreview( WordPath )
    then
      WordList.add( WordPath );
    Result := False;
  end);
  Result := WordList;
end;

class procedure MyWordPreviewUtil.SetWord(mmoWord: TRichEdit; DocPath: string);
var
  WordApp: Variant;     //声明一个word对象
begin
  try
    WordApp := CreateOleObject('Word.Application');   //创建word对象
    try
      WordApp.Documents.open(DocPath);    //打开一个word文档
      wordapp.activedocument.select;    //选取打开的word文档中全部内容
      wordapp.selection.copy;           //拷贝选取的内容
      mmoWord.PasteFromClipboard;       //把拷贝的内容粘贴到richedit中
    except
    end;
    WordApp.Quit;               //关闭对象
  except
  end;
end;

{ MyExcelPreviewUtil }

class function MyExcelPreviewUtil.getIsExcelPreview(Path: string): Boolean;
var
  FileSize : Int64;
  ExtName: string;
begin
  Result := False;
  FileSize := MyFileInfo.getFileSize( Path );
  if FileSize >= 128 * Size_KB then
    Exit;
  if MyFileInfo.getIsHide( Path ) then
    Exit;

  ExtName := MyFilePath.getExtName( Path );
  Result := ( ExtName = 'xls' ) or ( ExtName = 'xlsx' );
end;


class function MyExcelPreviewUtil.ReadExcelList(
  FolderPath: string): TStringList;
var
  WordList : TStringList;
begin
  WordList := TStringList.Create;
  TDirectory.GetFiles( FolderPath,
  function(const Path: string; const SearchRec: TSearchRec): Boolean
  var
    WordPath : string;
  begin
    WordPath := MyFilePath.getPath( Path ) + SearchRec.Name;
    if ( ( SearchRec.Attr and SysUtils.faDirectory ) = 0 ) and getIsExcelPreview( WordPath )
    then
      WordList.add( WordPath );
    Result := False;
  end);
  Result := WordList;
end;

class procedure MyExcelPreviewUtil.SetExcel(sgExcel: TStringGrid;
  ExcelPath: string);
const
  str= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  ColCount, RowCount : Integer;
  ExcelApp : Variant;
  i, j: Integer;
  s : string;
  StrLen : Integer;
begin
  try
    ExcelApp := CreateOleObject('Excel.Application');
    try
      ExcelApp.workBooks.Open( ExcelPath );
      ColCount := ExcelApp.WorkSheets[1].UsedRange.Columns.Count;
      RowCount := ExcelApp.WorkSheets[1].UsedRange.Rows.Count;
      sgExcel.ColCount := ColCount + 1;
      sgExcel.RowCount := RowCount + 1;
      StrLen := Length(str);
      for i := 1 to ColCount do
      begin
        if i > StrLen then
          s := str[ StrLen ] + IntToStr( i - StrLen )
        else
          s := str[i];
        sgExcel.Cells[i,0] := s;
      end;
      for i := 1 to RowCount do
        sgExcel.Cells[0,i] := IntToStr(i);
      sgExcel.ColWidths[0] := 35;
      for i := 1 to RowCount do
        for j := 1 to ColCount do
        begin
          s := ExcelApp.Cells[i,j].Value;
          sgExcel.Cells[j,i] := s;
        end;
    except
    end;
    ExcelApp.Quit;
  except
  end;
end;

end.
