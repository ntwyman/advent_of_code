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
        List.map (fun offset -> off cube offset) neighborhood

    type ActiveMap = Set<Cube>

    let setActive cube source = Set.add cube source

    let isAcive cube source = Set.contains cube source

    let setInactive cube source = Set.remove cube source


