@_spi(RFC_7405) import RFC_5234
import RFC_7405
import Testing

extension RFC_7405 {
    @Suite
    struct Test {
        @Suite
        struct `Case-Sensitive Strings` {
            @Test
            func `Case-sensitive string matches exact case`() throws {
                let rule = RFC_5234.Rule(
                    name: "test",
                    element: .terminal(.caseSensitiveString("aBc"))
                )

                try RFC_5234.Validator.validate([0x61, 0x42, 0x63], against: rule)
            }

            @Test
            func `Case-sensitive string rejects different case`() {
                let rule = RFC_5234.Rule(
                    name: "test",
                    element: .terminal(.caseSensitiveString("aBc"))
                )

                #expect(throws: RFC_5234.Validator.Error.self) {
                    try RFC_5234.Validator.validate([0x61, 0x62, 0x63], against: rule)
                }
                #expect(throws: RFC_5234.Validator.Error.self) {
                    try RFC_5234.Validator.validate([0x41, 0x42, 0x43], against: rule)
                }
                #expect(throws: RFC_5234.Validator.Error.self) {
                    try RFC_5234.Validator.validate([0x41, 0x42, 0x63], against: rule)
                }
            }

            @Test
            func `Case-sensitive uppercase`() throws {
                let rule = RFC_5234.Rule(
                    name: "test",
                    element: .terminal(.caseSensitiveString("HTTP"))
                )

                try RFC_5234.Validator.validate([0x48, 0x54, 0x54, 0x50], against: rule)

                #expect(throws: RFC_5234.Validator.Error.self) {

                    try RFC_5234.Validator.validate([0x68, 0x74, 0x74, 0x70], against: rule)
                }
            }

            @Test
            func `Case-sensitive lowercase`() throws {
                let rule = RFC_5234.Rule(
                    name: "test",
                    element: .terminal(.caseSensitiveString("http"))
                )

                try RFC_5234.Validator.validate([0x68, 0x74, 0x74, 0x70], against: rule)

                #expect(throws: RFC_5234.Validator.Error.self) {

                    try RFC_5234.Validator.validate([0x48, 0x54, 0x54, 0x50], against: rule)
                }
            }
        }

        @Suite
        struct `Case-Insensitive Strings` {
            @Test
            func `Explicit case-insensitive (%i) matches all cases`() throws {
                let rule = RFC_5234.Rule(
                    name: "test",
                    element: .terminal(.caseInsensitiveString("abc"))
                )

                try RFC_5234.Validator.validate([0x61, 0x62, 0x63], against: rule)
                try RFC_5234.Validator.validate([0x41, 0x42, 0x43], against: rule)
                try RFC_5234.Validator.validate([0x41, 0x62, 0x43], against: rule)
                try RFC_5234.Validator.validate([0x61, 0x42, 0x63], against: rule)
            }

            @Test
            func `Default RFC 5234 string() matches all cases`() throws {

                let rule = RFC_5234.Rule(
                    name: "test",
                    element: .terminal(.string("abc"))
                )

                try RFC_5234.Validator.validate([0x61, 0x62, 0x63], against: rule)
                try RFC_5234.Validator.validate([0x41, 0x42, 0x43], against: rule)
                try RFC_5234.Validator.validate([0x41, 0x62, 0x43], against: rule)
            }

            @Test
            func `Explicit %i equals default "..."`() throws {
                let explicitRule = RFC_5234.Rule(
                    name: "explicit",
                    element: .terminal(.caseInsensitiveString("test"))
                )

                let defaultRule = RFC_5234.Rule(
                    name: "default",
                    element: .terminal(.string("test"))
                )

                let testCases: [[UInt8]] = [
                    [0x74, 0x65, 0x73, 0x74],
                    [0x54, 0x45, 0x53, 0x54],
                    [0x54, 0x65, 0x73, 0x74],
                ]

                for testCase in testCases {
                    try RFC_5234.Validator.validate(testCase, against: explicitRule)
                    try RFC_5234.Validator.validate(testCase, against: defaultRule)
                }
            }
        }

        @Suite
        struct `Mixed Case Sensitivity` {
            @Test
            func `Sequence with both case-sensitive and case-insensitive`() throws {

                let rule = RFC_5234.Rule(
                    name: "test",
                    element: .sequence([
                        .terminal(.caseSensitiveString("GET")),
                        .terminal(.byte(0x20)),
                        .terminal(.caseInsensitiveString("http")),
                    ])
                )

                try RFC_5234.Validator.validate(
                    [0x47, 0x45, 0x54, 0x20, 0x68, 0x74, 0x74, 0x70],
                    against: rule
                )

                try RFC_5234.Validator.validate(
                    [0x47, 0x45, 0x54, 0x20, 0x48, 0x54, 0x54, 0x50],
                    against: rule
                )

                #expect(throws: RFC_5234.Validator.Error.self) {
                    try RFC_5234.Validator.validate(
                        [0x67, 0x65, 0x74, 0x20, 0x48, 0x54, 0x54, 0x50],
                        against: rule
                    )
                }
            }

            @Test
            func `Alternation with different case sensitivity`() throws {

                let rule = RFC_5234.Rule(
                    name: "test",
                    element: .alternation([
                        .terminal(.caseSensitiveString("POST")),
                        .terminal(.caseInsensitiveString("get")),
                    ])
                )

                try RFC_5234.Validator.validate([0x50, 0x4F, 0x53, 0x54], against: rule)

                try RFC_5234.Validator.validate([0x67, 0x65, 0x74], against: rule)

                try RFC_5234.Validator.validate([0x47, 0x45, 0x54], against: rule)

                #expect(throws: RFC_5234.Validator.Error.self) {
                    try RFC_5234.Validator.validate([0x70, 0x6F, 0x73, 0x74], against: rule)
                }
            }
        }

        @Suite
        struct `Backward Compatibility` {
            @Test
            func `RFC 5234 rules still work`() throws {

                try RFC_5234.Validator.validate([0x35], against: RFC_5234.CoreRules.digit)
                try RFC_5234.Validator.validate([0x41], against: RFC_5234.CoreRules.alpha)
                try RFC_5234.Validator.validate([0x46], against: RFC_5234.CoreRules.hexdig)
            }

            @Test
            func `Default string behavior unchanged`() throws {

                let rule = RFC_5234.Rule(
                    name: "protocol",
                    element: .terminal(.string("HTTP"))
                )

                try RFC_5234.Validator.validate([0x48, 0x54, 0x54, 0x50], against: rule)
                try RFC_5234.Validator.validate([0x68, 0x74, 0x74, 0x70], against: rule)
                try RFC_5234.Validator.validate([0x48, 0x74, 0x74, 0x70], against: rule)
            }
        }
    }
}
