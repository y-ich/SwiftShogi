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
public enum File: Int, CaseIterable {
    case a
    case b
    case c
    case d
    case e
    case f
    case g
    case h
    case i
}

public enum Rank: Int, CaseIterable {
    case one
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
    // 将棋盤は右上が原点なので、以下は左右反転させて見る
    case a1, b1, c1, d1, e1, f1, g1, h1, i1
    case a2, b2, c2, d2, e2, f2, g2, h2, i2
    case a3, b3, c3, d3, e3, f3, g3, h3, i3
    case a4, b4, c4, d4, e4, f4, g4, h4, i4
    case a5, b5, c5, d5, e5, f5, g5, h5, i5
    case a6, b6, c6, d6, e6, f6, g6, h6, i6
    case a7, b7, c7, d7, e7, f7, g7, h7, i7
    case a8, b8, c8, d8, e8, f8, g8, h8, i8
    case a9, b9, c9, d9, e9, f9, g9, h9, i9
}

extension Square {
    public init(file: File, rank: Rank) {
        self.init(rawValue: rank.rawValue * File.allCases.count + file.rawValue)!
    }

    public var file: File { File(rawValue: rawValue % File.allCases.count)! }
    public var rank: Rank { Rank(rawValue: rawValue / File.allCases.count)! }

    public static func cases(at file: File) -> [Self] {
        let f = file
        return allCases.filter { $0.file == f }
    }
    public static func cases(at rank: Rank) -> [Self] {
        let r = rank
        return allCases.filter { $0.rank == r }
    }

    public static func promotableCases(for color: Color) -> [Self] {
        let ranks: [Rank] = color.isBlack ? [.one, .two, .three] : [.seven, .eight, .nine]
        return allCases.filter { ranks.contains($0.rank) }
    }
}
