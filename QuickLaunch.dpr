program QuickLaunch;

uses
  ExceptionLog,
  Vcl.Forms,
  Windows,
  Messages,
  Dialogs,
  SysUtils,
  UMainForm in 'UMainForm.pas' {frmMain},
  UMyUtil in 'UnitUtil\UMyUtil.pas',
  UMyIcon in 'UnitUtil\UMyIcon.pas',
  Vcl.Themes,
  Vcl.Styles,
  UThreadUtil in 'UnitUtil\UThreadUtil.pas',
  UFormDesktopPath in 'UnitMyRun\UFormDesktopPath.pas' {frmDesktopPath},
  UFrameMyRun in 'UnitMyRun\UFrameMyRun.pas' {FrameMyRun: TFrame},
  UFormBatRun in 'UnitMyRun\UFormBatRun.pas' {frmBatRun},
  UFormAbout in 'UFormAbout.pas' {frmAbout},
  UMyUrl in 'UnitUtil\UMyUrl.pas';

{$R *.res}

var
  myhandle : Integer;
begin
    // 报告内存泄漏
  ReportMemoryLeaksOnShutdown := DebugHook<>0;

    // 防止多个程序同时运行
  myhandle := findwindow( hfck_Name, nil );
  if myhandle > 0 then  // 窗口在同一个 用户 ID 已经运行, 恢复之前的窗口
  begin
    postmessage( myhandle,hfck_index,0,0 );
    Exit;
  end;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Iceberg Classico');
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDesktopPath, frmDesktopPath);
  Application.CreateForm(TfrmBatRun, frmBatRun);
  Application.CreateForm(TfrmAbout, frmAbout);
  frmMain.AppStart;
  Application.Run;
end.
