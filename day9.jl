using ArgParse
using Statistics
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


function parseLine(l)
    [parse(UInt8, d) for d in l]
end

test_suffix = parsed_args["test"] ? "_test" : ""
depths = [parseLine(l) for l in readlines("input/day_9$test_suffix.txt")]
mx = length(depths)
my = length(depths[1])
function getValue(x, y)
    if x <= 0 || x > mx || y <= 0 || y > my
        return typemax(UInt8)
    end
    depths[x][y]
end

sinks = []
for x = 1:mx
    for y = 1:my
        v = getValue(x, y)
        if getValue(x - 1, y) > v && getValue(x + 1, y) > v && getValue(x, y - 1) > v && getValue(x, y + 1) > v
            push!(sinks, (x = x, y = y, v = v))
        end
    end
end

function part1()
    sum(s -> s.v + 1, sinks)
end


function basinsize(sink)
    basin = Set()
    function addtobasin(x, y)
        if (x, y) ∉ basin && getValue(x, y) < 9
            push!(basin, (x, y))
            addtobasin(x - 1, y)
            addtobasin(x + 1, y)
            addtobasin(x, y - 1)
            addtobasin(x, y + 1)
        end
    end
    addtobasin(sink.x, sink.y)
    length(basin)
end

function part2()
    sizes = sort(map(basinsize, sinks))
    s1 = pop!(sizes)
    s2 = pop!(sizes)
    s3 = pop!(sizes)
    s1 * s2 * s3
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
