namespace AoC

module Day12 =
    let rec normalizeHeading heading =
        if heading < 0 then
            normalizeHeading  (heading + 360)
        else if heading > 359 then
            normalizeHeading (heading - 360)
        else
            heading

    let parseMove (move:string) =
        (move.[0], int move.[1..])

    let updateShip (x, y, heading) (move : string) =
        let action, amount = parseMove move
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

    let updateShipWithWaypoint (x, y, wX, wY) (move : string) =
        let action, amount = parseMove move
        match action with
        | 'N' -> (x, y, wX, wY + amount)
        | 'S' -> (x, y, wX, wY - amount)
        | 'E' -> (x, y, wX + amount, wY)
        | 'W' -> (x, y, wX - amount, wY)
        | 'L' ->
            match amount with
            | 90 -> (x, y,  -wY, wX)
            | 180 -> (x, y, -wX, -wY)
            | 270 -> (x, y, wY, -wX)
            | _ -> invalidArg "rotation" move
        | 'R' ->
            match amount with
            | 90 -> (x, y, wY, -wX)
            | 180 -> (x, y, -wX, -wY)
            | 270 -> (x, y,  -wY, wX)
            | _ -> invalidArg "rotation" move
        | 'F' ->
            ( x + (wX * amount), y + (wY * amount), wX, wY)
        | _ -> invalidArg "unknown" move

    let handler part (entries: string seq) =
        let (x, y) =    if part = One then 
                            let (x, y, _) = Seq.fold updateShip (0, 0, 90) entries
                            (x, y)
                        else
                            let (x, y, _, _) = Seq.fold updateShipWithWaypoint (0, 0, 10, 1) entries
                            (x, y)
        (abs x) + (abs y) |> string
