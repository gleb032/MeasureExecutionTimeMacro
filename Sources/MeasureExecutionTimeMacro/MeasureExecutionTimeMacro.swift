/// The `@measure` macro that adds execution time measurement to a function.
/// The macro will create a new function with the execution time measurement, prefixing the function name with "measure_".
/// Apply this macro to a function to automatically add the execution time measurement.
/// Example usage:
///
///     @measure
///     func work() {
///       // Some expensive work
///     }
///
///     // This will log execution time of work()
///     measure_work()
@attached(peer, names: prefixed(measure_))
public macro measure() = #externalMacro(
  module: "MeasureExecutionTimeMacroMacros",
  type: "MeasureExecutionTimeMacro"
)
