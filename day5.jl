using ArgParse
using DataFrames

s=ArgParseSettings()
@add_arg_table s begin
    "--part2"
        help="Do part 2"
        action=:store_true
    "--test"
        help="Run test data"
        action=:store_true
end
parsed_args = parse_args(ARGS, s)



function parseend(endstr)
    coords = split(endstr, ",")
    (x=parse(UInt32, coords[1]), y=parse(UInt32, coords[2]))
end

function parseline(line)
    ends = split(line, " -> ")
    start = parseend(ends[1])
    stop = parseend(ends[2])
    (start=start, stop=stop)
end

function isortho(line)
    (line.start.x == line.stop.x || line.start.y == line.stop.y)
end

function getdelta(start, stop)
    if start > stop
        delta = -1
    elseif start < stop
        delta = 1
    else
        delta = 0
    end
    delta
end

function addpoints!(df, l)
    dx = getdelta(l.start.x, l.stop.x)
    dy = getdelta(l.start.y, l.stop.y)
    point = l.start
    while true
        push!(df, point)
        if point == l.stop
            break
        end
        point = (x=point.x+dx, y=point.y+dy)
    end
end

test_suffix = parsed_args["test"] ? "_test" : ""
endpoints = [parseline(line) for line in eachline("input/day_5$test_suffix.txt")]
if parsed_args["part2"]
    lines = endpoints
else
    lines = filter(isortho, endpoints)
end

df = DataFrame(x=UInt32[], y=UInt32[])
foreach(l -> addpoints!(df, l), lines)
counts = combine(groupby(df, [:x, :y]), nrow => :count)
answer = nrow(filter(:count => >=(2), counts))

println("The answer is: $answer")
