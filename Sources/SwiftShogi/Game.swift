public struct Game {
    public private(set) var board: Board
    public private(set) var color: Color
    public private(set) var capturedPieces: [Piece]

    public init(board: Board = Board(), color: Color = .black, capturedPieces: [Piece] = []) {
        self.board = board
        self.color = color
        self.capturedPieces = capturedPieces
        sortCapturedPieces()
    }

    public init(sfen: SFEN) {
        self.init(
            board: sfen.board,
            color: sfen.color,
            capturedPieces: sfen.capturedPieces
        )
    }
}

extension Game {
    /// Performs `move` with validating it.
    public mutating func perform(_ move: Move) throws {
        switch validate(move) {
        case .success(()):
            capturePieceIfNeeded(from: move.destination)
            remove(move.piece, from: move.source)
            insert(move.piece, to: move.destination, shouldPromote: move.shouldPromote)

            color.toggle()
        case .failure(let e):
            throw e
        }
    }

    /// An error in move validation.
    public enum MoveValidationError: Error {
        case boardPieceDoesNotExist
        case capturedPieceDoesNotExist
        case invalidPieceColor
        case friendlyPieceAlreadyExists
        case pieceCannotPromote
        case illegalBoardPiecePromotion
        case illegalCapturedPiecePromotion
        case illegalAttack
        case kingPieceIsChecked
        case pieceAlreadyPromoted
        case deadPiece
    }

    /// Validates `move`.
    public func validate(_ move: Move) -> Result<Void, MoveValidationError> {
        var result = validateSource(move.source, piece: move.piece)
        result = result.flatMap {
            validateDestination(move.destination)
        }
        if move.shouldPromote {
            result = result.flatMap {
                validatePromotion(
                    source: move.source,
                    destination: move.destination,
                    piece: move.piece
                )
            }
        } else {
            result = result.flatMap {
                validateLive(
                    destination: move.destination,
                    piece: move.piece
                )
            }
        }
        result = result.flatMap {
            validateAttack(
                source: move.source,
                destination: move.destination,
                piece: move.piece
            )
        }
        return result
    }

    public func validateForValidMoves(_ move: Move) -> Result<Void, MoveValidationError> {
        // var result = validateSource(move.source, piece: move.piece) sourceはvalidと保証されていると仮定
        var result: Result<Void, MoveValidationError> = .success(())
        if move.source != .capturedPiece {
            result = validateDestination(move.destination)
        }
        if move.shouldPromote {
            result = result.flatMap {
                validatePromotion(
                    source: move.source,
                    destination: move.destination,
                    piece: move.piece
                )
            }
        } else {
            // 死に駒チェック
            result = result.flatMap {
                validateLive(
                    destination: move.destination,
                    piece: move.piece
                )
            }
        }
        // 王手放置チェック
        result = result.flatMap {
            validateAttackForValidMoves(
                source: move.source,
                destination: move.destination,
                piece: move.piece
            )
        }
        return result
    }

    /// Returns the valid moves for the current color.
    public func validMoves() -> [Move] {
        [movesFromBoard, movesFromCapturedPieces].joined().filter { isValidForValidMoves(for: $0) }
    }

    /// Returns the valid moves of `piece` from `source`.
    public func validMoves(from source: Move.Source, piece: Piece) -> [Move] {
        let moves: [Move] = {
            switch source {
            case let .board(square):
                return Array(boardPieceMoves(for: piece, from: square))
            case .capturedPiece:
                return Array(capturedPieceMoves(for: piece))
            }
        }()
        return moves.filter { isValid(for: $0) }
    }
}

private extension Game {
    mutating func sortCapturedPieces() {
        capturedPieces.sort {
            $0.color == $1.color
                ? $0.kind > $1.kind
                : $0.color < $1.color
        }
    }

    mutating func capturePieceIfNeeded(from destination: Move.Destination) {
        guard case let .board(square) = destination, var piece = board[square] else { return }

        board[square] = nil
        piece.capture(by: color)
        capturedPieces.append(piece)
        sortCapturedPieces()
    }

    mutating func remove(_ piece: Piece, from source: Move.Source) {
        switch source {
        case let .board(square):
            board[square] = nil
        case .capturedPiece:
            let index = capturedPieces.firstIndex(of: piece)!
            capturedPieces.remove(at: index)
        }
    }

    mutating func insert(_ piece: Piece, to destination: Move.Destination, shouldPromote: Bool) {
        switch destination {
        case let .board(square):
            var piece = piece
            if shouldPromote {
                piece.promote()
            }
            board[square] = piece
        }
    }

    func validateSource(_ source: Move.Source, piece: Piece) -> Result<Void, MoveValidationError> {
        switch source {
        case let .board(square):
            guard board[square] == piece else {
                return .failure(MoveValidationError.boardPieceDoesNotExist)
            }
        case .capturedPiece:
            guard capturedPieces.contains(piece) else {
                return .failure(MoveValidationError.capturedPieceDoesNotExist)
            }
        }

        guard piece.color == color else {
            return .failure(MoveValidationError.invalidPieceColor)
        }
        return .success(())
    }

    func validateDestination(_ destination: Move.Destination) -> Result<Void, MoveValidationError> {
        switch destination {
        case let .board(square):
            // If a piece at the destination does not exist, no validation is required
            guard let piece = board[square] else { return .success(()) }

            guard piece.color != color else {
                return .failure(MoveValidationError.friendlyPieceAlreadyExists)
            }
            return .success(())
        }
    }

    func validatePromotion(source: Move.Source, destination: Move.Destination, piece: Piece) -> Result<Void, MoveValidationError> {
        guard !piece.isPromoted else {
            return .failure(MoveValidationError.pieceAlreadyPromoted)
        }
        guard piece.canPromote else {
            return .failure(MoveValidationError.pieceCannotPromote)
        }

        switch (source, destination) {
        case let (.board(sourceSquare), .board(destinationSquare)):
            let squares = Square.promotableCases(for: color)
            guard squares.contains(where: { $0 == sourceSquare || $0 == destinationSquare }) else {
                return .failure(MoveValidationError.illegalBoardPiecePromotion)
            }
        case (.capturedPiece, _):
            return .failure(MoveValidationError.illegalCapturedPiecePromotion)
        }
        return .success(())
    }

    func validateAttack(source: Move.Source, destination: Move.Destination, piece: Piece) -> Result<Void, MoveValidationError> {
        switch (source, destination, piece) {
        case let (.board(sourceSquare), .board(destinationSquare), _):
            guard board.isAttackable(from: sourceSquare, to: destinationSquare) else {
                return .failure(MoveValidationError.illegalAttack)
            }
            guard !board.isKingCheckedByMovingPiece(from: sourceSquare, to: destinationSquare, for: color) else {
                return .failure(MoveValidationError.kingPieceIsChecked)
            }
        case let (.capturedPiece, .board(destinationSquare), piece):
            guard !board.isKingCheckedByMovingPiece(piece, to: destinationSquare, for: color) else {
                return .failure(MoveValidationError.kingPieceIsChecked)
            }
        }
        return .success(())
    }

    func validateAttackForValidMoves(source: Move.Source, destination: Move.Destination, piece: Piece) -> Result<Void, MoveValidationError> {
        switch (source, destination, piece) {
        case let (.board(sourceSquare), .board(destinationSquare), _):
            guard !board.isKingCheckedByMovingPiece(from: sourceSquare, to: destinationSquare, for: color) else {
                return .failure(MoveValidationError.kingPieceIsChecked)
            }
        case let (.capturedPiece, .board(destinationSquare), piece):
            guard !board.isKingCheckedByMovingPiece(piece, to: destinationSquare, for: color) else {
                return .failure(MoveValidationError.kingPieceIsChecked)
            }
        }
        return .success(())
    }

    // moveのshouldPromoteはfalseであることを仮定する
    func validateLive(destination: Move.Destination, piece: Piece /*, shouldPromote: Bool*/) -> Result<Void, MoveValidationError> {
        switch piece.kind {
        case .pawn(.normal), .lance(.normal):
            if case .board(let square) = destination {
                if (piece.color == .black && square.isOn1) || (piece.color == .white && square.isOn9) {
                    return .failure(MoveValidationError.deadPiece)
                }
            }
        case .knight(.normal):
            if case .board(let square) = destination {
                if (piece.color == .black && square.isOn1Or2) || (piece.color == .white && square.isOn8Or9) {
                    return .failure(MoveValidationError.deadPiece)
                }
            }
        default:
            break
        }
        return .success(())
    }

    func isValid(for move: Move) -> Bool {
        switch validate(move) {
        case .success(()):
            return true
        case .failure(_):
            return false
        }
    }

    func isValidForValidMoves(for move: Move) -> Bool {
        switch validateForValidMoves(move) {
        case .success(()):
            return true
        case .failure(_):
            return false
        }
    }

    var movesFromBoard: LazySequence<[Move]> {
        board.occupiedSquares(for: color).flatMap { boardPieceMoves(for: board[$0]!, from: $0) }.lazy
    }

    func boardPieceMoves(for piece: Piece, from square: Square) -> LazySequence<[Move]> {
        board.attackableSuqares(from: square).flatMap { attackableSuqare in
            [true, false].lazy.map { shouldPromote in
                Move(
                    source: .board(square),
                    destination: .board(attackableSuqare),
                    piece: piece,
                    shouldPromote: shouldPromote
                )
            }
        }.lazy
    }

    var movesFromCapturedPieces: LazySequence<[Move]> {
        capturedPieces.filter({ $0.color == color }).lazy.flatMap { capturedPieceMoves(for: $0) }.lazy
    }

    func capturedPieceMoves(for piece: Piece) -> LazySequence<[Move]> {
        board.emptySquares.map {
            Move(source: .capturedPiece, destination: .board($0), piece: piece)
        }.lazy
    }
}

extension Game: CustomStringConvertible {
    public var description: String {
        var result = board.description
        result += "持駒 " + capturedPieces.map { $0.description }.joined()
        return result
    }
}
