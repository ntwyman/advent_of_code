namespace AoC

module Day14 =
    // The bitmask is always given as a string of 36 bits, written with the most
    // significant bit (representing 2^35) on the left and the least significant
    // bit (2^0, that is, the 1s bit) on the right. The current bitmask is
    // applied to values immediately before they are written to memory:
    //      a 0 or 1 overwrites the corresponding bit in the value,
    //      while an X leaves the bit in the value unchanged.
    let rec shiftBits (keepMask:uint64) (replaceMask:uint64) remainder =
        if String.length remainder = 0 then
            keepMask, replaceMask
        else
            let flag = remainder.[0]
            let nextRemainder = remainder.[1..]
            let (keepBit, replaceBit) = match flag with
                                        | '1' | '0' -> (0UL, uint64 ((int flag) - (int '0')))
                                        | _ -> (1UL, 0UL)
            shiftBits ((keepMask <<< 1) ||| keepBit) ((replaceMask <<< 1) ||| replaceBit) nextRemainder

    let valueFolder ((keepMask:uint64, replaceMask:uint64), memory:Map<string, uint64>) (line:string) =
        let parts = line.Split(" = ")
        if parts.[0] = "mask" then
            (shiftBits 0UL 0UL parts.[1], memory)
        else
            let value = (keepMask &&& uint64 parts.[1]) ||| replaceMask
            let addr = parts.[0]
            ((keepMask, replaceMask), memory.Add(addr, value))

    
    let bitsToOffsets (bits:uint64) =
        let rec bitValues (mask:uint64) (offsets: uint64 list) =
            if mask > bits then
                offsets
            else
                if (bits &&& mask) <> 0UL then
                    bitValues (mask <<< 1) (List.map (fun offset -> offset||| mask) offsets |> List.append offsets)
                else
                    bitValues (mask <<< 1) offsets
        bitValues 1UL [0UL;]

    let memFolder (setMask:uint64, clearMask:uint64,  offsets:uint64 list, memory: Map<uint64, uint64>) (line:string) = 
        let parts = line.Split(" = ")
        if parts.[0] = "mask" then
            let toggleBits, setBits = shiftBits 0UL 0UL parts.[1]
            (setBits, ~~~ toggleBits, bitsToOffsets toggleBits, memory)
        else
            let value = uint64 parts.[1]
            let memStr = parts.[0]
            let baseAddr = (setMask ||| uint64 memStr.[4..(memStr.Length - 2)]) &&& clearMask
            let newMem = List.fold (fun (mem:Map<uint64, uint64>) (offset: uint64) -> mem.Add(baseAddr + offset, value)) memory offsets
            (setMask, clearMask, offsets, newMem)

    let addValues<'K when 'K : comparison> (m:Map<'K, uint64>) =
        Map.fold (fun total _ value -> total + value) 0UL m

    let handler part (entries: string seq) =

        let total = match part with
                        | One ->
                            let (_, m1) = Seq.fold valueFolder ((0xffffffffffffffffUL, 0UL), Map.empty) entries
                            addValues m1
                        | _ ->
                            let (_, _, _, m2) = Seq.fold memFolder (0UL, 0xffffffffffffffffUL, [0UL;], Map.empty) entries
                            addValues m2
        string total
