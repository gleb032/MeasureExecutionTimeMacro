import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(MeasureExecutionTimeMacroMacros)
import MeasureExecutionTimeMacroMacros

let testMacros: [String: Macro.Type] = [
    "measure": MeasureExecutionTimeMacro.self,
]
#endif

final class MeasureExecutionTimeMacroTests: XCTestCase {
    func testMacro() throws {
        #if canImport(MeasureExecutionTimeMacroMacros)
        assertMacroExpansion(
            """
            @measure
            func foo() {
              let x = 1
              x += 2
              print(x)
            }
            """,
            expandedSource: """
            func foo() {
              let x = 1
              x += 2
              print(x)
            }

            func measure_foo() {\(twoSpaces)
              let __startTime=CFAbsoluteTimeGetCurrent()
              defer{ print("Execution time of foo: \\(CFAbsoluteTimeGetCurrent() - __startTime) sec") }
              let x = 1
              x += 2
              print(x)
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}

// TODO: Fix this
let twoSpaces = "  "
