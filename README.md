# swift-rfc-7405

Use this package when an ABNF grammar built with swift-rfc-5234 needs string literals that match only in the exact case written, the %s form of RFC 7405. Start from `RFC_5234.Terminal.caseSensitiveString(_:)` for that, and from `RFC_5234.Terminal.caseInsensitiveString(_:)` for the explicit %i form. The case-sensitive form is declared in swift-rfc-5234 under the `RFC_7405` SPI, so it is only visible with an SPI import of `RFC_5234`. If every literal in your grammar is case-insensitive, swift-rfc-5234 alone is enough.

## Laws

- `RFC_5234.Terminal.caseInsensitiveString(_:)` builds the same terminal as `RFC_5234.Terminal.string(_:)`. A plain quoted string stays case-insensitive, as in RFC 5234.
- A case-sensitive string matches only the exact UTF-8 bytes of the literal. "aBc" refuses "abc", "ABC" and "ABc".
- A case-insensitive string compares ASCII letters without regard to case, so "HTTP" matches "http", "Http" and "HtTp".
- Case-sensitive and case-insensitive literals mix freely in one sequence or alternation, and each keeps its own case rule.
