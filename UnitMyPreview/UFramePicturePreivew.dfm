object FramePicturePreview: TFramePicturePreview
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  object plOtherPic: TPanel
    Left = 0
    Top = 244
    Width = 451
    Height = 60
    Align = alBottom
    BevelEdges = [beTop]
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 0
    object Button1: TButton
      Left = 40
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object plPicPreivew: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 244
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object imgPreview: TImage
      Left = 0
      Top = 0
      Width = 326
      Height = 244
      Align = alClient
      ExplicitLeft = 144
      ExplicitTop = 88
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
    object spRightPicture: TSplitter
      Left = 326
      Top = 0
      Width = 5
      Height = 244
      Align = alRight
      Visible = False
      ExplicitLeft = 333
    end
    object plRighttPicture: TPanel
      Left = 331
      Top = 0
      Width = 120
      Height = 244
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      Visible = False
      object vstPicture: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 120
        Height = 244
        Align = alClient
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
        TabOrder = 0
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnFocusChanged = vstPictureFocusChanged
        OnGetText = vstPictureGetText
        OnGetImageIndex = vstPictureGetImageIndex
        Columns = <
          item
            Position = 0
            Width = 116
            WideText = 'FileName'
          end>
      end
    end
  end
end
