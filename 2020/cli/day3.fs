namespace AoC
module Day3 = 
    let handler part lines =
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
