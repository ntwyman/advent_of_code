namespace AoC

module Day11 =
    type Square = Chair | Person | Floor
    type WaitingRoom =
        {
            Squares: Square[];
            Width: int;
            Height: int;
        }

    let waitingRoom (entries: string seq) =
        let width = Seq.head entries |> String.length
        let height = Seq.length entries
        let charToSquare char =
            match char with
            | 'L' -> Chair
            | _ -> Floor
        let squares = Seq.concat entries |> Seq.map charToSquare |> Seq.toArray
        { Squares=squares; Width=width; Height=height;}

    let get x y room =
        if x < 0 || x >= room.Width || y < 0 || y >= room.Height then
            Floor
        else
            room.Squares.[ x + (y * room.Width)]

    let countNeighbors x y room =
        let check = [ (x - 1, y - 1); (x  , y - 1); (x + 1, y - 1);
                      (x - 1, y    );               (x + 1, y    );
                      (x - 1, y + 1); (x  , y + 1); (x + 1, y + 1)]
        let isNeighbor (x, y) = if Person = get x y room then 1 else 0
        List.map isNeighbor check |> List.sum

    let updateRoom room =
        printfn "Update Room"
        let squares = seq { for y = 0 to room.Height - 1 do
                                for x = 0 to room.Width - 1 do
                                    let current = get x y room
                                    if current = Floor then
                                        yield None
                                    else
                                        let n = countNeighbors x y room
                                        if current = Chair && n = 0 then
                                            yield Some Person
                                        else
                                            if current = Person && n >= 4 then
                                                yield Some Chair
                                            else
                                                yield None
                            }
        if Seq.exists Option.isSome squares then
            let updateSquare square someResult =
                match someResult with
                    | Some (s) -> s
                    | None -> square
            let newSquares = Seq.map2 updateSquare room.Squares squares |> Seq.toArray
            true, { room with Squares = newSquares; }
        else
            false, room

    let countPeople room =
        Array.map (fun square -> if square = Person then 1 else 0) room.Squares |> Seq.sum

    let handler part (entries: string seq) =
        let rec updateUntilStable room =
            let changed, rs = updateRoom room
            if changed then
                updateUntilStable rs
            else
                rs
        waitingRoom entries |> updateUntilStable |> countPeople |> string
