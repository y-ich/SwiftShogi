 enum Direction: Int, CaseIterable {
    case north = -9
    case south = 9
    case east = -1
    case west = 1
    case northEast = -10
    case northWest = -8
    case southEast = 8
    case southWest = 10
    case northNorthEast = -19
    case northNorthWest = -17
    case southSouthEast = 17
    case southSouthWest = 19
}

extension Direction {
    var flippedVertically: Self {
        let flippedComponents: [Component] = components.map {
            switch $0 {
            case .north: return .south
            case .south: return .north
            default: return $0
            }
        }
        return Self.allCases.first { $0.components == flippedComponents }!
    }

    var containsEast: Bool { components.contains(.east) }
    var containsWest: Bool { components.contains(.west) }

    var shift: Int {
        //components.map({ $0.shift }).reduce(0, +)
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
            case .east: return -1
            case .west: return 1
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
