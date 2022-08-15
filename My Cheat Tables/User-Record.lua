local function PrintTypes()
    print("Type:")
    print("  0 - Byte")
    print("  1 - Short")
    print("  2 - Int")
    print("  3 - Int64")
    print("  4 - Float")
    print("  5 - Double")
    print("  6 - String")
    print("  8 - Byte-Array")
    print("  9 - Binary")
end

local function HexOffset(_Number)
    if _Number < 0 then
        return '-' .. U.String.Hex(_Number * -1)
    else
        return '+' .. U.String.Hex(_Number)
    end
end

U.Record = {
    Add = function(_Offset, _Size, _Type, _Count)
        if not _Offset and not _Size and not _Type and not _Count then
            print("Add(Offset, Size, Type, Count)")
            print("Size in Bytes")
            PrintTypes()
            return
        end

        local P = U.AL.getSelectedRecord()

        local Offset = _Offset
        for I = 1, _Count do
            local R = U.AL.createMemoryRecord()
            R.setDescription(HexOffset(Offset))
            R.setAddress(HexOffset(Offset))
            R.setType(_Type)

            if P then R.appendToEntry(P) end

            Offset = Offset + _Size
        end
    end,

    AddHeader = function(_Offset, _Description)
        if not _Offset and not _Description then
            print("AddHeader(Offset, Description)")
            return
        end

        local R = U.AL.createMemoryRecord()
        R.setDescription(_Description)
        if type(_Offset) == "string" then
            R.setAddress(_Offset)
        else
            R.setAddress(HexOffset(_Offset))
        end
        R.IsGroupHeader = true
        R.IsAddressGroupHeader = true
        R.Options = "[moManualExpandCollapse]"

        local P = U.AL.getSelectedRecord()
        if P then R.appendToEntry(P) end

        return R
    end,

    AddFromArray = function(_Array)
        if not _Array then
            print("AddFromArray({")
            print("  Size, Type, Description,")
            print("  ...,")
            print("})")
            print("Size in Bytes")
            PrintTypes()
            return
        end

        local P = U.AL.getSelectedRecord()

        local Offset = 0
        local I = 1
        while _Array[I] do
            local Size = _Array[I]
            local Type = _Array[I + 1]
            local Description = _Array[I + 2]

            local R = U.AL.createMemoryRecord()
            R.setDescription(Description)
            R.setAddress(HexOffset(Offset))
            R.setType(Type)

            if P then R.appendToEntry(P) end

            Offset = Offset + Size
            I = I + 3
        end
    end,

    Children = function(_Record)
        local Array = {}

        local R = _Record or U.AL.getSelectedRecord() or U.AL
        local I = 0
        while R[I] do
            Array[I + 1] = R[I]
            I = I + 1
        end

        return Array
    end,

    FromDescription = function(_Description, _Record)
        if not _Record then
            return U.AL.getMemoryRecordByDescription(_Description)
        end

        local R = _Record
        local I = 0
        while R[I] do
            if R[I].Description == _Description then return R[I] end
            I = I + 1
        end

        return nil
    end,

    FromDescriptionChain = function(_Chain, _Record)
        local R = _Record

        for I, Description in ipairs(_Chain) do
            R = U.Record.FromDescription(Description, R)
            if R == nil then break end
        end

        return R
    end,

    Select = function(_Record) U.AL.setSelectedRecord(_Record) end
}
