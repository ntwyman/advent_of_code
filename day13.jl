using ArgParse
using Statistics
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

points = Set()
axes = []

for l in readlines("input/day_13$test_suffix.txt")
    if contains(l, ",")
        p = split(l, ",")
        push!(points, (x = parse(UInt16, p[1]), y = parse(UInt16, p[2])))
    elseif length(l) > 4
        axis = l[begin+11:end]
        p = split(axis, "=")
        push!(axes, (axis = p[1], line = parse(UInt16, p[2])))
    end
end

function dofold(points, fold)
    result = Set()
    for p in points
        if fold.axis == "x"
            x = p.x
            if x > fold.line
                x = 2 * fold.line - x
            end
            push!(result, (x = x, y = p.y))
        else
            y = p.y
            if y > fold.line
                y = 2 * fold.line - y
            end
            push!(result, (x = p.x, y = y))
        end
    end

    result
end

function part1()
    length(dofold(points, axes[1]))
end

function part2()
    p = points
    for fold in axes
        p = dofold(p, fold)
    end
    mx = 0
    my = 0
    for pt in p
        mx = max(pt.x, mx)
        my = max(pt.y, my)
    end
    code = zeros(mx + 1, my + 1)
    for pt in p
        code[pt.x+1, pt.y+1] = 1
    end
    for y = 1:my+1
        line = Vector{Char}()
        for x = 1:mx+1
            push!(line, code[x, y] == 1 ? '@' : ' ')
        end
        println(String(line))
    end
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
