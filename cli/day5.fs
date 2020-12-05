namespace AoC

open System.Text.RegularExpressions

module Day5 =

    let rec shiftBits (str:string) hiBit bits =
        
        if String.length str = 0 then
            bits
        else
            let bit = if str.[0] = hiBit then 1 else 0
            shiftBits str.[1..] hiBit ((bits <<< 1) ||| bit)

    let binShift (str:string) hiBit =
        shiftBits str hiBit  0

    let calculateSeatId (boardingPass:string) =
        let row = binShift boardingPass.[0..6] 'B'
        let seat = binShift boardingPass.[7..] 'R'
        (row * 8) + seat 


    let rec findMiddleSeat seats =
        match seats with
            | [| |] | [| _ |] -> 0 // oops
            | _ ->
                if seats.[0] = seats.[1] - 2 then
                    seats.[0] + 1
                else
                    findMiddleSeat seats.[1..]

    let handler part (lines: string seq) =
        match part with
            | One ->
                Seq.map calculateSeatId lines |> Seq.max |> string
            | Two ->
                let seatList = Seq.map calculateSeatId lines |> Seq.toArray |> Array.sort
                findMiddleSeat seatList |> string