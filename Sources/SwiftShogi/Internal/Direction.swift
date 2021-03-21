// File.allCases.count, Rank.callCases.countを使うほうが一貫性があるが、rawValueはリテラルしか許されない
 enum Direction: Int, CaseIterable {
    case north = -9
    case south = 9
    case east = 1
    case west = -1
    case northEast = -8
    case northWest = -10
    case southEast = 10
    case southWest = 8
    case northNorthEast = -17
    case northNorthWest = -19
    case southSouthEast = 19
    case southSouthWest = 17
}

extension Direction {
    var flippedVertically: Self {
        switch self {
        case .north:
            return .south
        case .south:
            return .north
        case .northEast:
            return .southEast
        case .northWest:
            return .southWest
        case .southEast:
            return .northEast
        case .southWest:
            return .northWest
        case .northNorthEast:
            return .southSouthEast
        case .northNorthWest:
            return .southSouthWest
        case .southSouthEast:
            return .northNorthEast
        case .southSouthWest:
            return .northNorthWest
        default:
            return self
        }
    }

    var containsEast: Bool {
        // components.contains(.east)
        switch self {
        case .east, .northEast, .southEast, .northNorthEast, .southSouthEast:
            return true
        default:
            return false
        }
    }
    var containsWest: Bool {
        //components.contains(.west)
        switch self {
        case .west, .northWest, .southWest, .northNorthWest, .southSouthWest:
            return true
        default:
            return false
        }
    }

    var shift: Int {
        rawValue
    }
 }

 private extension Direction {
    enum Component {
        case north
        case south
        case east
        case west

        var shift: Int {
            switch self {
            case .north: return -File.allCases.count
            case .south: return File.allCases.count
            case .east: return 1
            case .west: return -1
            }
        }
    }

    static let COMPONENTS: [Direction:[Component]] = [
        .north: [.north],
        .south: [.south],
        .east: [.east],
        .west: [.west],
        .northEast: [.north, .east],
        .northWest: [.north, .west],
        .southEast: [.south, .east],
        .southWest: [.south, .west],
        .northNorthEast: [.north, .north, .east],
        .northNorthWest: [.north, .north, .west],
        .southSouthEast: [.south, .south, .east],
        .southSouthWest: [.south, .south, .west]
    ]

    var components: [Component] { Self.COMPONENTS[self]! }
}
