namespace AoC
module Day2 =
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

    let handler part lines =
            Seq.filter (isValidPassword part) lines |> Seq.length |> string