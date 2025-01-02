//
//  MandalartPalette.swift
//  SharedDesignSystem
//
//  Created by choijunios on 1/1/25.
//

public enum MandalartPalette: String, CaseIterable {
    
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
    case type13
    case type14
    case type15
    case type16
    
    private var index: Int {
        switch self {
        case .type1:
            0
        case .type2:
            1
        case .type3:
            2
        case .type4:
            3
        case .type5:
            4
        case .type6:
            5
        case .type7:
            6
        case .type8:
            7
        case .type9:
            8
        case .type10:
            9
        case .type11:
            10
        case .type12:
            11
        case .type13:
            12
        case .type14:
            13
        case .type15:
            14
        case .type16:
            15
        }
    }
    
    public static var orderedList: [Self] {
        
        Self.allCases.sorted(by: { $0.index < $1.index })
    }
    
    public var identifier: String { self.rawValue }
    
    public init(identifier: String) {
     
        self = .init(rawValue: identifier)!
    }
    
    public var colors: MandalartColors {
        switch self {
        case .type1:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#e0aaff", secondHex: "#c77dff"),
                textColor: ColorSet(primaryHex: "#240046", secondHex: "#3c096c"),
                gageColor: ColorSet(primaryHex: "#9d4edd", secondHex: "#10002b")
            )
        case .type2:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#9ef01a", secondHex: "#70e000"),
                textColor: ColorSet(primaryHex: "#006400", secondHex: "#007200"),
                gageColor: ColorSet(primaryHex: "#38b000", secondHex: "#004b23")
            )
        case .type3:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#06dfc8", secondHex: "#0bbfbc"),
                textColor: ColorSet(primaryHex: "#213f8b", secondHex: "#1c5f97"),
                gageColor: ColorSet(primaryHex: "#00ffd4", secondHex: "#167fa3")
            )
        case .type4:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#cbe5f6", secondHex: "#97caed"),
                textColor: ColorSet(primaryHex: "#185d8b", secondHex: "#2280bf"),
                gageColor: ColorSet(primaryHex: "#eef6fc", secondHex: "#185d8b")
            )
        case .type5:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#eaac8b", secondHex: "#e88c7d"),
                textColor: ColorSet(primaryHex: "#355070", secondHex: "#515575"),
                gageColor: ColorSet(primaryHex: "#e56b6f", secondHex: "#515575")
            )
        case .type6:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#fe6d73", secondHex: "#e60707"),
                textColor: ColorSet(primaryHex: "#000000", secondHex: "#2c0000"),
                gageColor: ColorSet(primaryHex: "#feb3b1", secondHex: "#2c0000")
            )
        case .type7:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#345053", secondHex: "#51696c"),
                textColor: ColorSet(primaryHex: "#e2e6e6", secondHex: "#c5cdce"),
                gageColor: ColorSet(primaryHex: "#ffffff", secondHex: "#8b9b9d")
            )
        case .type8:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#ffac7f", secondHex: "#ffb78f"),
                textColor: ColorSet(primaryHex: "#fff7f2", secondHex: "#ffece2"),
                gageColor: ColorSet(primaryHex: "#ffe2d1", secondHex: "#ffc1a0")
            )
        case .type9:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#c7ffff", secondHex: "#a8f8f8"),
                textColor: ColorSet(primaryHex: "#7400b8", secondHex: "#934add"),
                gageColor: ColorSet(primaryHex: "#a3cdf1", secondHex: "#9876e4")
            )
        case .type10:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#e9e9e9", secondHex: "#c8c8c8"),
                textColor: ColorSet(primaryHex: "#000000", secondHex: "#212121"),
                gageColor: ColorSet(primaryHex: "#a6a6a6", secondHex: "#434343")
            )
        case .type11:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#efd2c7", secondHex: "#e5c1b1"),
                textColor: ColorSet(primaryHex: "#4c210e", secondHex: "#945d3c"),
                gageColor: ColorSet(primaryHex: "#e6bca3", secondHex: "#9d6441")
            )
        case .type12:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#3c096c", secondHex: "#5a189a"),
                textColor: ColorSet(primaryHex: "#ff6d00", secondHex: "#ff7900"),
                gageColor: ColorSet(primaryHex: "#ff9e00", secondHex: "#9d4edd")
            )
        case .type13:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#f9d94e", secondHex: "#eb8258"),
                textColor: ColorSet(primaryHex: "#2d3047", secondHex: "#661fff"),
                gageColor: ColorSet(primaryHex: "#eb5c68", secondHex: "#03b5aa")
            )
        case .type14:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#64574f", secondHex: "#746253"),
                textColor: ColorSet(primaryHex: "#fcd8a4", secondHex: "#eabc8b"),
                gageColor: ColorSet(primaryHex: "#d6a978", secondHex: "#9f8064")
            )
        case .type15:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#fff7f2", secondHex: "#ffece2"),
                textColor: ColorSet(primaryHex: "#ffac7f", secondHex: "#ffb78f"),
                gageColor: ColorSet(primaryHex: "#ffe2d1", secondHex: "#ffc1a0")
            )
        case .type16:
            return MandalartColors(
                backgroundColor: ColorSet(primaryHex: "#d2d2cf", secondHex: "#e5e6e4"),
                textColor: ColorSet(primaryHex: "#f6f4ea", secondHex: "#f5f5f4"),
                gageColor: ColorSet(primaryHex: "#797c77", secondHex: "#e5e6e4")
            )
        }
    }
}
