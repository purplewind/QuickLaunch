object FrameMyRun: TFrameMyRun
  Left = 0
  Top = 0
  Width = 597
  Height = 304
  Align = alClient
  TabOrder = 0
  ExplicitWidth = 451
  object Splitter1: TSplitter
    Left = 465
    Top = 0
    Width = 5
    Height = 269
    OnMoved = Splitter1Moved
    ExplicitLeft = 281
    ExplicitHeight = 361
  end
  object plLeft: TPanel
    Left = 0
    Top = 0
    Width = 465
    Height = 269
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object lvApps: TRzListView
      Left = 0
      Top = 35
      Width = 465
      Height = 234
      Align = alClient
      Columns = <
        item
          Caption = #25991#20214#21517
          Width = 150
        end
        item
          AutoSize = True
          Caption = #25991#20214#36335#24452
        end>
      TabOrder = 0
      OnItemChecked = lvAppsItemChecked
      OnDeletion = lvAppsDeletion
      OnDragDrop = lvAppsDragDrop
      OnDragOver = lvAppsDragOver
      OnMouseDown = lvAppsMouseDown
      OnMouseMove = lvAppsMouseMove
      ExplicitLeft = -1
      ExplicitTop = 33
    end
    object plAllRemove: TPanel
      Left = 0
      Top = 0
      Width = 465
      Height = 35
      Align = alTop
      BevelOuter = bvNone
      Color = clInfoBk
      ParentBackground = False
      TabOrder = 1
      Visible = False
      object plAllLeft: TPanel
        Left = 0
        Top = 0
        Width = 58
        Height = 35
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
      end
      object plAllCenter: TPanel
        Left = 58
        Top = 0
        Width = 185
        Height = 35
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object btnRemoveApp: TButton
          Left = 5
          Top = 6
          Width = 75
          Height = 25
          Caption = #21024#38500
          TabOrder = 0
          OnClick = btnRemoveAppClick
        end
        object btnCancelApp: TButton
          Left = 110
          Top = 6
          Width = 75
          Height = 25
          Caption = #21462#28040
          TabOrder = 1
          OnClick = btnCancelAppClick
        end
      end
    end
  end
  object plCenter: TPanel
    Left = 470
    Top = 0
    Width = 127
    Height = 269
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 332
    object Splitter2: TSplitter
      Left = 0
      Top = 129
      Width = 127
      Height = 5
      Cursor = crVSplit
      Align = alTop
      ExplicitTop = 145
      ExplicitWidth = 268
    end
    object slBat: TSplitter
      Left = 0
      Top = 147
      Width = 127
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      Visible = False
      ExplicitTop = 195
      ExplicitWidth = 361
    end
    object plFile: TPanel
      Left = 0
      Top = 0
      Width = 127
      Height = 129
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 332
      object vstFile: TVirtualStringTree
        Left = 0
        Top = 35
        Width = 127
        Height = 94
        Align = alClient
        Header.AutoSizeIndex = 1
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
        TabOrder = 0
        OnChecked = vstFileChecked
        OnGetText = vstFileGetText
        OnGetImageIndex = vstFileGetImageIndex
        OnMouseDown = vstFileMouseDown
        OnMouseMove = vstFileMouseMove
        ExplicitWidth = 332
        Columns = <
          item
            Position = 0
            Width = 180
            WideText = 'FileName'
          end
          item
            Position = 1
            Width = 10
            WideText = 'FileDir'
          end>
      end
      object plFileRemove: TPanel
        Left = 0
        Top = 0
        Width = 127
        Height = 35
        Align = alTop
        BevelOuter = bvNone
        Color = clInfoBk
        ParentBackground = False
        TabOrder = 1
        Visible = False
        ExplicitWidth = 332
        object plFileRemoveLeft: TPanel
          Left = 0
          Top = 0
          Width = 58
          Height = 35
          Align = alLeft
          BevelOuter = bvNone
          Caption = '`'
          TabOrder = 0
        end
        object plFileRemoveCenter: TPanel
          Left = 58
          Top = 0
          Width = 185
          Height = 35
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          object btnFileRemove: TButton
            Left = 5
            Top = 6
            Width = 75
            Height = 25
            Caption = #21024#38500
            TabOrder = 0
            OnClick = btnFileRemoveClick
          end
          object btnFileCancel: TButton
            Left = 110
            Top = 6
            Width = 75
            Height = 25
            Caption = #21462#28040
            TabOrder = 1
            OnClick = btnFileCancelClick
          end
        end
      end
    end
    object plFolder: TPanel
      Left = 0
      Top = 134
      Width = 127
      Height = 13
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 332
      object vstFolder: TVirtualStringTree
        Left = 0
        Top = 35
        Width = 127
        Height = 70
        Align = alClient
        Header.AutoSizeIndex = 1
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
        TabOrder = 0
        OnChecked = vstFolderChecked
        OnGetText = vstFolderGetText
        OnGetImageIndex = vstFolderGetImageIndex
        OnMouseDown = vstFolderMouseDown
        OnMouseMove = vstFolderMouseMove
        ExplicitWidth = 332
        Columns = <
          item
            Position = 0
            Width = 180
            WideText = 'FolderName'
          end
          item
            Position = 1
            Width = 10
            WideText = 'FolderDir'
          end>
      end
      object plFolderRemove: TPanel
        Left = 0
        Top = 0
        Width = 127
        Height = 35
        Align = alTop
        BevelOuter = bvNone
        Color = clInfoBk
        ParentBackground = False
        TabOrder = 1
        Visible = False
        ExplicitWidth = 332
        object plFolderRemoveLeft: TPanel
          Left = 0
          Top = 0
          Width = 58
          Height = 35
          Align = alLeft
          BevelOuter = bvNone
          Caption = '`'
          TabOrder = 0
        end
        object plFolderRemoveCenter: TPanel
          Left = 58
          Top = 0
          Width = 185
          Height = 35
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          object btnFolderRemove: TButton
            Left = 5
            Top = 6
            Width = 75
            Height = 25
            Caption = #21024#38500
            TabOrder = 0
            OnClick = btnFolderRemoveClick
          end
          object btnFolderRemoveCancel: TButton
            Left = 110
            Top = 6
            Width = 75
            Height = 25
            Caption = #21462#28040
            TabOrder = 1
            OnClick = btnFolderRemoveCancelClick
          end
        end
      end
    end
    object plBat: TPanel
      Left = 0
      Top = 152
      Width = 127
      Height = 117
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      ExplicitWidth = 332
      object vstBat: TVirtualStringTree
        Left = 0
        Top = 35
        Width = 127
        Height = 82
        Align = alClient
        Header.AutoSizeIndex = 4
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
        TabOrder = 0
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnChecked = vstBatChecked
        OnGetText = vstBatGetText
        OnGetImageIndex = vstBatGetImageIndex
        OnMouseDown = vstBatMouseDown
        OnMouseMove = vstBatMouseMove
        ExplicitWidth = 332
        Columns = <
          item
            Position = 0
            Width = 80
            WideText = 'Path1'
          end
          item
            Position = 1
            Width = 80
            WideText = 'Path2'
          end
          item
            Position = 2
            Width = 80
            WideText = 'Path3'
          end
          item
            Position = 3
            Width = 80
            WideText = 'Path4'
          end
          item
            Position = 4
            Width = 10
            WideText = 'Path5'
          end>
      end
      object plRemoveBat: TPanel
        Left = 0
        Top = 0
        Width = 127
        Height = 35
        Align = alTop
        BevelOuter = bvNone
        Color = clInfoBk
        ParentBackground = False
        TabOrder = 1
        Visible = False
        ExplicitWidth = 332
        object plRemoveBatLeft: TPanel
          Left = 0
          Top = 0
          Width = 58
          Height = 35
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
        end
        object plRemoveBatCenter: TPanel
          Left = 58
          Top = 0
          Width = 185
          Height = 35
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          object btnRemoveBat: TButton
            Left = 5
            Top = 6
            Width = 75
            Height = 25
            Caption = #21024#38500
            TabOrder = 0
            OnClick = btnRemoveBatClick
          end
          object btnRemoveBatCancel: TButton
            Left = 110
            Top = 6
            Width = 75
            Height = 25
            Caption = #21462#28040
            TabOrder = 1
            OnClick = btnRemoveBatCancelClick
          end
        end
      end
    end
  end
  object plInformation: TPanel
    Left = 0
    Top = 269
    Width = 597
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    Color = clInfoBk
    ParentBackground = False
    TabOrder = 2
    ExplicitWidth = 451
    object plDropHit: TPanel
      Left = 438
      Top = 0
      Width = 160
      Height = 35
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Image1: TImage
        Left = 8
        Top = 4
        Width = 24
        Height = 24
        Picture.Data = {
          055449636F6E0000010001001818000001000800C80600001600000028000000
          1800000030000000010008000000000040020000000000000000000000010000
          0001000000000000565656005E5E5E00626262006D6D6D00727272007D7D7D00
          FF7200009A817F00858585008E8E8E00999999009C9C9C00E2E2E200F0F0F000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          FFFFFF0000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0602030500000402020400000000000000000000000000000C09090401020405
          090C00000000000000000000000000000000000C040309000000000000000000
          0000000000000000000000000402000000000000000000000000000000000000
          0000000004020000000000000808080808080808080808080808080604010608
          0808000008FFFFFFFFFFFFFFFFFFFFFFFFFFFF0D05040EFFFF08000008FF0707
          07070707070707070707FF0D05030EFFFF08000008FF07070707070707070707
          0707FF0D05040EFFFF08000008FF070707070707070707070707FF0D05040EFF
          FF08000008FF070707070707070707070707FF0D05030EFFFF08000008FF0707
          07070707070707070707FF0E04040EFFFF08000008FF07070707070707070707
          0707FF0D05030EFFFF08000008FFFFFFFFFFFFFFFFFFFFFFFFFFFF0D05030EFF
          FF08000008080808080808080808080808080809040206080808000000000000
          0000000000000000000000000401000000000000000000000000000000000000
          0000000604030300000000000000000000000000000000000A03020304090402
          030500000000000000000000000000000A06090A00000C090609000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000FFFFFF00FFFFFF00FFF0C300FFF00300FFFE1F00FFFF3F00FFFF3F00
          0000030000000300000003000000030000000300000003000000030000000300
          0000030000000300FFFF3F00FFFE1F00FFF00300FFF0C300FFFFFF00FFFFFF00
          FFFFFF00}
      end
      object lbInput: TLinkLabel
        Left = 40
        Top = 9
        Width = 76
        Height = 17
        Caption = '<a>'#36755#20837#25991#20214#36335#24452'</a>'
        TabOrder = 0
        OnLinkClick = lbInputLinkClick
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 266
      Height = 35
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object Image2: TImage
        Left = 8
        Top = 4
        Width = 24
        Height = 24
        Picture.Data = {
          055449636F6E0000010001001818000001000800C80600001600000028000000
          1800000030000000010008000000000040020000000000000000000000010000
          000100000000000053454200524947005A4E4D0064575500655856006C636200
          72676500766E6C007D74720081797700817F7E00887F7E00FFA6290082807F00
          8A817F009C827300FFB65A0018799C00107DA5007A7A84001092BD00218AAD00
          2196BD0042A6BD00219EC60031A2C60052BADE0063CBFF006BD3FF007BDFFF00
          838383008D8482008D868500948C8B0098908E00909090009E979600A49D9C00
          9FAABE00A5A5A500AAA3A200A9A9A900B4AEAD00B7B8B800CEB69C00C1BDBD00
          C3C0BF00D6D3BD00FFD7AD00FFDBB5008EAFDD00B4BAC50098B8E30084E7FF00
          8CF7FF0094F7FF009CF3FF009CFBFF00A5E7FF00C1C1C100CCC7C700C0C7CF00
          CBCCCC00D1D0CF00D1D1D100D9D7D700DAD9D900FFE7CE00FFE7D600FFEBDE00
          D6E1F100E1E1E100E7E8E800EDEDED00FFF7E700FFF7EF00E4EAF100F5F5F500
          FFFBF700F7FFFF00F9F9F900FFFBFF0000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          FFFFFF0000000000000000000000000E0E0E0E0B0B0B0E000000000000000000
          00000000000000030C0B0C0B0A0A021F00000000000000000000000000004001
          484343424040032A3C00000000000000000000000000222F4A48484343430822
          3C000000000000000000000000400B424A4A4848484328082C41000000000000
          000000000025264E4A4A4A4A48482E062A410000000000000000000048074851
          514E4E4A4A4A430B253F0000000000000000004A252B2E4351514E4E4A4A490F
          243F0000000000000000002C294E233D5151514E4E4E4A202540000000000000
          001212232629033D4E48514251044E222A0000000000000016131A3D222C0F3D
          3D25510551043F233F0000000000001A1C153A1B1B1B233D3D2351054E032040
          000000000000001A1C1739303030233D3D092C07082E1200000000000000001A
          1C1739304646253D3D022041301A1200000000000000001A1C1A3A304646223D
          3D093E35301A1200000000000000001A1D1A3A304631253F3F14334D301A1200
          000000000000001A1E1A52455252342928274752451A1200000000000000001A
          361A18102D2D2D2D2D2D2D2D101A0000000000000000001A38373810464B4B4B
          4B4B4B4B10000000000000000000001A523A3A104B3232323232324C10000000
          00000000000000001A5252104F4F4F4F4F4F4444100000000000000000000000
          001A1A105032323232520D0D0D0000000000000000000000000000104C4F4F4F
          4F4F111100000000000000000000000000000010101010101010110000000000
          00000000FFE01F00FFE00F00FFC00700FFC00700FF800300FF800300FF000300
          FE000300FE000300F8000700F0000700E0000F00E0001F00E0001F00E0001F00
          E0001F00E0001F00E0003F00E0007F00E0007F00F0007F00F8007F00FE00FF00
          FE01FF00}
      end
      object lbDragdrop: TLabel
        Left = 38
        Top = 9
        Width = 180
        Height = 13
        Caption = #25226#38656#35201#24555#36895#36816#34892#30340#25991#20214#25302#21160#21040#36825#37324
      end
    end
    object Panel2: TPanel
      Left = 266
      Top = 0
      Width = 172
      Height = 35
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 2
      object Image3: TImage
        Left = 8
        Top = 4
        Width = 24
        Height = 24
        Picture.Data = {
          055449636F6E0000010001001818000001000800C80600001600000028000000
          1800000030000000010008000000000040020000000000000000000000010000
          0001000000000000534A470056504F005A5857005B5959006F5A54006D656200
          BB7E0D00AE711900976C2F00B77C2700D9642300D9662600D8662800D4692F00
          DE712F00D96D3100DD6F3000D9703200D9703600DB743500D5713A00DB723900
          DD793900E0763400E37C3B008065550081675800B06C5500B3715B00846F6000
          8571610084736F0081797600B6786200B87B6700B87C6700BA7F6B00D4764600
          DC764000DE794200D8794600DE7F4C0021B16500BF891300BF832F00D6980800
          E5A70100ECA10A00C1832900CD8D3400E4803F00BC824100BD854A00BD847000
          BF887500A7907E00DA804F00DF835100DC855600DC865900E5824100E8884700
          E3874800E58C4D00EA8D4D00EB904F00E0875800E0885A00E08A5C00E6915200
          EC925100EF985700F09A5A00F19E5D00C18C7A00C4917F00D59C7200D99F7400
          E38F6200E5926200E59A6B00F2A06000F4A56500F5A96900E5A27F00002FE100
          42D4FF00A5948B00B9A79800BCAC9E00B9AEA000BDB4A600C5928100C7988700
          CA9D8D00CC9F9000CDA29300D1A99C00D4AEA200C4B4A600C6B7AA00C4B9AB00
          CABCAF00D6B3A700D9B9AD00C9BBB000CCBCB100DCBEB300CBC0B400D2C7BD00
          DFC3B900E1C7BF00D6CCC100D9CFC600D9D0C800DCD3C900E4CCC400E6D0C900
          E8D5CE00E1D9D100EBD9D300E7E0D700EFE1DC00EBE5E100EDE8E400F3E8E500
          F1EEEC00F7EFED00FAF6F400FBF8F700FDFBFA00000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          FFFFFF0000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000006B6464656E787D7F7D78726D6566666666655C5C
          5C5C5C00670521092E2F2C0601010102020202020302040402835C006D20580A
          305707381A1B1B1B1B1B1F1E1E1F1F1F1F825C006E61552D562B085118193D3E
          414747494952525454815C006E613B353231343D1419333D4141474949525454
          54815C0072610E4F4D4E50111819193D3E41474749525252547F64007261150D
          11110C110F18193D3D41474749495254547F6500746129110D0D0C110F181933
          3E414147494A5252547E6400746139160D0C0C0C0F1818193D3E414747494A52
          527E6400785F3B29100C0C0C0F0F18193D3E4142474A4A52527B6600785F3C3B
          16140C0B100F1819193E3E4147484952527B6400785E3C433914100B100F1819
          193D3E4147474A4A52795C007A5D3C44432A100F0C0F0F18193D3D4147474A4A
          52776400784C3B43433928140F100F1819333E414147484952765C007B253B43
          44444327140F111818193D3E4147474A4A755A007A24263C3C443B2A16161414
          1417193D3F40464749705A007B1C1C1D1D22242436374B4C5D5F606162636869
          6C6F5A007B7A7A787B7878787474717174787C7F7F7A746B5B595C0000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000FFFFFF00FFFFFF00FFFFFF0000000100000001000000010000000100
          0000010000000100000001000000010000000100000001000000010000000100
          000001000000010000000100000001000000010000000100FFFFFF00FFFFFF00
          FFFFFF00}
      end
      object lbImport: TLinkLabel
        Left = 40
        Top = 9
        Width = 88
        Height = 17
        Caption = '<a>'#20174#26700#38754#23548#20837#25991#20214'</a>'
        TabOrder = 0
        OnLinkClick = LinkLabel1LinkClick
      end
    end
    object Panel3: TPanel
      Left = 598
      Top = 0
      Width = 185
      Height = 35
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 3
      object ChkHideForm: TCheckBox
        Left = 7
        Top = 8
        Width = 146
        Height = 17
        Caption = #19968#38190#36816#34892#21518#38544#34255#20027#31383#21475
        TabOrder = 0
      end
    end
  end
  object tmrFolderSelect: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrFolderSelectTimer
    Left = 128
    Top = 104
  end
  object tmrFileSelect: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrFileSelectTimer
    Left = 48
    Top = 104
  end
  object tmrBatCreate: TTimer
    Enabled = False
    Interval = 8000
    OnTimer = tmrBatCreateTimer
    Left = 40
    Top = 176
  end
  object tmrBatSelect: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrBatSelectTimer
    Left = 128
    Top = 184
  end
end
