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
            (.east, -1),
            (.west, 1),
            (.northEast, -10),
            (.northWest, -8),
            (.southEast, 8),
            (.southWest, 10),
            (.northNorthEast, -19),
            (.northNorthWest, -17),
            (.southSouthEast, 17),
            (.southSouthWest, 19),
        ]
        directions.forEach {
            XCTAssertEqual($0.direction.shift, $0.expected)
        }
    }
}
