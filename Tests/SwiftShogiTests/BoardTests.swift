import XCTest
@testable import SwiftShogi

final class BoardTests: XCTestCase {
    func testSubscript() {
        let piece = Piece(kind: .gold, color: .black)
        var board = Board()
        XCTAssertNil(board[.a1])

        board[.a1] = piece
        XCTAssertEqual(board[.a1], piece)

        board[.a1] = nil
        XCTAssertNil(board[.a1])
    }

    func testIsAttackable() {
        let piece = Piece(kind: .gold, color: .black)
        var board = Board()
        board[.a1] = piece

        XCTAssertTrue(board.isAttackable(from: .a1, to: .a2))
        XCTAssertFalse(board.isAttackable(from: .a1, to: .a3))
        XCTAssertFalse(board.isAttackable(from: .a2, to: .a3))
    }

    func testAttackableSquaresFromSquare() {
        let piece = Piece(kind: .gold, color: .black)
        var board = Board()
        board[.a1] = piece

        XCTAssertEqual(Array(board.attackableSuqares(from: .a1)), [.b1, .a2])
    }

    func testAttackableSquaresToSquare() {
        let piece1 = Piece(kind: .gold, color: .black)
        let piece2 = Piece(kind: .gold, color: .white)
        let piece3 = Piece(kind: .gold, color: .black)
        var board = Board()
        board[.a1] = piece1
        board[.a2] = piece2
        board[.a3] = piece3

        XCTAssertEqual(board.attackableSquares(to: .b2), [.a2, .a3])
        XCTAssertEqual(board.attackableSquares(to: .b2, for: .black), [.a3])
    }

    func testOccupiedSquares() {
        let piece1 = Piece(kind: .gold, color: .black)
        let piece2 = Piece(kind: .gold, color: .white)
        let piece3 = Piece(kind: .gold, color: .black)
        var board = Board()
        board[.a1] = piece1
        board[.a2] = piece2
        board[.a3] = piece3

        XCTAssertEqual(Array(board.occupiedSquares()), [.a1, .a2, .a3])
        XCTAssertEqual(Array(board.occupiedSquares(for: .black)), [.a1, .a3])
    }

    func testEmptySquares() {
        var board = Board()

        XCTAssertEqual(board.emptySquares.count, 81)
        XCTAssertTrue(board.emptySquares.contains(.a1))

        let piece = Piece(kind: .gold, color: .black)
        board[.a1] = piece

        XCTAssertEqual(board.emptySquares.count, 80)
        XCTAssertFalse(board.emptySquares.contains(.a1))
    }

    func testIsKingChecked() {
        let piece1 = Piece(kind: .king, color: .black)
        let piece2 = Piece(kind: .king, color: .white)
        let piece3 = Piece(kind: .gold, color: .black)
        var board = Board()
        board[.e9] = piece1
        board[.e1] = piece2
        board[.e2] = piece3

        XCTAssertFalse(board.isKingChecked(for: .black))
        XCTAssertTrue(board.isKingChecked(for: .white))
    }

    func testIsKingCheckedByMovingPieceFromSquare() {
        let piece1 = Piece(kind: .king, color: .black)
        let piece2 = Piece(kind: .lance(.normal), color: .white)
        let piece3 = Piece(kind: .gold, color: .black)
        var board = Board()
        board[.e9] = piece1
        board[.e1] = piece2
        board[.e8] = piece3

        XCTAssertFalse(board.isKingCheckedByMovingPiece(from: .e8, to: .e7, for: .black))
        XCTAssertTrue(board.isKingCheckedByMovingPiece(from: .e8, to: .d8, for: .black))
    }

    func testIsKingCheckedByMovingPiece() {
        let piece1 = Piece(kind: .king, color: .black)
        let piece2 = Piece(kind: .lance(.normal), color: .white)
        let piece3 = Piece(kind: .gold, color: .black)
        var board = Board()
        board[.e9] = piece1
        board[.e1] = piece2

        XCTAssertFalse(board.isKingCheckedByMovingPiece(piece3, to: .e7, for: .black))
        XCTAssertTrue(board.isKingCheckedByMovingPiece(piece3, to: .d8, for: .black))
    }
}
