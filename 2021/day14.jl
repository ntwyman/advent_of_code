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

test_suffix = parsed_args["test"] ? "_test" : ""

input = readlines("input/day_14$test_suffix.txt")
template = input[1]

function addcount!(d, k, n)
    c = get(d, k, 0)
    d[k] = c + n
end

paircounts = Dict{String,UInt128}()
for place = 1:length(template)-1
    pair = template[place:place+1]
    addcount!(paircounts, pair, 1)
end


rules = Dict{String,Tuple{String,String}}()
for l in input[3:end]
    r = split(l, " -> ")
    rules[r[1]] = (String([r[1][1], r[2][1]]), String([r[2][1], r[1][2]]))
end

function process(counts)
    newcounts = Dict{String,UInt128}()
    for (k, v) in counts
        product = rules[k]
        addcount!(newcounts, product[1], v)
        addcount!(newcounts, product[2], v)
    end
    newcounts
end

function doit(n)
    counts = paircounts
    for _ = 1:n
        counts = process(counts)
    end
    lettercounts = Dict{Char,UInt128}([template[end] => 1,])
    for (k, v) in counts
        addcount!(lettercounts, k[1], v)
    end

    mn = typemax(UInt128)
    mx = 0
    for v in values(lettercounts)
        mn = min(mn, v)
        mx = max(mx, v)
    end
    return mx - mn
end

function part1()
    doit(10)
end

function part2()
    doit(40)
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
