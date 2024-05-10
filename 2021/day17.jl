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
input = readlines("input/day_17$test_suffix.txt")
txt = split(input[1][14:end], ", ")

function get_min_max(rng)
    mn = [parse(Int16, p) for p in split(rng[3:end],"..")]
    (min = mn[1], max = mn[2])
end

bd = map( get_min_max, txt)
bounds = (x = bd[1], y = bd[2])

# target area: x=20..30, y=-10..-5
function hitsTarget(vel)
    pos = (x=0, y=0)
    ymax = 0
    while (pos.x < bounds.x.max && pos.y >= bounds.y.min)
        pos = (x= (pos.x + vel.x), y= (pos.y + vel.y))
        vel = (x= vel.x > 0 ? vel.x - 1 : 0, y= vel.y -1)
        ymax = max(ymax, pos.y)
        if pos.x >= bounds.x.min && pos.y >= bounds.y.min &&
            pos.x <= bounds.x.max && pos.y <= bounds.y.max
            return (true, false, ymax)
        end
    end
   (false, (pos.x >= bounds.x.max) || vel.x==0, ymax)
end

function part1()
    # 2 * bounds.min.x = (nn+n) >
    minx = Int16(floor(sqrt(2 * bounds.x.min)))
    maxx = bounds.x.max
    ymax = 0
    for vx in minx:maxx
        vy  = 0
        while true
            (hit, over, ym) = hitsTarget((x=vx, y=vy))
            if hit && ym > ymax
                ymax = ym
            end
            if vy > 1000
                break
            end
            vy +=1
        end
    end
    ymax
end

function part2()
    minx = Int16(floor(sqrt(2 * bounds.x.min)))
    maxx = bounds.x.max
    hits = 0
    for vx in minx:maxx
        vy  = bounds.y.min
        while true
            (hit, _, _) = hitsTarget((x=vx, y=vy))
            if hit
                hits += 1    
            end
            if vy > 1000
                break
            end
            vy +=1
        end
    end
    hits
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
