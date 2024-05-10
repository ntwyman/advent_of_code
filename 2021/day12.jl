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
corridors = [split(l, "-") for l in readlines("input/day_12$test_suffix.txt")]
neighbors = Dict()
function addneighbors(corridor)
    function from(cave1, cave2)
        exits = get(neighbors, cave1, [])
        push!(exits, cave2)
        neighbors[cave1] = exits
    end
    from(corridor[1], corridor[2])
    from(corridor[2], corridor[1])
    neighbors
end
foreach(addneighbors, corridors)

function findpaths(cave, paths, path)
    for c in neighbors[cave]
        if islowercase(c[1]) && occursin(c, path)
            continue
        end
        if c == "end"
            push!(paths, path)
        else
            findpaths(c, paths, "$path-$c")
        end
    end
    paths
end

function part1()
    length(findpaths("start", [], "start"))
end

struct State
    path::String
    smalldone::Bool
end

function findpaths2(cave, state)
    pathsfound = 0
    for c in neighbors[cave]
        smalldone = state.smalldone
        if islowercase(c[1]) && occursin(c, state.path)
            if smalldone || c == "start"
                continue
            else
                smalldone = true
            end
        end
        if c == "end"
            pathsfound += 1
        else
            pathsfound += findpaths2(c, State("$state.path-$c", smalldone))
        end
    end
    pathsfound
end
function part2()
    findpaths2("start", State("start", false))
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
