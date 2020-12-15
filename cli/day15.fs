namespace AoC

module Day15 =


 
    let handler part (entries:string seq) =
        let lastTurn = if part = One then 2019 else 29999999
        let whatComes2020th numbers =
             let initialNums = Seq.indexed numbers
             let primePump (lastSeen, turnMap:Map<int, int>) (idx, num) =
                 (num, turnMap.Add(num, idx + 1))
             let lastSeen, turnMap = Seq.fold primePump (0, Map.empty) initialNums
             
             let rec takeTurns turn lastSeen turnMap = 
                 let lastTime = Map.tryFind lastSeen turnMap
                 let shout = match lastTime with
                             | Some (t) -> turn - t
                             | _ -> 0
                 if (turn &&& 0xfffff) = 0 then printfn "%d - %d" turn shout

                 if turn = lastTurn then
                     shout
                 else
                     takeTurns (turn + 1) shout (turnMap.Add(lastSeen, turn))
             takeTurns (Seq.length initialNums) lastSeen (turnMap.Remove lastSeen)

        whatComes2020th ((Seq.head entries).Split(",") |> Seq.map int) |> string