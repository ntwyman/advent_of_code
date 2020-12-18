namespace AoC

module Day16 =
    type Range =
        {
            Min: int;
            Max: int;
        }
    type ValidValues =
        {
            Lower: Range;
            Upper: Range;
        }

    type Data = 
        {
            Fields: Map<string, ValidValues>
            MyTicket: int seq
            NearbyTickets: int seq list
        }

    type InputState = Fields | Mine | Nearby

    let parseRange (rangeString:string) =
        let minMax = rangeString.Split("-")
        { Min = (int minMax.[0]); Max = (int minMax.[1]);}

    let parseFieldLine data (line:string) =
        if line.Trim().Length = 0 then
            (Mine, data)
        else
            let nameValue = line.Split(": ")
            let name = nameValue.[0]
            let ranges = nameValue.[1].Split(" or ")
            let valid = { Lower = parseRange ranges.[0]; Upper = parseRange ranges.[1]; }
            let newFields = data.Fields.Add(name, valid)
            ( Fields, {data with Fields=newFields})

    let parseMyTicket data (line:string) =
        if line.Trim().Length = 0 then 
            (Nearby, data)
        else if line = "your ticket:" then
            (Mine, data)
        else
            let fields = line.Split(",") |> Seq.map int
            (Mine, { data with MyTicket=fields;})


    let parseNearbyTickets data (line:string) =
        if line = "nearby tickets:" then
            (Nearby, data)
        else
            let fields = line.Split(",") |> Seq.map int
            let newTickets = fields :: data.NearbyTickets
            (Nearby, {data with NearbyTickets=newTickets;})

    let dataFolder (state, data:Data) (line:string) =
        match state with
            | Fields ->
                parseFieldLine data line
            | Mine ->
                parseMyTicket data line
            | _ ->
                parseNearbyTickets data line

    let overLap range1 range2 =
        if (range1.Max + 1) >= range2.Min && (range2.Max + 1) >= range1.Min then
            Some {Min=(min range1.Min range2.Min); Max=max range1.Max range2.Max;}
        else
            None

    let rec mergeRange (range:Range) (ranges: Range list) =
        if List.isEmpty ranges then
            [range;]
        else
            let h = ranges.Head
            let t = ranges.Tail
            match overLap range h with
            | Some newR -> mergeRange newR t
            | _ -> h :: mergeRange range t

    let foldRanges (validRanges: Range list) _ (validValues: ValidValues) =
        let withMin = mergeRange validValues.Lower validRanges
        mergeRange validValues.Upper withMin

    let isValidField value fieldName data =
        let isInRange range =
            value >= range.Min && value <= range.Max
        let vv = data.Fields.[fieldName]
        isInRange vv.Lower || isInRange vv.Upper

    // At thi point we have a sequence pf the fields
    // and for each field a list of the possible names.
    // Each name can only appear once. So, if we have a singleton
    // we know that's the right one and can remove it from other fields.
    let rec reduceFieldNames (names:string seq seq) =
        let accountedFor = Seq.filter (fun opt -> (1 = Seq.length opt)) names |> Seq.map Seq.head
        if Seq.length accountedFor = Seq.length names then
            accountedFor
        else
            let removeAccountedFor (options: string seq) =
                if 1 = Seq.length options then
                   options
                else
                    Seq.filter (fun n -> Seq.contains n accountedFor |> not) options 
            Seq.map removeAccountedFor names |> reduceFieldNames

    let handler part (entries:string seq) =
        let (_, data) = Seq.fold dataFolder (Fields , {Fields=Map.empty; MyTicket=[]; NearbyTickets=[];}) entries
        let ranges = Map.fold foldRanges [] data.Fields
        let impossibleField value =
            List.forall (fun range -> value < range.Min || value > range.Max) ranges
        if part = One then
            let allFields = Seq.concat data.NearbyTickets
            let invalidFields = Seq.filter impossibleField allFields
            Seq.sum invalidFields |> string
        else
            let hasValidFields ticketFields =
                Seq.forall (fun f -> impossibleField f |> not) ticketFields
            let validNearBy = List.filter hasValidFields data.NearbyTickets
            let fieldNames = data.Fields |> Map.toSeq |> Seq.map fst
            let options = Seq.replicate (Seq.length data.MyTicket) fieldNames
            let pareFieldOptions (value,fieldNames) =
                let filtered = Seq.filter (fun fieldName -> isValidField value fieldName data) fieldNames
                filtered
            let pareOptions (opt:string seq seq) (nearByTicket: int seq) =
                Seq.zip nearByTicket opt |> Seq.map pareFieldOptions
            let possibleFieldNames = Seq.fold pareOptions options validNearBy
            let fieldNames = reduceFieldNames possibleFieldNames
            let filterDeparturesFields ((name:string), _) =
                name.StartsWith("departure")
            let depFields = Seq.zip fieldNames data.MyTicket |> Seq.filter filterDeparturesFields
            depFields |> Seq.map snd |> Seq.reduce (*) |> string
            
