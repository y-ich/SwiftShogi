import XCTest
@testable import SwiftShogi

final class DirectionTests: XCTestCase {
    func testFlippedHorizontally() {
        let directions: [(direction: Direction, expected: Direction)] = [
            (.north, .south),
            (.south, .north),
            (.east, .east),
            (.west, .west),
            (.northEast, .southEast),
            (.northWest, .southWest),
            (.southEast, .northEast),
            (.southWest, .northWest),
            (.northNorthEast, .southSouthEast),
            (.northNorthWest, .southSouthWest),
            (.southSouthEast, .northNorthEast),
            (.southSouthWest, .northNorthWest),
        ]
        directions.forEach { XCTAssertEqual($0.direction.flippedVertically, $0.expected)
        }
    }

    func testShift() {
        let directions: [(direction: Direction, expected: Int)] = [
            (.north, -9),
            (.south, 9),
            (.east, 1),
            (.west, -1),
            (.northEast, -8),
            (.northWest, -10),
            (.southEast, 10),
            (.southWest, 8),
            (.northNorthEast, -17),
            (.northNorthWest, -19),
            (.southSouthEast, 19),
            (.southSouthWest, 17),
        ]
        directions.forEach {
            XCTAssertEqual($0.direction.shift, $0.expected)
        }
    }
}
