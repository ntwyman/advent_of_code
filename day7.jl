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

function costtomove(n)
    parsed_args["part2"] ? div(n * (n + 1), 2) : n
end

function findcost(data, aim)

    sum([costtomove(abs(c - aim)) for c in data])
end

function findminimum(data)
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
end

test_suffix = parsed_args["test"] ? "_test" : ""
lines = readlines("input/day_7$test_suffix.txt")
data = [parse(Int32, crab) for crab in split(lines[1],",")]
answer = findminimum(data)
println("The answer is: $answer")
