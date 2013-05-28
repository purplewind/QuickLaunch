object FrameChildPicture: TFrameChildPicture
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  Align = alTop
  TabOrder = 0
  object plPicture: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    BevelOuter = bvNone
    BevelWidth = 2
    Padding.Left = 2
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    TabOrder = 0
    object imgPreview: TImage
      Left = 2
      Top = 2
      Width = 316
      Height = 236
      Align = alClient
      ExplicitLeft = 6
      ExplicitTop = 0
      ExplicitWidth = 314
      ExplicitHeight = 234
    end
  end
end
