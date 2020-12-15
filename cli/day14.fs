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
            printfn "Keep Mask %d, replace mask %d" keepMask replaceMask
            keepMask, replaceMask
        else
            let flag = remainder.[0]
            let nextRemainder = remainder.[1..]
            let (keepBit, replaceBit) = match flag with
                                        | '1' | '0' -> (0UL, uint64 ((int flag) - (int '0')))
                                        | _ -> (1UL, 0UL)
            shiftBits ((keepMask <<< 1) ||| keepBit) ((replaceMask <<< 1) ||| replaceBit) nextRemainder

    let processLine ((keepMask:uint64, replaceMask), (memory:Map<string, uint64>)) (line:string) =
        let parts = line.Split(" = ")
        if parts.[0] = "mask" then
            (shiftBits 0UL 0UL parts.[1], memory)
        else
            let value = (keepMask &&& uint64 parts.[1]) ||| replaceMask
            let addr = parts.[0]
            printfn "Setting %s to %d" addr value
            ((keepMask, replaceMask), memory.Add(addr, value))

    let handler part (entries: string seq) =
        let _, memory = Seq.fold processLine ((0xffffffffffffffffUL, 0UL), Map.empty) entries
        let total = Map.fold (fun total _ value -> total + value) 0UL memory
        string total
