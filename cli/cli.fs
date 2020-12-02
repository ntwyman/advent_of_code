// Learn more about F# at http://docs.microsoft.com/dotnet/fsharp

open System.IO

let rec find2020Pair numbers =
    match numbers with
    | a :: rest ->
        try
            (a, List.find (fun b -> a + b = 2020) rest)
        with
            | :? System.Collections.Generic.KeyNotFoundException -> find2020Pair rest
    | _ -> (0, 0)


[<EntryPoint>]  
let main argv =
    let lines = File.ReadAllLines(@"inputs/day1.txt")
    let numbers = Seq.map int lines |> Seq.toList
    let (a, b) = find2020Pair numbers
    printfn "%d, %d" a b 
    0 // return an integer exit code