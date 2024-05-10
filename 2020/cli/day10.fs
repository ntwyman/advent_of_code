namespace AoC

module Day10 =
    let rec countChains joltage (left: uint list) =
        let next = List.head left
        let rest = List.tail left
        if next > joltage + 3u then // Not viable
            0
        else
            if List.isEmpty rest then
                1 // this is it. next is the only way forwrd
            else
                (countChains joltage rest) + (countChains next rest)

    let countListChains span =
        let joltage = List.head span
        let rest = List.tail span
        if 2 > List.length rest then
            1UL
        else
            countChains joltage rest |> uint64
 
    let handler part (entries: string seq) =
        let adapters = Seq.map uint entries |> Seq.sort
        if part = One then
            let joltCounter ((last, joltCounts) : uint * Map<uint, uint>) (adapter:uint) =
                let step = adapter - last
                if step > 3u || step < 1u then
                    invalidArg "adapter" (string adapter)
                else
                
                    (adapter, Map.add step (joltCounts.[step] + 1u) joltCounts)

            let (_, bumps) = Seq.fold joltCounter (0u, Map.empty.
                                                        Add(1u, 0u).
                                                        Add(2u, 0u).
                                                        Add(3u, 0u)) adapters
            bumps.[1u] * (bumps.[3u] + 1u) |> string
        else
            let rec findPartitions (current, spans) next =
                let lastSeen = List.head current
                if next = lastSeen + 3u then
                    ([next], (List.rev current) :: spans)
                else
                    (next::current, spans)
            let (s, ss) = Seq.fold findPartitions ([0u], []) adapters

            let result = List.map countListChains ((List.rev s)::ss)
            List.reduce (*) result |> string
            //
            //countChains 0u adapters |> string
