U.String = {
    Decimal = function(_Number) return string.format("%u", _Number) end,
    Hex = function(_Number) return string.format("%02X", _Number) end
}
