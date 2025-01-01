//
//  MandalartPaletteBundle.swift
//  Home
//
//  Created by choijunios on 1/1/25.
//

enum MandalartPaletteBundle: String {
    
    case type1
    case type2
    case type3
    case type4
    case type5
    case type6
    case type7
    case type8
    case type9
    case type10
    case type11
    case type12
    
    var palette: MandalartPalette {
        switch self {
        case .type1:
            return MandalartPalette(
                backgroundColor: ColorSet(primaryHex: "#cb997e", secondHex: "#ddbea9"),
                textColor: ColorSet(primaryHex: "#ffe8d6", secondHex: "#b7b7a4"),
                gageColor: ColorSet(primaryHex: "#a5a58d", secondHex: "#6b705c")
            )
        case .type2:
            return MandalartPalette(
                backgroundColor: ColorSet(primaryHex: "#f47068", secondHex: "#ffb3ae"),
                textColor: ColorSet(primaryHex: "#fff4f1", secondHex: "#1697a6"),
                gageColor: ColorSet(primaryHex: "#0e606b", secondHex: "#ffc24b")
            )
        case .type3:
            return MandalartPalette(
                backgroundColor: ColorSet(primaryHex: "#ef476f", secondHex: "#f78c6b"),
                textColor: ColorSet(primaryHex: "#ffd166", secondHex: "#06d6a0"),
                gageColor: ColorSet(primaryHex: "#118ab2", secondHex: "#073b4c")
            )
        case .type4:
            return MandalartPalette(
                backgroundColor: ColorSet(primaryHex: "#797d62", secondHex: "#9b9b7a"),
                textColor: ColorSet(primaryHex: "#d9ae94", secondHex: "#f1dca7"),
                gageColor: ColorSet(primaryHex: "#d08c60", secondHex: "#997b66")
            )
        case .type5:
            return MandalartPalette(
                backgroundColor: ColorSet(primaryHex: "#ff5883", secondHex: "#ff91ad"),
                textColor: ColorSet(primaryHex: "#fec9d7", secondHex: "#b9eee1"),
                gageColor: ColorSet(primaryHex: "#79d3be", secondHex: "#39b89a")
            )
        case .type6:
            return MandalartPalette(
                backgroundColor: ColorSet(primaryHex: "#fd5901", secondHex: "#f78104"),
                textColor: ColorSet(primaryHex: "#faab36", secondHex: "#249ea0"),
                gageColor: ColorSet(primaryHex: "#008083", secondHex: "#005f60")
            )
        case .type7:
            return MandalartPalette(
                backgroundColor: ColorSet(primaryHex: "#9f8be8", secondHex: "#af99ff"),
                textColor: ColorSet(primaryHex: "#caadff", secondHex: "#ffc2e2"),
                gageColor: ColorSet(primaryHex: "#ffadc7", secondHex: "#ff99b6")
            )
        case .type8:
            return MandalartPalette(
                backgroundColor: ColorSet(primaryHex: "#264653", secondHex: "#287271"),
                textColor: ColorSet(primaryHex: "#2a9d8f", secondHex: "#e9c46a"),
                gageColor: ColorSet(primaryHex: "#f4a261", secondHex: "#e76f51")
            )
        case .type9:
            return MandalartPalette(
                backgroundColor: ColorSet(primaryHex: "#ff99c8", secondHex: "#fec8c3"),
                textColor: ColorSet(primaryHex: "#fcf6bd", secondHex: "#d0f4de"),
                gageColor: ColorSet(primaryHex: "#a9def9", secondHex: "#e4c1f9")
            )
        case .type10:
            return MandalartPalette(
                backgroundColor: ColorSet(primaryHex: "#e6e5e0", secondHex: "#230462"),
                textColor: ColorSet(primaryHex: "#203590", secondHex: "#6083c5"),
                gageColor: ColorSet(primaryHex: "#96b8db", secondHex: "#c5dbf0")
            )
        case .type11:
            return MandalartPalette(
                backgroundColor: ColorSet(primaryHex: "#8ecae6", secondHex: "#219ebc"),
                textColor: ColorSet(primaryHex: "#126782", secondHex: "#023047"),
                gageColor: ColorSet(primaryHex: "#ffb703", secondHex: "#fb8500")
            )
        case .type12:
            return MandalartPalette(
                backgroundColor: ColorSet(primaryHex: "#5a77d8", secondHex: "#81b1fb"),
                textColor: ColorSet(primaryHex: "#c3dbfd", secondHex: "#ff5db6"),
                gageColor: ColorSet(primaryHex: "#fe86c8", secondHex: "#ffc0db")
            )
        }
    }
}
