namespace AoC
open System.IO

module Cli =

    [<EntryPoint>]  
    let main argv =
        let day = 19
        let part = One
        let test = false

        let handler : Handler =
            match day with
                | 1 -> Day1.handler
                | 2 -> Day2.handler
                | 3 -> Day3.handler
                | 4 -> Day4.handler
                | 5 -> Day5.handler
                | 6 -> Day6.handler
                | 7 -> Day7.handler
                | 8 -> Day8.handler
                | 9 -> Day9.handler
                | 10 -> Day10.handler
                | 11 -> Day11.handler
                | 12 -> Day12.handler
                | 13 -> Day13.handler
                | 14 -> Day14.handler
                | 15 -> Day15.handler
                | 16 -> Day16.handler
                | 17 -> Day17.handler
                | 18 -> Day18.handler
                | 19 -> Day19.handler
                | day -> (fun part _ -> (sprintf "Day %d part %A is not implemented yet" day part))
        let directory = if test then "examples" else "inputs"
        printfn "%s" (handler part (File.ReadAllLines(sprintf "%s/day%d.txt" directory day)))
        0 // return an integer exit code
