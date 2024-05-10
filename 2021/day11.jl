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
parsed_args = parse_args(ARGS, s)

test_suffix = parsed_args["test"] ? "_test" : ""
octopi = [[parse(Int8, d) for d in l] for l in readlines("input/day_11$test_suffix.txt")]
my = length(octopi)
mx = length(octopi[1])

neighborhood = [(-1, -1), (0, -1), (+1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]
function step()
    flashers = []
    function increment(x, y)
        if x <= 0 || x > mx || y <= 0 || y > my
            return
        end
        octopi[x][y] += 1
        if octopi[x][y] == 10
            push!(flashers, (x = x, y = y))
        end
    end
    function reset(x, y)
        if octopi[x][y] > 9
            octopi[x][y] = 0
        end
    end

    function all_squares(f)
        for y = 1:my
            for x = 1:mx
                f(x, y)
            end
        end
    end

    all_squares(increment)
    count = 0
    while length(flashers) != 0
        flash = popfirst!(flashers)
        foreach(n -> increment(flash.x + n[1], flash.y + n[2]), neighborhood)
        count += 1
    end
    all_squares(reset)
    count
end

function part1()
    sum(map(n -> step(), 1:100))
end

function part2()
    i = 1
    while true
        count = step()
        if count == mx * my
            return i
        end
        i = i + 1
    end
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
