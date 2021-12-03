using ArgParse

s=ArgParseSettings()
@add_arg_table s begin
    "--part2"
        help="Do part 2"
        action=:store_true
end
parsed_args = parse_args(ARGS, s)


function part1(numbers)
    lastSeen = typemax(Int64)
    increases = 0 
    for value in numbers
        if value > lastSeen
            increases +=1
        end
        lastSeen = value
    end
    increases
end

function part2(fileHandle)
    "Not implemented yet... don't vaccinate and code"  
end

numbers = [parse(Int64, line) for line in eachline("input/day_1.txt")]
if parsed_args["part2"]
    println(part2(numbers))
else
    println(part1(numbers))
end

