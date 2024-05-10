using ArgParse
# using LinearAlgebra


s = ArgParseSettings()
@add_arg_table s begin
    "--part2"
    help = "Do part 2"
    action = :store_true
    "--test"
    help = "Run test data"
    action = :store_true
end

mutable struct InfiniteImage
    set::Set{Tuple{Int, Int}}
    minx::Int
    maxx::Int
    miny::Int
    maxy::Int
    outside::Bool
end


InfiniteImage() = InfiniteImage(Set(), 0, 0, 0,0, false)

function set!(image::InfiniteImage, x::Int, y::Int)
    if isempty(image.set)
        image.minx = image.maxx = x
        image.miny = image.maxy = y
    end
    sz = length(image.set)
    push!(image.set, (x, y))
    tz = length(image.set)
    if tz != sz +1
        println("Added $x, $y to no effect")
    end
    image.minx = min(x, image.minx)
    image.miny = min(y, image.miny)
    image.maxx = max(x, image.maxx)
    image.maxy = max(y, image.maxy)
end

function isset(i::InfiniteImage, x::Int, y::Int)
    if x >= i.minx && x <= i.maxx && y >= i.miny && y<=i.maxy
        (x, y) ∈ i.set
    else
        i.outside
    end
end

function size(image::InfiniteImage)
    return length(image.set)
end

parsed_args = parse_args(ARGS, s)
test_suffix = parsed_args["test"] ? "_test" : ""
initial_image = InfiniteImage()
input = readlines("input/day_20$test_suffix.txt")
lookup = [c == '#' for c in input[1]]

for (y, l) in enumerate(input[3:end])
    for (x, c) in enumerate(l)
        if c=='#'
            set!(initial_image, x, y)
        end
    end
end

function Base.show(io::IO, i::InfiniteImage)
    println(io, "($(i.minx), $(i.miny))x($(i.maxx),$(i.maxy)) : $(size(i)) pixels set")
    for y in i.miny:i.maxy
        l :: Vector{Char} = []
        for x in i.minx:i.maxx
            push!(l, isset(i, x, y) ? '#' : '.')
        end
        println(io,String(l))
    end
end

function evolve_image(image::InfiniteImage) :: InfiniteImage
    evolved = InfiniteImage()
    sub = [(-1, -1), (0, -1), (1, -1), (-1, 0), (0, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]
    for y in (image.miny - 1):(image.maxy + 1)
        for x in (image.minx - 1):(image.maxx + 1)
            function setbit(acc, off) :: Int
                (acc << 1) | (isset(image, x + off[1], y + off[2]) ? 1 : 0)
            end
            idx = reduce(setbit, sub; init = 0)
            if lookup[idx + 1]
                set!(evolved, x, y)
            end
        end
    end
    evolved.outside = lookup[1] ? !image.outside : false
    evolved
end

function part1()
    ev = evolve_image(initial_image)
    ev = evolve_image(ev)
    size(ev)
end

function part2()
    ev = initial_image
    for i in 1:50
        ev = evolve_image(ev)
    end
    size(ev)
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
