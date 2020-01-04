/// A bitmap of eighty-one bits suitable for storing squares for various pieces.
///
/// The first bit refers to `Square.oneA`, and the last (81th) bit refers to `Square.nineI`.
struct Bitboard: RawRepresentable, Equatable {
    private(set) var rawValue: UInt128

    init(rawValue: UInt128) {
        self.rawValue = rawValue & Self.maskValue
    }

    /// A mask value to prevent exceeding the maximum value of 81-bit integer.
    private static let maskValue = UInt128(upperBits: 0x1ffff, lowerBits: 0xffffffffffffffff)
}

extension Bitboard {

    /// The `Bool` value for the bit at `square`.
    subscript(square: Square) -> Bool {
        get {
            intersects(Self(square: square))
        }
        set(hasBit) {
            if hasBit {
                rawValue |= Self(square: square).rawValue
            } else {
                rawValue &= ~Self(square: square).rawValue
            }
        }
    }

    private init(square: Square) {
        self.init(rawValue: 1 << square.rawValue)
    }

    private func intersects(_ other: Self) -> Bool {
        rawValue & other.rawValue != 0
    }
}

extension Bitboard {

    /// An attacks bitboard for a piece.
    static func attacks(for piece: Piece, at square: Square, stoppers: Bitboard) -> Self {
        piece.attacks.map { attack in
            attack.isFarReaching
                ? Self(square: square).filled(toward: attack.direction, stoppers: stoppers)
                : Self(square: square).shifted(toward: attack.direction)
        }.reduce(Self(rawValue: 0), |)
    }

    private func filled(toward direction: Direction, stoppers: Bitboard) -> Self {
        var bitboard = self
        var previous: Bitboard
        repeat {
            previous = bitboard
            bitboard |= bitboard.shifted(toward: direction)
            bitboard &= ~self
        } while !bitboard.intersects(stoppers) && previous != bitboard
        return bitboard
    }

    private func shifted(toward direction: Direction) -> Self {
        var bitboard = self << direction.shift
        // Prevents rank changes by shifting
        if direction.containsNorth && intersects(Self.rankA) { bitboard &= ~Self.rankI }
        if direction.containsSouth && intersects(Self.rankI) { bitboard &= ~Self.rankA }
        return bitboard
    }

    private static let rankA: Bitboard
        = Square.cases(at: .a).map(Self.init).reduce(Bitboard(rawValue: 0), |)

    private static let rankI: Bitboard
        = Square.cases(at: .i).map(Self.init).reduce(Bitboard(rawValue: 0), |)
}

prefix func ~ (x: Bitboard) -> Bitboard { Bitboard(rawValue: ~x.rawValue) }
func & (lhs: Bitboard, rhs: Bitboard) -> Bitboard { Bitboard(rawValue: lhs.rawValue & rhs.rawValue) }
func &= (lhs: inout Bitboard, rhs: Bitboard) { lhs = lhs & rhs }
func | (lhs: Bitboard, rhs: Bitboard) -> Bitboard { Bitboard(rawValue: lhs.rawValue | rhs.rawValue) }
func |= (lhs: inout Bitboard, rhs: Bitboard) { lhs = lhs | rhs }
func << (lhs: Bitboard, rhs: Int) -> Bitboard { Bitboard(rawValue: lhs.rawValue << rhs) }
