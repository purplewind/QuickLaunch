unit UFileThread;

interface

uses UThreadUtil, IOUtils, classes, SysUtils, Math, shellapi, SyncObjs;

type

{$Region ' 文件 Job 信息 ' }

    // 父类
  TFileJobBase = class( TThreadJob )
  public
    ActionID : string;
  public
    constructor Create( _ActionID : string );
    procedure Update;override;
  protected
    procedure BeforeAction;
    procedure ActionHandle;virtual;abstract;
    procedure AfterAction;
  private
    procedure RemoveToFace;
  end;

  {$Region ' 复制/移动/删除 ' }

    // 文件父类
  TFileJob = class( TFileJobBase )
  public
    FilePath : string;
  public
    procedure SetFilePath( _FilePath : string );
  end;

    // 有目标的 Job
  TFileDesJob = class( TFileJob )
  public
    DesFilePath : string;
  public
    procedure SetDesFilePath( _DesFilePath : string );
  end;

    // 复制
  TFileCopyJob = class( TFileDesJob )
  protected
    procedure ActionHandle;override;
  private
    procedure AddToFace;
  end;

    // 移动
  TFileMoveJob = class( TFileDesJob )
  protected
    procedure ActionHandle;override;
  private
    procedure AddToFace;
  end;

    // 删除
  TFileDeleteJob = class( TFileJob )
  protected
    procedure ActionHandle;override;
  private
    procedure AddToFace;
  end;

  {$EndRegion}

  {$Region ' 压缩/解压 ' }

    // 压缩父类
  TFileZipBaseJob = class( TFileJobBase )
  public
    FileList : TStringList;
    ZipPath : string;
  public
    procedure SetFileList( _FileList : TStringList );
    procedure SetZipPath( _ZipPath : string );
    destructor Destroy; override;
  private
    procedure ShowForm;
    procedure HideForm;
  private
    procedure AddToFace;
  end;

    // 压缩
  TFileZipJob = class( TFileZipBaseJob )
  protected
    procedure ActionHandle;override;
  end;

    // 7Zip 压缩
  TFile7ZipJob = class( TFileZipBaseJob )
  protected
    procedure ActionHandle;override;
  end;

    // 解压
  TFileUnzipJob = class( TFileJobBase )
  public
    ZipPath, FolderPath : string;
  public
    procedure SetZipInfo( _ZipPath, _FolderPath : string );
  protected
    procedure ActionHandle;override;
  private
    procedure ShowForm;
    procedure HideForm;
  private
    procedure AddToFace;
  end;

  {$EndRegion}

{$EndRegion}

  TMyFileJobHandler = class( TMyJobHandler )
  private
    RunningLock : TCriticalSection;
    RunningCount : Integer;
  public
    constructor Create;
    destructor Destroy; override;
  public
    procedure AddFleCopy( FilePath, DesFilePath, ActionID : string );
    procedure AddFleMove( FilePath, DesFilePath, ActionID : string );
    procedure AddFleDelete( FilePath, ActionID : string );
  public
    procedure AddFileZip( FileList : TStringList; ZipPath, ActionID : string );
    procedure AddFile7Zip( FileList : TStringList; ZipPath, ActionID : string );
    procedure AddFileUnzip( ZipPath, FolderPath, ActionID : string );
  public
    procedure AddRuningCount;
    procedure RemoveRuningCount;
    function ReadIsRunning : Boolean;
  end;

var
  MyFileJobHandler : TMyFileJobHandler;

implementation

uses UFrameMyComputer, UFrameExplorer, UFormZip, UFormUnzip, UMyUtil;

{ TFileMoveInfo }

procedure TFileJobBase.AfterAction;
begin
    // 正在运行
  MyFileJobHandler.RemoveRuningCount;
end;

procedure TFileJobBase.BeforeAction;
begin
    // 结束 Waiting
  FaceUpdate( RemoveToFace );
end;

constructor TFileJobBase.Create(_ActionID: string);
begin
  ActionID := _ActionID;
end;

procedure TFileJobBase.RemoveToFace;
begin
  UserFileMoveApi.RemoveAction( ActionID );
end;

{ TFileDesJob }

procedure TFileDesJob.SetDesFilePath(_DesFilePath: string);
begin
  DesFilePath := _DesFilePath;
end;

{ TFileCopyJob }

procedure TFileCopyJob.ActionHandle;
var
  fo: TSHFILEOPSTRUCT;
begin
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := 0;
    wFunc := FO_COPY;
    pFrom := PChar(FilePath + #0);
    pTo := PChar(DesFilePath + #0);
    fFlags := FOF_NOCONFIRMATION + FOF_NOCONFIRMMKDIR;
  end;
  if SHFileOperation(fo)=0 then
    FaceUpdate( AddToFace );
end;

procedure TFileCopyJob.AddToFace;
begin
  UserFileListApi.AddMoveFile( ExtractFileDir( DesFilePath ), DesFilePath );
end;

{ TMyFileJobHandler }

procedure TMyFileJobHandler.AddFile7Zip(FileList: TStringList;
  ZipPath, ActionID: string);
var
  File7ZipJob : TFile7ZipJob;
begin
  AddRuningCount;

  File7ZipJob := TFile7ZipJob.Create( ActionID );
  File7ZipJob.SetFileList( FileList );
  File7ZipJob.SetZipPath( ZipPath );
  AddJob( File7ZipJob );
end;

procedure TMyFileJobHandler.AddFileUnzip(ZipPath, FolderPath, ActionID: string);
var
  FileUnzipJob : TFileUnzipJob;
begin
  AddRuningCount;

  FileUnzipJob := TFileUnzipJob.Create( ActionID );
  FileUnzipJob.SetZipInfo( ZipPath, FolderPath );
  AddJob( FileUnzipJob );
end;

procedure TMyFileJobHandler.AddFileZip(FileList: TStringList;
  ZipPath, ActionID: string);
var
  FileZipJob : TFileZipJob;
begin
  AddRuningCount;

  FileZipJob := TFileZipJob.Create( ActionID );
  FileZipJob.SetFileList( FileList );
  FileZipJob.SetZipPath( ZipPath );
  AddJob( FileZipJob );
end;

procedure TMyFileJobHandler.AddFleCopy(FilePath, DesFilePath, ActionID: string);
var
  FileCopyJob : TFileCopyJob;
begin
  AddRuningCount;

  FileCopyJob := TFileCopyJob.Create( ActionID );
  FileCopyJob.SetFilePath( FilePath );
  FileCopyJob.SetDesFilePath( DesFilePath );
  AddJob( FileCopyJob );
end;

procedure TMyFileJobHandler.AddFleDelete(FilePath, ActionID: string);
var
  FileDeleteJob : TFileDeleteJob;
begin
  AddRuningCount;

  FileDeleteJob := TFileDeleteJob.Create( ActionID );
  FileDeleteJob.SetFilePath( FilePath );
  AddJob( FileDeleteJob );
end;

procedure TMyFileJobHandler.AddFleMove(FilePath, DesFilePath, ActionID: string);
var
  FileMoveJob : TFileMoveJob;
begin
  AddRuningCount;

  FileMoveJob := TFileMoveJob.Create( ActionID );
  FileMoveJob.SetFilePath( FilePath );
  FileMoveJob.SetDesFilePath( DesFilePath );
  AddJob( FileMoveJob );
end;

procedure TMyFileJobHandler.AddRuningCount;
begin
  RunningLock.Enter;
  Inc( RunningCount );
  RunningLock.Leave;
end;

constructor TMyFileJobHandler.Create;
begin
  inherited;
  RunningLock := TCriticalSection.Create;
  RunningCount := 0;
end;

destructor TMyFileJobHandler.Destroy;
begin
  RunningLock.Free;
  inherited;
end;

function TMyFileJobHandler.ReadIsRunning: Boolean;
begin
  RunningLock.Enter;
  Result := RunningCount > 0;
  RunningLock.Leave;
end;

procedure TMyFileJobHandler.RemoveRuningCount;
begin
  RunningLock.Enter;
  Dec( RunningCount );
  RunningLock.Leave;
end;

procedure TFileJobBase.Update;
begin
    // 操作前
  BeforeAction;

  try   // 实际操作
    ActionHandle;
  except
  end;

    // 操作后
  AfterAction;
end;

{ TFileMoveJob }

procedure TFileMoveJob.ActionHandle;
var
  fo: TSHFILEOPSTRUCT;
begin
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := 0;
    wFunc := FO_MOVE;
    pFrom := PChar(FilePath + #0);
    pTo := PChar(DesFilePath + #0);
    fFlags := FOF_NOCONFIRMATION + FOF_NOCONFIRMMKDIR;
  end;
  if SHFileOperation(fo)=0 then
    FaceUpdate( AddToFace );
end;

procedure TFileMoveJob.AddToFace;
begin
  UserFileListApi.AddMoveFile( ExtractFileDir( DesFilePath ), DesFilePath );
  UserFileListApi.RemoveMoveFile( ExtractFileDir( FilePath ), FilePath );
end;

{ TFileDeleteJob }

procedure TFileDeleteJob.ActionHandle;
begin
  if MyShellFile.DeleteFile( FilePath ) then
    FaceUpdate( AddToFace );
end;

procedure TFileDeleteJob.AddToFace;
begin
  UserFileListApi.RemoveMoveFile( ExtractFileDir( FilePath ), FilePath );
end;

{ TFileJob }

procedure TFileJob.SetFilePath(_FilePath: string);
begin
  FilePath := _FilePath;
end;

{ TFileZipBaseJob }

procedure TFileZipBaseJob.AddToFace;
begin
  UserFileListApi.CancelSelect( ExtractFileDir( ZipPath ) );
  UserFileListApi.AddMoveFile( ExtractFileDir( ZipPath ), ZipPath );
end;

destructor TFileZipBaseJob.Destroy;
begin
  FileList.Free;
  inherited;
end;

procedure TFileZipBaseJob.HideForm;
begin
  frmZip.Close;
end;

procedure TFileZipBaseJob.SetFileList(_FileList: TStringList);
begin
  FileList := _FileList;
end;

procedure TFileZipBaseJob.SetZipPath(_ZipPath: string);
begin
  ZipPath := _ZipPath;
end;

procedure TFileZipBaseJob.ShowForm;
begin
  frmZip.Show;
end;

{ TFileZipJob }

procedure TFileZipJob.ActionHandle;
begin
  FaceUpdate( ShowForm );

  frmZip.SetFileList( FileList );
  frmZip.SetZipPath( ZipPath );
  if frmZip.FileZip then
    FaceUpdate( AddToFace )
  else  // 压缩失败，删除压缩文件
    MyShellFile.DeleteFile( ZipPath );

  FaceUpdate( HideForm );
end;

{ TFile7ZipJob }

procedure TFile7ZipJob.ActionHandle;
begin
  FaceUpdate( ShowForm );

  frmZip.SetFileList( FileList );
  frmZip.SetZipPath( ZipPath );
  if frmZip.File7Zip then
    FaceUpdate( AddToFace )
  else  // 压缩失败，删除压缩文件
  if FileExists( ZipPath ) then
    MyShellFile.DeleteFile( ZipPath );

  FaceUpdate( HideForm );
end;


{ TFileUnzipJob }

procedure TFileUnzipJob.ActionHandle;
var
  ZipExt : string;
  IsSuccess : Boolean;
begin
  FaceUpdate( ShowForm );

  frmUnzip.SetUnzipInfo( ZipPath, FolderPath );
  ZipExt := ExtractFileExt( ZipPath );
  ZipExt := LowerCase( ZipExt );
  if ZipExt = ZipExt_Zip then
    IsSuccess := frmUnzip.FileUnzip
  else
  if ZipExt = ZipExt_7z then
    IsSuccess := frmUnzip.FileUn7zip
  else
  if ZipExt = ZipExt_Rar then
    IsSuccess := frmUnzip.FileUnrar
  else
    IsSuccess := False;

      // 界面显示
  if DirectoryExists( FolderPath ) then
    FaceUpdate( AddToFace );

  FaceUpdate( HideForm );
end;

procedure TFileUnzipJob.AddToFace;
begin
  UserFileListApi.CancelSelect( ExtractFileDir( ZipPath ) );
  UserFileListApi.AddMoveFile( ExtractFileDir( ZipPath ), FolderPath );
end;

procedure TFileUnzipJob.HideForm;
begin
  frmUnzip.Close;
end;

procedure TFileUnzipJob.SetZipInfo(_ZipPath, _FolderPath: string);
begin
  ZipPath := _ZipPath;
  FolderPath := _FolderPath;
end;

procedure TFileUnzipJob.ShowForm;
begin
  frmUnzip.Show;
end;

end.
