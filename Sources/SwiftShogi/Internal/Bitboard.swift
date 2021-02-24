/// A bitmap of eighty-one bits suitable for storing squares for various pieces.
///
/// The first bit refers to `Square.a1`, and the last (81th) bit refers to `Square.i9`.
struct Bitboard: RawRepresentable, Equatable {
    private(set) var rawValue: UInt128

    init(rawValue: UInt128) {
        self.rawValue = rawValue & Self.maskValue
    }

    /// A mask value to prevent exceeding the maximum value of 81-bit integer.
    fileprivate static let maskValue = UInt128(upperBits: 0x1ffff, lowerBits: 0xffffffffffffffff)
}

extension Bitboard {
    /// Returns the squares where the bit is set to 1.
    var squares: [Square] { Square.allCases.filter { self[$0] } }

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
        piece.attacks.map { attack in
            attack.isFarReaching
                ? Self(square: square).filled(toward: attack.direction, stoppers: stoppers)
                : Self(square: square).shifted(toward: attack.direction)
        }.reduce(Self(rawValue: 0), |)
    }
}

private extension Bitboard {
    init(square: Square) {
        self.init(rawValue: 1 << square.rawValue)
    }

    func intersects(_ other: Self) -> Bool {
        self & other != Self(rawValue: 0)
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
        return self << direction.shift
    }

    static let rankOne: Bitboard
        = Square.cases(at: .one).map(Self.init).reduce(Bitboard(rawValue: 0), |)

    static let rankNine: Bitboard
        = Square.cases(at: .nine).map(Self.init).reduce(Bitboard(rawValue: 0), |)
}

prefix func ~ (x: Bitboard) -> Bitboard { Bitboard(rawValue: ~x.rawValue) }
func & (lhs: Bitboard, rhs: Bitboard) -> Bitboard { Bitboard(rawValue: lhs.rawValue & rhs.rawValue) }
func &= (lhs: inout Bitboard, rhs: Bitboard) { lhs = lhs & rhs }
func | (lhs: Bitboard, rhs: Bitboard) -> Bitboard { Bitboard(rawValue: lhs.rawValue | rhs.rawValue) }
func |= (lhs: inout Bitboard, rhs: Bitboard) { lhs = lhs | rhs }
func << (lhs: Bitboard, rhs: Int) -> Bitboard { Bitboard(rawValue: (lhs.rawValue << rhs) & Bitboard.maskValue) }
