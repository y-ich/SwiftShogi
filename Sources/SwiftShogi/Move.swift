public struct Move {
    public enum Source {
        case board(Square)
        case capturedPiece
    }

    public enum Destination {
        case board(Square)
    }

    public let source: Source
    public let destination: Destination
    public let piece: Piece
    public let shouldPromote: Bool

    public init(source: Source, destination: Destination, piece: Piece, shouldPromote: Bool = false) {
        self.source = source
        self.destination = destination
        self.piece = piece
        self.shouldPromote = shouldPromote
    }
}

extension Move.Source: Equatable {}
extension Move.Destination: Equatable {}
extension Move: Equatable {}
extension Move.Source: Hashable {}
extension Move.Destination: Hashable {}
extension Move: Hashable {}

extension Color: CustomStringConvertible {
    public var description: String {
        switch self {
        case .black:
            return "▲"
        case .white:
            return "△"
        }
    }
}

extension Piece.Kind: CustomStringConvertible {
    public var description: String {
        switch self {
        case .pawn(.normal):
            return "歩"
        case .pawn(.promoted):
            return "と"
        case .lance(.normal):
            return "香"
        case .lance(.promoted):
            return "杏"
        case .knight(.normal):
            return "桂"
        case .knight(.promoted):
            return "圭"
        case .silver(.normal):
            return "銀"
        case .silver(.promoted):
            return "全"
        case .gold:
            return "金"
        case .bishop(.normal):
            return "角"
        case .bishop(.promoted):
            return "馬"
        case .rook(.normal):
            return "飛"
        case .rook(.promoted):
            return "龍"
        case .king:
            return "玉"
        }
    }
}

extension Move: CustomStringConvertible {
    public var description: String {
        let NUMBERS = ["９", "８", "７", "６","５", "４", "３", "２", "１"]
        let KANJI_NUMBERS = ["一", "二", "三", "四", "五", "六", "七", "八", "九"]
        guard case .board(let square) = destination else {
            fatalError("should not reach")
        }
        var result = piece.color.description + NUMBERS[square.file.rawValue] + KANJI_NUMBERS[square.rank.rawValue] + piece.kind.description
        if shouldPromote {
            result += "成"
        }
        return result
    }
}
