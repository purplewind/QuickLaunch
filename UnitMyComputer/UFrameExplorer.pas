unit UFrameExplorer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  RzListVw, VirtualTrees, RzTabs, Vcl.ToolWin, Vcl.ImgList, Vcl.Menus, StrUtils, math,
  Vcl.StdCtrls, Vcl.Shell.ShellCtrls, dirnotify, Vcl.Buttons, RzPanel, IOUtils,
  Vcl.Grids, ActiveX;

type

    // ��Ӳ���
  TExplorerAddParams = record
  public
    FilePath : string;
    IsFolder : Boolean;
  public
    FileSize : Int64;
    FileTime : TDateTime;
  end;

    // �� Frame
  TFrameExplorer = class(TFrame)
    plMain: TPanel;
    il24: TImageList;
    il24Gray: TImageList;
    pmUpLevel: TPopupMenu;
    plCenter: TPanel;
    Splitter1: TSplitter;
    plRight: TPanel;
    vstFilter: TVirtualStringTree;
    tmrFilter: TTimer;
    pmManage: TPopupMenu;
    miCopy: TMenuItem;
    miMove: TMenuItem;
    miRename: TMenuItem;
    miDelete: TMenuItem;
    N4: TMenuItem;
    il16: TImageList;
    pmFolder: TPopupMenu;
    miRefresh: TMenuItem;
    miExplorer: TMenuItem;
    N1: TMenuItem;
    miZip: TMenuItem;
    miUnzip: TMenuItem;
    tmrFolderChange: TTimer;
    pmEmpty: TPopupMenu;
    plStatus: TPanel;
    sbFolderPath: TStatusBar;
    btnCopyPath: TSpeedButton;
    lbCopyPath: TPanel;
    edtSearch: TButtonedEdit;
    plSearch: TPanel;
    miNewFolder: TMenuItem;
    plPreview: TPanel;
    ilSmallPicture: TImage;
    PcBigPreview: TRzPageControl;
    tsFileList: TRzTabSheet;
    tsBigPicture: TRzTabSheet;
    vstExplorer: TVirtualStringTree;
    ilBigPicture: TImage;
    PcPreview: TRzPageControl;
    tsPreviewFileList: TRzTabSheet;
    tsPreviewImage: TRzTabSheet;
    PcSmallPreview: TRzPageControl;
    tsSmallPicture: TRzTabSheet;
    tsSmallText: TRzTabSheet;
    ilSmallText: TImage;
    tsBigText: TRzTabSheet;
    tsPreviewExt: TRzTabSheet;
    vstPreviewExt: TVirtualStringTree;
    tmrSaveText: TTimer;
    tsBigDoc: TRzTabSheet;
    mmoBigWord: TRichEdit;
    tsSmallWord: TRzTabSheet;
    ilSmallWord: TImage;
    tsSmallExcel: TRzTabSheet;
    ilSmallExcel: TImage;
    tsBigExcel: TRzTabSheet;
    sgExcel: TStringGrid;
    plExcelCopy: TPanel;
    lbExcelText: TLabel;
    sbExcelText: TSpeedButton;
    lbExcelTextCopy: TLabel;
    tmrBigPicture: TTimer;
    mmoBigText: TMemo;
    plBigTextTop: TPanel;
    plTextSave: TPanel;
    lbTextSaved: TLabel;
    Image1: TImage;
    plImageScroll: TPageScroller;
    plImageList: TPanel;
    procedure vstExplorerGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstExplorerGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstExplorerDblClick(Sender: TObject);
    procedure tbtnUpFolderClick(Sender: TObject);
    procedure tbtnFileFirstClick(Sender: TObject);
    procedure tbtnFolderFirstClick(Sender: TObject);
    procedure vstExplorerHeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure vstExplorerCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure pmUpLevelPopup(Sender: TObject);
    procedure miUpLevelClick(Sender: TObject);
    procedure vstFilterGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstFilterGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstFilterPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure vstFilterFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure tmrFilterTimer(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure vstExplorerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miCopyClick(Sender: TObject);
    procedure miMoveClick(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure miRenameClick(Sender: TObject);
    procedure tbtnNewFolderClick(Sender: TObject);
    procedure miRefreshClick(Sender: TObject);
    procedure miExplorerClick(Sender: TObject);
    procedure miCopyPathClick(Sender: TObject);
    procedure mi7zipClick(Sender: TObject);
    procedure miZipClick(Sender: TObject);
    procedure miUnzipClick(Sender: TObject);
    procedure pmManagePopup(Sender: TObject);
    procedure tmrFolderChangeTimer(Sender: TObject);
    procedure FolderNotifyChange;
    procedure DirNotifyChange(Sender: TObject);
    procedure sbFolderPathMouseEnter(Sender: TObject);
    procedure btnCopyPathMouseLeave(Sender: TObject);
    procedure btnCopyPathClick(Sender: TObject);
    procedure lbCopyPathMouseLeave(Sender: TObject);
    procedure ftbtnUpFolderilMainClick(Sender: TObject);
    procedure ftbtnNewFolderilMainClick(Sender: TObject);
    procedure vstExplorerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtSearchRightButtonClick(Sender: TObject);
    procedure edtSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miNewFolderClick(Sender: TObject);
    procedure vstExplorerChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstExplorerFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure ilSmallPictureMouseEnter(Sender: TObject);
    procedure ilSmallPictureMouseLeave(Sender: TObject);
    procedure ilSmallPictureClick(Sender: TObject);
    procedure ilSmallTextMouseEnter(Sender: TObject);
    procedure ilSmallTextMouseLeave(Sender: TObject);
    procedure ilSmallTextClick(Sender: TObject);
    procedure vstPreviewExtGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstPreviewExtGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstPreviewExtFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure tmrSaveTextTimer(Sender: TObject);
    procedure mmoBigTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ilSmallWordMouseEnter(Sender: TObject);
    procedure ilSmallWordMouseLeave(Sender: TObject);
    procedure ilSmallWordClick(Sender: TObject);
    procedure ilSmallExcelMouseEnter(Sender: TObject);
    procedure ilSmallExcelMouseLeave(Sender: TObject);
    procedure ilSmallExcelClick(Sender: TObject);
    procedure lbExcelTextMouseEnter(Sender: TObject);
    procedure sbExcelTextMouseLeave(Sender: TObject);
    procedure lbExcelTextCopyMouseLeave(Sender: TObject);
    procedure sbExcelTextClick(Sender: TObject);
    procedure lbExcelTextCopyMouseEnter(Sender: TObject);
    procedure sgExcelSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure tmrBigPictureTimer(Sender: TObject);
    procedure vstExplorerDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure vstExplorerDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
  public        // ��ʼ/����
    procedure IniFrame;
  private
    TsFolder : TRzTabSheet;  // �ļ���ҳ��
    FolderPath : string;  // �ļ���
    DirNotify : TDirNotify;  // Ŀ¼������
    IsFileSelected : Boolean; // �Ƿ�ѡ���ļ�
  public
    procedure SetTsFolder( _TsFolder : TRzTabSheet );
    procedure SetFolderPath( _FolderPath : string );
    procedure SetNotifyPath( NotifyPath : string );
  end;

{$Region ' ���� ���� ' }

    // �ļ��б� ����
  TVstFileListData = record
  public
    FilePath : WideString;
    IsFolder : Boolean;
  public
    FileSize : Int64;
    FileTime : TDateTime;
  public
    ShowName, ShowSize, ShowTime : WideString;
    ShowIcon : Integer;
  public
    IsLocked : Boolean;
  end;
  PVstFileListData = ^TVstFileListData;

    // �ļ����� ����
  TVstFileFilterData = record
  public
    FilterStr : WideString;
  public
    IsSelected : Boolean;
    ShowName : WideString;
    ShowIcon : Integer;
  end;
  PVstFileFilterData = ^TVstFileFilterData;

    // ��ͬ��׺���ļ�
  TVstPreviewExtData = record
  public
    FilePath : WideString;
  public
    ShowName : WideString;
    ShowIcon : Integer;
    ActionType : WideString;
  end;
  PVstPreviewExtData = ^TVstPreviewExtData;

{$EndRegion}

{$Region ' ���� �ӿ� ' }

    // Frame �ӿ�
  TFaceFrameExplorerApi = class
  private
    FrameExplorer : TFrameExplorer;
  public
    procedure ActivateFrame( _FrameExplorer : TFrameExplorer );
  public
    function ReadFilterList : TStringList; // ��ȡ��������Ϣ
    function ReadSearchName : string;  // ��ȡ������Ϣ
  public
    procedure ClearSearchHistory;  // ���������Ϣ
  end;

    // ˢ�¹�����Ϣ
  TFileListRefreshFilterHandle = class
  private
    FilterList : TStringList;
    SeachName : string;
    vstFileList : TVirtualStringTree;
  private
    IsShowAll, IsShowAllSearch : Boolean;
    IsShowFolder, IsShowFile : Boolean;
  public
    constructor Create( _FilterList: TStringList; _SeachName : string );
    procedure SetVstFileList( _vstFileList : TVirtualStringTree );
    procedure Update;
  private
    procedure FindSpecialFilter;
    function ReadIsVisible( SelectNode : PVirtualNode ): Boolean;
    function ReadIsFilter( SelectNode : PVirtualNode ): Boolean;
    function ReadIsSearch( SelectNode : PVirtualNode ): Boolean;
  end;

    // �ļ��б� �ӿ�
  TFaceFileListApi = class
  public
    vstFileList : TVirtualStringTree;
  public        // ����
    procedure ActivateVstFileList( _vstFileList : TVirtualStringTree );
  public
    procedure ClearFiles; // ����ļ�
    procedure AddFile( Params : TExplorerAddParams );  // ����ļ�
    procedure AddBackFolder( FolderPath : string );  // ��ӷ���Ŀ¼
    procedure InsertFile( Params : TExplorerAddParams );  // �����ļ�
    procedure RemoveFile( Path : string ); // ɾ���ļ�
    function ReadExist( Path : string ): Boolean;  // �Ƿ�����ļ�
    procedure RefreshFileInfo( Params: TExplorerAddParams ); // ˢ�½ڵ���Ϣ
  public
    procedure ShowFileFirst;  // ������ʾ�ļ�
    procedure ShowFolderFirst; // ������ʾĿ¼
    procedure SelectPath( Path : string ); // ѡ��·��
    procedure CancelSelect; // ȡ��ѡ��
    procedure RefreshFileFilter( FilterList: TStringList; SeachName : string );  // ˢ�¹�����Ϣ
    function ReadSelectList : TStringList;  // ��ȡѡ����ļ��б�
    function ReadFocusPath : string; // ��ȡѡ�е�·��
    function ReadPathList : TStringList; // ��ȡ����·��
  private
    function ReadNode( Path : string ): PVirtualNode; // Ѱ�ҽڵ�
    function CreateInseartNode : PVirtualNode; // ����Ľڵ�
  end;

    // �ļ����� �ӿ�
  TFaceFileFilterApi = class
  public
    vstFileFilter : TVirtualStringTree;
  public        // ����
    procedure ActivateVstFileFilter( _vstFileFilter : TVirtualStringTree );
  public
    procedure ClearFilters;  // ��չ�����
    procedure AddFilter( FilterStr : string; FilterCount : Integer );  // ��ӹ�����
  end;

    // �ļ�Ԥ�� �ӿ�
  TFacePreviewApi = class
  public
    plPreview : TPanel;
  public
    PcMain : TRzPageControl;
    tsFileList, tsBigPicture, tsBigText, tsBigWord, tsBigExcel : TRzTabSheet;
    ilBigPicture : TImage;
    mmoBigText : TMemo;
    mmoBigWord : TRichEdit;
    sgBigExcel : TStringGrid;
    plExcelText : TPanel;
    lbExcelText : TLabel;
    tmrBigPicture : TTimer;
  public
    PcPreview : TRzPageControl;
    tsPreviewFileList, tsPreviewPicture, tsPreviewExt : TRzTabSheet;
    plImageList : TPanel;
  public
    PcSmallPreview : TRzPageControl;
    tsSmallPicture, tsSmallText, tsSmallWord, tsSmallExcel : TRzTabSheet;
    ilSmallPicture, ilSmallText, ilSmallWord, ilSmallExcel : TImage;
  public
    procedure ActivateFrame( FrameExplorer : TFrameExplorer );
  public
    procedure ShowSmallPicture( Path : string );
    procedure ShowSmallText;
    procedure ShowSmallDoc;
    procedure ShowSmallExcel;
    procedure ShowSmallEmpty;
  public
    procedure ShowBigPicture( Path : string );
    procedure ShowBigText( Path : string );
    procedure ShowBigWord( Path : string );
    procedure ShowBigExcel( Path : string );
    procedure ShowBigFileList;
  public
    procedure ShowPreviewPictrure( Path : string );
    procedure PreviewPictureClick( Sender : TObject );
    procedure ClosePreviewPicture;
    procedure SetBigPictureTimer( IsEnable : Boolean );
    procedure ShowBackPicture;
    procedure CloseBackPicture;
  public
    procedure ShowPreviewText( Path : string );
    function ReadIsTextChange : Boolean;
    procedure SavePreviewText;
    procedure ShowBackText;
    procedure CloseBackText;
  public
    procedure ShowPreviewWord( Path : string );
    procedure ShowBackWord;
    procedure CloseBackWord;
  public
    procedure ShowPreviewExcel( Path : string );
    procedure ShowBackExcel;
    procedure CloseBackExcel;
  public
    procedure ShowPreviewFilter;
  public
    function ReadIsLockPreview : Boolean;
    procedure SetIsLockPreview( IsLockPreview : Boolean );
  end;

    // Ԥ����ͬ��׺
  TFacePreviewExtApi = class
  private
    vstPreviewExt : TVirtualStringTree;
  public
    procedure ActivatePrivewExt( _vstPreviewExt : TVirtualStringTree );
  public
    procedure ClearFiles;
    procedure AddFile( FilePath, ActionType : string );
  end;

{$EndRegion}

{$Region ' �û� �ӿ� ' }

    // �ƶ��ļ� ����
  TFileListMoveFileHandle = class
  private
    SelectPathList : TStringList;
    DesPath : string;  // ���Ƶ�Ŀ��·��
  public
    constructor Create( _SelectPathList : TStringList );
    procedure Update;
  protected
    function FindDesPath : Boolean;
    procedure AddActoin( FilePath, DesFilePath : string );virtual;abstract;
    function ReadActionType : string;virtual;abstract;
  end;

    // �����ļ�
  TFileListCopyFileHandle = class( TFileListMoveFileHandle )
  protected
    procedure AddActoin( FilePath, DesFilePath : string );override;
    function ReadActionType : string;override;
  end;

    // �ƶ��ļ�
  TFileListCutFileHandle = class( TFileListMoveFileHandle )
  protected
    procedure AddActoin( FilePath, DesFilePath : string );override;
    function ReadActionType : string;override;
  end;

    // �ļ��б��û��ӿ�
  UserFileListApi = class
  public
    class procedure ShowFileFirst( FolderPath : string );  // ������ʾ�ļ�
    class procedure ShowFolderFirst( FolderPath : string );  // ������ʾĿ¼
  public
    class procedure SelectChild( FolderPath, ChildPath : string ); // ѡ����·��
    class procedure RefreshFilter( FolderPath : string ); // ����Ҫ��ʾ����Ϣ
    class procedure CancelSelect( FolderPath : string ); // ȡ��ѡ��
  public
    class procedure CopyFiles( FolderPath : string );  // ����ѡ�е��ļ�
    class procedure MoveFiles( FolderPath : string );  // �ƶ�ѡ�е��ļ�
    class procedure DeleteFiles( FolderPath : string ); // ɾ��ѡ�е��ļ�
    class procedure RenameFile( FolderPath : string ); // �ļ�����
  public
    class procedure FileZip( FolderPath : string ); // ѹ���ļ�
    class procedure File7Zip( FolderPath : string );  // 7 Zip ѹ���ļ�
    class procedure FileUnzip( FolderPath : string ); // ��ѹ�ļ�
  public
    class procedure NewFolder( FolderPath : string ); // �½��ļ���
    class procedure RefreshFolder( FolderPath : string ); // ˢ���ļ���
    class procedure CopySelected( SourceFolder, TargeFolder : string ); // ����ѡ����ļ�
    class procedure OpenSelected( SourceFolder : string ); // ��ѡ���Ŀ¼
    class procedure BackToParent( FolderPath : string ); // ���ظ�Ŀ¼
  public
    class procedure FolderChangeNotify( FolderPath : string ); // Ŀ¼���ܷ����仯
    class procedure AddMoveFile( FolderPath, ChildPath : string ); // �ƶ������������·��
    class procedure RemoveMoveFile( FolderPath, ChildPath : string ); // �ƶ�������ɾ����·��
  public
    class function ReadFileList( FolderPath : string ): TStringList; // ��ȡĿ¼���ļ��б�
    class function ReadSelectList( FolderPath : string ): TStringList; // ��ȡĿ¼ѡ����ļ��б�
  private
    class function ReadFocusePath( FolderPath : string ): string; // ��ȡѡ�е�·��
    class function ControlPage( FolderPath : string ): Boolean; // ����Ҫ�޸ĵ�ҳ��
  end;

    // �û�Ԥ������
  UserPreviewApi = class
  public
    class function PreviewSmallPicture( FolderPath : string ): Boolean;
    class function PreviewSmallText( FolderPath : string ): Boolean;
    class function PreviewSmallWord( FolderPath : string ): Boolean;
    class function PreviewSmallExcel( FolderPath : string ): Boolean;
  public              // ͼƬ
    class procedure StartBigPicturePrivew( FolderPath : string );
    class procedure StopBigPicturePreview( FolderPath : string );
    class procedure LockBigPicturePreivew( FolderPath : string );
  public              // �ĵ�
    class procedure StartBigTextPrivew( FolderPath : string );
    class procedure StopBigTextPreview( FolderPath : string );
    class procedure LockBigTextPreivew( FolderPath : string );
  public              // Word
    class procedure StartBigWordPrivew( FolderPath : string );
    class procedure StopBigWordPreview( FolderPath : string );
    class procedure LockBigWordPreivew( FolderPath : string );
  public              // Excel
    class procedure StartBigExcelPrivew( FolderPath : string );
    class procedure StopBigExcelPreview( FolderPath : string );
    class procedure LockBigExcelPreivew( FolderPath : string );
  private
    class function ControlPage( FolderPath : string ): Boolean; // ����Ҫ�޸ĵ�ҳ��
  end;

{$EndRegion}

const
  PreviewAction_Text = 'Text';
  PreviewAction_Word = 'Word';
  PreviewAction_Excel = 'Excel';

const
  FileFilter_All = 'All';
  FileFilter_Folder = 'Folders';
  FileFilter_File = 'Files';

var
  ShowCol_Name : string = '����';
  ShowCol_Size : string = '��С';
  ShowCol_Time : string = 'ʱ��';

  OtherPathShow_Back : string = '������һ��';
  Show_BtnCopy : string = '����·��';
  Show_CopyOK : string = '·���Ѹ���';

  FileFilterShow_All : string = 'ȫ��';
  FileFilterShow_Folder : string = 'Ŀ¼';
  FileFilterShow_File : string = '�ļ�';

  PmFileList_Zip : string = 'ѹ���ļ�';
  PmFileList_UnZip : string = '��ѹ�ļ�';
  PmFileList_Copy : string = '���Ƶ�...';
  PmFileList_Move : string = '�ƶ���...';
  PmFileList_Rename : string = '������';
  PmFileList_Delete : string = 'ɾ��';

  PmFileList_NewFolder : string = '�½��ļ���';
  PmFileList_Refresh : string = 'ˢ��';
  PmFileList_Explorer : string = '��Դ������';

  Compressed_NewName : string = 'ѹ���ļ�';

  Confirm_Save : string = '�ļ����޸ģ��Ƿ񱣴棿';
  Text_Saved : string = '�ĵ����޸�';
  Copy_ExcelText : string = '�����Ѹ���';

const
  VstExplorer_FileName = 0;
  VstExplorer_FileSize = 1;
  VstExplorer_FileTime = 2;

var
  FaceFrameExplorerApi : TFaceFrameExplorerApi; // Frame ���� Api
  FaceFileListApi : TFaceFileListApi; // �ļ��б� ���� Api
  FaceFileFilterApi : TFaceFileFilterApi; // �ļ����� ���� Api
  FacePreviewApi : TFacePreviewApi; // �ļ�Ԥ�� ���� Api
  FacePreviewExtApi : TFacePreviewExtApi; // ��ͬ��׺Ԥ������ Api

implementation

uses UMyIcon, UMyUtil, UFrameMyComputer, UMyFaceThread, UFormDestination, shellapi, Clipbrd;

{$R *.dfm}

{ TFrameExplorer }

procedure TFrameExplorer.miExplorerClick(Sender: TObject);
begin
  MyExplorer.ShowFolder( FolderPath );
end;

procedure TFrameExplorer.FolderNotifyChange;
begin
  tmrFolderChange.Enabled := False;
  tmrFolderChange.Enabled := True;
end;

procedure TFrameExplorer.ftbtnNewFolderilMainClick(Sender: TObject);
begin
  UserFileListApi.NewFolder( FolderPath );
end;

procedure TFrameExplorer.ftbtnUpFolderilMainClick(Sender: TObject);
var
  ParentPath, ChildPath : string;
begin
    // ·����Ϣ
  ParentPath := ExtractFileDir( FolderPath );
  ChildPath := FolderPath;

    // ����·��
  UserFolderPageApi.EnterPage( FolderPath, ParentPath );

    // ѡ��Ŀ¼
  MyFaceJobHandler.FileListSelectChild( ParentPath, ChildPath  );
end;

procedure TFrameExplorer.ilSmallExcelClick(Sender: TObject);
begin
  UserPreviewApi.LockBigExcelPreivew( FolderPath );
end;

procedure TFrameExplorer.ilSmallExcelMouseEnter(Sender: TObject);
begin
  UserPreviewApi.StartBigExcelPrivew( FolderPath );
end;

procedure TFrameExplorer.ilSmallExcelMouseLeave(Sender: TObject);
begin
  UserPreviewApi.StopBigExcelPreview( FolderPath );
end;

procedure TFrameExplorer.ilSmallPictureClick(Sender: TObject);
begin
    // ����Ԥ��
  UserPreviewApi.LockBigPicturePreivew( FolderPath );
end;

procedure TFrameExplorer.ilSmallPictureMouseEnter(Sender: TObject);
begin
    // ��ʾ��ͼԤ��
  UserPreviewApi.StartBigPicturePrivew( FolderPath );
end;

procedure TFrameExplorer.ilSmallPictureMouseLeave(Sender: TObject);
begin
    // �رմ�ͼԤ��
  UserPreviewApi.StopBigPicturePreview( FolderPath );
end;

procedure TFrameExplorer.ilSmallTextClick(Sender: TObject);
begin
  UserPreviewApi.LockBigTextPreivew( FolderPath );
end;

procedure TFrameExplorer.ilSmallTextMouseEnter(Sender: TObject);
begin
  UserPreviewApi.StartBigTextPrivew( FolderPath );
end;

procedure TFrameExplorer.ilSmallTextMouseLeave(Sender: TObject);
begin
  UserPreviewApi.StopBigTextPreview( FolderPath );
end;

procedure TFrameExplorer.ilSmallWordClick(Sender: TObject);
begin
  UserPreviewApi.LockBigWordPreivew( FolderPath );
end;

procedure TFrameExplorer.ilSmallWordMouseEnter(Sender: TObject);
begin
  UserPreviewApi.StartBigWordPrivew( FolderPath );
end;

procedure TFrameExplorer.ilSmallWordMouseLeave(Sender: TObject);
begin
  UserPreviewApi.StopBigWordPreview( FolderPath );
end;

procedure TFrameExplorer.IniFrame;
begin
  vstExplorer.Header.Columns[VstExplorer_FileName].Text := ShowCol_Name;
  vstExplorer.Header.Columns[VstExplorer_FileSize].Text := ShowCol_Size;
  vstExplorer.Header.Columns[VstExplorer_FileTime].Text := ShowCol_Time;
  miZip.Caption := PmFileList_Zip;
  miUnZip.Caption := PmFileList_UnZip;
  miCopy.Caption := PmFileList_Copy;
  miMove.Caption := PmFileList_Move;
  miRename.Caption := PmFileList_Rename;
  miDelete.Caption := PmFileList_Delete;
  miNewFolder.Caption := PmFileList_NewFolder;
  miRefresh.Caption := PmFileList_Refresh;
  miExplorer.Caption := PmFileList_Explorer;
  lbTextSaved.Caption := Text_Saved;
  lbExcelTextCopy.Caption := Copy_ExcelText;

  vstExplorer.NodeDataSize := SIzeOf( TVstFileListData );
  vstExplorer.Images := MyIcon.getSysIcon;

  vstFilter.NodeDataSize := SizeOf( TVstFileFilterData );
  vstFilter.Images := MyIcon.getSysIcon;

  vstPreviewExt.NodeDataSize := SizeOf( TVstPreviewExtData );
  vstPreviewExt.Images := MyIcon.getSysIcon;

  DirNotify := TDirNotify.Create( Self );
  DirNotify.OnChange := DirNotifyChange;

  btnCopyPath.Caption := Show_BtnCopy;
  lbCopyPath.Caption := Show_CopyOK;

  PcBigPreview.ActivePage := tsFileList;
  PcPreview.ActivePage := tsPreviewFileList;
  PcSmallPreview.ActivePage := tsSmallPicture;
end;

procedure TFrameExplorer.lbCopyPathMouseLeave(Sender: TObject);
begin
  lbCopyPath.Visible := False;
  sbFolderPath.Visible := True;
end;

procedure TFrameExplorer.lbExcelTextCopyMouseEnter(Sender: TObject);
begin
  lbExcelText.Visible := False;
end;

procedure TFrameExplorer.lbExcelTextCopyMouseLeave(Sender: TObject);
begin
  lbExcelTextCopy.Visible := False;
  lbExcelText.Visible := True;
end;

procedure TFrameExplorer.lbExcelTextMouseEnter(Sender: TObject);
begin
  sbExcelText.Visible := True;
  lbExcelText.Visible := False;
end;

procedure TFrameExplorer.miUpLevelClick(Sender: TObject);
var
  mi : TMenuItem;
begin
  mi := Sender as TMenuItem;
  UserFolderPageApi.EnterPage( FolderPath, mi.Caption );
end;

procedure TFrameExplorer.miUnzipClick(Sender: TObject);
begin
  UserFileListApi.FileUnzip( FolderPath );
end;

procedure TFrameExplorer.mi7zipClick(Sender: TObject);
begin
  UserFileListApi.File7Zip( FolderPath );
end;

procedure TFrameExplorer.miCopyPathClick(Sender: TObject);
begin
  Clipboard.AsText := FolderPath;
end;

procedure TFrameExplorer.miMoveClick(Sender: TObject);
begin
  UserFileListApi.MoveFiles( FolderPath );
end;

procedure TFrameExplorer.miNewFolderClick(Sender: TObject);
begin
  UserFileListApi.NewFolder( FolderPath );
end;

procedure TFrameExplorer.miRenameClick(Sender: TObject);
begin
  UserFileListApi.RenameFile( FolderPath );
end;

procedure TFrameExplorer.miDeleteClick(Sender: TObject);
begin
  if MessageDlg( DeleteFile_Comfirm, mtConfirmation, [mbYes, mbNo], 0 ) <> mrYes then
    Exit;

  UserFileListApi.DeleteFiles( FolderPath );
end;

procedure TFrameExplorer.pmManagePopup(Sender: TObject);
var
  SelectNode : PVirtualNode;
  NodeData : PVstFileListData;
  Path : string;
  IsZip : Boolean;
begin
  SelectNode := vstExplorer.FocusedNode;
  if not Assigned( SelectNode ) then
  begin
    SelectNode := vstExplorer.GetFirstSelected;
    if not Assigned( SelectNode ) then
      IsZip := False;
  end;
  if Assigned( SelectNode ) then
  begin
    NodeData := vstExplorer.GetNodeData( SelectNode );
    Path := NodeData.FilePath;
    IsZip := MyFilePath.getIsZipFile( Path );
  end;
  IsZip := IsZip and ( vstExplorer.SelectedCount <= 1 );
  miZip.Visible := not IsZip;
  miUnzip.Visible := IsZip;
end;

procedure TFrameExplorer.pmUpLevelPopup(Sender: TObject);
var
  SelectPath, ParentPath : string;
  mi : TMenuItem;
begin
  pmUpLevel.Items.Clear;
  SelectPath := FolderPath;
  while True do
  begin
    if MyFilePath.getIsRoot( SelectPath )  then
      Break;
    SelectPath := ExtractFileDir( SelectPath );
    mi := TMenuItem.Create( pmUpLevel );
    mi.Caption := SelectPath;
    mi.OnClick := miUpLevelClick;
    mi.ImageIndex := 8;
    pmUpLevel.Items.Add( mi );
  end;
end;

procedure TFrameExplorer.sbExcelTextClick(Sender: TObject);
begin
  lbExcelTextCopy.Visible := True;
  sbExcelText.Visible := False;
  try
    Clipboard.AsText := lbExcelText.Caption;
  except
  end;
end;

procedure TFrameExplorer.sbExcelTextMouseLeave(Sender: TObject);
begin
  lbExcelText.Visible := True;
  sbExcelText.Visible := False;
end;

procedure TFrameExplorer.sbFolderPathMouseEnter(Sender: TObject);
begin
  sbFolderPath.Visible := False;
  btnCopyPath.Align := alClient;
  btnCopyPath.Visible := True;
end;

procedure TFrameExplorer.miRefreshClick(Sender: TObject);
begin
  UserFileListApi.RefreshFolder( FolderPath );
end;

procedure TFrameExplorer.SetFolderPath(_FolderPath: string);
begin
  FolderPath := _FolderPath;
end;

procedure TFrameExplorer.SetNotifyPath(NotifyPath: string);
begin
  TThread.CreateAnonymousThread(
  procedure
  begin
    if MyFilePath.getIsFixedDriver( ExtractFileDrive( NotifyPath ) ) then
      DirNotify.Path := NotifyPath;
  end).Start;
end;

procedure TFrameExplorer.SetTsFolder(_TsFolder: TRzTabSheet);
begin
  TsFolder := _TsFolder;
end;

procedure TFrameExplorer.sgExcelSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  plExcelCopy.Enabled := True;
  lbExcelText.Caption := sgExcel.Cells[ ACol, ARow ];
  sbExcelText.Caption := sgExcel.Cells[ ACol, ARow ];;
end;

procedure TFrameExplorer.tbtnFileFirstClick(Sender: TObject);
begin
  UserFileListApi.ShowFileFirst( FolderPath );
end;

procedure TFrameExplorer.tbtnFolderFirstClick(Sender: TObject);
begin
  UserFileListApi.ShowFolderFirst( FolderPath );
end;

procedure TFrameExplorer.tbtnNewFolderClick(Sender: TObject);
begin
  UserFileListApi.NewFolder( FolderPath );
end;

procedure TFrameExplorer.tbtnUpFolderClick(Sender: TObject);
var
  ParentPath, ChildPath : string;
begin
    // ·����Ϣ
  ParentPath := ExtractFileDir( FolderPath );
  ChildPath := FolderPath;

    // ����·��
  UserFolderPageApi.EnterPage( FolderPath, ParentPath );

    // ѡ��Ŀ¼
  MyFaceJobHandler.FileListSelectChild( ParentPath, ChildPath  );
end;

procedure TFrameExplorer.tmrBigPictureTimer(Sender: TObject);
begin
  if tmrBigPicture.Tag = ( ilBigPicture.Width + ilBigPicture.Height ) then
    Exit;

  FacePreviewApi.ShowBigPicture( ilBigPicture.Hint );
  tmrBigPicture.Tag := ilBigPicture.Width + ilBigPicture.Height;
end;

procedure TFrameExplorer.tmrFilterTimer(Sender: TObject);
begin
    // �رն�ʱ��
  tmrFilter.Enabled := False;

    // ˢ�¹�����ʾ
  UserFileListApi.RefreshFilter( FolderPath );
end;

procedure TFrameExplorer.tmrFolderChangeTimer(Sender: TObject);
begin
  tmrFolderChange.Enabled := False;
  UserFileListApi.FolderChangeNotify( FolderPath );
end;

procedure TFrameExplorer.tmrSaveTextTimer(Sender: TObject);
begin
  tmrSaveText.Enabled := False;
  plTextSave.Visible := False;
end;

procedure TFrameExplorer.miCopyClick(Sender: TObject);
begin
  UserFileListApi.CopyFiles( FolderPath );
end;

procedure TFrameExplorer.btnCopyPathClick(Sender: TObject);
begin
  Clipboard.AsText := btnCopyPath.Caption;
  btnCopyPath.Visible := False;
  lbCopyPath.Align := alClient;
  lbCopyPath.Visible := True;
end;

procedure TFrameExplorer.btnCopyPathMouseLeave(Sender: TObject);
begin
  btnCopyPath.Visible := False;
  sbFolderPath.Visible := True;
end;

procedure TFrameExplorer.DirNotifyChange(Sender: TObject);
begin
  tmrFolderChange.Enabled := False;
  tmrFolderChange.Enabled := True;
end;

procedure TFrameExplorer.edtSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  FirstVisibleNode : PVirtualNode;
begin
    // �س�
  if Key = VK_RETURN then
  begin
    FirstVisibleNode := vstExplorer.GetFirstVisible;
    if Assigned( FirstVisibleNode ) then
    begin
      vstExplorer.FocusedNode := FirstVisibleNode;
      vstExplorerDblClick( Sender );
    end;
    Exit;
  end;

    // ����/����
  if ( Key = VK_UP ) or ( Key = VK_DOWN ) then
  begin
    vstExplorer.SetFocus;
    Exit;
  end;

    // ������ʱ��
  if not tmrFilter.Enabled then
    tmrFilter.Enabled := True;
end;

procedure TFrameExplorer.edtSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      // ����������ʾ�رհ�ť
  edtSearch.RightButton.Visible := edtSearch.Text <> '';
end;

procedure TFrameExplorer.edtSearchRightButtonClick(Sender: TObject);
begin
  edtSearch.RightButton.Visible := False;
  edtSearch.Clear;

      // ������ʱ��
  if not tmrFilter.Enabled then
    tmrFilter.Enabled := True;
end;

procedure TFrameExplorer.vstExplorerChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  IsFileSelected := Sender.SelectedCount > 0;
end;

procedure TFrameExplorer.vstExplorerCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  NodeData1, NodeData2 : PVstFileListData;
begin
  NodeData1 := Sender.GetNodeData( Node1 );
  NodeData2 := Sender.GetNodeData( Node2 );
  if NodeData1.IsLocked then
    Result := 0
  else
  if NodeData2.IsLocked then
    Result := 0
  else
  if NodeData1.IsFolder <> NodeData2.IsFolder then
    Result := 0
  else
  if Column = VstExplorer_FileName then
    Result := CompareText( NodeData1.ShowName, NodeData2.ShowName )
  else
  if Column = VstExplorer_FileSize then
    Result := NodeData1.FileSize - NodeData2.FileSize
  else
  if Column = VstExplorer_FileTime then
  begin
    if NodeData1.FileTime > NodeData2.FileTime then
      Result := 1
    else
    if NodeData1.FileTime < NodeData2.FileTime then
      Result := -1
    else
      Result := 0;
  end
  else
    Result := 0;
end;

procedure TFrameExplorer.vstExplorerDblClick(Sender: TObject);
var
  NodeData : PVstFileListData;
  ParentPath, ChildPath : string;
  MarkPath, MarkName : string;
  RootCount : Integer;
begin
  if not Assigned( vstExplorer.FocusedNode ) then
    Exit;
  NodeData := vstExplorer.GetNodeData( vstExplorer.FocusedNode );

      // ���ظ�Ŀ¼
  if NodeData.IsLocked then
  begin
      // ·����Ϣ
    ParentPath := ExtractFileDir( FolderPath );
    ChildPath := FolderPath;

      // ����·��
    UserFolderPageApi.EnterPage( FolderPath, ParentPath );

      // ѡ��Ŀ¼
    MyFaceJobHandler.FileListSelectChild( ParentPath, ChildPath  );
    Exit;
  end;

    // ��¼����Ϣ
  MarkPath := FolderPath;
  MarkName := NodeData.ShowName;
  RootCount := vstExplorer.RootNode.ChildCount;

    // �ļ�������
  if not NodeData.IsFolder then
    MyExplorer.RunFile( NodeData.FilePath )
  else   // Ŀ¼�����
    UserFolderPageApi.EnterPage( FolderPath, NodeData.FilePath );

    // ����ѡ�е��ļ���ֻ��¼����10���ļ���Ŀ¼
  if RootCount > 10 then
    MyFaceJobHandler.FileListMarkSelect( MarkPath, MarkName );
end;

procedure TFrameExplorer.vstExplorerDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  SelectNode : PVirtualNode;
  NodeData : PVstFileListData;
  FileList : TStringList;
begin
  SelectNode := Sender.GetNodeAt( Pt.X, Pt.Y );
  if not Assigned( SelectNode ) then
    Exit;
  NodeData := Sender.GetNodeData( SelectNode );
  if not NodeData.IsFolder then
    Exit;

    // �����ļ�
  FileList := FaceFileListApi.ReadSelectList;
  UserCopyUtil.Move( FileList, NodeData.FilePath );
  FileList.Free;

    // ҳ����ת
  UserFolderPageApi.AddPage( NodeData.FilePath );
end;

procedure TFrameExplorer.vstExplorerDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
  SelectNode : PVirtualNode;
  NodeData : PVstFileListData;
begin
  SelectNode := Sender.GetNodeAt( pt.X, pt.Y );
  if Assigned( SelectNode ) then
  begin
    NodeData := Sender.GetNodeData( SelectNode );
    Accept := NodeData.IsFolder;
  end
  else
    Accept := False;
end;

procedure TFrameExplorer.vstExplorerFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
    // Ԥ��ͼƬ
  if not UserPreviewApi.PreviewSmallPicture( FolderPath ) and
     not UserPreviewApi.PreviewSmallWord( FolderPath ) and
     not UserPreviewApi.PreviewSmallExcel( FolderPath ) and
     not UserPreviewApi.PreviewSmallText( FolderPath )
  then
    FacePreviewApi.ShowSmallEmpty;
end;

procedure TFrameExplorer.vstExplorerGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstFileListData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TFrameExplorer.vstExplorerGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstFileListData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = VstExplorer_FileName then
    CellText := NodeData.ShowName
  else
  if ( Column = VstExplorer_FileSize ) and not NodeData.IsFolder then
    CellText := NodeData.ShowSize
  else
  if Column = VstExplorer_FileTime then
    CellText := NOdeData.ShowTime
  else
    CellText := '';
end;

procedure TFrameExplorer.vstExplorerHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if vstExplorer.Header.SortDirection = sdAscending then
  begin
    vstExplorer.Header.SortDirection := sdDescending;
    vstExplorer.SortTree( HitInfo.Column, sdDescending )
  end
  else
  begin
    vstExplorer.Header.SortDirection := sdAscending;
    vstExplorer.SortTree( HitInfo.Column, sdAscending );
  end;
end;

procedure TFrameExplorer.vstExplorerKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then  // ����
  begin
    if ssCtrl in Shift then
      UserFileListApi.OpenSelected( FolderPath )
    else
      vstExplorerDblClick( Sender )
  end
  else
  if Key = VK_ESCAPE then  // ����
    UserFileListApi.BackToParent( FolderPath )
  else
  if Key = VK_F5 then     // ˢ��
    miRefresh.Click
  else                     // ����
  if ( Key > 47 ) and ( Key < 91 ) and ( not ( ssCtrl in Shift ) ) then
  begin
    edtSearch.Text := LowerCase( Char( Key ) );
    edtSearchKeyDown( Sender, Key, Shift );
    edtSearch.SetFocus;
    edtSearch.SelStart := 1;
  end
  else                  // ����/�ƶ�/����/ɾ��
  if IsFileSelected then  // ������ѡ���ļ�
  begin
    if ( ssCtrl in Shift ) and ( Key = integer( 'C' ) ) then
      miCopy.Click
    else
    if ( ssCtrl in Shift ) and ( Key = integer( 'X' ) ) then
      miMove.Click
    else
    if Key = VK_F2 then
      miRename.Click
    else
    if ( Key = VK_DELETE ) or ( ( ssCtrl in Shift ) and ( Key = integer( 'D' ) ) ) then
      miDelete.Click;
  end;
end;


procedure TFrameExplorer.vstExplorerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  SelectNode : PVirtualNode;
  NodeData : PVstFileListData;
  IsSelectNode : Boolean;
begin
  if Button <> mbRight then
    Exit;

  SelectNode := vstExplorer.GetNodeAt( x, y );
  IsSelectNode := False;
  if Assigned( SelectNode ) then
    IsSelectNode := vstExplorer.Selected[ SelectNode ];

  if IsSelectNode then
    vstExplorer.PopupMenu := pmManage
  else
  begin
    vstExplorer.PopupMenu := pmFolder;
    SelectNode := vstExplorer.GetFirstSelected;
    while Assigned( SelectNode ) do
    begin
      vstExplorer.Selected[ SelectNode ] := False;
      SelectNode := vstExplorer.GetNextSelected( SelectNode );
    end;
  end;
end;

procedure TFrameExplorer.vstFilterFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  SelectNode : PVirtualNode;
  NodeData : PVstFileFilterData;
begin
    // Ĭ��ѡ���һ���ڵ�
  if ( Sender.SelectedCount = 0 ) and Assigned( Sender.RootNode.FirstChild ) then
    Sender.Selected[ Sender.RootNode.FirstChild ] := True;

    // ˢ��ѡ��·��
  SelectNode := Sender.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := Sender.GetNodeData( SelectNode );
    if NodeData.IsSelected <> Sender.Selected[ SelectNode ] then
    begin
      NodeData.IsSelected := Sender.Selected[ SelectNode ];
      Sender.RepaintNode( SelectNode );
    end;
    SelectNode := SelectNode.NextSibling;
  end;

    // ˢ�¹�����ʾ
  UserFileListApi.RefreshFilter( FolderPath );
end;

procedure TFrameExplorer.vstFilterGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstFileFilterData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TFrameExplorer.vstFilterGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstFileFilterData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.ShowName
  else
    CellText := '';
end;

procedure TFrameExplorer.vstFilterPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  NodeData : PVstFileFilterData;
begin
  NodeData := Sender.GetNodeData( Node );
  if NodeData.IsSelected then
  begin
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
    TargetCanvas.Font.Color := clBlue;
  end;
end;

procedure TFrameExplorer.vstPreviewExtFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  NodeData : PVstPreviewExtData;
begin
  if not Assigned( Node ) then
    Exit;
  NodeData := Sender.GetNodeData( Node );
  if NodeData.ActionType = PreviewAction_Text then
    FacePreviewApi.ShowBigText( NodeData.FilePath )
  else
  if NodeData.ActionType = PreviewAction_Word then
    FacePreviewApi.ShowBigWord( NodeData.FilePath )
  else
  if NodeData.ActionType = PreviewAction_Excel then
    FacePreviewApi.ShowBigExcel( NodeData.FilePath );
end;

procedure TFrameExplorer.vstPreviewExtGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstPreviewExtData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TFrameExplorer.vstPreviewExtGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstPreviewExtData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.ShowName
  else
    CellText := '';
end;

procedure TFrameExplorer.miZipClick(Sender: TObject);
begin
  UserFileListApi.FileZip( FolderPath );
end;

procedure TFrameExplorer.mmoBigTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ( ssCtrl in Shift ) and ( Key = integer( 'S' ) ) then
  begin
    try
      mmoBigText.Lines.SaveToFile( mmoBigText.Hint );
    except
    end;
    mmoBigText.Tag := 0;
    plTextSave.Visible := True;
    tmrSaveText.Enabled := True;
  end
  else
    mmoBigText.Tag := 1;
end;


{ TFileListFaceApi }

procedure TFaceFileListApi.AddBackFolder( FolderPath : string );
var
  FileNode : PVirtualNode;
  NodeData : PVstFileListData;
begin
  FileNode := vstFileList.InsertNode( vstFileList.RootNode, amAddChildFirst );
  NodeData := vstFileList.GetNodeData( FileNode );
  NodeData.FilePath := FolderPath;
  NodeData.IsFolder := True;
  NodeData.IsLocked := True;

  NodeData.ShowName := OtherPathShow_Back;
  NodeData.ShowSize := '';
  NodeData.ShowTime := '';
  NodeData.ShowIcon := My16IconUtil.getBack;
end;

procedure TFaceFileListApi.AddFile(Params: TExplorerAddParams);
var
  FileNode : PVirtualNode;
  NodeData : PVstFileListData;
begin
  FileNode := vstFileList.AddChild( vstFileList.RootNode );
  NodeData := vstFileList.GetNodeData( FileNode );
  NodeData.FilePath := Params.FilePath;
  NodeData.IsFolder := Params.IsFolder;
  NodeData.FileSize := Params.FileSize;
  NodeData.FileTime := Params.FileTime;
  NodeData.IsLocked := False;

  NodeData.ShowName := ExtractFileName( Params.FilePath );
  NodeData.ShowSize := MySizeUtil.getFileSizeStr( Params.FileSize );
  NodeData.ShowTime := DateTimeToStr( Params.FileTime );
  NodeData.ShowIcon := MyIcon.getPathIcon( Params.FilePath, not Params.IsFolder );
end;

procedure TFaceFileListApi.CancelSelect;
var
  SelectNode : PVirtualNode;
begin
  SelectNode := vstFileList.GetFirstSelected;
  while Assigned( SelectNode ) do
  begin
    vstFileList.Selected[ SelectNode ] := False;
    SelectNode := vstFileList.GetNextSelected( SelectNode );
  end;
end;

procedure TFaceFileListApi.ClearFiles;
begin
  vstFileList.Clear;
  vstFileList.Header.SortDirection := sdDescending;
end;

procedure TFaceFileListApi.InsertFile(Params: TExplorerAddParams);
var
  FileNode : PVirtualNode;
  NodeData : PVstFileListData;
begin
  FileNode := CreateInseartNode;
  NodeData := vstFileList.GetNodeData( FileNode );
  NodeData.FilePath := Params.FilePath;
  NodeData.IsFolder := Params.IsFolder;
  NodeData.FileSize := Params.FileSize;
  NodeData.FileTime := Params.FileTime;
  NodeData.IsLocked := False;

  NodeData.ShowName := ExtractFileName( Params.FilePath );
  NodeData.ShowSize := MySizeUtil.getFileSizeStr( Params.FileSize );
  NodeData.ShowTime := DateTimeToStr( Params.FileTime );
  NodeData.ShowIcon := MyIcon.getPathIcon( Params.FilePath, not Params.IsFolder );
end;

function TFaceFileListApi.ReadExist(Path: string): Boolean;
begin
  Result := Assigned( ReadNode( Path ) );
end;

function TFaceFileListApi.ReadFocusPath: string;
var
  NodeData : PVstFileListData;
  SelectNode : PVirtualNode;
begin
  Result := '';
  SelectNode := vstFileList.FocusedNode;
  if not Assigned( SelectNode ) then
  begin
    SelectNode := vstFileList.GetFirstSelected;
    if not Assigned( SelectNode ) then
      Exit;
  end;
  NodeData := vstFileList.GetNodeData( SelectNode );
  Result := NodeData.FilePath;
end;

function TFaceFileListApi.CreateInseartNode: PVirtualNode;
var
  FirstNode : PVirtualNode;
  NodeData : PVstFileListData;
begin
  FirstNode := vstFileList.RootNode.FirstChild;
  if Assigned( FirstNode ) then
  begin
    NodeData := vstFileList.GetNodeData( FirstNode );
    if NodeData.IsLocked then
      Result := vstFileList.InsertNode( FirstNode, amInsertAfter )
    else
      Result := vstFileList.InsertNode( vstFileList.RootNode, amAddChildFirst );
  end
  else
    Result := vstFileList.InsertNode( vstFileList.RootNode, amAddChildFirst );
end;

function TFaceFileListApi.ReadNode(Path: string): PVirtualNode;
var
  SelectNode : PVirtualNode;
  NodeData : PVstFileListData;
begin
  Result := nil;
  SelectNode := vstFileList.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFileList.GetNodeData( SelectNode );
    if NodeData.FilePath = Path then
    begin
      Result := SelectNode;
      Break;
    end;
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceFileListApi.ReadPathList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstFileListData;
begin
  Result := TStringList.Create;
  SelectNode := vstFileList.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFileList.GetNodeData( SelectNode );
    if not NodeData.IsLocked then
      Result.Add( NodeData.FilePath );
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceFileListApi.ReadSelectList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstFileListData;
begin
  Result := TStringList.Create;
  SelectNode := vstFileList.GetFirstSelected;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFileList.GetNodeData( SelectNode );
    if not NodeData.IsLocked then
      Result.Add( NodeData.FilePath );
    SelectNode := vstFileList.GetNextSelected( SelectNode );
  end;
end;

procedure TFaceFileListApi.RefreshFileFilter(FilterList: TStringList;
  SeachName: string);
var
  FileListRefreshFilterHandle : TFileListRefreshFilterHandle;
begin
  FileListRefreshFilterHandle := TFileListRefreshFilterHandle.Create( FilterList, SeachName );
  FileListRefreshFilterHandle.SetVstFileList( vstFileList );
  FileListRefreshFilterHandle.Update;
  FileListRefreshFilterHandle.Free;
end;

procedure TFaceFileListApi.RefreshFileInfo(Params: TExplorerAddParams);
var
  SelectNode : PVirtualNode;
  NodeData : PVstFileListData;
begin
  SelectNode := ReadNode( Params.FilePath );
  if not Assigned( SelectNode ) then
    Exit;
  NodeData := vstFileList.GetNodeData( SelectNode );
  NodeData.FilePath := Params.FilePath;
  NodeData.IsFolder := Params.IsFolder;
  NodeData.FileSize := Params.FileSize;
  NodeData.FileTime := Params.FileTime;

  NodeData.ShowName := ExtractFileName( Params.FilePath );
  NodeData.ShowSize := MySizeUtil.getFileSizeStr( Params.FileSize );
  NodeData.ShowTime := DateTimeToStr( Params.FileTime );
  NodeData.ShowIcon := MyIcon.getPathIcon( Params.FilePath, not Params.IsFolder );
end;

procedure TFaceFileListApi.RemoveFile(Path: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadNode( Path );
  if not Assigned( SelectNode ) then
    Exit;
  vstFileList.DeleteNode( SelectNode );
end;

procedure TFaceFileListApi.SelectPath(Path: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadNode( Path );
  if not Assigned( SelectNode ) then
    Exit;
  vstFileList.Selected[ SelectNode ] := True;
  vstFileList.FocusedNode := SelectNode;
end;

procedure TFaceFileListApi.ShowFileFirst;
var
  NowCount, MaxCount : Integer;
  MoveNode, SelectNode : PVirtualNode;
  NodeData : PVstFileListData;
begin
  NowCount := 0;
  MaxCount := vstFileList.RootNode.ChildCount;

  SelectNode := vstFileList.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFileList.GetNodeData( SelectNode );
    if NodeData.IsFolder then
    begin
      MoveNode := SelectNode;
      SelectNode := SelectNode.NextSibling;
      vstFileList.MoveTo( MoveNode, vstFileList.RootNode.LastChild, amInsertAfter, False );
      Inc( NowCount );
      if NowCount = MaxCount then
        Break;
    end
    else
      Break;
  end;
end;

procedure TFaceFileListApi.ShowFolderFirst;
var
  NowCount, MaxCount : Integer;
  MoveNode, SelectNode : PVirtualNode;
  NodeData : PVstFileListData;
begin
  NowCount := 0;
  MaxCount := vstFileList.RootNode.ChildCount;

  SelectNode := vstFileList.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFileList.GetNodeData( SelectNode );
    if not NodeData.IsFolder then
    begin
      MoveNode := SelectNode;
      SelectNode := SelectNode.NextSibling;
      vstFileList.MoveTo( MoveNode, vstFileList.RootNode.LastChild, amInsertAfter, False );
      Inc( NowCount );
      if NowCount = MaxCount then
        Break;
    end
    else
      Break;
  end;
end;

procedure TFaceFileListApi.ActivateVstFileList(_vstFileList: TVirtualStringTree);
begin
  vstFileList := _vstFileList;
end;

{ TFrameExplorerFaceApi }

procedure TFaceFrameExplorerApi.ActivateFrame(_FrameExplorer: TFrameExplorer);
begin
  FrameExplorer := _FrameExplorer;

    // �����ӿؼ�
  FaceFileListApi.ActivateVstFileList( FrameExplorer.vstExplorer );
  FaceFileFilterApi.ActivateVstFileFilter( FrameExplorer.vstFilter );
  FacePreviewApi.ActivateFrame( FrameExplorer );
  FacePreviewExtApi.ActivatePrivewExt( FrameExplorer.vstPreviewExt );
end;

{ TFileFilterFaceApi }

procedure TFaceFileFilterApi.ActivateVstFileFilter(
  _vstFileFilter: TVirtualStringTree);
begin
  vstFileFilter := _vstFileFilter;
end;

procedure TFaceFileFilterApi.AddFilter(FilterStr: string; FilterCount: Integer);
var
  ShowStr, ShowName : string;
  ShowIcon : Integer;
  IsSelected : Boolean;
  FilterNode : PVirtualNode;
  NodeData : PVstFileFilterData;
begin
    // ��ʾ��ͼ��/����
  if FilterStr = FileFilter_All then
  begin
    ShowIcon := My16IconUtil.getAllFiles;
    ShowName := FileFilterShow_All;
  end
  else
  if FilterStr = FileFilter_Folder then
  begin
    ShowIcon := My16IconUtil.getFolder;
    ShowName := FileFilterShow_Folder;
  end
  else
  if FilterStr = FileFilter_File then
  begin
    ShowIcon := My16IconUtil.getFile;
    ShowName := FileFilterShow_File;
  end
  else
  begin
    ShowIcon := MyIcon.getFileExtIcon( 'a' + FilterStr );
    ShowName := '*' + FilterStr;
  end;

    // ��ʾ���ַ���
  ShowStr := ShowName + ' (' + IntToStr( FilterCount ) + ')';

    // �Ƿ�ѡ��
  IsSelected := FilterStr = FileFilter_All;

    // �����ڵ�
  FilterNode := vstFileFilter.AddChild( vstFileFilter.RootNode );
  NodeData := vstFileFilter.GetNodeData( FilterNode );
  NodeData.FilterStr := FilterStr;
  NodeData.ShowName := ShowStr;
  NodeData.ShowIcon := ShowIcon;
  NodeData.IsSelected := IsSelected;
end;

procedure TFaceFileFilterApi.ClearFilters;
begin
  vstFileFilter.Clear;
end;

{ UserFileListApi }

class procedure UserFileListApi.AddMoveFile(FolderPath, ChildPath: string);
var
  Params : TExplorerAddParams;
begin
    // ҳ���Ѿ��л�
  if not ControlPage( FolderPath ) then
    Exit;

    // �ļ�/Ŀ¼������
  if not FileExists( ChildPath ) and not DirectoryExists( ChildPath ) then
    Exit;

    // ���·��
  Params.FilePath := ChildPath;
  Params.IsFolder := DirectoryExists( ChildPath );
  Params.FileSize := MyFileInfo.getFileSize( ChildPath );
  Params.FileTime := MyFileInfo.getFileTime( ChildPath );
  if not FaceFileListApi.ReadExist( ChildPath ) then
    FaceFileListApi.InsertFile( Params )
  else
    FaceFileListApi.RefreshFileInfo( Params );

    // ѡ��·��
  FaceFileListApi.SelectPath( ChildPath );
end;

class procedure UserFileListApi.BackToParent( FolderPath : string );
var
  ParentPath, ChildPath : string;
begin
    // ��Ŀ¼
  if MyFilePath.getIsRoot( FolderPath ) then
    Exit;

    // ·����Ϣ
  ParentPath := ExtractFileDir( FolderPath );
  ChildPath := FolderPath;

    // ����·��
  UserFolderPageApi.EnterPage( ChildPath, ParentPath );

    // ѡ��Ŀ¼
  MyFaceJobHandler.FileListSelectChild( ParentPath, ChildPath );
end;

class procedure UserFileListApi.CancelSelect(FolderPath: string);
begin
    // ҳ���Ѿ��л�
  if not ControlPage( FolderPath ) then
    Exit;

    // ȡ��ѡ��
  FaceFileListApi.CancelSelect;
end;

class function UserFileListApi.ControlPage(FolderPath: string): Boolean;
begin
    // ����ҳ��
  Result := FaceFolderPageApi.ControlPage( FolderPath );
end;

class procedure UserFileListApi.CopyFiles( FolderPath : string );
var
  SelectPathList : TStringList;
  FileListCopyFileHandle : TFileListCopyFileHandle;
begin
    // ����Ŀ¼
  ControlPage( FolderPath );

    // ��ȡѡ����ļ�·��
  SelectPathList := FaceFileListApi.ReadSelectList;

    // �����ļ�
  FileListCopyFileHandle := TFileListCopyFileHandle.Create( SelectPathList );
  FileListCopyFileHandle.Update;
  FileListCopyFileHandle.Free;

  SelectPathList.Free;
end;

class procedure UserFileListApi.CopySelected(SourceFolder, TargeFolder: string);
var
  PathList : TStringList;
begin
    // �����ļ�
  PathList := UserFileListApi.ReadSelectList( SourceFolder );
  UserCopyUtil.Copy( PathList, TargeFolder );
  PathList.Free;
end;

class procedure UserFileListApi.DeleteFiles(FolderPath: string);
var
  SelectPathList : TStringList;
  FileListCutFileHandle : TFileListCutFileHandle;
  i: Integer;
begin
    // ����Ŀ¼
  ControlPage( FolderPath );

    // ��ȡѡ����ļ�·��
  SelectPathList := FaceFileListApi.ReadSelectList;

    // ɾ���ļ�
  for i := 0 to SelectPathList.Count - 1 do
    UserFileMoveApi.FileDelete( SelectPathList[i] );

  SelectPathList.Free;
end;

class procedure UserFileListApi.File7Zip(FolderPath: string);
var
  SelectPathList : TStringList;
  ZipPath : string;
begin
    // ����Ŀ¼
  ControlPage( FolderPath );

    // ��ȡѡ����ļ�·��
  SelectPathList := FaceFileListApi.ReadSelectList;

    // ѹ����Ŀ��·��
  if SelectPathList.Count = 1 then
  begin
    ZipPath := SelectPathList[0];
    if FileExists( ZipPath ) then
      ZipPath := MyFilePath.getPath( FolderPath ) + TPath.GetFileNameWithoutExtension( ZipPath );
  end
  else
    ZipPath := MyFilePath.getPath( FolderPath ) + Compressed_NewName;
  ZipPath := ZipPath + '.7z';
  ZipPath := MyFilePath.getRenamePath( ZipPath, True );

    // ����ѹ��
  UserFileMoveApi.File7Zip( SelectPathList, ZipPath );
end;

class procedure UserFileListApi.FileUnzip(FolderPath: string);
var
  ZipPath, ZipFolderPath : string;
begin
    // ����Ŀ¼
  ControlPage( FolderPath );

    // ѹ���ļ�
  ZipPath := FaceFileListApi.ReadFocusPath;
  ZipFolderPath := MyFilePath.getPath( FolderPath ) + TPath.GetFileNameWithoutExtension( ZipPath );
  ZipFolderPath := MyFilePath.getRenamePath( ZipFolderPath, False );

    // ���
  UserFileMoveApi.FileUnzip( ZipPath, ZipFolderPath );
end;

class procedure UserFileListApi.FileZip(FolderPath: string);
var
  SelectPathList : TStringList;
  ZipPath : string;
begin
    // ����Ŀ¼
  ControlPage( FolderPath );

    // ��ȡѡ����ļ�·��
  SelectPathList := FaceFileListApi.ReadSelectList;

    // ѹ����Ŀ��·��
  if SelectPathList.Count = 1 then
  begin
    ZipPath := SelectPathList[0];
    if FileExists( ZipPath ) then
      ZipPath := MyFilePath.getPath( FolderPath ) + TPath.GetFileNameWithoutExtension( ZipPath );
  end
  else
    ZipPath := MyFilePath.getPath( FolderPath ) + Compressed_NewName;
  ZipPath := ZipPath + '.zip';
  ZipPath := MyFilePath.getRenamePath( ZipPath, True );

    // ����ѹ��
  UserFileMoveApi.FileZip( SelectPathList, ZipPath );
end;

class procedure UserFileListApi.FolderChangeNotify(FolderPath: string);
begin
  MyFaceJobHandler.FolderChangeNofity( FolderPath );
end;

class procedure UserFileListApi.MoveFiles(FolderPath: string);
var
  SelectPathList : TStringList;
  FileListCutFileHandle : TFileListCutFileHandle;
begin
    // ����Ŀ¼
  ControlPage( FolderPath );

    // ��ȡѡ����ļ�·��
  SelectPathList := FaceFileListApi.ReadSelectList;

    // �ƶ��ļ�
  FileListCutFileHandle := TFileListCutFileHandle.Create( SelectPathList );
  FileListCutFileHandle.Update;
  FileListCutFileHandle.Free;

  SelectPathList.Free;
end;

class procedure UserFileListApi.NewFolder(FolderPath: string);
var
  FolderName, NewFolderPath : string;
begin
    // ����ҳ��
  ControlPage( FolderPath );

  FolderName := NewFolder_DefaultName;
  FolderName := MyFilePath.getRenamePath( MyFilePath.getPath( FolderPath ) + FolderName, False );
  FolderName := ExtractFileName( FolderName );

    // ����������
  if not InputQuery( NewFolder_Title, NewFolder_Name, FolderName ) then
    Exit;

    // ��·��
  NewFolderPath := MyFilePath.getPath( FolderPath ) + FolderName;

    // �Ѵ�����ȡ��
  if MyFilePath.getIsExist( NewFolderPath, False ) then
  begin
    MyMessageForm.ShowWarnning( Rename_Exist );
    NewFolder( FolderPath );
    Exit;
  end;

    // �����ļ���
  ForceDirectories( NewFolderPath );
  CancelSelect( FolderPath );
  AddMoveFile( FolderPath, NewFolderPath );
end;

class procedure UserFileListApi.OpenSelected(SourceFolder: string);
var
  PathList : TStringList;
  i: Integer;
  SourcePath : string;
begin
    // ��Ŀ¼
  PathList := UserFileListApi.ReadSelectList( SourceFolder );
  for i := 0 to PathList.Count - 1 do
  begin
    SourcePath := PathList[i];
    if DirectoryExists( SourcePath ) then
      UserFolderPageApi.AddPage( SourcePath );
  end;
  PathList.Free;
end;

class function UserFileListApi.ReadFileList(FolderPath: string): TStringList;
begin
    // ����ҳ��
  ControlPage( FolderPath );

    // ��ȡ·���б�
  Result := FaceFileListApi.ReadPathList;
end;

class function UserFileListApi.ReadFocusePath(FolderPath: string): string;
begin
  if ControlPage( FolderPath ) then
    Result := FaceFileListApi.ReadFocusPath;
end;

class function UserFileListApi.ReadSelectList(FolderPath: string): TStringList;
begin
    // ����ҳ��
  ControlPage( FolderPath );

    // ��ȡ·���б�
  Result := FaceFileListApi.ReadSelectList;
end;

class procedure UserFileListApi.RefreshFilter(FolderPath: string);
var
  FilterList : TStringList;
  SearchName : string;
begin
    // ����ҳ��
  ControlPage( FolderPath );

    // ��ȡ������Ϣ
  FilterList := FaceFrameExplorerApi.ReadFilterList;
  SearchName := FaceFrameExplorerApi.ReadSearchName;

    // ˢ�¹�����ʾ
  FaceFileListApi.RefreshFileFilter( FilterList, SearchName );

  FilterList.Free;
end;

class procedure UserFileListApi.RefreshFolder(FolderPath: string);
begin
  FaceFolderPageApi.EnterPage( FolderPath, FolderPath );
end;

class procedure UserFileListApi.RemoveMoveFile(FolderPath, ChildPath: string);
begin
    // ҳ���Ѿ��л�
  if not ControlPage( FolderPath ) then
    Exit;

    // ɾ���ļ�
  FaceFileListApi.RemoveFile( ChildPath );
end;

class procedure UserFileListApi.RenameFile(FolderPath: string);
var
  OldPath, NewName, NewPath : string;
  fo: TSHFILEOPSTRUCT;
begin
    // ����ҳ��
  ControlPage( FolderPath );

    // ��ȡѡ���·��
  OldPath := FaceFileListApi.ReadFocusPath;
  NewName := ExtractFileName( OldPath );

    // ����������
  if not InputQuery( Rename_Title, Rename_Name, NewName ) then
    Exit;

    // û�к�׺
  if ExtractFileExt( NewName ) = '' then
    NewName := NewName + ExtractFileExt( OldPath );

    // ��·��
  NewPath := ExtractFilePath( OldPath ) + NewName;

    // �Ѵ�����ȡ��
  if MyFilePath.getIsExist( NewPath, FileExists( OldPath ) ) then
  begin
    if NewPath <> OldPath then
    begin
      MyMessageForm.ShowWarnning( Rename_Exist );
      RenameFile( FolderPath );
    end;
    Exit;
  end;

    // ������
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := 0;
    wFunc := FO_RENAME;
    pFrom := PChar( OldPath + #0);
    pTo := PChar( NewPath + #0);
    fFlags := FOF_NOCONFIRMATION + FOF_NOCONFIRMMKDIR;
  end;
  if SHFileOperation(fo)=0 then
  begin
    RemoveMoveFile( FolderPath, OldPath );
    AddMoveFile( FolderPath, NewPath );
  end;
end;

class procedure UserFileListApi.SelectChild(FolderPath, ChildPath: string);
begin
    // ����ҳ��
  ControlPage( FolderPath );

    // ѡ��·��
  FaceFileListApi.SelectPath( ChildPath );
end;

class procedure UserFileListApi.ShowFileFirst(FolderPath: string);
begin
    // ����ҳ��
  ControlPage( FolderPath );

    // ������ʾ�ļ�
  FaceFileListApi.ShowFileFirst;
end;

class procedure UserFileListApi.ShowFolderFirst(FolderPath: string);
begin
    // ����ҳ��
  ControlPage( FolderPath );

    // ������ʾ�ļ�
  FaceFileListApi.ShowFolderFirst;
end;

{ TFileListRefreshFilterHandle }

constructor TFileListRefreshFilterHandle.Create(_FilterList: TStringList;
  _SeachName: string);
begin
  FilterList := _FilterList;
  SeachName := _SeachName;
end;

procedure TFileListRefreshFilterHandle.FindSpecialFilter;
var
  SelectFilter : string;
  i: Integer;
begin
    // ��ʼ��
  IsShowAll := False;
  IsShowFolder := False;
  IsShowFile := False;

    // Ѱ��
  for i := FilterList.Count - 1 downto 0 do
  begin
    SelectFilter := FilterList[i];
    if SelectFilter = FileFilter_All then
    begin
      IsShowAll := True;
      FilterList.Delete(i);
    end
    else
    if SelectFilter = FileFilter_Folder then
    begin
      IsShowFolder := True;
      FilterList.Delete(i);
    end
    else
    if SelectFilter = FileFilter_File then
    begin
      IsShowFile := True;
      FilterList.Delete(i);
    end;
  end;
end;

function TFileListRefreshFilterHandle.ReadIsFilter(
  SelectNode: PVirtualNode): Boolean;
var
  NodeData : PVstFileListData;
  FileExt : string;
  i: Integer;
begin
    // ��ʾ����
  if IsShowAll then
  begin
    Result := True;
    Exit;
  end;

  NodeData := vstFileList.GetNodeData( SelectNode );

    // �̶���ʾ��
  if NodeData.IsLocked then
  begin
    Result := True;
    Exit;
  end;

    // Ŀ¼�����
  if NodeData.IsFolder then
  begin
    Result := IsShowFolder;
    Exit;
  end;

    // �ļ������
  if IsShowFile then  // ��ʾ�ļ�
  begin
    Result := True;
    Exit;
  end;

    // �ļ���׺����
  FileExt := ExtractFileExt( NodeData.FilePath );

    // �Ƿ�ѡ���ļ���׺
  Result := False;
  for i := 0 to FilterList.Count - 1 do
    if FileExt = FilterList[i] then
    begin
      Result := True;
      Break;
    end;
end;

function TFileListRefreshFilterHandle.ReadIsSearch(
  SelectNode: PVirtualNode): Boolean;
var
  NodeData : PVstFileListData;
begin
    // ��ʾ����
  if IsShowAllSearch then
  begin
    Result := True;
    Exit;
  end;

    // �ļ�������ѡ�ַ�
  NodeData := vstFileList.GetNodeData( SelectNode );
  Result := ( NodeData.IsLocked ) or ( Pos( SeachName, LowerCase( string( NodeData.ShowName ) ) ) > 0 );
end;

function TFileListRefreshFilterHandle.ReadIsVisible(
  SelectNode: PVirtualNode): Boolean;
begin
  Result := ReadIsFilter( SelectNode ) and ReadIsSearch( SelectNode );
end;

procedure TFileListRefreshFilterHandle.SetVstFileList(
  _vstFileList: TVirtualStringTree);
begin
  vstFileList := _vstFileList;
end;

procedure TFileListRefreshFilterHandle.Update;
var
  SelectNode : PVirtualNode;
begin
    // ����Ĺ���
  FindSpecialFilter;
  IsShowAllSearch := SeachName = '';
  SeachName := LowerCase( SeachName );

    // �����ڵ�
  SelectNode := vstFileList.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    vstFileList.IsVisible[ SelectNode ] := ReadIsVisible( SelectNode );
    SelectNode := SelectNode.NextSibling;
  end;
end;

procedure TFaceFrameExplorerApi.ClearSearchHistory;
begin
  FrameExplorer.edtSearch.Clear;
end;


function TFaceFrameExplorerApi.ReadFilterList: TStringList;
var
  vstFileFilter : TVirtualStringTree;
  SelectNode : PVirtualNode;
  NodeData : PVstFileFilterData;
begin
  vstFileFilter := FrameExplorer.vstFilter;

  Result := TStringList.Create;
  SelectNode := vstFileFilter.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFileFilter.GetNodeData( SelectNode );
    if NodeData.IsSelected then
      Result.Add( NodeData.FilterStr );
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceFrameExplorerApi.ReadSearchName: string;
begin
  Result := FrameExplorer.edtSearch.Text;
end;

{ TFileListCopyFileHandle }

constructor TFileListMoveFileHandle.Create(_SelectPathList: TStringList);
begin
  SelectPathList := _SelectPathList;
end;

function TFileListMoveFileHandle.FindDesPath: Boolean;
var
  i : Integer;
  PagePathList, HistoryPathList, WindowPathList : TStringList;
  PathList : TStringList;
  SelectFolder : string;
begin
    // ��� Input
  FaceDesFormApi.ClearInputs;
  for i := 0 to SelectPathList.Count - 1 do
    FaceDesFormApi.AddInput( SelectPathList[i] );

    // ��� ����
  HistoryPathList := FaceDriverApi.ReadDriverList;
  FaceDesDriverApi.ClearDrivers;
  for i := 0 to HistoryPathList.Count - 1 do
  begin
    if HistoryPathList[i]= MyFilePath.getDesktopPath then
      FaceDesDriverApi.AddDriver( '', HistoryPathList[i], Show_Desktop, True )
    else
      FaceDesDriverApi.AddDriver( '', HistoryPathList[i], True );
  end;
  HistoryPathList.Free;

    // ��� ��ǰ��ҳ��
  FaceDesHistoryFolderApi.ClearHistorys;
  PathList := TStringList.Create;
  PagePathList := FaceFolderPageApi.ReadPageList;
  for i := 0 to PagePathList.Count - 1 do
    PathList.Add( PagePathList[i] );
  PagePathList.Free;

    // �����ʷ�ļ���ҳ��
  HistoryPathList := FaceHistoryFolderApi.ReadHistoryList;
  for i := 0 to HistoryPathList.Count - 1 do
    if PathList.IndexOf( HistoryPathList[i] ) < 0 then
      PathList.Add( HistoryPathList[i] );
  HistoryPathList.Free;

    // Windowns ��ǰ�ļ���
  WindowPathList := MyShellFile.ReadOpenFolderList;
  for i := 0 to WindowPathList.Count - 1 do
    if PathList.IndexOf( WindowPathList[i] ) < 0 then
      PathList.Add( WindowPathList[i] );
  WindowPathList.Free;

    // ɾ����ǰĿ¼
  if SelectPathList.Count > 0 then
    SelectFolder := ExtractFileDir( SelectPathList[0] );
  if PathList.IndexOf( SelectFolder ) >= 0 then
    PathList.Delete( PathList.IndexOf( SelectFolder ) );

    // ��� ������
  for i := 0 to PathList.Count - 1 do
    FaceDesHistoryFolderApi.AddHistory( PathList[i] );
  PathList.Free;

    // ��ȡ·��
  FaceDesFormApi.SetActionType( ReadActionType );
  DesPath := frmDestination.ReadDesPath;

    // ��ֵ������ȡ��
  Result := DesPath <> '';
end;

procedure TFileListMoveFileHandle.Update;
var
  i: Integer;
  FilePath, DesFilePath, FileAction : string;
begin
    // ѡ��Ŀ��Ŀ¼
  if not FindDesPath then
    Exit;

    // ����Ŀ��Ŀ¼
  UserFolderPageApi.AddPage( DesPath );

    // ȡ��ѡ��
  UserFileListApi.CancelSelect( DesPath );

    // �ƶ��ļ�
  for i := 0 to SelectPathList.Count - 1 do
  begin
    FilePath := SelectPathList[i];
    FileAction := frmDestination.ReadInputAcion( FilePath );
    if FileAction = FileAction_Cancel then
      Continue
    else
    if FileAction = FileAction_Rename then
      DesFilePath := MyFilePath.getRenamePath(  MyFilePath.getPath( DesPath ) + MyFilePath.getName( FilePath ), FileExists( FilePath ) )
    else
      DesFilePath := MyFilePath.getPath( DesPath ) + MyFilePath.getName( FilePath );
    AddActoin( FilePath, DesFilePath );
  end;
end;

{ TFileListCopyFileHandle }

procedure TFileListCopyFileHandle.AddActoin(FilePath, DesFilePath: string);
begin
  UserFileMoveApi.FileCopy( FilePath, DesFilePath );
end;

function TFileListCopyFileHandle.ReadActionType: string;
begin
  Result := ActionType_Copy;
end;

{ TFileListCutFileHandle }

procedure TFileListCutFileHandle.AddActoin(FilePath, DesFilePath: string);
begin
  UserFileMoveApi.FileMove( FilePath, DesFilePath );
end;

function TFileListCutFileHandle.ReadActionType: string;
begin
  Result := ActionType_Move;
end;

{ UserPreviewApi }

class procedure UserPreviewApi.StartBigExcelPrivew(FolderPath: string);
var
  FilePath : string;
begin
    // Ԥ��·��
  FilePath := UserFileListApi.ReadFocusePath( FolderPath );

      // �Ƿ�����Ԥ��
  if FacePreviewApi.ReadIsLockPreview then
    Exit;

    // ��ʾ
  FacePreviewApi.ShowBigExcel( FilePath );
end;


class procedure UserPreviewApi.StartBigPicturePrivew(FolderPath: string);
var
  FilePath : string;
begin
    // Ԥ��·��
  FilePath := UserFileListApi.ReadFocusePath( FolderPath );

    // �Ƿ�����Ԥ��
  if FacePreviewApi.ReadIsLockPreview then
    Exit;

    // ��ʾԤ��
  FacePreviewApi.ShowBigPicture( FilePath );
end;

class procedure UserPreviewApi.StartBigTextPrivew(FolderPath: string);
var
  FilePath : string;
begin
    // Ԥ��·��
  FilePath := UserFileListApi.ReadFocusePath( FolderPath );

      // �Ƿ�����Ԥ��
  if FacePreviewApi.ReadIsLockPreview then
    Exit;

    // ��ʾ
  FacePreviewApi.ShowBigText( FilePath );
end;

class procedure UserPreviewApi.StartBigWordPrivew(FolderPath: string);
var
  FilePath : string;
begin
    // Ԥ��·��
  FilePath := UserFileListApi.ReadFocusePath( FolderPath );

      // �Ƿ�����Ԥ��
  if FacePreviewApi.ReadIsLockPreview then
    Exit;

    // ��ʾ
  FacePreviewApi.ShowBigWord( FilePath );
end;

class procedure UserPreviewApi.StopBigExcelPreview(FolderPath: string);
begin
    // �Ƿ�����Ԥ��
  if FacePreviewApi.ReadIsLockPreview then
    Exit;

    // ��ʾ�ļ��б�
  FacePreviewApi.ShowBigFileList;
end;

class procedure UserPreviewApi.StopBigPicturePreview(FolderPath: string);
begin
    // ����ҳ��
  ControlPage( FolderPath );

    // ��������
  if FacePreviewApi.ReadIsLockPreview then
    Exit;

    // ��ʾ�ļ��б�
  FacePreviewApi.ShowBigFileList;
end;

class procedure UserPreviewApi.StopBigTextPreview(FolderPath: string);
begin
    // �Ƿ�����Ԥ��
  if FacePreviewApi.ReadIsLockPreview then
    Exit;

    // ��ʾ�ļ��б�
  FacePreviewApi.ShowBigFileList;
end;

class procedure UserPreviewApi.StopBigWordPreview(FolderPath: string);
begin
    // �Ƿ�����Ԥ��
  if FacePreviewApi.ReadIsLockPreview then
    Exit;

    // ��ʾ�ļ��б�
  FacePreviewApi.ShowBigFileList;
end;

class function UserPreviewApi.ControlPage(FolderPath: string): Boolean;
begin
  Result := UserFileListApi.ControlPage( FolderPath );
end;

class procedure UserPreviewApi.LockBigExcelPreivew(FolderPath: string);
var
  FilePath : string;
  IsLockPreview : Boolean;
begin
    // ��ȡ·��
  FilePath := UserFileListApi.ReadFocusePath( FolderPath );

    // ��ȡҪ���еĲ���
  IsLockPreview := not FacePreviewApi.ReadIsLockPreview;

    // ���ý���
  FacePreviewApi.SetIsLockPreview( IsLockPreview );

    // ��ʾ��ͬ����
  if IsLockPreview then
    FacePreviewApi.ShowPreviewExcel( FilePath )
  else
    FacePreviewApi.ShowPreviewFilter;
end;

class procedure UserPreviewApi.LockBigPicturePreivew(FolderPath: string);
var
  IsLockPreview : Boolean;
begin
    // ����ҳ��
  ControlPage( FolderPath );

    // ��ȡҪ���еĲ���
  IsLockPreview := not FacePreviewApi.ReadIsLockPreview;

    // ����
  FacePreviewApi.SetIsLockPreview( IsLockPreview );

    // ��ʾͼƬ�б�
  if IsLockPreview then
  begin
    FacePreviewApi.ShowPreviewPictrure( FolderPath );
    FacePreviewApi.ShowBackPicture;
  end
  else  // ��ʾ�����б�
  begin
    FacePreviewApi.ClosePreviewPicture;
    FacePreviewApi.ShowPreviewFilter;
    FacePreviewApi.CloseBackPicture;
  end;

    // ��ʱˢ��ͼƬ��С
  FacePreviewApi.SetBigPictureTimer( IsLockPreview );
end;

class procedure UserPreviewApi.LockBigTextPreivew(FolderPath: string);
var
  FilePath : string;
  IsLockPreview : Boolean;
begin
    // ��ȡ·��
  FilePath := UserFileListApi.ReadFocusePath( FolderPath );

    // ��ȡҪ���еĲ���
  IsLockPreview := not FacePreviewApi.ReadIsLockPreview;

    // ��ȡ��ͬ��׺
  if IsLockPreview then
  begin
    FacePreviewApi.ShowPreviewText( FilePath );
    FacePreviewApi.SetIsLockPreview( IsLockPreview );
    FacePreviewApi.ShowBackText;
    Exit;
  end;

    // ����Ԥ������
  if FacePreviewApi.ReadIsTextChange then
  begin
    if MyMessageForm.ShowConfirm( Confirm_Save ) then
      FacePreviewApi.SavePreviewText;
     FacePreviewApi.ShowBigFileList;
  end;
  FacePreviewApi.ShowPreviewFilter;
  FacePreviewApi.SetIsLockPreview( IsLockPreview );
  FacePreviewApi.CloseBackText;
end;

class procedure UserPreviewApi.LockBigWordPreivew(FolderPath: string);
var
  FilePath : string;
  IsLockPreview : Boolean;
begin
    // ��ȡ·��
  FilePath := UserFileListApi.ReadFocusePath( FolderPath );

    // ��ȡҪ���еĲ���
  IsLockPreview := not FacePreviewApi.ReadIsLockPreview;

    // ���ý���
  FacePreviewApi.SetIsLockPreview( IsLockPreview );

    // ��ʾ��ͬ����
  if IsLockPreview then
  begin
    FacePreviewApi.ShowPreviewWord( FilePath );
    FacePreviewApi.ShowBackWord;
  end
  else
  begin
    FacePreviewApi.ShowPreviewFilter;
    FacePreviewApi.CloseBackWord;
  end;
end;

class function UserPreviewApi.PreviewSmallExcel(FolderPath: string): Boolean;
var
  FilePath : string;
begin
    // ��ȡѡ�е�·��
  FilePath := UserFileListApi.ReadFocusePath( FolderPath );

    // �Ƿ�һ���ı��ļ�
  Result := FileExists( FilePath ) and MyExcelPreviewUtil.getIsExcelPreview( FilePath );

    // ������ı��ļ�����Ԥ������ļ�
  if Result then
    FacePreviewApi.ShowSmallExcel;
end;

class function UserPreviewApi.PreviewSmallPicture(FolderPath: string): Boolean;
var
  FilePath : string;
begin
    // ��ȡѡ�е�·��
  FilePath := UserFileListApi.ReadFocusePath( FolderPath );

    // �Ƿ�һ��ͼƬ�ļ�
  Result := FileExists( FilePath ) and MyPicturePriviewUtil.getIsPictureFile( FilePath );

    // �����ͼƬ�ļ�����Ԥ������ļ�
  if Result then
    FacePreviewApi.ShowSmallPicture( FilePath );
end;

class function UserPreviewApi.PreviewSmallText(FolderPath: string): Boolean;
var
  FilePath : string;
begin
    // ��ȡѡ�е�·��
  FilePath := UserFileListApi.ReadFocusePath( FolderPath );

    // �Ƿ�һ���ı��ļ�
  Result := FileExists( FilePath ) and MyTextPreviewUtil.getIsTextPreview( FilePath );

    // ������ı��ļ�����Ԥ������ļ�
  if Result then
    FacePreviewApi.ShowSmallText;
end;

class function UserPreviewApi.PreviewSmallWord(FolderPath: string): Boolean;
var
  FilePath : string;
begin
    // ��ȡѡ�е�·��
  FilePath := UserFileListApi.ReadFocusePath( FolderPath );

    // �Ƿ�һ���ı��ļ�
  Result := FileExists( FilePath ) and MyWordPreviewUtil.getIsWordPreview( FilePath );

    // ������ı��ļ�����Ԥ������ļ�
  if Result then
    FacePreviewApi.ShowSmallDoc;
end;

{ TFacePreviewApi }

procedure TFacePreviewApi.ActivateFrame(FrameExplorer: TFrameExplorer);
begin
  plPreview := FrameExplorer.plPreview;

  PcMain := FrameExplorer.PcBigPreview;
  tsFileList := FrameExplorer.tsFileList;
  tsBigPicture := FrameExplorer.tsBigPicture;
  tsBigText := FrameExplorer.tsBigText;
  tsBigWord := FrameExplorer.tsBigDoc;
  tsBigExcel := FrameExplorer.tsBigExcel;
  ilBigPicture := FrameExplorer.ilBigPicture;
  tmrBigPicture := FrameExplorer.tmrBigPicture;
  mmoBigText := FrameExplorer.mmoBigText;
  mmoBigWord := FrameExplorer.mmoBigWord;
  sgBigExcel := FrameExplorer.sgExcel;
  plExcelText := FrameExplorer.plExcelCopy;
  lbExcelText := FrameExplorer.lbExcelText;

  PcPreview := FrameExplorer.PcPreview;
  tsPreviewFileList := FrameExplorer.tsPreviewFileList;
  tsPreviewPicture := FrameExplorer.tsPreviewImage;
  tsPreviewExt := FrameExplorer.tsPreviewExt;
  plImageList := FrameExplorer.plImageList;

  PcSmallPreview := FrameExplorer.PcSmallPreview;
  tsSmallPicture := FrameExplorer.tsSmallPicture;
  tsSmallText := FrameExplorer.tsSmallText;
  tsSmallWord := FrameExplorer.tsSmallWord;
  tsSmallExcel := FrameExplorer.tsSmallExcel;
  ilSmallPicture := FrameExplorer.ilSmallPicture;
  ilSmallText := FrameExplorer.ilSmallText;
  ilSmallWord := FrameExplorer.ilSmallWord;
  ilSmallExcel := FrameExplorer.ilSmallExcel;
end;

procedure TFacePreviewApi.CloseBackExcel;
begin
  MyPicturePriviewUtil.SetPicture( ilSmallExcel, MyAppData.getPreviewExcel );
end;

procedure TFacePreviewApi.CloseBackPicture;
begin
  MyPicturePriviewUtil.SetPicture( ilSmallPicture, ilSmallPicture.Hint );
end;

procedure TFacePreviewApi.CloseBackText;
begin
  MyPicturePriviewUtil.SetPicture( ilSmallText, MyAppData.getPreviewNote );
end;

procedure TFacePreviewApi.CloseBackWord;
begin
  MyPicturePriviewUtil.SetPicture( ilSmallWord, MyAppData.getPreviewWord );
end;

procedure TFacePreviewApi.ClosePreviewPicture;
var
  i: Integer;
begin
  for i := plImageList.ControlCount - 1 downto 0 do
    plImageList.Controls[i].Free;
end;

procedure TFacePreviewApi.PreviewPictureClick(Sender: TObject);
var
  ilImage : TImage;
  plImage : TPanel;
begin
  try
    ilImage := Sender as TImage;
    plImage := ilImage.Parent as TPanel;
    ShowBigPicture( plImage.Hint );
  except
  end;
end;

function TFacePreviewApi.ReadIsLockPreview;
begin
  Result := plPreview.Tag = 1;
end;

function TFacePreviewApi.ReadIsTextChange: Boolean;
begin
  Result := mmoBigText.Tag = 1;
end;

procedure TFacePreviewApi.SavePreviewText;
begin
  try
    mmoBigText.Lines.SaveToFile( mmoBigText.Hint );
  except
  end;
end;

procedure TFacePreviewApi.SetBigPictureTimer(IsEnable: Boolean);
begin
  tmrBigPicture.Enabled := IsEnable;
  if IsEnable then
    tmrBigPicture.Tag := ilBigPicture.Width + ilBigPicture.Height;
end;

procedure TFacePreviewApi.SetIsLockPreview(IsLockPreview: Boolean);
begin
  if IsLockPreview then
  begin
    plPreview.BevelOuter := bvLowered;
    plPreview.Tag := 1;
  end
  else
  begin
    plPreview.BevelOuter := bvRaised;
    plPreview.Tag := 0;
  end;
end;

procedure TFacePreviewApi.ShowBigPicture(Path: string);
begin
  PcMain.ActivePage := tsBigPicture;
  ilBigPicture.Picture := nil;
  ilBigPicture.Hint := Path;
  MyPicturePriviewUtil.SetBigPicture( ilBigPicture, Path );
end;

procedure TFacePreviewApi.ShowBigText(Path: string);
begin
  PcMain.ActivePage := tsBigText;
  try
    mmoBigText.Lines.LoadFromFile( Path );
    mmoBigText.Hint := Path;
    mmoBigText.Tag := 0;
  except
  end;
end;

procedure TFacePreviewApi.ShowBigWord(Path: string);
begin
  PcMain.ActivePage := tsBigWord;
  mmoBigWord.ReadOnly := False;
  mmoBigWord.Clear;
  MyWordPreviewUtil.SetWord( mmoBigWord, Path );
  mmoBigWord.ReadOnly := True;
end;

procedure TFacePreviewApi.ShowPreviewExcel(Path: string);
var
  FolderPath, ExtStr : string;
  FileList : TStringList;
  i: Integer;
begin
  PcPreview.ActivePage := tsPreviewExt;

  FolderPath := ExtractFileDir( Path );
  ExtStr := ExtractFileExt( Path );
  FacePreviewExtApi.ClearFiles;
  FileList := MyExcelPreviewUtil.ReadExcelList( FolderPath );
  for i := 0 to FileList.Count - 1 do
    if ( MyFileInfo.getFileSize( FileList[i] ) <= 128 * Size_KB ) and
       not MyFileInfo.getIsHide( FileList[i] )
    then
      FacePreviewExtApi.AddFile( FileList[i], PreviewAction_Excel );
  FileList.Free;
end;

procedure TFacePreviewApi.ShowPreviewFilter;
begin
  PcPreview.ActivePage := tsPreviewFileList;
end;

procedure TFacePreviewApi.ShowPreviewPictrure(Path: string);
var
  ImageFileList : TStringList;
  ImgFolderPath : string;
  plImage : TPanel;
  ilImage : TImage;
  i: Integer;
begin
  PcPreview.ActivePage := tsPreviewPicture;

  ImgFolderPath := Path;
  ImageFileList := MyPicturePriviewUtil.ReadPictureList( ImgFolderPath );
    // ���Ԥ��50��
  if ImageFileList.Count > 50 then
    for i := ImageFileList.Count - 1 downto 50 do
      ImageFileList.Delete( i );
  plImageList.Height := 0;
  for i := 0 to ImageFileList.Count - 1 do
  begin
    plImage := TPanel.Create(plImageList);
    plImage.Parent := plImageList;
    plImage.Height := 70;
    plImage.BevelKind := bkTile;
    plImage.Top := 10000;
    plImage.Align := alTop;
    plImage.Hint := ImageFileList[i];
    plImageList.Height := plImageList.Height + plImage.Height;

    ilImage := TImage.Create( plImage );
    ilImage.Parent := plImage;
    ilImage.Align := alClient;
    ilImage.ShowHint := True;
    ilImage.Hint := ExtractFileName( ImageFileList[i] );
    ilImage.OnClick := PreviewPictureClick;
    MyPicturePriviewUtil.SetPicture( ilImage, ImageFileList[i] );
  end;
  ImageFileList.Free;
end;

procedure TFacePreviewApi.ShowPreviewText(Path: string);
var
  FolderPath, ExtStr : string;
  FileList : TStringList;
  i: Integer;
begin
  PcPreview.ActivePage := tsPreviewExt;

  FolderPath := ExtractFileDir( Path );
  ExtStr := ExtractFileExt( Path );
  FacePreviewExtApi.ClearFiles;
  FileList := MyFilePath.ReadSameExtList( FolderPath, ExtStr );
  for i := 0 to FileList.Count - 1 do
    if MyFileInfo.getFileSize( FileList[i] ) <= 128 * Size_KB then
      FacePreviewExtApi.AddFile( FileList[i], PreviewAction_Text );
  FileList.Free;
end;

procedure TFacePreviewApi.ShowPreviewWord(Path: string);
var
  FolderPath, ExtStr : string;
  FileList : TStringList;
  i: Integer;
begin
  PcPreview.ActivePage := tsPreviewExt;

  FolderPath := ExtractFileDir( Path );
  ExtStr := ExtractFileExt( Path );
  FacePreviewExtApi.ClearFiles;
  FileList := MyWordPreviewUtil.ReadWordList( FolderPath );
  for i := 0 to FileList.Count - 1 do
    if ( MyFileInfo.getFileSize( FileList[i] ) <= 128 * Size_KB ) and
       not MyFileInfo.getIsHide( FileList[i] )
    then
      FacePreviewExtApi.AddFile( FileList[i], PreviewAction_Word );
  FileList.Free;
end;

procedure TFacePreviewApi.ShowBackExcel;
begin
  MyPicturePriviewUtil.SetPicture( ilSmallExcel, MyAppData.getPreviewBack );
end;

procedure TFacePreviewApi.ShowBackPicture;
begin
  MyPicturePriviewUtil.SetPicture( ilSmallPicture, MyAppData.getPreviewBack );
end;

procedure TFacePreviewApi.ShowBackText;
begin
  MyPicturePriviewUtil.SetPicture( ilSmallText, MyAppData.getPreviewBack );
end;

procedure TFacePreviewApi.ShowBackWord;
begin
  MyPicturePriviewUtil.SetPicture( ilSmallWord, MyAppData.getPreviewBack );
end;

procedure TFacePreviewApi.ShowBigExcel(Path: string);
var
  i: Integer;
begin
  PcMain.ActivePage := tsBigExcel;
  lbExcelText.Caption := '';
  plExcelText.Enabled := False;
  for i := 0 to sgBigExcel.RowCount - 1 do
    sgBigExcel.Rows[i].Clear;
  MyExcelPreviewUtil.SetExcel( sgBigExcel, Path );
end;

procedure TFacePreviewApi.ShowBigFileList;
begin
  PcMain.ActivePage := tsFileList;
end;

procedure TFacePreviewApi.ShowSmallDoc;
begin
  plPreview.Visible := True;
  PcSmallPreview.ActivePage := tsSmallWord;
  if ilSmallWord.Tag = 1 then
    Exit;
  MyPicturePriviewUtil.SetPicture( ilSmallWord, MyAppData.getPreviewWord );
  ilSmallWord.Tag := 1;
end;

procedure TFacePreviewApi.ShowSmallEmpty;
begin
  plPreview.Visible := False;
end;

procedure TFacePreviewApi.ShowSmallExcel;
begin
  plPreview.Visible := True;
  PcSmallPreview.ActivePage := tsSmallExcel;
  if ilSmallExcel.Tag = 1 then
    Exit;
  MyPicturePriviewUtil.SetPicture( ilSmallExcel, MyAppData.getPreviewExcel );
  ilSmallExcel.Tag := 1;
end;

procedure TFacePreviewApi.ShowSmallPicture(Path: string);
begin
  plPreview.Visible := True;
  PcSmallPreview.ActivePage := tsSmallPicture;
  ilSmallPicture.Hint := Path;
  MyPicturePriviewUtil.SetPicture( ilSmallPicture, Path );
end;

procedure TFacePreviewApi.ShowSmallText;
begin
  plPreview.Visible := True;
  PcSmallPreview.ActivePage := tsSmallText;
  if ilSmallText.Tag = 1 then
    Exit;
  MyPicturePriviewUtil.SetPicture( ilSmallText, MyAppData.getPreviewNote );
  ilSmallText.Tag := 1;
end;

{ TFacePreviewExtApi }

procedure TFacePreviewExtApi.ActivatePrivewExt(
  _vstPreviewExt: TVirtualStringTree);
begin
  vstPreviewExt := _vstPreviewExt;
end;

procedure TFacePreviewExtApi.AddFile(FilePath, ActionType: string);
var
  NewNode : PVirtualNode;
  NodeData : PVstPreviewExtData;
begin
  NewNode := vstPreviewExt.AddChild( vstPreviewExt.RootNode );
  NodeData := vstPreviewExt.GetNodeData( NewNode );
  NodeData.FilePath := FilePath;
  NodeData.ActionType := ActionType;
  NodeData.ShowName := ExtractFileName( FilePath );
  NodeData.ShowIcon := MyIcon.getFileIcon( FilePath );
end;

procedure TFacePreviewExtApi.ClearFiles;
begin
  vstPreviewExt.Clear;
end;

end.
