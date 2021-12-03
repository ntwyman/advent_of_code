using ArgParse

s=ArgParseSettings()
@add_arg_table s begin
    "--part2"
        help="Do part 2"
        action=:store_true
end
parsed_args = parse_args(ARGS, s)


function part1(moves)
    d = 0
    x = 0
    for (dir, amount) in moves
        if dir == "forward"
            x += amount
        elseif  dir == "down"
            d += amount
        else
            d -= amount
        end
    end
    d * x
end

function part2(moves)
    "Not implemented"
end

function parseLine(line)
    parts = split(line)
    (parts[1], parse(Int32, parts[2]))
end

moves = [parseLine(line) for line in eachline("input/day_2.txt")]
if parsed_args["part2"]
    println(part2(moves))
else
    println(part1(moves))
end

