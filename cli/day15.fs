namespace AoC

module Day15 =


    let whatComes2020th numbers =
        let initialNums = Seq.indexed numbers
        let primePump (lastSeen, turnMap:Map<int, int>) (idx, num) =
            printfn "%d - %d" (idx + 1) num
            (num, turnMap.Add(num, idx + 1))
        let lastSeen, turnMap = Seq.fold primePump (0, Map.empty) initialNums
        let rec takeTurns turn lastSeen turnMap = 
            let lastTime = Map.tryFind lastSeen turnMap
            let shout = match lastTime with
                        | Some (t) -> turn - t
                        | _ -> 0
            printfn "%d - %d" turn shout

            if turn = 2020 then
                shout
            else
                takeTurns (turn + 1) shout (turnMap.Add(shout, turn))
        takeTurns (1 + Seq.length initialNums) lastSeen turnMap
