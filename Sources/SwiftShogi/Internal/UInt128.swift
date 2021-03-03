struct UInt128 {
    private(set) var upperBits: UInt64
    private(set) var lowerBits: UInt64

    @inline(__always)
    prefix static func ~ (x: Self) -> Self {
        Self(
            upperBits: ~x.upperBits,
            lowerBits: ~x.lowerBits
        )
    }

    @inline(__always)
    static func & (lhs: Self, rhs: Self) -> Self {
        Self(
            upperBits: lhs.upperBits & rhs.upperBits,
            lowerBits: lhs.lowerBits & rhs.lowerBits
        )
    }

    @inline(__always)
    static func | (lhs: Self, rhs: Self) -> Self {
        Self(
            upperBits: lhs.upperBits | rhs.upperBits,
            lowerBits: lhs.lowerBits | rhs.lowerBits
        )
    }

    @inline(__always)
    static func << (lhs: Self, rhs: UInt) -> Self {
        let shift = rhs

        return Self(
            upperBits: lhs.upperBits << shift | lhs.lowerBits << (Int(shift) - UInt64.bitWidth),
            lowerBits: lhs.lowerBits << shift
        )
    }

    @inline(__always)
    static func >> (lhs: Self, rhs: UInt) -> Self {
        let shift = rhs

        return Self(
            upperBits: lhs.upperBits >> shift,
            lowerBits: lhs.lowerBits >> shift | lhs.upperBits >> (Int(shift) - UInt64.bitWidth)
        )
    }
}

extension UInt128: ExpressibleByIntegerLiteral {
    init(integerLiteral value: UInt64) {
        self.init(value)
    }

    init<T>(_ source: T) where T : BinaryInteger {
        self.init(upperBits: 0, lowerBits: UInt64(source))
    }
}

extension UInt128: Equatable {}
