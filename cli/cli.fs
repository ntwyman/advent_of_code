namespace AoC
open System.IO

module Cli =

    [<EntryPoint>]  
    let main argv =
        let day = 5
        let part = Two
        let test = false

        let handler : Handler =
            match day with
                | 1 -> Day1.handler
                | 2 -> Day2.handler
                | 3 -> Day3.handler
                | 4 -> Day4.handler
                | 5 -> Day5.handler
                | day -> (fun part _ -> (sprintf "Day %d part %A is not implemented yet" day part))
        let directory = if test then "examples" else "inputs"
        printfn "%s" (handler part (File.ReadAllLines(sprintf "%s/day%d.txt" directory day)))
        0 // return an integer exit code
