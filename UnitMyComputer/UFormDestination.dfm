object frmDestination: TfrmDestination
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #22797#21046#21040
  ClientHeight = 443
  ClientWidth = 665
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001000800680500001600000028000000100000002000
    0000010008000000000000010000000000000000000000010000000100000000
    00000066000014631F0016701600377224003D5763002D5971004C4C4C004A5D
    67005F737C006262620066666600686868006E6E6E00767C76007C7C7C000DA0
    19000FA41C000FA81C001DAA3B001BB4360022A53F002DA3440028C1500033CC
    65003ED7710040D973004BE47E0098806900DD984A00166385002C6F8E00297E
    9D0031739000117BA80051849B005497B300609FAC0070A4AF007DA3B70070AA
    BE0050E9830060F9930039A9C90056A9CC004EA8D2005CB9D60060A6C30066A9
    C60073A9C30070B3CF0070B7D60075B7D8007EBDD90046BCE90058B5E2005BCB
    F50079D9FF007AE0FF0086868600A1988D00A79A9000A89C94009FA6990084A5
    AC0089A2AF00CFB99900E5B5A700E4B8A700FFCC9900FFCF9E00FAD09800FFD1
    A300FFD2A500FFD4A800F9DEB30080BCD20086CCDF008EC9D90099D2D900A1D7
    D900BED1D6009FCFE200AFD2E200AFD9E90085EBFF008FF5FF0099FFFF00ACEC
    FF00B3E2F200B7F2FF00B9FFFF00FAE3CC00FFEBD700CAECF500C6FFFF00D6FF
    FF00D9F9FF00D9FFFF00FFF7EF00E1F9FC00E3FFFF00ECFFFF00F8F7F600FFF9
    F400F0FFFF00F9F9F900FEFEFE00000000000000000000000000000000000000
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
    0000000000000000000000000000000000000000000000000000FFFFFF000000
    000000000000040F0F0000000000000F0F0F0F0F0F0F0404073B00000000222C
    221E06080B0D041104073B000000225239383601010101141204073B00002233
    583A3A012A291A171412040B3B00222D615555012A291A18171410033B002237
    54565601010101191813020E3B002234305B57575757041B1504200D3B002235
    235E65615F5B041604604D053B00224E3D3F26284C6604045A69651F3B00224F
    3D464648422F0453596B6B323B0022503D48464A464844252B1F243100002251
    3D6B6B635D5C43402E410000000000223D6B6B6B68471D092700000000000000
    3D6B6B67674B1C0000000000000000003D3D3D3D3E3D0000000000000000FF1F
    0000800F00000007000000030000000100000001000000010000000100000001
    0000000100000001000000030000000F0000801F0000C07F0000C0FF0000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object plMain: TPanel
    Left = 0
    Top = 0
    Width = 665
    Height = 401
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object slMain: TSplitter
      Left = 233
      Top = 0
      Width = 5
      Height = 401
      ExplicitLeft = 209
      ExplicitHeight = 412
    end
    object plLeft: TPanel
      Left = 0
      Top = 0
      Width = 233
      Height = 401
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Splitter2: TSplitter
        Left = 0
        Top = 227
        Width = 233
        Height = 5
        Cursor = crVSplit
        Align = alBottom
        ExplicitLeft = -1
        ExplicitTop = -6
        ExplicitWidth = 185
      end
      object vstHistory: TVirtualStringTree
        Left = 0
        Top = 232
        Width = 233
        Height = 169
        Align = alBottom
        BorderWidth = 1
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
        TabOrder = 0
        TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnFocusChanged = vstHistoryFocusChanged
        OnGetText = vstHistoryGetText
        OnGetImageIndex = vstHistoryGetImageIndex
        OnMouseDown = vstHistoryMouseDown
        Columns = <
          item
            Position = 0
            Width = 127
            WideText = 'FileName'
          end
          item
            Position = 1
            Width = 100
            WideText = 'FolderPath'
          end>
      end
      object vstDriver: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 233
        Height = 227
        Align = alClient
        BorderWidth = 1
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
        TabOrder = 1
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnFocusChanged = vstDriverFocusChanged
        OnGetText = vstDriverGetText
        OnGetImageIndex = vstDriverGetImageIndex
        OnInitChildren = vstDriverInitChildren
        Columns = <
          item
            Position = 0
            Width = 227
            WideText = 'FileName'
          end>
      end
    end
    object plCenter: TPanel
      Left = 238
      Top = 0
      Width = 427
      Height = 401
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 427
        Height = 23
        Align = alTop
        BevelOuter = bvNone
        Padding.Top = 1
        Padding.Right = 2
        Padding.Bottom = 1
        TabOrder = 0
        object edtPath: TButtonedEdit
          Left = 0
          Top = 1
          Width = 425
          Height = 21
          Align = alClient
          Images = il16
          ImeName = #20013#25991' - QQ'#25340#38899#36755#20837#27861
          LeftButton.Enabled = False
          LeftButton.ImageIndex = 0
          LeftButton.Visible = True
          ReadOnly = True
          TabOrder = 0
        end
      end
      object vstFileList: TVirtualStringTree
        Left = 0
        Top = 23
        Width = 427
        Height = 378
        Align = alClient
        BorderWidth = 1
        CheckImageKind = ckXP
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
        TabOrder = 1
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnChecked = vstFileListChecked
        OnDblClick = vstFileListDblClick
        OnGetText = vstFileListGetText
        OnPaintText = vstFileListPaintText
        OnGetImageIndex = vstFileListGetImageIndex
        OnMouseDown = vstFileListMouseDown
        Columns = <
          item
            Position = 0
            Width = 281
            WideText = #25991#20214#21517
          end
          item
            Position = 1
            Width = 140
            WideText = #25805#20316
          end>
      end
    end
  end
  object plBottom: TPanel
    Left = 0
    Top = 401
    Width = 665
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object plButtonLeft: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 42
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
    end
    object plButtonCenter: TPanel
      Left = 185
      Top = 0
      Width = 236
      Height = 42
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object btnOK: TButton
        Left = 4
        Top = 9
        Width = 75
        Height = 25
        Caption = #30830#23450
        TabOrder = 0
        OnClick = btnOKClick
      end
      object btnCancel: TButton
        Left = 157
        Top = 9
        Width = 75
        Height = 25
        Cancel = True
        Caption = #21462#28040
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
  end
  object il16: TImageList
    Left = 104
    Top = 240
    Bitmap = {
      494C0101010008003C0010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000018799C001879
      9C0018799C0018799C0018799C0018799C0018799C0018799C0018799C001879
      9C0018799C0018799C0018799C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000188EB500188EB500188E
      B500188EB500188EB500188EB500188EB500188EB500188EB500188EB500188E
      B500188EB500188EB500188EB50018799C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319EBD0063CBFF00188EB5009CFF
      FF006BD7FF006BD7FF006BD7FF006BD7FF006BD7FF006BD7FF006BD7FF006BD7
      FF0039B2DE009CF3FF00188EB50018799C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319EBD0063CBFF00188EB5009CFF
      FF007BE3FF007BE3FF007BE3FF007BE3FF007BE3FF007BE3FF007BE3FF007BDF
      FF0042B2DE009CFFFF00188EB50018799C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319EBD0063CBFF00188EB5009CFF
      FF0084E7FF0084E7FF0084E7FF0084E7FF0084E7FF0084E7FF0084E7FF0084EB
      FF004AB6DE00A5F7FF00188EB50018799C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319EBD0063CBFF00188EB5009CFF
      FF0094FBFF0094FBFF0094FBFF0094FBFF0094FBFF0094FBFF0094FBFF008CF3
      FF0052BEE7009CFFFF00188EB50018799C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319EBD006BD7FF00188EB5009CFF
      FF009CFFFF009CFFFF009CFFFF00A5F7FF009CFFFF009CFFFF009CFFFF009CFF
      FF0063CBFF009CFFFF00188EB50018799C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319EBD007BDFFF00188EB5000000
      0000F7FBFF00F7FBFF00F7FBFF00F7FBFF00F7FBFF0000000000000000000000
      000084D7F700F7FBFF00188EB50018799C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319EBD0084EBFF0084E7FF00188E
      B500188EB500188EB500188EB500188EB500188EB500188EB500188EB500188E
      B500188EB500188EB500188EB500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319EBD009CF3FF008CF3FF008CF7
      FF008CF7FF008CF3FF008CF3FF00000000000000000000000000000000000000
      0000107DA5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319EBD00000000009CFFFF009CFF
      FF009CFFFF009CFFFF0000000000188EB500188EB500188EB500188EB500188E
      B500107DA5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000319EBD00000000000000
      000000000000F7FBFF00319EBD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000319EBD00319E
      BD00319EBD00319EBD0000000000000000000000000000000000000000000000
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
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000C001000000000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000010700000000000000001000000000000
      01F70000000000004207000000000000B9FF000000000000C3FF000000000000
      FFFF000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
end
