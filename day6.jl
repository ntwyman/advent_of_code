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

function grow!(fish)
    newfish = 0
    for (i, f) in enumerate(fish)
        f -= 1
        if f < 0
            newfish += 1
            f = 6
        end
        fish[i] = f
    end
    for _ in 1:newfish
        push!(fish, 8)
    end
end

function part1(fish)
    for _ in 1:80
        grow!(fish)
    end
    length(fish)
end

function growcounts!(counts)
    n = counts[1]
    for i in 1:8
        counts[i] = counts[i+1]
    end
    counts[7] += n
    counts[9] = n
end

function part2(fish)
    counts = zeros(UInt64, 9)
    for f in fish
        counts[f+1]+=1
    end
    for _ in 1:256
        growcounts!(counts)
    end
    sum(counts)
end

function parseLine(line)
    parse(Int32, line)
end

test_suffix = parsed_args["test"] ? "_test" : ""
lines = readlines("input/day_6$test_suffix.txt")
fish = [parse(Int8, f) for f in split(lines[1], ",")]
if parsed_args["part2"]
    answer = part2(fish)
else
    answer = part1(fish)
end
println("The answer is: $answer")
