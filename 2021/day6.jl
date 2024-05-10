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
    parse(Int32, line)
end

function growcounts!(counts)
    n = counts[1]
    for i in 1:8
        counts[i] = counts[i+1]
    end
    counts[7] += n
    counts[9] = n
end

test_suffix = parsed_args["test"] ? "_test" : ""
lines = readlines("input/day_6$test_suffix.txt")
fish = [parse(Int8, f) for f in split(lines[1], ",")]
census = zeros(UInt64, 9)
function countfish(age)
    ageindex = age + 1
    census[ageindex] += 1
end
foreach(countfish, fish)
for _ in 1:(parsed_args["part2"] ? 256 : 80)
    growcounts!(census)
end
answer = sum(census)
println("The answer is: $answer")
