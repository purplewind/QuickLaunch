unit UFormZip;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, zip, types, SevenZipVcl,
  Vcl.ExtCtrls;

type
  TfrmZip = class(TForm)
    lbZiping: TLabel;
    btnCancel: TButton;
    tmrZipFile: TTimer;
    liFileName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrZipFileTimer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FileList : TStringList;
    ZipPath : string;
  private
    ShowZip : string;
    IsStop : Boolean;
    procedure BeforeZip;
    procedure AfterZip;
  public
    procedure SetFileList( _FileList : TStringList );
    procedure SetZipPath( _ZipPath : string );
    function FileZip : Boolean;
    function File7Zip : Boolean;
  end;

    // ѹ������
  TZipFileBaseHandle = class
  protected
    FileList : TStringList;
    ZipPath : string;
  private
    IsSuccess : Boolean;
    RootPath : string;
  public
    procedure SetFileList( _FileList : TStringList );
    procedure SetZipPath( _ZipPath : string );
    function Update: Boolean;virtual;
  private
    procedure AddZip( Path : string );
    procedure AddZipFile( FilePath : string );virtual;abstract;
    procedure AddZipFolder( FolderPath : string );
    function ReadIsNext : Boolean;
  end;

    // zip ѹ��
  TZipFileHandle = class( TZipFileBaseHandle )
  private
    ZipFile : TZipFile;
  public
    constructor Create;
    function Update: Boolean;override;
    destructor Destroy; override;
  protected
    procedure AddZipFile( FilePath : string );override;
  end;

    // 7 Zip ѹ��
  T7ZipFileHandle = class( TZipFileBaseHandle )
  private
    SevenZip : TSevenZip;
  public
    constructor Create;
    function Update: Boolean;override;
    destructor Destroy; override;
  protected
    procedure AddZipFile( FilePath : string );override;
  private
    procedure OnAdd( Sender: TObject; Filename: Widestring; Filesize:int64 );
  end;

var
  frmZip: TfrmZip;

implementation

uses IOUtils, UMyUtil;

{$R *.dfm}

procedure TfrmZip.AfterZip;
begin
  tmrZipFile.Enabled := False;
end;

procedure TfrmZip.BeforeZip;
begin
  IsStop := False;
  if FileList.Count > 0 then
    ShowZip := FileList[0];
  liFileName.Caption := MyFilePath.getName( ShowZip );
  tmrZipFile.Enabled := True;
end;

procedure TfrmZip.btnCancelClick(Sender: TObject);
begin
  IsStop := True;
  Close;
end;

function TfrmZip.File7Zip: Boolean;
var
  ZipFileHandle : T7ZipFileHandle;
begin
  BeforeZip;

  ZipFileHandle := T7ZipFileHandle.Create;
  ZipFileHandle.SetFileList( FileList );
  ZipFileHandle.SetZipPath( ZipPath );
  Result := ZipFileHandle.Update;
  ZipFileHandle.Free;

  AfterZip;
end;

function TfrmZip.FileZip: Boolean;
var
  ZipFileHandle : TZipFileHandle;
begin
  BeforeZip;

  ZipFileHandle := TZipFileHandle.Create;
  ZipFileHandle.SetFileList( FileList );
  ZipFileHandle.SetZipPath( ZipPath );
  Result := ZipFileHandle.Update;
  ZipFileHandle.Free;

  AfterZip;
end;

procedure TfrmZip.FormCreate(Sender: TObject);
begin
  FileList := TStringList.Create;
end;

procedure TfrmZip.FormDestroy(Sender: TObject);
begin
  FileList.Free;
end;

procedure TfrmZip.SetFileList(_FileList: TStringList);
var
  I: Integer;
begin
  FileList.Clear;
  for I := 0 to _FileList.Count - 1 do
    FileList.Add( _FileList[i] );
end;

procedure TfrmZip.SetZipPath(_ZipPath: string);
begin
  ZipPath := _ZipPath;
end;

procedure TfrmZip.tmrZipFileTimer(Sender: TObject);
begin
  liFileName.Caption := ExtractFileName( ShowZip );
end;

{ TZipFileBaseHandle }

function TZipFileBaseHandle.ReadIsNext: Boolean;
begin
  Result := not frmZip.IsStop;
  if not Result then
    IsSuccess := False;
end;

procedure TZipFileBaseHandle.SetFileList(_FileList: TStringList);
begin
  FileList := _FileList;
end;

procedure TZipFileBaseHandle.SetZipPath(_ZipPath: string);
begin
  ZipPath := _ZipPath;
end;

function TZipFileBaseHandle.Update: Boolean;
var
  i: Integer;
begin
  IsSuccess := True;

  if FileList.Count = 1 then
  begin
    RootPath := FileList[0];
    AddZip( FileList[0] );
  end
  else
  begin
    for i := 0 to FileList.Count - 1 do
    begin
      if not ReadIsNext then
        Break;

      if FileExists( FileList[i] ) then
        RootPath := FileList[i]
      else
        RootPath := ExtractFileDir( FileList[i] );
      AddZip( FileList[i] );
    end;
  end;

  Result := IsSuccess;
end;

procedure TZipFileBaseHandle.AddZip(Path: string);
begin
  if FileExists( Path ) then
    AddZipFile( Path )
  else
  if DirectoryExists( Path ) then
    AddZipFolder( Path );
end;

procedure TZipFileBaseHandle.AddZipFolder(FolderPath: string);
var
  StrArray : TStringDynArray;
  i: Integer;
begin
  StrArray := TDirectory.GetFileSystemEntries( FolderPath );
  for i := 0 to Length( StrArray ) - 1 do
  begin
    if not ReadIsNext then
      Break;

    AddZip( StrArray[i] );
  end;
end;

{ TZipFileHandle }

procedure TZipFileHandle.AddZipFile(FilePath: string);
var
  ZipName : string;
  IsCompleted, IsCancel : Boolean;
begin
    // ��ʾѹ���ļ�
  frmZip.ShowZip := FilePath;

    // ѹ��·��
  if RootPath = FilePath then
    ZipName := ExtractFileName( FilePath )
  else
    ZipName := ExtractRelativePath( MyFilePath.getPath( RootPath ), FilePath );

    // �߳�ѹ��
  IsCompleted := False;
  TThread.CreateAnonymousThread(
    procedure
    begin
      try
        ZipFile.Add( FilePath, ZipName );
      except
      end;
      IsCompleted := True;
    end
  ).Start;

    // �ȴ�ѹ������ �� ѹ��ȡ��
  IsCancel := False;
  while not IsCompleted do
  begin
    if not ReadIsNext and not IsCancel then
    begin
      ZipFile.Close;
      IsCancel := True;
    end;
    Sleep(100);
  end;
end;

constructor TZipFileHandle.Create;
begin
  ZipFile := TZipFile.Create;
end;

destructor TZipFileHandle.Destroy;
begin
  ZipFile.Free;
  inherited;
end;

function TZipFileHandle.Update: Boolean;
begin
  try
      // ��ѹ���ļ�
    ZipFile.Open( ZipPath, zmWrite );

      // ѹ��
    Result := inherited;

      // �ر�ѹ���ļ�
    if IsSuccess then
      ZipFile.Close;
  except
    Result := False;
  end;
end;

{ T7ZipFileHandle }

procedure T7ZipFileHandle.AddZipFile(FilePath: string);
var
  BasePath : string;
begin
  if FilePath = RootPath then
    BasePath := ExtractFileDir( FilePath )
  else
    BasePath := RootPath;
  SevenZip.AddRootDir := BasePath;
  SevenZip.Files.AddString( FilePath );
end;

constructor T7ZipFileHandle.Create;
begin
  SevenZip := TSevenZip.Create( nil );
  SevenZip.AddOptions := [AddSolid];
  SevenZip.LZMACompressType := LZMA;
  SevenZip.LZMACompressStrength := NORMAL;
end;

destructor T7ZipFileHandle.Destroy;
begin
  SevenZip.Free;
  inherited;
end;

procedure T7ZipFileHandle.OnAdd(Sender: TObject; Filename: Widestring;
  Filesize: int64);
begin
  frmZip.ShowZip := Filename;
end;

function T7ZipFileHandle.Update: Boolean;
var
  IsCompleted, IsCancel : Boolean;
begin
  SevenZip.SZFileName := ZipPath;

  Result := inherited;
  if not Result then
    Exit;

  SevenZip.OnAddfile := OnAdd;
  IsCompleted := False;
  TThread.CreateAnonymousThread(
    procedure
    begin
      try
        IsSuccess := SevenZip.Add = S_OK;
      except
        IsSuccess := False;
      end;
      IsCompleted := True;
    end ).Start;

  IsCancel := False;
  while not IsCompleted do
  begin
    if not ReadIsNext and not IsCancel then
    begin
      SevenZip.Cancel;
      IsCancel := True;
    end;
    Sleep(100);
  end;

  Result := IsSuccess;
end;

end.
