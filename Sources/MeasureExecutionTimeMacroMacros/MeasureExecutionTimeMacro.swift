import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public class MeasureExecutionTimeMacro: PeerMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard var funcDecl = declaration.as(FunctionDeclSyntax.self) else {
      throw MeasureExecutionTimeMacroError.onlyApplicableToFunction
    }

    guard let body = funcDecl.body else {
      throw MeasureExecutionTimeMacroError.functionBodyShouldExist
    }

    let startTimeDecl = VariableDeclSyntax(
      leadingTrivia: .newline,
      .let,
      name: startTimeVariableName,
      initializer: InitializerClauseSyntax(value: CFAbsoluteTimeGetCurrentCall)
    )

    let logContent: TokenSyntax = "Execution time of \(raw: funcDecl.name.text): \\(\(CFAbsoluteTimeGetCurrentCall) -\(startTimeVariableName)) sec"
    let logExecutionTimeDecl = DeferStmtSyntax(
      body: CodeBlockSyntax(
        statements: CodeBlockItemListSyntax([
          CodeBlockItemSyntax(
            item: .expr(
              ExprSyntax(
                FunctionCallExprSyntax(
                  leadingTrivia: .space,
                  calledExpression: ExprSyntax("print"),
                  leftParen: .leftParenToken(),
                  arguments: LabeledExprListSyntax([
                    LabeledExprListBuilder.Expression(
                      expression: StringLiteralExprSyntax(
                        openingQuote: .stringQuoteToken(),
                        segments: StringLiteralSegmentListSyntax([
                          .stringSegment(
                            StringSegmentSyntax(
                              content: logContent
                            )
                          )
                        ]),
                        closingQuote: .stringQuoteToken()
                      )
                    )
                  ]),
                  rightParen: .rightParenToken(),
                  trailingTrivia: .space
                )
              )
            )
          )
        ])
      )
    )

    // TODO: fix this
    let newBody: ExprSyntax = """
      \(startTimeDecl)
      \(logExecutionTimeDecl)
    \(body.statements.with(leadingTrivia: .spaces(2)))
    """

    funcDecl.body = CodeBlockSyntax(
      statements: CodeBlockItemListSyntax(
        [CodeBlockItemSyntax(item: .expr(newBody))]
      ),
      rightBrace: .rightBraceToken(leadingTrivia: .newline)
    )

    funcDecl.attributes = funcDecl.attributes.filter {
      guard case let .attribute(attribute) = $0,
            let _ = attribute.attributeName.as(IdentifierTypeSyntax.self),
            let _ = node.attributeName.as(IdentifierTypeSyntax.self)
      else {
        return true
      }

      return false
    }
    funcDecl.name = TokenSyntax(stringLiteral: "measure_\(funcDecl.name.text)")

    return [DeclSyntax(funcDecl)]
  }
}

extension CodeBlockItemListSyntax {
  fileprivate func with(leadingTrivia: Trivia) -> CodeBlockItemListSyntax {
    var new = self
    new.leadingTrivia = leadingTrivia
    return new
  }
}

private let startTimeVariableName: PatternSyntax = " __startTime"
private let CFAbsoluteTimeGetCurrentCall: ExprSyntax = "CFAbsoluteTimeGetCurrent()"
