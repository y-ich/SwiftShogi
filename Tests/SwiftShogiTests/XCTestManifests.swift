#if !canImport(ObjectiveC)
import XCTest

extension BitboardTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__BitboardTests = [
        ("testAttacks", testAttacks),
        ("testAttacksWithStoppers", testAttacksWithStoppers),
        ("testSubscript", testSubscript),
    ]
}

extension BoardTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__BoardTests = [
        ("testIsValidAttack", testIsValidAttack),
        ("testSubscript", testSubscript),
    ]
}

extension ColorTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ColorTests = [
        ("testToggle", testToggle),
    ]
}

extension DirectionTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DirectionTests = [
        ("testFlippedHorizontally", testFlippedHorizontally),
        ("testShift", testShift),
    ]
}

extension GameTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__GameTests = [
        ("testPerformFromBoard", testPerformFromBoard),
        ("testPerformFromCapturedPiece", testPerformFromCapturedPiece),
        ("testPerformWithCapturingPiece", testPerformWithCapturingPiece),
        ("testValidateWithBoardPieceDoesNotExistMoveValidationError", testValidateWithBoardPieceDoesNotExistMoveValidationError),
        ("testValidateWithCapturedPieceDoesNotExistMoveValidationError", testValidateWithCapturedPieceDoesNotExistMoveValidationError),
        ("testValidateWithFriendlyPieceAlreadyExistsMoveValidationError", testValidateWithFriendlyPieceAlreadyExistsMoveValidationError),
        ("testValidateWithIllegalAttackMoveValidationError", testValidateWithIllegalAttackMoveValidationError),
        ("testValidateWithIllegalBoardPiecePromotionMoveValidationError", testValidateWithIllegalBoardPiecePromotionMoveValidationError),
        ("testValidateWithIllegalCapturedPiecePromotionMoveValidationError", testValidateWithIllegalCapturedPiecePromotionMoveValidationError),
        ("testValidateWithInvalidPieceColorMoveValidationError", testValidateWithInvalidPieceColorMoveValidationError),
        ("testValidateWithPieceAlreadyPromotedMoveValidationError", testValidateWithPieceAlreadyPromotedMoveValidationError),
        ("testValidateWithPieceCannotPromoteMoveValidationError", testValidateWithPieceCannotPromoteMoveValidationError),
    ]
}

extension PieceTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PieceTests = [
        ("testAttacks", testAttacks),
        ("testCanPromote", testCanPromote),
        ("testCapture", testCapture),
        ("testIsPromoted", testIsPromoted),
        ("testUnpromote", testUnpromote),
    ]
}

extension SquareTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SquareTests = [
        ("testFile", testFile),
        ("testFileCases", testFileCases),
        ("testPromotableCases", testPromotableCases),
        ("testRank", testRank),
        ("testRankCases", testRankCases),
    ]
}

extension UInt128Tests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__UInt128Tests = [
        ("testLeftShift", testLeftShift),
        ("testRightShift", testRightShift),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BitboardTests.__allTests__BitboardTests),
        testCase(BoardTests.__allTests__BoardTests),
        testCase(ColorTests.__allTests__ColorTests),
        testCase(DirectionTests.__allTests__DirectionTests),
        testCase(GameTests.__allTests__GameTests),
        testCase(PieceTests.__allTests__PieceTests),
        testCase(SquareTests.__allTests__SquareTests),
        testCase(UInt128Tests.__allTests__UInt128Tests),
    ]
}
#endif
