namespace AoC

module Day17 =
    type Cube = int * int * int
    type Offset = int * int * int
    let inline off ((px, py, pz):Cube) ((ox, oy, oz):Offset) = Cube(px + ox, py + oy, pz + oz)

    let neighborhood =
        [Offset(-1, -1, -1); Offset(-1, 0, -1); Offset(-1,  1, -1);
        Offset( 0, -1, -1); Offset( 0, 0, -1); Offset( 0, 1, -1);
        Offset( 1, -1, -1); Offset( 1, 0, -1); Offset( 1, 1, -1);

        Offset(-1, -1, 0); Offset(-1, 0, 0); Offset(-1,  1, 0);
        Offset( 0, -1, 0);                   Offset( 0, 1, 0);
        Offset( 1, -1, 0); Offset( 1, 0, 0); Offset( 1, 1, 0);

        Offset(-1, -1, 1); Offset(-1, 0, 1); Offset(-1,  1, 1);
        Offset( 0, -1, 1); Offset( 0, 0, 1); Offset( 0, 1, 1);
        Offset( 1, -1, 1); Offset( 1, 0, 1); Offset( 1, 1, 1);]

    let neighbors (cube:Cube) =
        List.map (fun offset -> off cube offset) neighborhood |> Set

    type ActiveMap = Set<Cube>

    let rowFolder (activityMap:ActiveMap) (row:int, rowData:string) =
        let lineFolder (activityAcc:ActiveMap) (col:int, cubeState:char) =
            if cubeState = '#' then
                Set.add (col, row, 0) activityAcc
            else
                activityAcc
        Seq.indexed rowData |> Seq.fold lineFolder activityMap

    let gatherNeighbors (activityMap:ActiveMap) =
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

    let handler part (input:string seq) =
        let activityMap = Seq.indexed input |> Seq.fold rowFolder Set.empty
        let booted = Seq.fold (fun map _ -> cycle map) activityMap (seq {1..6})
        Set.count booted |> string