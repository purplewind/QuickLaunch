unit UFrameToolBtton;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TFrameToolButton = class(TFrame)
    plMain: TPanel;
    ilDisable: TImage;
    ilMain: TImage;
    plCaption: TPanel;
    procedure ilMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ilMainMouseLeave(Sender: TObject);
    procedure ilMainMouseEnter(Sender: TObject);
    procedure ilMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    procedure SetEnable( IsEnable : Boolean );
    procedure SetSelected( IsSelect : Boolean );
  end;

implementation

{$R *.dfm}

procedure TFrameToolButton.ilMainMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  plMain.BevelOuter := bvLowered;
end;

procedure TFrameToolButton.ilMainMouseEnter(Sender: TObject);
begin
  plMain.BevelOuter := bvRaised;
end;

procedure TFrameToolButton.ilMainMouseLeave(Sender: TObject);
begin
  plMain.BevelOuter := bvNone;
end;

procedure TFrameToolButton.ilMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  plMain.BevelOuter := bvRaised;
end;

procedure TFrameToolButton.SetEnable(IsEnable: Boolean);
begin
  ilMain.Visible := IsEnable;
  plCaption.Enabled := IsEnable;

  ilDisable.Visible := not IsEnable;
end;

procedure TFrameToolButton.SetSelected(IsSelect: Boolean);
begin
  if IsSelect then
    plMain.BevelInner := bvRaised
  else
    plMain.BevelInner := bvNone;
end;

end.
