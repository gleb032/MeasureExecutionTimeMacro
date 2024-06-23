import MeasureExecutionTimeMacro
import Foundation

@measure
func foo() {
  sleep(2) // Some work
}

measure_foo()

