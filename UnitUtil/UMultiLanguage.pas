unit UMultiLanguage;

interface

uses IniFiles;

type

    // 多语言辅助类
  LanguageUtil = class
  public
    class procedure StartLoad;
    class procedure StopLoad;
  public
    class function getIsEn : Boolean;
    class function getIsCn : Boolean;
  public
    class function Read( ReadName : string ): string;
  end;

    // 全局范围多语言
  AppLanguageUtil = class
  public
    class function getOK : string;
    class function getRemove : string;
    class function getCancel : string;
  public
    class function getError : string;
    class function getWarnning : string;
    class function getInformation : string;
  end;

    // 主窗口
  MainFormLanguage = class
  public
    class function getTitle : string;
    class function getBtnMyComputer : string;
    class function getBtnMyRun : string;
  public
    class function getTrayUpgrade : string;
    class function getTrayAutoRun : string;
    class function getTrayAutoRunOff : string;
    class function getTrayAutoRunOn : string;
    class function getTrayAbout : string;
    class function getTrayExit : string;
  end;

    // 我的电脑
  MyComputerLanguage = class
  public
    class function getCloseOtherTab: string;
    class function getCloseLeftTab: string;
    class function getCloseRightTab: string;
    class function getAddTab: string;
    class function getAddFavorite: string;
    class function getRemoveFavorite: string;
  public
    class function getDesktop : string;
    class function getWaitFor : string;
    class function getCopy : string;
    class function getMove : string;
    class function getDelete : string;
    class function getZip : string;
    class function getUnzip : string;
  end;

    // 历史记录管理
  HistoryFormLanguage = class
  public
    class function getTitle : string;
  end;

    // 压缩文件
  ZipFormLanguage = class
  public
    class function getTitle : string;
    class function getZiping : string;
  end;

    // 解压文件
  UnzipFormLanguage = class
  public
    class function getTitle : string;
    class function getZiping : string;
  end;

    // 目标窗口
  DestinationFormLanguage = class
  public
    class function getCopyTitle : string;
    class function getMoveTitle : string;
  public
    class function getPaste : string;
    class function getConflict : string;
    class function getReplace : string;
    class function getRename : string;
    class function getCancel : string;
  end;

    // 文件列表
  FileListLanguage = class
  public
    class function getNameCol : string;
    class function getSizeCol : string;
    class function getTimeCol : string;
  public
    class function getBack : string;
    class function getBtnCopy : string;
    class function getCopyOK : string;
  public
    class function getFilterAll : string;
    class function getFilterFolder : string;
    class function getFilterFile : string;
  public
    class function getNewTabTitle : string;
    class function getNewTabName : string;
    class function getNewTabNotExist : string;
  public
    class function getRenameTitle : string;
    class function getRenameName : string;
    class function getRenameExist : string;
  public
    class function getNewFolderTitle : string;
    class function getNewFolderName : string;
    class function getNewFolderDefault : string;
  public
    class function getDeleteConfirm : string;
    class function getNewCompressedName : string;
  public
    class function getPmZip : string;
    class function getPmUnZip : string;
    class function getPmCopy : string;
    class function getPmMove : string;
    class function getPmRename : string;
    class function getPmDelete : string;
    class function getPmNewFolder : string;
    class function getPmRefresh : string;
    class function getPmExplorer : string;
  end;

    // 快速运行
  MyRunLanguage = class
  public
    class function getDragdrop : string;
    class function getImport : string;
    class function getInput : string;
  end;

    // 桌面导入
  DesktopFormLanguage = class
  public
    class function getTitle : string;
    class function getAll : string;
    class function getImportCompleted : string;
  end;

    // 添加快速运行
  MyRunInputLanguage = class
  public
    class function getTitle : string;
    class function getName : string;
    class function getNotExist : string;
  end;

    // 批运行
  BatRunFormLanguage = class
  public
    class function getTitle : string;
  end;

    // 关于窗口
  AboutFormLanguage = class
  public
    class function getTitle : string;
    class function getName : string;
    class function getHomePage : string;
    class function getContactUs : string;
    class function getCopyEmail : string;
    class function getBytheway : string;
  end;

    // 修复窗口
  FixFormLanguage = class
  public
    class function getTitle : string;
    class function getErrorStr : string;
  end;

    // 预览
  PreviewLanguage = class
  public
    class function getSaveTextConfirm : string;
    class function getTextSaved : string;
    class function getExcelCopy : string;
  end;

const
  IniAppLang_en = 'en';
  IniAppLang_cn = 'cn';

const
  Ini_App_OK = 'App_OK';
  Ini_App_Remove = 'App_Remove';
  Ini_App_Cancel = 'App_Cancel';

  Ini_App_Error = 'MessageForm_Error';
  Ini_App_Information = 'MessageForm_Information';
  Ini_App_Warnning = 'MessageForm_Warnning';

const
  Ini_MainForm_Title = 'MainForm_Title';
  Ini_MainForm_btnMyComputer = 'MainForm_btnMyComputer';
  Ini_MainForm_btnMyRun = 'MainForm_btnMyRun';

  Ini_PmTray_Upgrade = 'PmTray_Upgrade';
  Ini_PmTray_AutoRun = 'PmTray_AutoRun';
  Ini_PmTray_AutoRunOff = 'PmTray_AutoRunOff';
  Ini_PmTray_AutoRunOn = 'PmTray_AutoRunOn';
  Ini_PmTray_About = 'PmTray_About';
  Ini_PmTray_Exit = 'PmTray_Exit';

const
  Ini_MyComputer_CloseOtherTabs = 'MyComputer_CloseOtherTabs';
  Ini_MyComputer_CloseLeftTabs = 'MyComputer_CloseLeftTabs';
  Ini_MyComputer_CloseRightTabs = 'MyComputer_CloseRightTabs';
  Ini_MyComputer_AddTab = 'MyComputer_AddTab';
  Ini_MyComputer_AddFavorite = 'MyComputer_AddFavorites';
  Ini_MyComputer_RemoveFavorite = 'MyComputer_CancelFavorites';

const
  Ini_MyComputer_Desktop = 'MyComputer_Desktop';
  Ini_MyComputer_WaitFor = 'MyComputer_WaitFor';
  Ini_MyComputer_Copy = 'MyComputer_Copy';
  Ini_MyComputer_Move = 'MyComputer_Move';
  Ini_MyComputer_Delete = 'MyComputer_Delete';
  Ini_MyComputer_Zip = 'MyComputer_Zip';
  Ini_MyComputer_Unzip = 'MyComputer_Unzip';

const
  Ini_History_Title = 'HistoryForm_Title';

const
  Ini_Zip_Title = 'ZipForm_Title';
  Ini_Zip_Ziping = 'ZipForm_Ziping';

const
  Ini_Unzip_Title = 'UnzipForm_Title';
  Ini_Unzip_Unziping = 'UnzipForm_Unziping';

const
  Ini_Destination_CopyTitle = 'DesForm_CopyTitle';
  Ini_Destination_MoveTitle = 'DesForm_MoveTitle';
  Ini_Destination_PasteAction = 'DesForm_PasteAction';
  Ini_Destination_ConfliectAction = 'DesForm_ConfliectAction';
  Ini_Destination_ReplaceAction = 'DesForm_ReplaceAction';
  Ini_Destination_RenameAction = 'DesForm_RenameAction';
  Ini_Destination_CancelAction = 'DesForm_CancelAction';

const
  Ini_FileList_NameCol = 'FileList_NameCol';
  Ini_FileList_SizeCol = 'FileList_SizeCol';
  Ini_FileList_TimeCol = 'FileList_TimeCol';

  Ini_FileList_BtnCopyPath = 'FileList_BtnCopyPath';
  Ini_FileList_CopyOK = 'FileList_CopyOK';
  Ini_FileList_Back = 'FileList_Back';

  Ini_FileList_FilterAll = 'FileList_FilterAll';
  Ini_FileList_FilterFolder = 'FileList_FilterFolder';
  Ini_FileList_FilterFile = 'FileList_FilterFile';

const
  Ini_NewTab_Title = 'NewTab_Title';
  Ini_NewTab_Name = 'NewTab_Name';
  Ini_NewTab_NotExist = 'NewTab_NotExist';

const
  Ini_Rename_Title = 'Rename_Title';
  Ini_Rename_Name = 'Rename_Name';
  Ini_Rename_Exist = 'Rename_Exist';

const
  Ini_NewFolder_Title = 'NewFolder_Title';
  Ini_NewFolder_Name = 'NewFolder_Name';
  Ini_NewFolder_DefaultName = 'NewFolder_DefaultName';

  Ini_Compressed_NewName = 'Compressed_NewName';

const
  Ini_DeleteFile_Confirm = 'DeleteFile_Confirm';

const
  Ini_FileListPm_Zip = 'FileList_Zip';
  Ini_FileListPm_Unzip = 'FileList_Unzip';
  Ini_FileListPm_Copy = 'FileList_Copy';
  Ini_FileListPm_Move = 'FileList_Move';
  Ini_FileListPm_Rename = 'FileList_Rename';
  Ini_FileListPm_Delete = 'FileList_Delete';
  Ini_FileListPm_NewFolder = 'FileList_NewFolder';
  Ini_FileListPm_Refresh = 'FileList_Refresh';
  Ini_FileListPm_Explorer = 'FileList_Explorer';

const
  Ini_MyRun_Dragdrop = 'MyRun_DragDrop';
  Ini_MyRun_Import = 'MyRun_Import';
  Ini_MyRun_Input = 'MyRun_Input';

const
  Ini_DesktopForm_Title = 'DesktopForm_Title';
  Ini_DesktopForm_All = 'DesktopForm_SelectAll';
  Ini_DesktopForm_ImportCompleted = 'DesktopForm_Completed';

const
  Ini_MyRunInput_Title = 'MyRunInput_Title';
  Ini_MyRunInput_Name = 'MyRunInput_Name';
  Ini_MyRunInput_NotEixst = 'MyRunInput_NotExist';

const
  Ini_BatRunForm_Title = 'BatRunForm_Title';

const
  Ini_AboutForm_Title = 'AboutForm_Title';
  Ini_AboutForm_Name = 'AboutForm_AppName';
  Ini_AboutForm_HomePage = 'AboutForm_HomePage';
  Ini_AboutForm_ContactUs = 'AboutForm_ContactUs';
  Ini_AboutForm_CopyEmail = 'AboutForm_CopyEmail';
  Ini_AboutForm_ByTheWay = 'AboutForm_ByTheWay';

const
  Ini_FixForm_Title = 'FixForm_Title';
  Ini_FixForm_Error = 'FixForm_Error';

const
  Ini_Preview_SaveTextConfirm = 'Preivew_SaveTextConfirm';
  Ini_Preview_TextSaved = 'Preview_TextSaved';
  Ini_Preview_CopyExcel = 'Preview_CopyExcel';

var
  LangIniFile : TIniFile;
  AppLang_Default : string = IniAppLang_en;

implementation

uses UMyUtil;

{ MainFormLanguage }

class function MainFormLanguage.getBtnMyComputer: string;
begin
  Result := LanguageUtil.Read( Ini_MainForm_btnMyComputer );
end;

class function MainFormLanguage.getBtnMyRun: string;
begin
  Result := LanguageUtil.Read( Ini_MainForm_btnMyRun );
end;

class function MainFormLanguage.getTitle: string;
begin
  Result := LanguageUtil.Read( Ini_MainForm_Title );
end;

class function MainFormLanguage.getTrayAbout: string;
begin
  Result := LanguageUtil.Read( Ini_PmTray_About );
end;

class function MainFormLanguage.getTrayAutoRun: string;
begin
  Result := LanguageUtil.Read( Ini_PmTray_AutoRun );
end;

class function MainFormLanguage.getTrayAutoRunOff: string;
begin
  Result := LanguageUtil.Read( Ini_PmTray_AutoRunOff );
end;

class function MainFormLanguage.getTrayAutoRunOn: string;
begin
  Result := LanguageUtil.Read( Ini_PmTray_AutoRunOn );
end;

class function MainFormLanguage.getTrayExit: string;
begin
  Result := LanguageUtil.Read( Ini_PmTray_Exit );
end;

class function MainFormLanguage.getTrayUpgrade: string;
begin
  Result := LanguageUtil.Read( Ini_PmTray_Upgrade );
end;

{ LanguageUtil }

class function LanguageUtil.getIsCn: Boolean;
begin
  Result := AppLang_Default = IniAppLang_cn;
end;

class function LanguageUtil.getIsEn: Boolean;
begin
  Result := AppLang_Default = IniAppLang_en;
end;

class function LanguageUtil.Read(ReadName: string): string;
begin
  try
    Result := LangIniFile.ReadString( ReadName, AppLang_Default, '' );
  except
  end;
end;

class procedure LanguageUtil.StartLoad;
begin
  LangIniFile := TIniFile.Create( MyAppData.getLanguagePath );
end;

class procedure LanguageUtil.StopLoad;
begin
  LangIniFile.Free;
end;

{ MyComputerLanguage }

class function MyComputerLanguage.getAddFavorite: string;
begin
  Result := LanguageUtil.Read( Ini_MyComputer_AddFavorite );
end;

class function MyComputerLanguage.getAddTab: string;
begin
  Result := LanguageUtil.Read( Ini_MyComputer_AddTab );
end;

class function MyComputerLanguage.getCloseLeftTab: string;
begin
  Result := LanguageUtil.Read( Ini_MyComputer_CloseLeftTabs );
end;

class function MyComputerLanguage.getCloseOtherTab: string;
begin
  Result := LanguageUtil.Read( Ini_MyComputer_CloseOtherTabs );
end;

class function MyComputerLanguage.getCloseRightTab: string;
begin
  Result := LanguageUtil.Read( Ini_MyComputer_CloseRightTabs );
end;

class function MyComputerLanguage.getCopy: string;
begin
  Result := LanguageUtil.Read( Ini_MyComputer_Copy );
end;

class function MyComputerLanguage.getDelete: string;
begin
  Result := LanguageUtil.Read( Ini_MyComputer_Delete );
end;

class function MyComputerLanguage.getDesktop: string;
begin
  Result := LanguageUtil.Read( Ini_MyComputer_Desktop );
end;

class function MyComputerLanguage.getMove: string;
begin
  Result := LanguageUtil.Read( Ini_MyComputer_Move );
end;

class function MyComputerLanguage.getRemoveFavorite: string;
begin
  Result := LanguageUtil.Read( Ini_MyComputer_RemoveFavorite );
end;

class function MyComputerLanguage.getUnzip: string;
begin
  Result := LanguageUtil.Read( Ini_MyComputer_Unzip );
end;

class function MyComputerLanguage.getWaitFor: string;
begin
  Result := LanguageUtil.Read( Ini_MyComputer_WaitFor );
end;

class function MyComputerLanguage.getZip: string;
begin
  Result := LanguageUtil.Read( Ini_MyComputer_Zip );
end;

{ AppLanguageUtil }

class function AppLanguageUtil.getCancel: string;
begin
  Result := LanguageUtil.Read( Ini_App_Cancel );
end;

class function AppLanguageUtil.getError: string;
begin
  Result := LanguageUtil.Read( Ini_App_Error );
end;

class function AppLanguageUtil.getInformation: string;
begin
  Result := LanguageUtil.Read( Ini_App_Information );
end;

class function AppLanguageUtil.getOK: string;
begin
  Result := LanguageUtil.Read( Ini_App_OK );
end;

class function AppLanguageUtil.getRemove: string;
begin
  Result := LanguageUtil.Read( Ini_App_Remove );
end;

class function AppLanguageUtil.getWarnning: string;
begin
  Result := LanguageUtil.Read( Ini_App_Warnning );
end;

{ HistoryFormLanguage }

class function HistoryFormLanguage.getTitle: string;
begin
  Result := LanguageUtil.Read( Ini_History_Title );
end;

{ ZipFormLanguage }

class function ZipFormLanguage.getTitle: string;
begin
  Result := LanguageUtil.Read( Ini_Zip_Title );
end;

class function ZipFormLanguage.getZiping: string;
begin
  Result := LanguageUtil.Read( Ini_Zip_Ziping );
end;

{ UnzipFormLanguage }

class function UnzipFormLanguage.getTitle: string;
begin
  Result := LanguageUtil.Read( Ini_Unzip_Title );
end;

class function UnzipFormLanguage.getZiping: string;
begin
  Result := LanguageUtil.Read( Ini_Unzip_Unziping );
end;

{ DestinationFormLanguage }

class function DestinationFormLanguage.getCancel: string;
begin
  Result := LanguageUtil.Read( Ini_Destination_CancelAction );
end;

class function DestinationFormLanguage.getConflict: string;
begin
  Result := LanguageUtil.Read( Ini_Destination_ConfliectAction );
end;

class function DestinationFormLanguage.getCopyTitle: string;
begin
  Result := LanguageUtil.Read( Ini_Destination_CopyTitle );
end;

class function DestinationFormLanguage.getMoveTitle: string;
begin
  Result := LanguageUtil.Read( Ini_Destination_MoveTitle );
end;

class function DestinationFormLanguage.getPaste: string;
begin
  Result := LanguageUtil.Read( Ini_Destination_PasteAction );
end;

class function DestinationFormLanguage.getRename: string;
begin
  Result := LanguageUtil.Read( Ini_Destination_RenameAction );
end;

class function DestinationFormLanguage.getReplace: string;
begin
  Result := LanguageUtil.Read( Ini_Destination_ReplaceAction );
end;

{ FileListLanguage }

class function FileListLanguage.getBack: string;
begin
  Result := LanguageUtil.Read( Ini_FileList_Back );
end;

class function FileListLanguage.getBtnCopy: string;
begin
  Result := LanguageUtil.Read( Ini_FileList_BtnCopyPath );
end;

class function FileListLanguage.getCopyOK: string;
begin
  Result := LanguageUtil.Read( Ini_FileList_CopyOK );
end;

class function FileListLanguage.getDeleteConfirm: string;
begin
  Result := LanguageUtil.Read( Ini_DeleteFile_Confirm );
end;

class function FileListLanguage.getFilterAll: string;
begin
  Result := LanguageUtil.Read( Ini_FileList_FilterAll );
end;

class function FileListLanguage.getFilterFile: string;
begin
  Result := LanguageUtil.Read( Ini_FileList_FilterFile );
end;

class function FileListLanguage.getFilterFolder: string;
begin
  Result := LanguageUtil.Read( Ini_FileList_FilterFolder );
end;

class function FileListLanguage.getNameCol: string;
begin
  Result := LanguageUtil.Read( Ini_FileList_NameCol );
end;

class function FileListLanguage.getNewTabNotExist: string;
begin
  Result := LanguageUtil.Read( Ini_NewTab_NotExist );
end;

class function FileListLanguage.getNewTabTitle: string;
begin
  Result := LanguageUtil.Read( Ini_NewTab_Title );
end;

class function FileListLanguage.getPmCopy: string;
begin
  Result := LanguageUtil.Read( Ini_FileListPm_Copy );
end;

class function FileListLanguage.getPmDelete: string;
begin
  Result := LanguageUtil.Read( Ini_FileListPm_Delete );
end;

class function FileListLanguage.getPmExplorer: string;
begin
  Result := LanguageUtil.Read( Ini_FileListPm_Explorer );
end;

class function FileListLanguage.getPmMove: string;
begin
  Result := LanguageUtil.Read( Ini_FileListPm_Move );
end;

class function FileListLanguage.getPmNewFolder: string;
begin
  Result := LanguageUtil.Read( Ini_FileListPm_NewFolder );
end;

class function FileListLanguage.getPmRefresh: string;
begin
  Result := LanguageUtil.Read( Ini_FileListPm_Refresh );
end;

class function FileListLanguage.getPmRename: string;
begin
  Result := LanguageUtil.Read( Ini_FileListPm_Rename );
end;

class function FileListLanguage.getPmUnZip: string;
begin
  Result := LanguageUtil.Read( Ini_FileListPm_Unzip );
end;

class function FileListLanguage.getPmZip: string;
begin
  Result := LanguageUtil.Read( Ini_FileListPm_Zip );
end;

class function FileListLanguage.getRenameExist: string;
begin
  Result := LanguageUtil.Read( Ini_Rename_Exist );
end;

class function FileListLanguage.getRenameName: string;
begin
  Result := LanguageUtil.Read( Ini_Rename_Name );
end;

class function FileListLanguage.getRenameTitle: string;
begin
  Result := LanguageUtil.Read( Ini_Rename_Title );
end;

class function FileListLanguage.getNewCompressedName: string;
begin
  Result := LanguageUtil.Read( Ini_Compressed_NewName );
end;

class function FileListLanguage.getNewFolderDefault: string;
begin
  Result := LanguageUtil.Read( Ini_NewFolder_DefaultName );
end;

class function FileListLanguage.getNewFolderName: string;
begin
  Result := LanguageUtil.Read( Ini_NewFolder_Name );
end;

class function FileListLanguage.getNewFolderTitle: string;
begin
  Result := LanguageUtil.Read( Ini_NewFolder_Title );
end;

class function FileListLanguage.getNewTabName: string;
begin
  Result := LanguageUtil.Read( Ini_NewTab_Name );
end;

class function FileListLanguage.getSizeCol: string;
begin
  Result := LanguageUtil.Read( Ini_FileList_SizeCol );
end;

class function FileListLanguage.getTimeCol: string;
begin
  Result := LanguageUtil.Read( Ini_FileList_TimeCol );
end;

{ MyRunLanguage }

class function MyRunLanguage.getDragdrop: string;
begin
  Result := LanguageUtil.Read( Ini_MyRun_Dragdrop );
end;

class function MyRunLanguage.getImport: string;
begin
  Result := LanguageUtil.Read( Ini_MyRun_Import );
end;

class function MyRunLanguage.getInput: string;
begin
  Result := LanguageUtil.Read( Ini_MyRun_Input );
end;

{ DesktopFormLanguage }

class function DesktopFormLanguage.getAll: string;
begin
  Result := LanguageUtil.Read( Ini_DesktopForm_All );
end;

class function DesktopFormLanguage.getImportCompleted: string;
begin
  Result := LanguageUtil.Read( Ini_DesktopForm_ImportCompleted );
end;

class function DesktopFormLanguage.getTitle: string;
begin
  Result := LanguageUtil.Read( Ini_DesktopForm_Title );
end;

{ MyRunInputLanguage }

class function MyRunInputLanguage.getName: string;
begin
  Result := LanguageUtil.Read( Ini_MyRunInput_Name );
end;

class function MyRunInputLanguage.getNotExist: string;
begin
  Result := LanguageUtil.Read( Ini_MyRunInput_NotEixst );
end;

class function MyRunInputLanguage.getTitle: string;
begin
  Result := LanguageUtil.Read( Ini_MyRunInput_Title );
end;

{ BatRunFormLanguage }

class function BatRunFormLanguage.getTitle: string;
begin
  Result := LanguageUtil.Read( Ini_BatRunForm_Title );
end;

{ AboutFormLanguage }

class function AboutFormLanguage.getBytheway: string;
begin
  Result := LanguageUtil.Read( Ini_AboutForm_ByTheWay );
end;

class function AboutFormLanguage.getContactUs: string;
begin
  Result := LanguageUtil.Read( Ini_AboutForm_ContactUs );
end;

class function AboutFormLanguage.getCopyEmail: string;
begin
  Result := LanguageUtil.Read( Ini_AboutForm_CopyEmail );
end;

class function AboutFormLanguage.getHomePage: string;
begin
  Result := LanguageUtil.Read( Ini_AboutForm_HomePage );
end;

class function AboutFormLanguage.getName: string;
begin
  Result := LanguageUtil.Read( Ini_AboutForm_Name );
end;

class function AboutFormLanguage.getTitle: string;
begin
  Result := LanguageUtil.Read( Ini_AboutForm_Title );
end;

{ FixFormLanguage }

class function FixFormLanguage.getErrorStr: string;
begin
  Result := LanguageUtil.Read( Ini_FixForm_Error );
end;

class function FixFormLanguage.getTitle: string;
begin
  Result := LanguageUtil.Read( Ini_FixForm_Title );
end;

{ PreviewLanguage }

class function PreviewLanguage.getExcelCopy: string;
begin
  Result := LanguageUtil.Read( Ini_Preview_CopyExcel );
end;

class function PreviewLanguage.getSaveTextConfirm: string;
begin
  Result := LanguageUtil.Read( Ini_Preview_SaveTextConfirm );
end;

class function PreviewLanguage.getTextSaved: string;
begin
  Result := LanguageUtil.Read( Ini_Preview_TextSaved );
end;

end.
