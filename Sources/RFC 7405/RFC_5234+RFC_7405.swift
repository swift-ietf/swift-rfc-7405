@_spi(RFC_7405) import RFC_5234

extension RFC_5234.Terminal {

    public static func caseInsensitiveString(_ string: String) -> Self {

        Self.string(string)
    }
}
