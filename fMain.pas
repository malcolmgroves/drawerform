unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Layouts,
  System.Actions, FMX.ActnList, FMX.Gestures;

type
  TfrmMain = class(TForm)
    lytDrawer: TLayout;
    lytMain: TLayout;
    ToolBar1: TToolBar;
    ActionList1: TActionList;
    actOpenDrawer: TAction;
    btnDrawer: TButton;
    GestureManager1: TGestureManager;
    procedure FormResize(Sender: TObject);
    procedure actOpenDrawerExecute(Sender: TObject);
    procedure actOpenDrawerUpdate(Sender: TObject);
  private
    FDrawerVisible: boolean;
    { Private declarations }
    function IsPad : boolean;
    function IsLandscape : boolean;
    procedure LayoutForm;
    procedure SetDrawerVisible(const Value: boolean);
  public
    { Public declarations }
    property DrawerVisible : boolean read FDrawerVisible write SetDrawerVisible;
  end;

var
  frmMain: TfrmMain;

implementation
uses
  {$IFDEF IOS}
  iOSapi.UIKit,
  {$ENDIF }
  {$IFDEF ANDROID}
  FMX.Platform.Android, Androidapi.JNI.GraphicsContentViewText,
  {$ENDIF }
  FMX.Platform;

{$R *.fmx}

procedure TfrmMain.actOpenDrawerExecute(Sender: TObject);
begin
  DrawerVisible := not DrawerVisible;
end;

procedure TfrmMain.actOpenDrawerUpdate(Sender: TObject);
begin
  actOpenDrawer.Visible := not (IsPad and IsLandscape);
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  LayoutForm;
end;

function TfrmMain.IsLandscape: boolean;
begin
  Result := self.Width > self.Height;
end;

function TfrmMain.IsPad: boolean;
begin
{$IFDEF IOS}
  Result := TUIDevice.Wrap(TUIDevice.OCClass.currentDevice).userInterfaceIdiom = UIUserInterfaceIdiomPad;
{$ENDIF}
{$IFDEF ANDROID}
  Result := (MainActivity.getResources.getConfiguration.screenLayout and TJConfiguration.JavaClass.SCREENLAYOUT_SIZE_MASK)
    >= TJConfiguration.JavaClass.SCREENLAYOUT_SIZE_LARGE;
{$ENDIF}
end;

procedure TfrmMain.LayoutForm;
begin
  lytMain.Height := self.Height;
  lytDrawer.Height := self.Height;

  if IsPad and IsLandscape then
  begin
    lytDrawer.Align := TAlignLayout.alLeft;
    lytMain.Align := TAlignLayout.alClient;
  end
  else
  begin
    lytDrawer.Align := TAlignLayout.alNone;
    lytMain.Align := TAlignLayout.alNone;
    lytMain.Width := self.Width;

    if DrawerVisible then
      lytMain.Position.X := lytDrawer.Position.X + lytDrawer.Width
    else
      lytMain.Position.X := 0;
  end;
end;

procedure TfrmMain.SetDrawerVisible(const Value: boolean);
begin
  if FDrawerVisible <> Value then
  begin
    FDrawerVisible := Value;
    if DrawerVisible then
      lytMain.AnimateFloat('Position.X', lytDrawer.Position.X + lytDrawer.Width)
    else
      lytMain.AnimateFloat('Position.X', 0);
  end;
end;

end.
