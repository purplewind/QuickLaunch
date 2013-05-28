unit UFormUnzip;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SevenZipVcl, zip, Vcl.ExtCtrls, Rar;

type
  TfrmUnzip = class(TForm)
    lbUnziping: TLabel;
    liFileName: TLabel;
    btnCancel: TButton;
    tmrShowFile: TTimer;
    procedure tmrShowFileTimer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    ShowZip : string;
    IsStop : Boolean;
  private
    procedure BeforeUnzip;
    procedure AfterUnzip;
  public
    FolderPath, ZipPath : string;
    procedure SetUnzipInfo( _ZipPath, _FolderPath : string );
    function FileUnzip : Boolean;
    function FileUn7zip : Boolean;
    function FileUnrar : Boolean;
  end;

    // 解压父类
  TUnzipFileBaseHandle = class
  private
    ZipPath, FolderPath : string;
    IsUnZipCompleted : Boolean;
  public
    procedure SetPathInfo( _ZipPath, _FolderPath : string );
    function Update: Boolean;
  protected
    procedure UnZipHandle;virtual;abstract;
    procedure StopZipHandle;virtual;abstract;
  private
    function ReadIsStop : Boolean; // 是否停止解压
  end;

    // 解压 Zip
  TUnzipFileHandle = class( TUnzipFileBaseHandle )
  public
    ZipFile : TZipFile;
  public
    constructor Create;
    destructor Destroy; override;
  protected
    procedure UnZipHandle;override;
    procedure StopZipHandle;override;
  end;

    // 解压 7zip
  TUn7zipFileHandle = class( TUnzipFileBaseHandle )
  private
    SevenZip : TSevenZip;
  public
    constructor Create;
    destructor Destroy; override;
  protected
    procedure UnZipHandle;override;
    procedure StopZipHandle;override;
  private
    procedure ExtractFile( Sender: TObject; Filename: Widestring; Filesize:int64 );
  end;

    // 解压 rar
  TUnrarFileHandle = class( TUnzipFileBaseHandle )
  private
    RarFile : TRAR;
    RarList : TStringList;
  public
    constructor Create;
    destructor Destroy; override;
  protected
    procedure UnZipHandle;override;
    procedure StopZipHandle;override;
  private
    procedure ListFile(Sender: TObject; const FileInformation:TRARFileItem);
    procedure UnzipProgress(Sender: TObject; const FileName:WideString; const ArchiveBytesTotal, ArchiveBytesDone, FileBytesTotal, FileBytesDone:cardinal);
  end;

var
  frmUnzip: TfrmUnzip;

implementation

uses UMyUtil;

{$R *.dfm}

{ TfrmUnzip }

procedure TfrmUnzip.AfterUnzip;
begin
  tmrShowFile.Enabled := False;
end;

procedure TfrmUnzip.BeforeUnzip;
begin
  IsStop := False;
  ShowZip := MyFilePath.getName( ZipPath );
  liFileName.Caption := ShowZip;
  tmrShowFile.Enabled := True;
end;

procedure TfrmUnzip.btnCancelClick(Sender: TObject);
begin
  IsStop := True;
end;

function TfrmUnzip.FileUn7zip: Boolean;
var
  Un7zipFileHandle : TUn7zipFileHandle;
begin
  BeforeUnzip;

  Un7zipFileHandle := TUn7zipFileHandle.Create;
  Un7zipFileHandle.SetPathInfo( ZipPath, FolderPath );
  Result := Un7zipFileHandle.Update;
  Un7zipFileHandle.Free;

  AfterUnzip;
end;

function TfrmUnzip.FileUnrar: Boolean;
var
  UnrarFileHandle : TUnrarFileHandle;
begin
  BeforeUnzip;

  UnrarFileHandle := TUnrarFileHandle.Create;
  UnrarFileHandle.SetPathInfo( ZipPath, FolderPath );
  Result := UnrarFileHandle.Update;
  UnrarFileHandle.Free;

  AfterUnzip;
end;

function TfrmUnzip.FileUnzip: Boolean;
var
  UnzipFileHandle : TUnzipFileHandle;
begin
  BeforeUnzip;

  UnzipFileHandle := TUnzipFileHandle.Create;
  UnzipFileHandle.SetPathInfo( ZipPath, FolderPath );
  Result := UnzipFileHandle.Update;
  UnzipFileHandle.Free;

  AfterUnzip;
end;

procedure TfrmUnzip.SetUnzipInfo(_ZipPath, _FolderPath: string);
begin
  ZipPath := _ZipPath;
  FolderPath := _FolderPath;
end;

procedure TfrmUnzip.tmrShowFileTimer(Sender: TObject);
begin
  liFileName.Caption := ShowZip;
end;

{ TUnzipFileBaseHandle }

function TUnzipFileBaseHandle.ReadIsStop: Boolean;
begin
  Result := frmUnzip.IsStop;
  if Result then
    IsUnZipCompleted := False;
end;

procedure TUnzipFileBaseHandle.SetPathInfo(_ZipPath, _FolderPath: string);
begin
  ZipPath := _ZipPath;
  FolderPath := _FolderPath;
end;

function TUnzipFileBaseHandle.Update: Boolean;
var
  IsCancel, IsCompleted : Boolean;
begin
  IsUnZipCompleted := True;

    // 线程解压
  IsCompleted := False;
  TThread.CreateAnonymousThread(
  procedure
  begin
    try
      UnZipHandle;
    except
    end;
    IsCompleted := True;
  end).Start;

    // 等待压缩结束 或 压缩取消
  IsCancel := False;
  while not IsCompleted do
  begin
    if ReadIsStop and not IsCancel then
    begin
      try
        StopZipHandle;
      except
      end;
      IsCancel := True;
    end;
    Sleep(100);
  end;

  Result := IsUnZipCompleted;
end;

{ TUnzipFileHandle }

constructor TUnzipFileHandle.Create;
begin
  ZipFile := TZipFile.Create;
end;

destructor TUnzipFileHandle.Destroy;
begin
  ZipFile.Free;
  inherited;
end;

procedure TUnzipFileHandle.StopZipHandle;
begin
  try
    ZipFile.Close;
  except
  end;
end;

procedure TUnzipFileHandle.UnZipHandle;
var
  i: Integer;
  FileName : string;
begin
  try
    ZipFile.Open( ZipPath, zmRead );
    for i := 0 to ZipFile.FileCount - 1 do
    begin
      if ReadIsStop then  // 停止解压
        Break;
      try
        FileName := ZipFile.FileNames[i];
        frmUnzip.ShowZip := FileName;
        ZipFile.Extract( i, FolderPath );
      except
      end;
    end;
    ZipFile.Close;
  except
    IsUnZipCompleted := False;
  end;
end;

{ TUn7zipFileHandle }

constructor TUn7zipFileHandle.Create;
begin
  SevenZip := TSevenZip.Create( nil );
  SevenZip.OnExtractfile := ExtractFile;
end;

destructor TUn7zipFileHandle.Destroy;
begin
  SevenZip.Free;
  inherited;
end;

procedure TUn7zipFileHandle.ExtractFile(Sender: TObject; Filename: Widestring;
  Filesize: int64);
begin
  if Filename <> '' then
    frmUnzip.ShowZip :=  MyFilePath.getName( Filename );
end;

procedure TUn7zipFileHandle.StopZipHandle;
begin
  try
    SevenZip.Cancel;
  except
  end;
end;

procedure TUn7zipFileHandle.UnZipHandle;
begin
  try
    SevenZip.ExtrBaseDir := FolderPath;
    SevenZip.ExtractOptions := [ExtractOverwrite];
    SevenZip.SZFileName := ZipPath;
    IsUnZipCompleted := SevenZip.Extract = S_OK;
  except
    IsUnZipCompleted := False;
  end;
end;

{ TUnrarFileHandle }

constructor TUnrarFileHandle.Create;
begin
  RarFile := TRAR.Create(nil);
  RarList := TStringList.Create;
end;

destructor TUnrarFileHandle.Destroy;
begin
  RarList.Free;
  RarFile.Free;
  inherited;
end;

procedure TUnrarFileHandle.ListFile(Sender: TObject;
  const FileInformation: TRARFileItem);
begin
  RarList.Add( FileInformation.FileName );
end;

procedure TUnrarFileHandle.StopZipHandle;
begin
  try
    RarFile.Abort;
  except
  end;
end;

procedure TUnrarFileHandle.UnZipHandle;
begin
  try
    RarFile.OnListFile := ListFile;
    RarFile.DllName := DllPath_Rar;
    RarFile.OpenFile( ZipPath );
    RarFile.OnProgress := UnzipProgress;
    IsUnZipCompleted := RarFile.Extract( FolderPath, True, RarList );
  except
    IsUnZipCompleted := False;
  end;
end;

procedure TUnrarFileHandle.UnzipProgress(Sender: TObject;
  const FileName: WideString; const ArchiveBytesTotal, ArchiveBytesDone,
  FileBytesTotal, FileBytesDone: cardinal);
begin
  frmUnzip.ShowZip := ExtractFileName( FileName );
end;

end.
