import Foundation

internal enum MeasureExecutionTimeMacroError: Error {
  case onlyApplicableToFunction
  case functionBodyShouldExist
}

extension MeasureExecutionTimeMacroError: CustomStringConvertible {
  var description: String {
    switch self {
    case .onlyApplicableToFunction:
      "@measure can only be applied to func"
    case .functionBodyShouldExist:
      "Function body should exist to apply @measure macro"
    }
  }
}

extension MeasureExecutionTimeMacroError: CustomDebugStringConvertible {
  var debugDescription: String {
    "\(self): \(description)"
  }
}
