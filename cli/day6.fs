namespace AoC



module Day6 =

    type CustomsDeclaration = Set<char>
    type DeclarationAccumulator = {
        Declarations: CustomsDeclaration list;
        Current : CustomsDeclaration list;
    }

    let handler part (entries: string seq) =

        let finishGroup acc =
            let current =
                if part = One then
                    Set.unionMany acc.Current
                else
                    Set.intersectMany acc.Current
            current :: acc.Declarations
        let declarationsFolder acc (entry: string) =
            match String.length entry with
            | 0 ->
                 { Declarations = finishGroup acc; Current = []; }
            | _ ->
                 { Declarations = acc.Declarations; Current = Set(entry) :: acc.Current; }                 
        let declarations = Seq.fold declarationsFolder {Declarations = []; Current= []} entries |> finishGroup
        List.map Set.count declarations |> List.sum |> string
