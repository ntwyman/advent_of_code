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

function parseLine(l)
    l
end

parsed_args = parse_args(ARGS, s)
test_suffix = parsed_args["test"] ? "_test" : ""
input = [parseLine(l) for l in readlines("input/day_18$test_suffix.txt")]

function part1()
end

function part2()
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
