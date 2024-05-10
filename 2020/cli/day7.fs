namespace AoC
open System.Text.RegularExpressions

module Day7 =
    type Quantity = {
        Bag: string
        Count: int
    }

    let parseQuantity quantity =
        let m = Regex.Match(quantity, @"^(\d*) (.*) bag(s?)$")
        if not m.Success then invalidArg "quantity" quantity
        { Bag = m.Groups.[2].Value; Count = (int m.Groups.[1].Value); }

    let parseRule  rule =
        let m = Regex.Match(rule, @"^(.*) bags contain (.*)\.$")
        if not m.Success then invalidArg "rule" rule
        let bagType = m.Groups.[1].Value
        let contents = m.Groups.[2].Value
        if contents = "no other bags" then
            (bagType, [])
        else
            let contentsSeq = contents.Split(", ")
            let quantitiesSeq = Seq.map parseQuantity contentsSeq
            ( bagType, Seq.toList quantitiesSeq)

    let containerFolder (acc: Map<string, Set<string>>) (bagType, quantities) =
        let addContainer (ac: Map<string, Set<string>>)  quantity =
            ac.Add(quantity.Bag, if ac.ContainsKey quantity.Bag then
                                    ac.[quantity.Bag].Add bagType
                                 else
                                    Set.singleton bagType)
        match quantities with
            | [] -> acc
            | _ -> List.fold addContainer acc quantities


    let handler part (entries: string seq) =
        let rules = Seq.map parseRule entries
        if part = One then
            let containedIn = Seq.fold containerFolder Map.empty rules
            let rec inAll bag =
                if containedIn.ContainsKey(bag) then
                    let bc = containedIn.[bag]
                    if 0 = bc.Count then
                        Set.singleton bag
                    else
                        Set.union (Set.singleton bag) (Set.map inAll bc |> Set.unionMany)
                else
                    Set.singleton bag
            (inAll "shiny gold" |> Set.count) - 1 |> string
        else
            let contents = Map(rules)
            let rec contains quantity =
                let inside = contents.[quantity.Bag]
                match inside with
                | [] -> quantity.Count
                | lst -> quantity.Count * (1 +  (List.map contains lst |> List.sum))
            (contains { Bag="shiny gold"; Count=1;}) - 1  |> string