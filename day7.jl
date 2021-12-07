using ArgParse
using Statistics
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

function findcost(data, aim)
    sum([abs(c - aim) for c in data])
end
function part1(data)
    total = sum(data)
    attempt = div(total, length(data))
    costplus = findcost(data, attempt + 1)
    cost = findcost(data, attempt)
    costminus = findcost(data, attempt - 1)
    while true
        if cost <= costplus && cost <= costminus
            return cost
        end
        if costminus <= cost
            costplus = cost
            cost = costminus
            attempt = attempt - 1
            costminus = findcost(data, attempt - 1)
        else
            costminus = cost
            cost = costplus
            attempt = attempt + 1
            costminus = findcost(data, attempt  + 1)
        end
    end

    println("$costminus, $cost, $costplus")
    attempt
end

function part2(data)
    "Part2: Not Implemented"
end
test_suffix = parsed_args["test"] ? "_test" : ""
lines = readlines("input/day_7$test_suffix.txt")
data = [parse(Int32, crab) for crab in split(lines[1],",")]
if parsed_args["part2"]
    answer = part2(data)
else
    answer = part1(data)
end
println("The answer is: $answer")
