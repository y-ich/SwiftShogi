public struct Piece {
    public enum Kind {
        case pawn(State)
        case lance(State)
        case knight(State)
        case silver(State)
        case gold
        case bishop(State)
        case rook(State)
        case king
    }

    public enum State {
        case normal
        case promoted
    }

    public private(set) var kind: Kind
    public private(set) var color: Color

    public init(kind: Kind, color: Color) {
        self.kind = kind
        self.color = color
    }
}

extension Piece {
    public var isPromoted: Bool {
        switch kind {
        case .pawn(.promoted),
             .lance(.promoted),
             .knight(.promoted),
             .silver(.promoted),
             .bishop(.promoted),
             .rook(.promoted):
            return true
        default:
            return false
        }
    }

    public var canPromote: Bool {
        switch kind {
        case .pawn(.normal),
             .lance(.normal),
             .knight(.normal),
             .silver(.normal),
             .bishop(.normal),
             .rook(.normal):
            return true
        default:
            return false
        }
    }

    public mutating func promote() {
        switch kind {
        case .pawn(.normal): kind = .pawn(.promoted)
        case .lance(.normal): kind = .lance(.promoted)
        case .knight(.normal): kind = .knight(.promoted)
        case .silver(.normal): kind = .silver(.promoted)
        case .bishop(.normal): kind = .bishop(.promoted)
        case .rook(.normal): kind = .rook(.promoted)
        default: break
        }
    }

    public mutating func unpromote() {
        switch kind {
        case .pawn(.promoted): kind = .pawn(.normal)
        case .lance(.promoted): kind = .lance(.normal)
        case .knight(.promoted): kind = .knight(.normal)
        case .silver(.promoted): kind = .silver(.normal)
        case .bishop(.promoted): kind = .bishop(.normal)
        case .rook(.promoted): kind = .rook(.normal)
        default: break
        }
    }

    public mutating func capture(by color: Color) {
        unpromote()
        self.color = color
    }
}

extension Piece {
    struct Attack: Hashable {
        let direction: Direction
        let isFarReaching: Bool
    }

    var attacks: Set<Attack> { Self.pieceAttacks[rawValue] }

    init?(character: Character, isPromoted: Bool) {
        let state: State = isPromoted ? .promoted : .normal
        switch character.lowercased() {
        case "p": self.kind = .pawn(state)
        case "l": self.kind = .lance(state)
        case "n": self.kind = .knight(state)
        case "s": self.kind = .silver(state)
        case "g": self.kind = .gold
        case "b": self.kind = .bishop(state)
        case "r": self.kind = .rook(state)
        case "k": self.kind = .king
        default: return nil
        }
        self.color = character.isUppercase ? .black : .white
    }
}

private extension Piece {
    static let pieceAttacks: [Set<Attack>] = piecesAndAttacks

    static var piecesAndAttacks: [Set<Attack>] {
        var result = [Set<Attack>]()
        for i in 0..<allCases.count {
            let piece = Piece(rawValue: i)!
            let directions = piece.farReachingDirections
            let attacks = piece.attackableDirections.map {
                Attack(direction: $0, isFarReaching: directions.contains($0))
            }
            result.append(Set(attacks))
        }
        return result
    }

    var attackableDirections: [Direction] {
        let directions: [Direction] = {
            switch kind {
            case .pawn(.normal),
                 .lance(.normal):
                return [.north]
            case .knight(.normal):
                return [.northNorthEast, .northNorthWest]
            case .silver(.normal):
                return [.north, .northEast, .northWest, .southEast, .southWest]
            case .pawn(.promoted),
                 .lance(.promoted),
                 .knight(.promoted),
                 .silver(.promoted),
                 .gold:
                return [.north, .south, .east, .west, .northEast, .northWest]
            case .bishop(.normal):
                return [.northEast, .northWest, .southEast, .southWest]
            case .rook(.normal):
                return [.north, .south, .east, .west]
            case .bishop(.promoted),
                 .rook(.promoted),
                 .king:
                return [.north, .south, .east, .west, .northEast, .northWest, .southEast, .southWest]
            }
        }()
        return color.isBlack ? directions : directions.map { $0.flippedVertically }
    }

    var farReachingDirections: [Direction] {
        let directions: [Direction] = {
            switch kind {
            case .lance(.normal):
                return [.north]
            case .bishop:
                return [.northEast, .northWest, .southEast, .southWest]
            case .rook:
                return [.north, .south, .east, .west]
            default:
                return []
            }
        }()
        return color.isBlack ? directions : directions.map { $0.flippedVertically }
    }
}

extension Piece.Kind: CaseIterable {
    public static let allCases: [Self] = [
        .pawn(.normal), .pawn(.promoted),
        .lance(.normal), .lance(.promoted),
        .knight(.normal), .knight(.promoted),
        .silver(.normal), .silver(.promoted),
        .gold,
        .bishop(.normal), .bishop(.promoted),
        .rook(.normal), .rook(.promoted),
        .king,
    ]
}

extension Piece: CaseIterable {
    public static let allCases: [Self] = kindsAndColors.map(Self.init)

    private static var kindsAndColors: [(Kind, Color)] {
        Kind.allCases.flatMap { kind in
            Color.allCases.map { color in (kind, color) }
        }
    }
}

extension Piece.Kind: RawRepresentable {
    public typealias RawValue = Int

    public init?(rawValue: RawValue) {
        switch rawValue {
        case 0: self = .pawn(.normal)
        case 1: self = .lance(.normal)
        case 2: self = .knight(.normal)
        case 3: self = .silver(.normal)
        case 4: self = .gold
        case 5: self = .bishop(.normal)
        case 6: self = .rook(.normal)
        case 7: self = .king
        case 8: self = .pawn(.promoted)
        case 9: self = .lance(.promoted)
        case 10: self = .knight(.promoted)
        case 11: self = .silver(.promoted)
        case 12: self = .bishop(.promoted)
        case 13: self = .rook(.promoted)
        default: return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .pawn(.normal): return 0
        case .lance(.normal): return 1
        case .knight(.normal): return 2
        case .silver(.normal): return 3
        case .gold: return 4
        case .bishop(.normal): return 5
        case .rook(.normal): return 6
        case .king: return 7
        case .pawn(.promoted): return 8
        case .lance(.promoted): return 9
        case .knight(.promoted): return 10
        case .silver(.promoted): return 11
        case .bishop(.promoted): return 12
        case .rook(.promoted): return 13
        }
    }
}

extension Piece.Kind: Comparable {
    public static func < (lhs: Piece.Kind, rhs: Piece.Kind) -> Bool {
        return allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}
extension Piece.Kind: Hashable {}

extension Piece: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(kind.rawValue | (color == .black ? 0 : 0x80))
    }
}
extension Piece: RawRepresentable {
    public typealias RawValue = Int

    public init?(rawValue: RawValue) {
        let kinds = Piece.Kind.allCases.count
        if rawValue < kinds {
            self = Piece(kind: Kind(rawValue: rawValue)!, color: .black)
        } else if rawValue < 2 * kinds {
            self = Piece(kind: Kind(rawValue: rawValue - kinds)!, color: .white)
        } else {
            return nil
        }
    }

    public var rawValue: RawValue {
        let offset = color == .black ? 0 : Piece.Kind.allCases.count
        return kind.rawValue + offset
    }
}
extension Piece: CustomStringConvertible {
    public var description: String {
        return (color == .black ? " " : "v") + kind.description
    }
}
