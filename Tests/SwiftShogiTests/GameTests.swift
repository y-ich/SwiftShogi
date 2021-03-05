import XCTest
@testable import SwiftShogi

final class GameTests: XCTestCase {
    func testInitializerWithSFEN() {
        let sfen = SFEN(string: "4k4/9/9/9/9/9/9/9/4K4 w G")!
        let game = Game(sfen: sfen)
        XCTAssertEqual(game.board[.e1], Piece(kind: .king, color: .white))
        XCTAssertEqual(game.board[.e9], Piece(kind: .king, color: .black))
        XCTAssertEqual(game.color, .white)
        XCTAssertEqual(game.capturedPieces, [Piece(kind: .gold, color: .black)])
    }

    func testPerformFromBoard() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [.a1: piece])
        var game = Game(board: board)
        XCTAssertEqual(game.board[.a1], piece)
        XCTAssertNil(game.board[.b1])
        XCTAssertEqual(game.color, .black)
        XCTAssertTrue(game.capturedPieces.isEmpty)

        let move = Move(
            source: .board(.a1),
            destination: .board(.b1),
            piece: piece
        )
        XCTAssertNoThrow(try game.perform(move))

        XCTAssertNil(game.board[.a1])
        XCTAssertEqual(game.board[.b1], piece)
        XCTAssertEqual(game.color, .white)
        XCTAssertTrue(game.capturedPieces.isEmpty)
    }

    func testPerformFromCapturedPiece() {
        let piece = Piece(kind: .gold, color: .black)
        var game = Game(capturedPieces: [piece])
        XCTAssertNil(game.board[.a1])
        XCTAssertEqual(game.color, .black)
        XCTAssertTrue(game.capturedPieces.contains(piece))

        let move = Move(
            source: .capturedPiece,
            destination: .board(.a1),
            piece: piece
        )
        XCTAssertNoThrow(try game.perform(move))

        XCTAssertEqual(game.board[.a1], piece)
        XCTAssertEqual(game.color, .white)
        XCTAssertTrue(game.capturedPieces.isEmpty)
    }

    func testPerformWithCapturingPiece() {
        let piece1 = Piece(kind: .gold, color: .black)
        let piece2 = Piece(kind: .rook(.promoted), color: .white)
        let piece3 = Piece(kind: .pawn(.normal), color: .black)
        let piece4 = Piece(kind: .gold, color: .white)
        let board = Board(pieces: [.a1: piece1, .b1: piece2])
        var game = Game(board: board, capturedPieces: [piece3, piece4])
        XCTAssertEqual(game.board[.a1], piece1)
        XCTAssertEqual(game.board[.b1], piece2)
        XCTAssertEqual(game.color, .black)
        XCTAssertEqual(game.capturedPieces, [piece3, piece4])

        let move = Move(
            source: .board(.a1),
            destination: .board(.b1),
            piece: piece1
        )
        XCTAssertNoThrow(try game.perform(move))

        let expected = Piece(kind: .rook(.normal), color: .black)
        XCTAssertNil(game.board[.a9])
        XCTAssertEqual(game.board[.b1], piece1)
        XCTAssertEqual(game.color, .white)
        XCTAssertEqual(game.capturedPieces, [expected, piece3, piece4])
    }

    func testPerformWithPromotingPiece() {
        let piece = Piece(kind: .rook(.normal), color: .black)
        let board = Board(pieces: [.a1: piece])
        var game = Game(board: board)
        XCTAssertEqual(game.board[.a1], piece)
        XCTAssertNil(game.board[.b1])
        XCTAssertEqual(game.color, .black)
        XCTAssertTrue(game.capturedPieces.isEmpty)

        let move = Move(
            source: .board(.a1),
            destination: .board(.b1),
            piece: piece,
            shouldPromote: true
        )
        XCTAssertNoThrow(try game.perform(move))

        let expectedPiece = Piece(kind: .rook(.promoted), color: .black)
        XCTAssertNil(game.board[.a1])
        XCTAssertEqual(game.board[.b1], expectedPiece)
        XCTAssertEqual(game.color, .white)
        XCTAssertTrue(game.capturedPieces.isEmpty)
    }

    func testValidateWithBoardPieceDoesNotExistMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [:])
        let game = Game(board: board)

        let move = Move(
            source: .board(.a1),
            destination: .board(.b1),
            piece: piece
        )
        switch game.validate(move) {
        case .success(()):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, Game.MoveValidationError.boardPieceDoesNotExist)
        }
    }

    func testValidateWithCapturedPieceDoesNotExistMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let game = Game(capturedPieces: [])

        let move = Move(
            source: .capturedPiece,
            destination: .board(.a1),
            piece: piece
        )
        switch game.validate(move) {
        case .success(()):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, Game.MoveValidationError.capturedPieceDoesNotExist)
        }
    }

    func testValidateWithInvalidPieceColorMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [.a1: piece])
        let game = Game(board: board, color: .white)

        let move = Move(
            source: .board(.a1),
            destination: .board(.b1),
            piece: piece
        )
        switch game.validate(move) {
        case .success(()):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, Game.MoveValidationError.invalidPieceColor)
        }
    }

    func testValidateWithFriendlyPieceAlreadyExistsMoveValidationError() {
        let piece1 = Piece(kind: .gold, color: .black)
        let piece2 = Piece(kind: .king, color: .black)
        let board = Board(pieces: [.a1: piece1, .b1: piece2])
        let game = Game(board: board)

        let move = Move(
            source: .board(.a1),
            destination: .board(.b1),
            piece: piece1
        )
        switch game.validate(move) {
        case .success(()):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, Game.MoveValidationError.friendlyPieceAlreadyExists)
        }
    }

    func testValidateWithIllegalAttackMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [.a1: piece])
        let game = Game(board: board)

        let move = Move(
            source: .board(.a1),
            destination: .board(.i1),
            piece: piece
        )
        switch game.validate(move) {
        case .success(()):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, Game.MoveValidationError.illegalAttack)
        }
    }

    func testValidateWithKingPieceIsCheckedMoveValidationError() {
        let piece1 = Piece(kind: .king, color: .black)
        let piece2 = Piece(kind: .lance(.normal), color: .white)
        let piece3 = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [.e9: piece1, .e1: piece2])

        let moves: [Move] = [
            Move(
                source: .board(.e9),
                destination: .board(.e8),
                piece: piece1
            ),
            Move(
                source: .capturedPiece,
                destination: .board(.a1),
                piece: piece3
            )
        ]
        moves.forEach { move in
            let game = Game(board: board, capturedPieces: [piece3])

            switch game.validate(move) {
            case .success(()):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, Game.MoveValidationError.kingPieceIsChecked)
            }
        }
    }

    func testValidateWithPieceAlreadyPromotedMoveValidationError() {
        let piece = Piece(kind: .rook(.promoted), color: .black)
        let board = Board(pieces: [.a1: piece])
        let game = Game(board: board)

        let move = Move(
            source: .board(.a1),
            destination: .board(.b1),
            piece: piece,
            shouldPromote: true
        )
        switch game.validate(move) {
        case .success(()):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, Game.MoveValidationError.pieceAlreadyPromoted)
        }
    }

    func testValidateWithPieceCannotPromoteMoveValidationError() {
        let piece = Piece(kind: .gold, color: .black)
        let board = Board(pieces: [.a1: piece])
        let game = Game(board: board)

        let move = Move(
            source: .board(.a1),
            destination: .board(.b1),
            piece: piece,
            shouldPromote: true
        )
        switch game.validate(move) {
        case .success(()):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, Game.MoveValidationError.pieceCannotPromote)
        }
    }

    func testValidateWithIllegalBoardPiecePromotionMoveValidationError() {
        let piece = Piece(kind: .rook(.normal), color: .black)
        let board = Board(pieces: [.a9: piece])
        let game = Game(board: board)

        let move = Move(
            source: .board(.a9),
            destination: .board(.a8),
            piece: piece,
            shouldPromote: true
        )
        switch game.validate(move) {
        case .success(()):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, Game.MoveValidationError.illegalBoardPiecePromotion)
        }
    }

    func testValidateWithIllegalCapturedPiecePromotionMoveValidationError() {
        let piece = Piece(kind: .rook(.normal), color: .black)
        let game = Game(capturedPieces: [piece])

        let move = Move(
            source: .capturedPiece,
            destination: .board(.a1),
            piece: piece,
            shouldPromote: true
        )
        switch game.validate(move) {
        case .success(()):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, Game.MoveValidationError.illegalCapturedPiecePromotion)
        }
    }

    func testValidMoves() {
        let piece1 = Piece(kind: .silver(.normal), color: .black)
        let piece2 = Piece(kind: .silver(.normal), color: .white)
        let piece3 = Piece(kind: .gold, color: .black)
        let piece4 = Piece(kind: .gold, color: .white)
        let board = Board(pieces: [.e9: piece1, .e1: piece2])
        let game = Game(board: board, capturedPieces: [piece3, piece4])

        let expectedFromBoard: [Move] = [
            .d8, .e8, .f8
        ].map {
            Move(
                source: .board(.e9),
                destination: .board($0),
                piece: piece1,
                shouldPromote: false
            )
        }
        let expectedFromCapturedPiece: [Move] = [
            .a1, .b1, .c1, .d1,      .f1, .g1, .h1, .i1,
            .a2, .b2, .c2, .d2, .e2, .f2, .g2, .h2, .i2,
            .a3, .b3, .c3, .d3, .e3, .f3, .g3, .h3, .i3,
            .a4, .b4, .c4, .d4, .e4, .f4, .g4, .h4, .i4,
            .a5, .b5, .c5, .d5, .e5, .f5, .g5, .h5, .i5,
            .a6, .b6, .c6, .d6, .e6, .f6, .g6, .h6, .i6,
            .a7, .b7, .c7, .d7, .e7, .f7, .g7, .h7, .i7,
            .a8, .b8, .c8, .d8, .e8, .f8, .g8, .h8, .i8,
            .a9, .b9, .c9, .d9,      .f9, .g9, .h9, .i9,
        ].map {
            Move(
                source: .capturedPiece,
                destination: .board($0),
                piece: piece3,
                shouldPromote: false
            )
        }
        XCTAssertEqual(Set(game.validMoves()), Set(expectedFromBoard + expectedFromCapturedPiece))
    }

    func testValidMovesWithMoveSource() {
        let piece1 = Piece(kind: .silver(.normal), color: .black)
        let piece2 = Piece(kind: .silver(.normal), color: .white)
        let piece3 = Piece(kind: .gold, color: .black)
        let piece4 = Piece(kind: .gold, color: .white)
        let board = Board(pieces: [.e9: piece1, .e1: piece2])
        let game = Game(board: board, capturedPieces: [piece3, piece4])

        let expectedFromBoard: [Move] = [
            .d8, .e8, .f8
        ].map {
            Move(
                source: .board(.e9),
                destination: .board($0),
                piece: piece1,
                shouldPromote: false
            )
        }
        XCTAssertEqual(Set(game.validMoves(from: .board(.e9), piece: piece1)), Set(expectedFromBoard))

        let expectedFromCapturedPiece: [Move] = [
            .a1, .b1, .c1, .d1,      .f1, .g1, .h1, .i1,
            .a2, .b2, .c2, .d2, .e2, .f2, .g2, .h2, .i2,
            .a3, .b3, .c3, .d3, .e3, .f3, .g3, .h3, .i3,
            .a4, .b4, .c4, .d4, .e4, .f4, .g4, .h4, .i4,
            .a5, .b5, .c5, .d5, .e5, .f5, .g5, .h5, .i5,
            .a6, .b6, .c6, .d6, .e6, .f6, .g6, .h6, .i6,
            .a7, .b7, .c7, .d7, .e7, .f7, .g7, .h7, .i7,
            .a8, .b8, .c8, .d8, .e8, .f8, .g8, .h8, .i8,
            .a9, .b9, .c9, .d9,      .f9, .g9, .h9, .i9,
        ].map {
            Move(
                source: .capturedPiece,
                destination: .board($0),
                piece: piece3,
                shouldPromote: false
            )
        }
        XCTAssertEqual(Set(game.validMoves(from: .capturedPiece, piece: piece3)), Set(expectedFromCapturedPiece))
    }
}

private extension Board {
    init(pieces: [Square: Piece]) {
        self.init()
        pieces.forEach { square, piece in self[square] = piece }
    }
}
