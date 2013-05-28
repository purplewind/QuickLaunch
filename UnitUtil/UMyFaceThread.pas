unit UMyFaceThread;

interface

uses classes, Generics.Collections, SyncObjs, UFileSearch, UFrameExplorer, Sysutils, Inifiles,
     IOUtils, Types, UThreadUtil;

type

{$Region ' �ļ��б� Frame ' }

    // Ŀ¼������
  TFolderOpenFilter = class
  public
    FilterStr : string;
    FilterCount : Integer;
  public
    constructor Create( _FilterStr : string );
    procedure AddCount;
  end;
  TFolderOpenFilterList = class( TObjectList<TFolderOpenFilter> )end;

    // ��ȡ�ļ��б�
  TFileListReadJob = class( TThreadJob )
  private
    FolderPath : string;
  private
    FileList : TFileList;
    FilterList : TFolderOpenFilterList;
  public
    constructor Create( _FolderPath : string );
    procedure Update;override;
    destructor Destroy; override;
  private
    procedure ReadFileList;
    procedure ShowFileList;
    procedure FindFilter;
    procedure ShowFilter;
    procedure AddParentFolder;
  private
    procedure SortFileList;
    procedure MoveFile( FileName : string );
  private
    procedure AddFilter( FilterStr : string );
    procedure SortFilter;
  end;

    // ѡ�� �ļ��б��е��ļ�
  TFileListSelectJob = class( TThreadJob )
  private
    FolderPath, ChildPath : string;
  public
    constructor Create( _FolderPath, _ChildPath : string );
    procedure Update;override;
  private
    procedure SelectChildPath;
  end;

    // ��¼ �ļ��б��ѡ��
  TFileListMarkSelectJob = class( TThreadJob )
  private
    FolderPath, SelectName : string;
  public
    constructor Create( _FolderPath, _SelectName : string );
    procedure Update;override;
  end;

    // Ŀ¼�仯 Job
  TFolderChangeNofityJob = class( TThreadJob )
  private
    FolderPath : string;
    OldFileList, NewFileList : TStringList;
    FileName : string;
  public
    constructor Create( _FolderPath : string );
    procedure Update;override;
    destructor Destroy; override;
  private
    procedure ReadOldFileList;
    procedure ReadNewFileList;
  private
    procedure AddFile;
    procedure RemoveFile;
  end;

{$EndRegion}

{$Region ' Ŀ��·�� Form ' }

  TFolderExpandInfo = class
  public
    FolderPath : string;
    HasChildFolder : Boolean;
  public
    constructor Create( _FolderPath : string; _HasChildFolder : Boolean );
  end;
  TFolderExpandList = class( TObjectList<TFolderExpandInfo> )end;


    // չ������·��
  TDesDriverExpandJob = class( TThreadJob )
  private
    FolderPath : string;
  private
    FolderExpandList : TFolderExpandList;
  public
    constructor Create( _FolderPath : string );
    procedure Update;override;
    destructor Destroy; override;
  private
    procedure ReadFileList;
    procedure ShowFileList;
  end;

    // ��ȡ�ļ��б�
  TDesFileListReadJob = class( TThreadJob )
  private
    FolderPath : string;
  private
    FileList : TFileList;
  public
    constructor Create( _FolderPath : string );
    procedure Update;override;
    destructor Destroy; override;
  private
    procedure ReadFileList;
    procedure ShowFileList;
  end;

{$EndRegion}

    // ���� Job ������
  TMyFaceJobHandler = class( TMyJobHandler )
  public        // �ļ��б� Frame
    procedure ReadFileList( FolderPath : string );
    procedure FileListSelectChild( FolderPath, ChildPath : string );
    procedure FileListMarkSelect( FolderPath, SelectName : string );
    procedure FolderChangeNofity( FolderPath : string );
  public        // Ŀ��·�� Form
    procedure ExpandDesDriver( FolderPath : string );
    procedure ReadDesFileList( FolderPath : string );
  end;


var
  MyFaceJobHandler : TMyFaceJobHandler;

implementation

uses UMyUtil, UFrameMyComputer, UFormDestination, VirtualTrees;


{ TFolderOpenFilter }

procedure TFolderOpenFilter.AddCount;
begin
  Inc( FilterCount );
end;

constructor TFolderOpenFilter.Create(_FilterStr: string);
begin
  FilterStr := _FilterStr;
  FilterCount := 1;
end;

{ TFolderExpandInfo }

constructor TFolderExpandInfo.Create(_FolderPath: string;
  _HasChildFolder: Boolean);
begin
  FolderPath := _FolderPath;
  HasChildFolder := _HasChildFolder;
end;

{ TFileListReadJob }

procedure TFileListReadJob.AddFilter(FilterStr: string);
var
  IsFind : Boolean;
  i: Integer;
  FilterInfo : TFolderOpenFilter;
begin
    // �ж��Ƿ����
  IsFind := False;
  for i := 0 to FilterList.Count - 1 do
    if FilterList[i].FilterStr = FilterStr then
    begin
      FilterList[i].AddCount;
      IsFind := True;
      Break;
    end;

    // �Ѵ���
  if IsFind then
    Exit;

    // ������
  FilterInfo := TFolderOpenFilter.Create( FilterStr );
  FilterList.Add( FilterInfo );
end;

procedure TFileListReadJob.AddParentFolder;
begin
  if not MyFilePath.getIsRoot( FolderPath ) then
    FaceFileListApi.AddBackFolder( ExtractFileDir( FolderPath ) );
end;

constructor TFileListReadJob.Create(_FolderPath: string);
begin
  FolderPath := _FolderPath;
  FileList := TFileList.Create;
  FilterList := TFolderOpenFilterList.Create;
end;

destructor TFileListReadJob.Destroy;
begin
  FilterList.Free;
  FileList.Free;
  inherited;
end;

procedure TFileListReadJob.FindFilter;
var
  i : Integer;
  FileExtStr : string;
  FilterInfo : TFolderOpenFilter;
begin
    // û���ļ�
  if FileList.Count = 0 then
    Exit;

    // ��������ļ��Ĺ�����
  FilterInfo := TFolderOpenFilter.Create( FileFilter_All );
  FilterInfo.FilterCount := FileList.Count;
  FilterList.Add( FilterInfo );

    // �����ļ�������׺����
  for i := 0 to FileList.Count - 1 do
    if FileList[i].IsFolder then
      AddFilter( FileFilter_Folder )
    else
    begin
      AddFilter( FileFilter_File );

      FileExtStr := ExtractFileExt( FileList[i].FileName );
      AddFilter( FileExtStr );
    end;

    // ����Ŀ��С����
  SortFilter;
end;


procedure TFileListReadJob.MoveFile(FileName: string);
var
  FilePos : Integer;
  i: Integer;
begin
  FilePos := -1;
  for i := 0 to FileList.Count - 1 do
  begin
    if not FileList[i].IsFolder and ( FilePos = -1 ) then // ��һ���ļ���λ��
      FilePos := i;
    if FileList[i].FileName = FileName then  // �ҵ���·��
    begin
      if FileList[i].IsFolder then
        FileList.Move( i, 0 )
      else
      if FilePos >= 0 then
        FileList.Move( i, FilePos );
      Break;
    end;
  end;
end;

procedure TFileListReadJob.ReadFileList;
var
  FolderExplorer : TFolderExplorer;
begin
  FolderExplorer := TFolderExplorer.Create( FolderPath );
  FolderExplorer.SetFileList( FileList );
  FolderExplorer.Update;
  FolderExplorer.Free;

  SortFileList;
end;

procedure TFileListReadJob.ShowFileList;
var
  i: Integer;
  Params : TExplorerAddParams;
  ParentFolderPath : string;
  HasFile : Boolean;
  FolderCount : Integer;
begin
    // �������ҳ��
  FaceFolderPageApi.ControlPage( FolderPath );

    // ����ļ��б�
  FaceFileListApi.ClearFiles;

    // ��ʾ�б��ļ�
  HasFile := False;
  FolderCount := 0;
  ParentFolderPath := MyFilePath.getPath( FolderPath );
  for i := 0 to FileList.Count - 1 do
  begin
    Params.FilePath := ParentFolderPath + FileList[i].FileName;
    Params.IsFolder := FileList[i].IsFolder;
    Params.FileSize := FileList[i].FileSize;
    Params.FileTime := FileList[i].FileTime;
    FaceFileListApi.AddFile( Params );
    HasFile := HasFile or not Params.IsFolder;
    if Params.IsFolder then
      Inc( FolderCount );
  end;
end;

procedure TFileListReadJob.ShowFilter;
var
  i: Integer;
begin
    // �������ҳ��
  FaceFolderPageApi.ControlPage( FolderPath );

    // ��վɹ���
  FaceFileFilterApi.ClearFilters;

    // ��ʾ���й���
  for i := 0 to FilterList.Count - 1 do
    FaceFileFilterApi.AddFilter( FilterList[i].FilterStr, FilterList[i].FilterCount );
end;

procedure TFileListReadJob.SortFileList;
var
  HistorySelectList : TStringList;
  IniFile : TIniFile;
  i: Integer;
begin
    // ��ȡ��ʷѡ��
  HistorySelectList := TStringList.Create;
  IniFile := TIniFile.Create( MyAppData.getExplorerHistoryPath );
  try
    IniFile.ReadSection( FolderPath, HistorySelectList );
  except
  end;
  IniFile.Free;

    // �ƶ��ļ�
  for i := 0 to HistorySelectList.Count - 1 do
    MoveFile( HistorySelectList[i] );
  HistorySelectList.Free;
end;

procedure TFileListReadJob.SortFilter;
var
  i: Integer;
  IsExistFolderFilter : Boolean;
  StartCount : Integer;
  j: Integer;
begin
    // ��Ŀ¼�����ŵ��ڶ�
  IsExistFolderFilter := False;
  for i := 0 to FilterList.Count - 1 do
    if FilterList[i].FilterStr = FileFilter_Folder then
    begin
      FilterList.Move( i, 1 );
      IsExistFolderFilter := True;
      Break;
    end;

    // ��ʼ�����λ��
  if IsExistFolderFilter then
    StartCount := 2
  else
    StartCount := 1;

    // ð������
  for i := StartCount to FilterList.Count - 2 do
    for j := StartCount to FilterList.Count - 2 - ( i - StartCount ) do
      if FilterList[j].FilterCount < FilterList[j+1].FilterCount then
        FilterList.Move( j + 1, j );
end;

procedure TFileListReadJob.Update;
begin
    // ��ȡ�ļ��б�
  ReadFileList;

    // ��ʾ�ļ��б�
  FaceUpdate( ShowFileList );

    // Ѱ�ҹ�����Ϣ
  FindFilter;

    // ��ʾ������Ϣ
  FaceUpdate( ShowFilter );

    // ��Ӹ�Ŀ¼��ť
  FaceUpdate( AddParentFolder );
end;

{ TFileListSelectJob }

constructor TFileListSelectJob.Create(_FolderPath, _ChildPath: string);
begin
  FolderPath := _FolderPath;
  ChildPath := _ChildPath;
end;

procedure TFileListSelectJob.SelectChildPath;
begin
  UserFileListApi.SelectChild( FolderPath, ChildPath );
end;

procedure TFileListSelectJob.Update;
begin
  FaceUpdate( SelectChildPath );
end;

{ TFileListMarkSelectJob }

constructor TFileListMarkSelectJob.Create(_FolderPath, _SelectName: string);
begin
  FolderPath := _FolderPath;
  SelectName := _SelectName;
end;

procedure TFileListMarkSelectJob.Update;
var
  IniFile : TIniFile;
  HistoryList : TStringList;
begin
  IniFile := TIniFile.Create( MyAppData.getExplorerHistoryPath );
  try
      // ɾ���ɵ�λ��
    IniFile.DeleteKey( FolderPath, SelectName );

      // ���Ʊ�����ʷ��
    HistoryList := TStringList.Create;
    IniFile.ReadSection( FolderPath, HistoryList );
    if HistoryList.Count >= 7 then
      IniFile.DeleteKey( FolderPath, HistoryList[0] );
    HistoryList.Free;

      // ��ӵ��µ�λ��
    IniFile.WriteString( FolderPath, SelectName, SelectName );

      // ��ʷ·������
    HistoryList := TStringList.Create;
    IniFile.ReadSections( HistoryList );
    try
      if HistoryList.Count > 100 then
        IniFile.EraseSection( HistoryList[0] );
    except
    end;
    HistoryList.Free
  except
  end;
  IniFile.Free;
end;

{ TDesDriverExpandJob }

constructor TDesDriverExpandJob.Create(_FolderPath: string);
begin
  FolderPath := _FolderPath;
  FolderExpandList := TFolderExpandList.Create;
end;

destructor TDesDriverExpandJob.Destroy;
begin
  FolderExpandList.Free;
  inherited;
end;

procedure TDesDriverExpandJob.ReadFileList;
var
  FolderList : TStringDynArray;
  i: Integer;
  ChildPath : string;
  HasChildFolder : Boolean;
  FolderExpandInfo : TFolderExpandInfo;
begin
  FolderList := TDirectory.GetDirectories( FolderPath );
  for i := 0 to Length( FolderList ) - 1 do
  begin
    ChildPath := FolderList[i];
    HasChildFolder := MyFilePath.getHasChildFolder( ChildPath );
    FolderExpandInfo := TFolderExpandInfo.Create( ChildPath, HasChildFolder );
    FolderExpandList.Add( FolderExpandInfo );
  end;
end;

procedure TDesDriverExpandJob.ShowFileList;
var
  i: Integer;
begin
  for i := 0 to FolderExpandList.Count - 1 do
    FaceDesDriverApi.AddDriver( FolderPath, FolderExpandList[i].FolderPath, FolderExpandList[i].HasChildFolder );
  FaceDesDriverApi.ExpandDriver( FolderPath );
end;

procedure TDesDriverExpandJob.Update;
begin
    // ����
  ReadFileList;

    // ��ʾ
  FaceUpdate( ShowFileList );
end;

{ TDesFileListReadJob }

constructor TDesFileListReadJob.Create(_FolderPath: string);
begin
  FolderPath := _FolderPath;
  FileList := TFileList.Create;
end;

destructor TDesFileListReadJob.Destroy;
begin
  FileList.Free;
  inherited;
end;

procedure TDesFileListReadJob.ReadFileList;
var
  FolderExplorer : TFolderExplorer;
begin
  FolderExplorer := TFolderExplorer.Create( FolderPath );
  FolderExplorer.SetFileList( FileList );
  FolderExplorer.Update;
  FolderExplorer.Free;
end;

procedure TDesFileListReadJob.ShowFileList;
var
  i: Integer;
  IsFolder : Boolean;
  ParentPath, FilePath : string;
begin
  ParentPath := MyFilePath.getPath( FolderPath );
  for i := 0 to FileList.Count - 1 do
  begin
    FilePath := ParentPath + FileList[i].FileName;
    UserDesFileListApi.AddFile( FilePath, FileList[i].IsFolder );
  end;
end;

procedure TDesFileListReadJob.Update;
begin
    // �����ļ�
  ReadFileList;

    // ��ʾ�������
  FaceUpdate( ShowFileList );
end;

{ TMyFaceJobHandler }

procedure TMyFaceJobHandler.ExpandDesDriver(FolderPath: string);
var
  DesDriverExpandJob : TDesDriverExpandJob;
begin
  DesDriverExpandJob := TDesDriverExpandJob.Create( FolderPath );
  AddJob( DesDriverExpandJob );
end;

procedure TMyFaceJobHandler.FileListMarkSelect(FolderPath, SelectName: string);
var
  FileListMarkSelectJob : TFileListMarkSelectJob;
begin
  FileListMarkSelectJob := TFileListMarkSelectJob.Create( FolderPath, SelectName );
  AddJob( FileListMarkSelectJob );
end;

procedure TMyFaceJobHandler.FileListSelectChild(FolderPath, ChildPath: string);
var
  FileListSelectJob : TFileListSelectJob;
begin
  FileListSelectJob := TFileListSelectJob.Create( FolderPath, ChildPath );
  AddJob( FileListSelectJob );
end;

procedure TMyFaceJobHandler.FolderChangeNofity(FolderPath: string);
var
  FolderChangeNofityJob : TFolderChangeNofityJob;
begin
  FolderChangeNofityJob := TFolderChangeNofityJob.Create( FolderPath );
  AddJob( FolderChangeNofityJob );
end;

procedure TMyFaceJobHandler.ReadDesFileList(FolderPath: string);
var
  DesFileListReadJob : TDesFileListReadJob;
begin
  DesFileListReadJob := TDesFileListReadJob.Create( FolderPath );
  AddJob( DesFileListReadJob );
end;

procedure TMyFaceJobHandler.ReadFileList(FolderPath: string);
var
  FileListReadJob : TFileListReadJob;
begin
  FileListReadJob := TFileListReadJob.Create( FolderPath );
  AddJob( FileListReadJob );
end;

{ TFolderChangeNofityJob }

procedure TFolderChangeNofityJob.AddFile;
var
  FilePath : string;
begin
  FilePath := MyFilePath.getPath( FolderPath ) + FileName;
  UserFileListApi.AddMoveFile( FolderPath, FilePath );
end;

constructor TFolderChangeNofityJob.Create(_FolderPath: string);
begin
  FolderPath := _FolderPath;
  NewFileList := TStringList.Create;
  OldFileList := TStringList.Create;
end;

destructor TFolderChangeNofityJob.Destroy;
begin
  OldFileList.Free;
  NewFileList.Free;
  inherited;
end;

procedure TFolderChangeNofityJob.ReadNewFileList;
begin
  TDirectory.GetFileSystemEntries( FolderPath,
    function(const Path: string; const SearchRec: TSearchRec): Boolean
    begin
      NewFileList.Add( SearchRec.Name );
      Result := False;
    end);
end;

procedure TFolderChangeNofityJob.ReadOldFileList;
var
  PathList : TStringList;
  i: Integer;
begin
  PathList := UserFileListApi.ReadFileList( FolderPath );
  for i := 0 to PathList.Count - 1 do
    OldFileList.Add( ExtractFileName( PathList[i] ) );
  PathList.Free;
end;

procedure TFolderChangeNofityJob.RemoveFile;
var
  FilePath : string;
begin
  FilePath := MyFilePath.getPath( FolderPath ) + FileName;
  UserFileListApi.RemoveMoveFile( FolderPath, FilePath );
end;

procedure TFolderChangeNofityJob.Update;
var
  i, FileIndex: Integer;
begin
    // ��ȡ��ǰ�����ļ�
  FaceUpdate( ReadOldFileList );

    // ��ȡ��ǰӲ���ļ�
  ReadNewFileList;

    // �Ƿ�����������ļ�
  for i := 0 to NewFileList.Count - 1 do
  begin
    FileName := NewFileList[i];
    FileIndex := OldFileList.IndexOf( FileName );
    if FileIndex >= 0 then
      OldFileList.Delete( FileIndex )
    else
      FaceUpdate( AddFile );
  end;

    // �Ƿ�����Ѿ�ɾ�����ļ�
  for i := 0 to OldFileList.Count - 1 do
  begin
    FileName := OldFileList[i];
    FaceUpdate( RemoveFile );
  end;
end;

end.
