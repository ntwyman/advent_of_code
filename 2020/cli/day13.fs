namespace AoC

module Day13 =
    let numType = int32 
    let firstStamp (busList:string) =
        let input = busList.Split(',') |> Seq.toArray
        let constraints = seq { for i = 0 to input.Length - 1 do
                                    if input.[i] <> "x" then
                                        yield (i, numType input.[i]) }
        let calcTModId (tPlus, bus) =
            let rec fixModulo m =
                if m < 0 then
                    fixModulo (m + bus)
                else
                    m
            if tPlus <> 0 then
                (bus, fixModulo (bus - tPlus))
            else
                (bus, 0)

        let tModulo = Seq.map calcTModId constraints |>
                            Seq.sortBy (fun (bus, _) -> bus)

        let getToModulo (currentT, currentInc) (bus, tMod) =
            let bigBus = uint64 bus
            let bigMod = uint64 tMod
            let rec findNewT t =
                let nowMod = t % bigBus
                if nowMod <> bigMod then
                    findNewT (t + currentInc)
                else
                    t
            (findNewT currentT, currentInc * bigBus)
        let (firstT, _) = Seq.fold getToModulo (0UL, 1UL) tModulo
        firstT

    let handler part (entries: string seq) =
        let time = Seq.head entries |> int32
        let busString = Seq.tail entries |> Seq.head

        if part = One then
            let busIds = busString.Split(',') |> Seq.filter (fun id -> id <> "x") |> Seq.map int32
            let timeToWait busId =
                let timeSince = time % busId
                busId - timeSince, busId
            let waits = Seq.map timeToWait busIds |> Seq.sortBy (fun (wait, _) -> wait)
            let wait, id = Seq.head waits
            wait * id |> string
        else
            firstStamp busString |> string



