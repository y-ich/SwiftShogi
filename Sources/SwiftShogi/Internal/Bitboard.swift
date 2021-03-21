/// A bitmap of eighty-one bits suitable for storing squares for various pieces.
///
/// The first bit refers to `Square.a1`, and the last (81th) bit refers to `Square.i9`.
//           north
//         ihgfedcba
// i1(LSB) 000000000 1
//         000000000 2
//         000000000 3
//         000000000 4
//    west 000000000 5 east
//         000000000 6
//         000000000 7
//         000000000 8
//         000000000 9 a9(MSB)
//           south
struct Bitboard: RawRepresentable, Equatable {
    static let empty = Self(rawValue: 0)
    static let squares: [Bitboard] = Square.allCases.map { Bitboard(rawValue: 1 << UInt($0.rawValue)) }
    private(set) var rawValue: UInt128

    init(rawValue: UInt128) {
        self.rawValue = rawValue & Self.maskValue
    }

    init(square: Square) {
        self = Bitboard.squares[square.rawValue]
    }

    /// A mask value to prevent exceeding the maximum value of 81-bit integer.
    private static let maskValue = UInt128(upperBits: 0x1ffff, lowerBits: 0xffffffffffffffff)
}

extension Bitboard {
    /// Returns the squares where the bit is set to 1.
    var occupiedIndices: OccupiedIndexSequence { OccupiedIndexSequence(self) }
    var occupiedSquares: LazySequence<[Square]> { occupiedIndices.map { Square(rawValue: $0)! }.lazy }

    /// The `Bool` value for the bit at `square`.
    subscript(square: Square) -> Bool {
        get {
            intersects(Self(square: square))
        }
        set(hasBit) {
            if hasBit {
                self |= Self(square: square)
            } else {
                self &= ~Self(square: square)
            }
        }
    }

    /// An attacks bitboard for a piece.
    static func attacks(from square: Square, piece: Piece, stoppers: Bitboard) -> Self {
        piece.attacks.lazy.map { attack in
            attack.isFarReaching
                ? Self(square: square).filled(toward: attack.direction, stoppers: stoppers)
                : Self(square: square).shifted(toward: attack.direction)
        }.reduce(Self(rawValue: 0), |)
    }
}

private extension Bitboard {
    func intersects(_ other: Self) -> Bool {
        self & other != Self.empty
    }

    func filled(toward direction: Direction, stoppers: Bitboard) -> Self {
        var bitboard = self
        var previous: Bitboard
        repeat {
            previous = bitboard
            bitboard |= bitboard.shifted(toward: direction)
            bitboard &= ~self
        } while !bitboard.intersects(stoppers) && previous != bitboard
        return bitboard
    }

    func shifted(toward direction: Direction) -> Self {
       var bitboard = self << direction.shift
        // Prevents rank changes by shifting
        if direction.containsEast {
            bitboard &= ~Self.fileI
        }
        if direction.containsWest {
            bitboard &= ~Self.fileA
        }
        return bitboard
    }

    static let fileA: Bitboard
        = Square.cases(at: .a).map(Self.init).reduce(Bitboard(rawValue: 0), |)

    static let fileI: Bitboard
        = Square.cases(at: .i).map(Self.init).reduce(Bitboard(rawValue: 0), |)
}

prefix func ~(x: Bitboard) -> Bitboard {
    Bitboard(rawValue: ~x.rawValue)
}

func &(lhs: Bitboard, rhs: Bitboard) -> Bitboard {
    Bitboard(rawValue: lhs.rawValue & rhs.rawValue)
}

func &=(lhs: inout Bitboard, rhs: Bitboard) {
    lhs = lhs & rhs
}

func |(lhs: Bitboard, rhs: Bitboard) -> Bitboard {
    Bitboard(rawValue: lhs.rawValue | rhs.rawValue)
}

func |=(lhs: inout Bitboard, rhs: Bitboard) {
    lhs = lhs | rhs
}

func <<(lhs: Bitboard, rhs: Int) -> Bitboard {
    Bitboard(rawValue: rhs >= 0 ? (lhs.rawValue << UInt(rhs)) : (lhs.rawValue >> UInt(-rhs)))
}

public struct OccupiedIndexSequence: Sequence, IteratorProtocol {
    var iterator: OnesBitIndexIterator

    init(_ bitboard: Bitboard) {
        iterator = OnesBitIndexIterator(bitboard.rawValue)
    }

    public mutating func next() -> Int? {
        iterator.next()
    }    
}
