namespace AoC

module Day18 =
    type NumberType = uint64
    type Operator = Mul | Plus
    type Token = Number of NumberType | Op of Operator | Open | Close

    let rec tokens (expr:string) : Token seq =
        seq {
            match expr.[0] with
                | '+' -> yield Op Plus
                | '*' -> yield Op Mul
                | '(' -> yield Open
                | ')' -> yield Close
                | x when x>='0' && x <= '9' -> yield Number ( uint64 (int x - int '0'))
                | _ -> ()
            if String.length expr > 1 then
                yield! tokens expr.[1..]
        }

    type State = SOE | LHS | OP
    type Eval =
        {
            S: State;
            Op: Operator;
            LeftVal: NumberType;
            MulStack: NumberType list;
            EvalStack: Eval list;

        }

    let handler part (input:string seq) =
        let endExpression eval =
            if List.isEmpty eval.MulStack then
                eval.LeftVal
            else
                eval.LeftVal * List.reduce (*) eval.MulStack
        let tokenHandler eval token =
            match token with
            | Number n ->
                match eval.S with
                | SOE ->
                    { eval with S=LHS; LeftVal=n;}
                | LHS -> invalidArg "Number after number"  "oops"
                | OP ->
                    let res = match eval.Op with
                                | Plus -> n + eval.LeftVal
                                | Mul -> n * eval.LeftVal
                    { eval with S=LHS; LeftVal = res;}
            | Op oper ->
                match eval.S with
                | SOE | OP -> invalidArg "operator out of place" (string oper)
                | LHS ->
                    if part = One || oper = Plus then
                        { eval with S=OP; Op=oper;}
                    else
                        { eval with S=SOE; MulStack = eval.LeftVal :: eval.MulStack; }
            | Open ->
                match eval.S with
                | LHS -> invalidArg "OParens after number" "oops"
                | SOE | OP ->
                    { eval with S=SOE; MulStack = []; EvalStack = eval :: eval.EvalStack}
            | Close ->
                match eval.S with
                | SOE -> invalidArg "CParens on empty expression" "oops"
                | OP -> invalidArg "CParens after operator" "oops"
                | LHS ->
                    if List.isEmpty eval.EvalStack then invalidArg "Mismatched CPARENS" "oops"
                    let value = endExpression eval
                    let oldEval = eval.EvalStack.Head
                    let res = if oldEval.S = SOE then
                                value
                              else
                                match oldEval.Op with
                                        | Plus -> value + oldEval.LeftVal
                                        | Mul -> value * oldEval.LeftVal
                    { oldEval with S=LHS; LeftVal = res;}

        let evaluate (expr:string) =
            let tokenSeq = tokens expr
            let endEval = Seq.fold tokenHandler { S=SOE; Op=Plus; LeftVal=0UL; MulStack=[]; EvalStack=[];} tokenSeq
            let res = endExpression endEval
            printfn "%s = %d" expr res
            res

        Seq.map evaluate input |> Seq.sum |> string

        