namespace AoC

module Day8 =

    let rec runToRepeatOrEnd  (instructions : (string * int) [] ) ip (acc: int) =
        try
            let (instruction, arg) = instructions.[ip]
            if instruction = "hlt" then
                ("hlt", acc)
            else
                let newIp, newAcc = match instruction with
                                    | "acc" -> (ip + 1, acc + arg)
                                    | "nop" -> (ip + 1, acc)
                                    | "jmp" -> (ip + arg, acc)
                                    | _ -> invalidArg "instruction" instruction
                Array.set instructions ip ("hlt", 0)
                runToRepeatOrEnd  instructions newIp newAcc
        with
            | :? System.IndexOutOfRangeException -> ("ok", acc)

    let handler part (lines: string seq) =
        let parseLine (line: string) =
            let parts = line.Split(' ');
            (parts.[0], int parts.[1])
        let instructions = Seq.map parseLine lines |> Seq.toArray
        let result =
            if part = One then
                let (_, acc) =  runToRepeatOrEnd  instructions 0 0
                acc
            else
                let rec runToCompletion lastSwapped =
                    let startIndex = lastSwapped + 1
                    let swap  =
                        startIndex + Array.findIndex (fun (inst, _) -> inst = "nop" || inst = "jmp") instructions.[startIndex..]
                    let testInstructions = Array.copy instructions
                    let (swapee, arg) = Array.get testInstructions swap
                    let newInstr = if swapee = "nop" then "jmp" else "nop"
                    Array.set testInstructions swap (newInstr, arg)
                    let (outcome, acc) = runToRepeatOrEnd testInstructions 0 0
                    match outcome with
                    | "ok" -> acc
                    | _ -> runToCompletion swap
                runToCompletion -1
        string result