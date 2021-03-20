//        north
//      ihgfedcba
//      000000000 1
//      000000000 2
//      000000000 3
//      000000000 4
// west 000000000 5 east
//      000000000 6
//      000000000 7
//      000000000 8
//      000000000 9
//        south
// linear coordinateでは左上を原点として水平を優先する。すなわちi1が0、a1が8、i2が9、...a9が80。

public enum File: Int, CaseIterable { // rawValueは左オリジンにする
    case i = 0
    case h
    case g
    case f
    case e
    case d
    case c
    case b
    case a
}

public enum Rank: Int, CaseIterable {
    case one = 0
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
}

public enum Square: Int, CaseIterable {
    case i1 = 0, h1, g1, f1, e1, d1, c1, b1, a1
    case i2, h2, g2, f2, e2, d2, c2, b2, a2
    case i3, h3, g3, f3, e3, d3, c3, b3, a3
    case i4, h4, g4, f4, e4, d4, c4, b4, a4
    case i5, h5, g5, f5, e5, d5, c5, b5, a5
    case i6, h6, g6, f6, e6, d6, c6, b6, a6
    case i7, h7, g7, f7, e7, d7, c7, b7, a7
    case i8, h8, g8, f8, e8, d8, c8, b8, a8
    case i9, h9, g9, f9, e9, d9, c9, b9, a9
}

extension Square {
    public init(file: File, rank: Rank) {
        self.init(rawValue: rank.rawValue * File.allCases.count + file.rawValue)!
    }

    public var file: File { File(rawValue: rawValue % File.allCases.count)! }
    public var rank: Rank { Rank(rawValue: rawValue / File.allCases.count)! }
    public var isOn1: Bool { rawValue < File.allCases.count }
    public var isOn9: Bool { rawValue >= Square.allCases.count - File.allCases.count }
    public var isOn1Or2: Bool { rawValue < File.allCases.count * 2 }
    public var isOn8Or9: Bool { rawValue >= Square.allCases.count - File.allCases.count * 2 }

    public static func cases(at file: File) -> [Self] {
        switch file {
        case .i:
            return [.i1, .i2, .i3, .i4, .i5, .i6, .i7, .i8, .i9]
        case .h:
            return [.h1, .h2, .h3, .h4, .h5, .h6, .h7, .h8, .h9]
        case .g:
            return [.g1, .g2, .g3, .g4, .g5, .g6, .g7, .g8, .g9]
        case .f:
            return [.f1, .f2, .f3, .f4, .f5, .f6, .f7, .f8, .f9]
        case .e:
            return [.e1, .e2, .e3, .e4, .e5, .e6, .e7, .e8, .e9]
        case .d:
            return [.d1, .d2, .d3, .d4, .d5, .d6, .d7, .d8, .d9]
        case .c:
            return [.c1, .c2, .c3, .c4, .c5, .c6, .c7, .c8, .c9]
        case .b:
            return [.b1, .b2, .b3, .b4, .b5, .b6, .b7, .b8, .b9]
        case .a:
            return [.a1, .a2, .a3, .a4, .a5, .a6, .a7, .a8, .a9]
        }
    }
    public static func cases(at rank: Rank) -> [Self] {
        switch rank {
        case .one:
            return [.i1, .h1, .g1, .f1, .e1, .d1, .c1, .b1, .a1]
        case .two:
            return [.i2, .h2, .g2, .f2, .e2, .d2, .c2, .b2, .a2]
        case .three:
            return [.i3, .h3, .g3, .f3, .e3, .d3, .c3, .b3, .a3]
        case .four:
            return [.i4, .h4, .g4, .f4, .e4, .d4, .c4, .b4, .a4]
        case .five:
            return [.i5, .h5, .g5, .f5, .e5, .d5, .c5, .b5, .a5]
        case .six:
            return [.i6, .h6, .g6, .f6, .e6, .d6, .c6, .b6, .a6]
        case .seven:
            return [.i7, .h7, .g7, .f7, .e7, .d7, .c7, .b7, .a7]
        case .eight:
            return [.i8, .h8, .g8, .f8, .e8, .d8, .c8, .b8, .a8]
        case .nine:
            return [.i9, .h9, .g9, .f9, .e9, .d9, .c9, .b9, .a9]
        }
    }

    public static func promotableCases(for color: Color) -> [Self] {
        switch color {
        case .black:
            return [
                .i1, .h1, .g1, .f1, .e1, .d1, .c1, .b1, .a1,
                .i2, .h2, .g2, .f2, .e2, .d2, .c2, .b2, .a2,
                .i3, .h3, .g3, .f3, .e3, .d3, .c3, .b3, .a3,
            ]
        case .white:
            return [
                .i7, .h7, .g7, .f7, .e7, .d7, .c7, .b7, .a7,
                .i8, .h8, .g8, .f8, .e8, .d8, .c8, .b8, .a8,
                .i9, .h9, .g9, .f9, .e9, .d9, .c9, .b9, .a9,
            ]
        }
    }

}
