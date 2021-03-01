 enum Direction: CaseIterable {
    case north
    case south
    case east
    case west
    case northEast
    case northWest
    case southEast
    case southWest
    case northNorthEast
    case northNorthWest
    case southSouthEast
    case southSouthWest
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
        components.lazy.map({ $0.shift }).reduce(0, +)
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
