//// The Swift Programming Language
//// https://docs.swift.org/swift-book
//
@attached(peer, names: prefixed(measure_))
public macro measure() = #externalMacro(
  module: "MeasureExecutionTimeMacroMacros",
  type: "MeasureExecutionTimeMacro"
)
