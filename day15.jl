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

test_suffix = parsed_args["test"] ? "_test" : ""
input = readlines("input/day_15$test_suffix.txt")
input_x = length(input[1])
input_y = length(input)

function risk(cave)
    (sx, sy) = size(cave)
    risks = fill(typemax(UInt16), sx, sy)
    risks[1,1] = 0
    function update_risk(x, y)
        codb = cave[x, y]
        risk = risks[x, y]
        path_risk = risk - codb
        if x > 1 && risks[x - 1, y] < path_risk
            path_risk = risks[x - 1, y]
        end
        if y > 1 && risks[x, y - 1] < path_risk
            path_risk = risks[x, y - 1 ]
        end
        if x < sx && risks[x + 1, y] < path_risk
            path_risk = risks[x+1, y]
        end
        if y < sy && risks[x, y+1] < path_risk
            path_risk = risks[x, y + 1]
        end
        path_risk += codb
        if path_risk < risk
            risks[x, y] = path_risk
            return true
        end
        false
    end

    while true
        updated = false
        for x in 1: sx
            for y in 1: sy
                if update_risk(x, y)
                    updated = true
                end
            end
        end
        if !updated
            break;
        end
    end
    risks[sx, sy]
end

function populate_input!(cave)
    for (y, l) in enumerate(input)
        for (x, v) in enumerate([parse(UInt8, c) for c in l])
            cave[x, y] = v
        end
    end
end

function part1()
    cave = Array{UInt8}(undef, input_x, input_y)
    populate_input!(cave)
    risk(cave)
end

function part2()
    cave = Array{UInt8}(undef, input_x * 5, input_y * 5)
    populate_input!(cave)
    for tile_x in 0:4
        offset_x = input_x * tile_x
        for tile_y in 0:4
            offset_y = input_y * tile_y
            if tile_x ==0 && tile_y == 0
                continue
            end
            for x in 1: input_x
                for y in 1: input_y
                    c = cave[x,y] + tile_x + tile_y
                    while c > 9
                        c -= 9
                    end
                    cave[offset_x + x, offset_y + y] = c
                end
            end
        end
    end
    risk(cave)
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
