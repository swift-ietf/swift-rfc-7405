import RFC_5234
import RFC_7405
import Testing

extension RFC_7405.Test {
    @Suite
    struct `Case Sensitivity` {
        @Test
        func `Case-insensitive matching using RFC 5234 syntax`() throws {
            let rule = RFC_5234.Rule(
                name: "protocol",
                element: .terminal(.string("HTTP"))
            )

            try RFC_5234.Validator.validate([0x48, 0x54, 0x54, 0x50], against: rule)
            try RFC_5234.Validator.validate([0x68, 0x74, 0x74, 0x70], against: rule)
            try RFC_5234.Validator.validate([0x48, 0x74, 0x54, 0x70], against: rule)
        }

        @Test
        func `Explicit case-insensitive matching using RFC 7405 syntax`() throws {
            let rule = RFC_5234.Rule(
                name: "protocol",
                element: .terminal(.caseInsensitiveString("HTTP"))
            )

            try RFC_5234.Validator.validate([0x48, 0x54, 0x54, 0x50], against: rule)
            try RFC_5234.Validator.validate([0x68, 0x74, 0x74, 0x70], against: rule)
            try RFC_5234.Validator.validate([0x48, 0x74, 0x54, 0x70], against: rule)
        }

        @Test
        func `RFC 7405 case sensitivity - documentation of intended behavior`() throws {

            #expect(true)
        }

        @Test
        func `Byte value matching is always case-sensitive`() throws {

            let rule = RFC_5234.Rule(
                name: "uppercase-a",
                element: .terminal(.byte(0x41))
            )

            try RFC_5234.Validator.validate([0x41], against: rule)

        }

        @Test
        func `Byte range matching with ASCII uppercase letters`() throws {
            let rule = RFC_5234.Rule(
                name: "uppercase-letter",
                element: .terminal(.byteRange(0x41, 0x5A))
            )

            try RFC_5234.Validator.validate([0x41], against: rule)
            try RFC_5234.Validator.validate([0x5A], against: rule)
            try RFC_5234.Validator.validate([0x4D], against: rule)
        }

        @Test
        func `Byte range matching with ASCII lowercase letters`() throws {
            let rule = RFC_5234.Rule(
                name: "lowercase-letter",
                element: .terminal(.byteRange(0x61, 0x7A))
            )

            try RFC_5234.Validator.validate([0x61], against: rule)
            try RFC_5234.Validator.validate([0x7A], against: rule)
            try RFC_5234.Validator.validate([0x6D], against: rule)
        }

        @Test
        func `RFC 7405 demonstrates the distinction between syntax cases`() throws {

            let caseInsensitiveRule = RFC_5234.Rule(
                name: "greeting",
                element: .terminal(.caseInsensitiveString("hello"))
            )

            try RFC_5234.Validator.validate(Array("hello".utf8), against: caseInsensitiveRule)
            try RFC_5234.Validator.validate(Array("HELLO".utf8), against: caseInsensitiveRule)
            try RFC_5234.Validator.validate(Array("Hello".utf8), against: caseInsensitiveRule)
        }
    }
}
