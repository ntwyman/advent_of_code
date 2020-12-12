namespace AoC

module Day12 =
    let rec normalizeHeading heading =
        if heading < 0 then
            normalizeHeading  (heading + 360)
        else if heading > 359 then
            normalizeHeading (heading - 360)
        else
            heading

    let handler part (entries: string seq) =
        let updateShip (x, y, heading) (move : string) =
            let action = move.[0]
            let amount = int move.[1..]
            match action with
                | 'N' -> (x, y + amount, heading)
                | 'S' -> (x, y - amount, heading)
                | 'E' -> (x + amount, y, heading)
                | 'W' -> (x - amount, y, heading)
                | 'L' ->
                    let newHeading = normalizeHeading (heading - amount)
                    (x, y, newHeading)
                | 'R' ->
                    let newHeading = normalizeHeading (heading + amount)
                    (x, y, newHeading)
                | _ ->
                    match heading with
                        | 0 -> (x, y + amount, heading)
                        | 90 -> (x + amount, y, heading)
                        | 180 -> ( x, y - amount, heading)
                        | _ -> (x - amount, y, heading)
        let (x, y, _) = Seq.fold updateShip (0, 0, 90) entries
        (abs x) + (abs y) |> string