import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MeasureExecutionTimeMacroPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    MeasureExecutionTimeMacro.self,
  ]
}
