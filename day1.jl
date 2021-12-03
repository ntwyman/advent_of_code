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

function part2(numbers)
    increases = 0
    for idx in 1:(Base.length(numbers)-3)
        if sum(numbers[idx:idx+2]) < sum(numbers[idx+1:idx+3])
            increases += 1
        end
    end
    increases
end

numbers = [parse(Int64, line) for line in eachline("input/day_1.txt")]
if parsed_args["part2"]
    answer = part2(numbers)
else
    answer = part1(numbers)
end
println("The answer is: $answer")
