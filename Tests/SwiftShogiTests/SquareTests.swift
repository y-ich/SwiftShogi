import XCTest
@testable import SwiftShogi

final class SquareTests: XCTestCase {
    func testinitializer() {
        let square = Square(file: .a, rank: .one)
        XCTAssertEqual(square, Square.a1)
    }

    func testFile() {
        let square = Square.a1
        XCTAssertEqual(square.file, File.a)
    }

    func testRank() {
        let square = Square.a1
        XCTAssertEqual(square.rank, Rank.one)
    }

    func testFileCases() {
        let cases = Square.cases(at: .a)
        XCTAssertEqual(cases, [.a1, .a2, .a3, .a4, .a5, .a6, .a7, .a8, .a9])
    }

    func testRankCases() {
        let cases = Square.cases(at: .one)
        XCTAssertEqual(cases, [.a1, .b1, .c1, .d1, .e1, .f1, .g1, .h1, .i1])
    }

    func testPromotableCases() {
        let colors: [(color: Color, expected: [Square])] = [
            (.black, [
                .a1, .b1, .c1, .d1, .e1, .f1, .g1, .h1, .i1,
                .a2, .b2, .c2, .d2, .e2, .f2, .g2, .h2, .i2,
                .a3, .b3, .c3, .d3, .e3, .f3, .g3, .h3, .i3,
            ]),
            (.white, [
                .a7, .b7, .c7, .d7, .e7, .f7, .g7, .h7, .i7,
                .a8, .b8, .c8, .d8, .e8, .f8, .g8, .h8, .i8,
                .a9, .b9, .c9, .d9, .e9, .f9, .g9, .h9, .i9,
            ])
        ]
        colors.forEach {
            XCTAssertEqual(Square.promotableCases(for: $0.color), $0.expected)
        }
    }
}
