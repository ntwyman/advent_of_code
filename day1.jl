using ArgParse

s=ArgParseSettings()
@add_arg_table s begin
    "--part2"
        help="Do part 2"
        action=:store_true
end
parsed_args = parse_args(ARGS, s)

function lineAsInteger(f)
    line = readline(f)
    parse(Int64, line)
end

function part1(fileHandle)
    lastSeen = lineAsInteger(fileHandle)
    increases = 0
    while ! eof(fileHandle)
        next = lineAsInteger(fileHandle)
        if next > lastSeen
            increases += 1
        end
        lastSeen = next
    end
    increases
end

function part2(fileHandle)
    "Not implemented yet... don't vaccinate and code"  
end
open("input/day_1.txt", "r") do dataFile
    if parsed_args["part2"]
        println(part2(dataFile))
    else
        println(part1(dataFile))
    end
end

