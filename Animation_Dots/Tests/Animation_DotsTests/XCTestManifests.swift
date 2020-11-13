import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Animation_DotsTests.allTests),
    ]
}
#endif
