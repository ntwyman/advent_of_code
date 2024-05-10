namespace AoC

module Day17 =
    type Cube = int * int * int * int


    let handler part (input:string seq) =
        let neighbors ((x, y, w, z):Cube) =
            let n = seq { for ix = (x - 1) to (x + 1) do
                            for iy = (y - 1) to (y + 1) do
                                for iz = (z - 1) to (z + 1) do
                                    let isOrig = (x = ix) && ( y = iy) && (z = iz)
                                    if part = One then
                                        if not isOrig then yield (ix, iy, 0, iz)
                                    else
                                        for iw = (w - 1) to ( w + 1) do
                                            if w <> iw || not isOrig then yield (ix, iy, iw, iz)
            }
            Set n

        let rowFolder activityMap (row:int, rowData:string) =
            let lineFolder activityAcc (col:int, cubeState:char) =
                if cubeState = '#' then
                    Set.add (col, row, 0, 0) activityAcc
                else
                    activityAcc
            Seq.indexed rowData |> Seq.fold lineFolder activityMap

        let gatherNeighbors activityMap =
            let addNeighbors acc cube =
                acc + neighbors cube
            Set.fold addNeighbors Set.empty activityMap

        let cycle activityMap =
            let underConsideration = gatherNeighbors activityMap
            let checkNeighbors newActivity cube =
                let activeNeighbors = Set.intersect activityMap (neighbors cube) |> Set.count
                if Set.contains cube activityMap then // Currently active
                    if activeNeighbors = 2 || activeNeighbors = 3 then
                        Set.add cube newActivity
                    else
                        newActivity
                else // Not currently active
                    if activeNeighbors = 3 then
                        Set.add cube newActivity
                    else
                        newActivity
            Set.fold checkNeighbors Set.empty underConsideration


        let activityMap = Seq.indexed input |> Seq.fold rowFolder Set.empty
        let booted = Seq.fold (fun map _ -> cycle map) activityMap (seq {1..6})
        Set.count booted |> string