unit UFrameMyPreview;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, VirtualTrees,
  Vcl.StdCtrls, RzTabs;

type
  TFrameMyPreview = class(TFrame)
    plPreview: TPanel;
    PcPreview: TRzPageControl;
    TabSheet1: TRzTabSheet;
    plBottom: TPanel;
    Panel2: TPanel;
    Image3: TImage;
    LinkLabel2: TLinkLabel;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
