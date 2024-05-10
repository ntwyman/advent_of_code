using ArgParse


s = ArgParseSettings()
@add_arg_table s begin
    "--part2"
    help = "Do part 2"
    action = :store_true
    "--test"
    help = "Run test data"
    action = :store_true
end
parsed_args = parse_args(ARGS, s)

mutable struct SNumber
    value :: Union{UInt32, Tuple{SNumber, SNumber}}
end

SNumber(n1::SNumber, n2::SNumber) = SNumber((n1,n2))
SNumber(n1::UInt32, n2::UInt32) = SNumber((SNumber(n1), SNumber(n2)))

function iscompound(n::SNumber)
    isa(n.value, Tuple)
end

function Base.show(io::IO, n::SNumber)
    if iscompound(n)
        print(io, "[")
        Base.show(io, n.value[1])
        print(io, ',')
        Base.show(io, n.value[2])
        print(io, ']')
    else
        print(io, n.value::UInt32)
    end
end

function magnitude(n::SNumber)
    if iscompound(n)
        magnitude(n.value[1]) * 3 + magnitude(n.value[2]) * 2
    else
        n.value
    end
end

function parseNumber(s)
    function parseSide(s)
        c = popfirst!(s)
        if c == '['
            v = parseNumber(s)
        else
            v = SNumber(parse(UInt32, c))
        end
        v
    end
    left = parseSide(s)
    @assert popfirst!(s) == ','
    right = parseSide(s)
    @assert popfirst!(s) == ']'
    SNumber((left, right))
end

function parseLine(l)
    s = Iterators.Stateful(l)
    if popfirst!(s) != '['
        throw(ArgumentError("number starts wit '['"))
    end
    value = parseNumber(s)
    @assert isempty(s)
    value
end

test_suffix = parsed_args["test"] ? "_test" : ""
input = [parseLine(l) for l in readlines("input/day_18$test_suffix.txt")]

function prop_right(n::SNumber, val::UInt32)
    if val == 0xffffffff
        return n
    elseif !iscompound(n)
        return SNumber(n.value + val)
    else
        return SNumber(prop_right(n.value[1], val), n.value[2])
    end
end

function prop_left(n::SNumber, val::UInt32)
    if val == 0xffffffff
        return n
    elseif !iscompound(n)
        return SNumber(n.value+val)
    else
        return SNumber(n.value[1],prop_left(n.value[2], val))
    end
end

function explode(n::SNumber) :: Tuple{Bool, SNumber}
    boom = false
    function do_explode(n, dep) :: Tuple{Tuple{UInt32, UInt32}, SNumber}
        if !iscompound(n)
            return ((0xffffffff,0xffffffff), n)
        elseif dep <= 3
            lex, ln = do_explode(n.value[1], dep+1)
            if boom  # something down the left branch exploded
                return ((lex[1], 0xffffffff), SNumber(ln, prop_right(n.value[2], lex[2])))
            else
                rex, rn = do_explode(n.value[2],dep+1)
                return ((0xffffffff, rex[2]), SNumber(prop_left(ln, rex[1]), rn))
           end
        else
            boom = true
            return ((n.value[1].value, n.value[2].value), SNumber(zero(UInt32)))
        end
    end
    ex, res = do_explode(n, 0)
    (boom, res)
end

function split(n::SNumber) :: Tuple{Bool, SNumber}
    splat = false
    function do_split(n::SNumber)
        if iscompound(n)
            ln = do_split(n.value[1])
            if splat
                return SNumber(ln, n.value[2])
            else
                return SNumber(ln, do_split(n.value[2]))
            end
        elseif n.value >= 10
            splat = true
            return SNumber(div(n.value,UInt32(2)), div(n.value+UInt32(1), UInt32(2)))
        else
            return n
        end
    end
    val = do_split(n)
    splat, val
end

function addsnap(n1::SNumber, n2::SNumber) ::SNumber
    result = SNumber((n1, n2))
    while true
        (boom, result) = explode(result)
        if boom
            continue
        end
        (splat, result) = split(result)
        if !splat
            break
        end
    end
    result
end


function part1()
    sum = foldl(addsnap, input)
    magnitude(sum)
end

function part2()
    maxmag = 0
    l = length(input)
    for i in 1:l
        for o in 1:l
            if i == o
                continue
            end
            m = magnitude(addsnap(input[i],input[o]))
            maxmag = max(m, maxmag)
        end
    end
    maxmag
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
