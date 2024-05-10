namespace AoC

type Part =
    | One
    | Two

type Handler = Part -> string seq -> string
