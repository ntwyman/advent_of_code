namespace AoC

module Day19 =

    type Terminal = string
    type Name = string
    type Rule = Choice of Rule list | RList of Rule list | Ref of Name | Term of Terminal


    let parseRuleList (rulelist:string) : Rule =
        let names = rulelist.Trim().Split(" ")
        Array.map (fun (n:string) -> n.Trim() |> Ref) names |> Array.toList |> RList

    let parseInput ((rMap, msgs):Map<Name, Rule> * string list) (input:string) =
        if input.Contains ":" then
            let parts = input.Split(": ")
            let r = if parts.[1].Contains("|") then
                        let choices = parts.[1].Split("|")
                        Choice ((Array.map parseRuleList choices) |> Array.toList)
                    else if parts.[1].Contains('"') then
                        let quoted = parts.[1].Trim()
                        Term quoted.[1..quoted.Length-2]
                    else
                        parseRuleList parts.[1]

            (rMap.Add(parts.[0], r), msgs)
        else if input.Length = 0 then
            (rMap, msgs)
        else
            (rMap, input.Trim() :: msgs)

    let handler part (entries:string seq) =
        let (ruleMap, messages) = Seq.fold parseInput (Map.empty, []) entries
        printfn "%d rules and %d messages" ruleMap.Count messages.Length
        let rec matches rule (expr:string) =
            printfn "Matching %A with %s" rule expr
            // Returns a list of the substrings that match the rule
            match rule with
            | Choice rList ->
                List.collect ( fun r -> matches r expr) rList
            | RList [] -> []
            | RList (head :: tail) ->
                    let start = matches head expr
                    let matchTails used =
                        let l = String.length used
                        start @ (matches (RList tail) expr.[l..])
                    List.collect matchTails start
            | Ref refName -> matches ruleMap.[refName] expr
            | Term terminal ->
                if expr.StartsWith terminal then
                    [terminal]
                else
                    []
        let checkMatches msg =
            let ms = matches ruleMap.["0"] msg
            printfn "%s had %d matches" msg ms.Length
            List.exists (fun  mtch -> msg = mtch) ms
        //
        let m1 = matches ruleMap.["0"] messages.Head
        m1.Length |> string
        