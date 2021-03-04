import XCTest
import SwiftShogi

final class GamePerformanceTests: XCTestCase {
    func testValidMoves() {
        let game = Game(sfen: SFEN(string: "l6nl/5+P1gk/2np1S3/p1p4Pp/3P2Sp1/1PPb2P1P/P5GS1/R8/LN4bKL w RGgsn5p")!)
        measure {
            _ = game.validMoves()
            /*
            for _ in 0..<5_000_000 {
                _ = game.validMoves()
            }
            */
        }
    }
}
