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
    // �����ڴ�й©
  ReportMemoryLeaksOnShutdown := DebugHook<>0;

    // ��ֹ�������ͬʱ����
  myhandle := findwindow( hfck_Name, nil );
  if myhandle > 0 then  // ������ͬһ�� �û� ID �Ѿ�����, �ָ�֮ǰ�Ĵ���
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
