// Learn more about F# at http://docs.microsoft.com/dotnet/fsharp

open System.IO

let rec binSearch target arr =
   match Array.length arr with
     | 0 -> None
     | i -> let middle = i / 2
            match  sign <| compare target arr.[middle] with
              | 0  -> Some(target)
              | -1 -> binSearch target arr.[..middle-1]
              | _  -> binSearch target arr.[middle+1..]

                
let rec findPair numbers sum =
    if Array.length numbers < 2 then
        None
    else
        let first = numbers.[0]
        if first * 2 > sum then
            None
        else
            let rest = numbers.[1..]
            let somePair = binSearch (sum - first) rest
            match somePair with
                | None -> findPair rest sum
                | Some(pair) -> Some(first, pair)

let rec find2020Triple numbers =
    if Array.length numbers < 3 then
        None
    else
        let first = numbers.[0]
        if first > 674 then // 2020 / 3
            printfn "Bailing at %d, %A" first numbers
            None
        else
            let rest = numbers.[1..]
            let someTuple = findPair rest (2020 - first)
            match someTuple with
                | None -> find2020Triple rest
                | Some(second, third) -> Some(first, second, third)

type Part =
    | One
    | Two

let dayOneHandler part lines =
    let sortedNumbers = Seq.map int lines |> Seq.toArray |> Array.sort
    match part with
        | One ->
            let pair = findPair sortedNumbers 2020
            match pair with
                | Some(a, b) -> sprintf "Pair: %d, %d -> %d" a b (a * b)
                | None -> "Day 1.1 failed to find pair"
        | Two ->
            let triple = find2020Triple sortedNumbers
            match triple with
                | Some(a, b, c) -> sprintf "Triple: %d, %d, %d -> %d" a b c (a * b * c)
                | None -> "Day 1.2 failed to find triple"

let countOccurences x = Seq.filter ((=) x) >> Seq.length


let isValidPassword rule (line:string) =
    let parts =  line.Split(" ") |> Seq.toArray
    let minMax = parts.[0].Split('-') |> Seq.map int |> Seq.toArray
    let arg1 = int minMax.[0]
    let arg2 = int minMax.[1]
    let atom = parts.[1].Chars(0)
    let pwd = parts.[2]
    match rule with
        | One ->
            let occurances = countOccurences atom pwd
            occurances >= arg1 && occurances <= arg2
        | Two ->
            (pwd.Chars(arg1 - 1) = atom) <> (pwd.Chars(arg2 - 1) = atom )

let dayTwoHandler part lines =
     Seq.filter (isValidPassword part) lines |> Seq.length |> string

             
let dayThreeHandler part lines =
    // Split map into an array of arrays.
    let hillTile = Seq.map Seq.toArray lines |> Seq.toArray
    let tileWidth = hillTile.[0].Length
    let height = hillTile.Length
    let rec whee right down x y crashes =
        let newY = y + down
        if newY >= height then
            crashes
        else
            let xPrime = x + right
            let newX = if xPrime >= tileWidth then xPrime - tileWidth else xPrime
            let newCrashes = if hillTile.[newY].[newX] = '#' then crashes + 1UL else crashes
            whee right down newX newY newCrashes
    let doWhee right down = whee right down 0 0 0UL
    match part with
        | One -> doWhee 3 1 |> string
        | Two ->
            let oneOne = doWhee 1 1
            let threeOne = doWhee 3 1
            let fiveOne = doWhee 5 1
            let sevenOne = doWhee 7 1
            let oneTwo = doWhee 1 2
            oneOne * threeOne * fiveOne * sevenOne * oneTwo |> string

let getHandler =
    function | 1 -> dayOneHandler
             | 2 -> dayTwoHandler
             | 3 -> dayThreeHandler
             | day -> (fun part _ -> (sprintf "Day %d part %A is not implemented yet" day part))

[<EntryPoint>]  
let main argv =
    let day = 3
    let part = Two
    let test = false

    let handler = getHandler day
    let directory = if test then "examples" else "inputs"
    printfn "%s" (handler part (File.ReadAllLines(sprintf "%s/day%d.txt" directory day)))
    0 // return an integer exit code
