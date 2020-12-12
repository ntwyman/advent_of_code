namespace AoC

module Day11 =
    type Square = Chair | Person | Floor
    type WaitingRoom =
        {
            Squares: Square[];
            Neighbors: (int * int) list []
            Width: int;
            Height: int;
        }

    let getIndex x y room =
        if x < 0 || x >= room.Width || y < 0 || y >= room.Height then
            None 
        else
            Some (x + (y * room.Width))

    let get x y room =
        match getIndex x y room with
            | Some idx -> Some room.Squares.[idx]
            | _ -> None

    let getNeighbors x y room = 
        match getIndex x y room with
            | Some idx -> room.Neighbors.[idx]
            | _ -> invalidArg "neighborIndex" (string (x,y))

    let visibleSeats part room =
        let rec firstChair x y dX dY =
            let nextX = x + dX
            let nextY = y + dY
            let nextInSight = get nextX nextY room
            if nextInSight = Some Floor then
                if part = One then
                    None
                else
                    firstChair nextX nextY dX dY
            else
                match nextInSight with
                    | Some Chair -> Some (nextX, nextY)
                    | _ -> None

        let visibleNeighbors x y =
            let seat = get x y room
            if seat = Some Floor then
                []
            else
                let foldNeighbors list (dx, dY) =
                    let location = firstChair x y dx dY
                    match location with
                    | Some (chairX, chairY) -> (chairX, chairY) :: list
                    | _ -> list
                List.fold foldNeighbors []  [(-1, -1); ( 0, -1); ( 1, -1); (-1,  0);( 1,  0); (-1,  1); ( 0,  1); ( 1,  1);]

        seq { for y = 0 to room.Height - 1 do
                for x = 0 to room.Width - 1 do
                    yield visibleNeighbors x y} |> Seq.toArray

    let waitingRoom part (entries: string seq) =
        let width = Seq.head entries |> String.length
        let height = Seq.length entries
        let charToSquare char =
            match char with
            | 'L' -> Chair
            | _ -> Floor
        let squares = Seq.concat entries |> Seq.map charToSquare |> Seq.toArray
        let bareRoom = { Squares=squares; Width=width; Height=height; Neighbors= [| |];}
        { bareRoom with Neighbors = visibleSeats part bareRoom;}
 
    let countNeighbors x y room =
        let check = getNeighbors x y room
        let isNeighborOccupied (x, y) = if Some Person = get x y room then 1 else 0
        Seq.map isNeighborOccupied check |> Seq.sum

    let updateRoom part room =
        printfn "Update Room"
        let squares = seq { for y = 0 to room.Height - 1 do
                                for x = 0 to room.Width - 1 do
                                    let current = get x y room
                                    if current = Some Floor then
                                        yield None
                                    else
                                        let n = countNeighbors x y room
                                        if current = Some Chair && n = 0 then
                                            yield Some Person
                                        else
                                            let limit = if part = One then 4 else 5
                                            if current = Some Person && n >= limit then
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
            let changed, rs = updateRoom part room
            if changed then
                updateUntilStable rs
            else
                rs
        waitingRoom part entries |> updateUntilStable |> countPeople |> string
