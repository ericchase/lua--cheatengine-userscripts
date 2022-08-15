local b31 = 2 ^ 31 | 0

U.Number = {
    Signed = function(_Number)
        return _Number > b31 and (_Number ~ b31) + -b31 or _Number
    end,
    Unsigned = function(_Number)
        return _Number < 0 and _Number ~ -b31 + b31 or _Number
    end
}
