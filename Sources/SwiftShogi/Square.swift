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
public enum File: Int, CaseIterable { // rawValueは左オリジンにする
    case i
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
    case i1, h1, g1, f1, e1, d1, c1, b1, a1
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

    public static func cases(at file: File) -> [Self] {
        let f = file
        return allCases.filter { $0.file == f }
    }
    public static func cases(at rank: Rank) -> [Self] {
        let r = rank
        return allCases.filter { $0.rank == r }
    }

    public static func promotableCases(for color: Color) -> [Self] {
        //let ranks: [Rank] = color.isBlack ? [.one, .two, .three] : [.seven, .eight, .nine]
        //return allCases.filter { ranks.contains($0.rank) }
        let range = color.isBlack ? 0..<(3 * File.allCases.count) : (Square.allCases.count - 3 * File.allCases.count)..<Square.allCases.count
        return range.map { Square(rawValue: $0)! }
    }
}
