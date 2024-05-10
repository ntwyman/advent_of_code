namespace AoC

module Day9 =
    let rec binSearch target arr =
            match Array.length arr with
                | 0 -> None
                | i ->
                    let middle = i / 2
                    match  sign <| compare target arr.[middle] with
                        | 0  -> Some(target)
                        | -1 -> binSearch target arr.[..middle-1]
                        | _  -> binSearch target arr.[middle+1..]

              
    let rec findPair (numbers: int64[]) sum =
        if Array.length numbers < 2 then
            None
        else
            let first = numbers.[0]
            if first * 2L > sum then
                None
            else
                let rest = numbers.[1..]
                let somePair = binSearch (sum - first) rest
                match somePair with
                    | None -> findPair rest sum
                    | Some(pair) -> Some(first, pair)


    let findError windowSize (input:int64[]) =
        let findPair number preamble = 
            let sorted  = Array.sort preamble
            let somePair = findPair sorted number
            somePair.IsSome

        let rec findFirstError offset =
            let needle = input.[offset + windowSize]
            if findPair needle input.[offset..offset+windowSize] then
                findFirstError (offset + 1)
            else        
                needle
        findFirstError 0

    let findWindow target (input:int64[]) =
        let rec findWindowOffset first =
            let rec findWindowEnd last =
                let s = Array.sum input.[first..last]
                match sign <| compare s target with
                    | 0 -> last
                    | -1 -> findWindowEnd (last + 1)
                    | _ -> 0
            let lst = findWindowEnd (first + 1)
            if lst > 0 then
                first, lst
            else
                findWindowOffset (first + 1)

        let fst, lst = findWindowOffset 0
        input.[fst..lst]

    let handler part (lines: string seq) =
        let codes = Seq.map int64 lines
        let windowSize = int(Seq.head codes)
        let input = Seq.tail codes |> Seq.toArray

        let error = findError windowSize input
        if part = One then
            string error
        else
            let slice = findWindow error input
            string <| (Array.min slice) + (Array.max slice)
