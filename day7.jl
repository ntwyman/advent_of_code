using ArgParse

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

function parseLine(line)
    "Fake data"
end

function part1(data)
    "Part1: Not Implemented"
end

function part2(data)
    "Part2: Not Implemented"
end
test_suffix = parsed_args["test"] ? "_test" : ""
data = [parseLine(l) for l in readlines("input/day_7$test_suffix.txt")]
if parsed_args["part2"]
    answer = part2(data)
else
    answer = part1(data)
end
println("The answer is: $answer")
