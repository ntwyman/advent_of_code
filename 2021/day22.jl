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


Extent = @NamedTuple{min::Int64, max::Int64}
Cuboid = @NamedTuple{x::Extent, y::Extent, z::Extent}
struct RebootStep
    on::Bool
    cuboid::Cuboid
end

function Base.show(io::IO, c::Cuboid)
    println(io, "[x=($(c.x.min), $(c.x.max)), y=($(c.y.min), $(c.y.max)), z=($(c.z.min), $(c.z.max)))]")
end

function parseline(l:: String) :: RebootStep
    parts = split(l," ")
    onOff = (parts[1] == "on")
    axes = split(parts[2], ",")

    function getminmax(axis::AbstractString) :: Extent
        p = split(axis, "=")
        mm=map(e -> parse(Int, e), split(p[2],".."))
        (min = mm[1], max = mm[2])
    end
    xyz = map(getminmax, axes)
    RebootStep(onOff, (x= xyz[1], y= xyz[2], z=xyz[3]))
end

function overlap(a::Extent, b::Extent)
    a.min <= b.max && a.max>= b.min
end

function intersect(a::Cuboid, b::Cuboid)
    overlap(a.x, b.x) && overlap(a.y, b.y) && overlap(a.z, b.z)
end

function len(e::Extent)
    BigInt(e.max) - BigInt(e.min) + BigInt(1)
end


function size(c::Cuboid)
    BigInt(len(c.x)) * BigInt(len(c.y)) * BigInt(len(c.z))
end

function covers(e1::Extent, e2::Extent)
    e1.min<=e2.min  && e1.max >= e2.max
end

function contains(c1::Cuboid, c2::Cuboid)
    covers(c1.x, c2.x) && covers(c1.y, c2.y) && covers(c1.z, c2.z)
end

steps = [parseline(l) for l in readlines("input/day_22$test_suffix.txt")]

function remove(cut::Cuboid, from::Cuboid) :: Vector{Cuboid}
    result = []
    if cut.x.min > from.x.min 
        s = (x=(min=from.x.min, max=cut.x.min-1), y=from.y, z=from.z)
        from = (x=(min=cut.x.min, max=from.x.max), y=from.y, z=from.z)
        push!(result, s)
    end
    if cut.x.max < from.x.max
        s = (x=(min=cut.x.max+1, max=from.x.max), y=from.y, z=from.z)
        from = (x=(min=from.x.min, max=cut.x.max), y=from.y, z=from.z)
        push!(result, s)
    end
    if cut.y.min > from.y.min
        s = (x=from.x, y=(min=from.y.min, max=cut.y.min-1), z=from.z)
        from = (x=from.x, y=(min=cut.y.min, max=from.y.max), z=from.z)
        push!(result, s)
    end
    if cut.y.max < from.y.max
        s = (x=from.x, y=(min=cut.y.max+1, max=from.y.max), z=from.z)
        from = (x=from.x, y=(min=from.y.min, max=cut.y.max), z=from.z)
        push!(result, s)
    end
    if cut.z.min > from.z.min
        s = (x=from.x, y=from.y, z=(min=from.z.min, max=cut.z.min-1))
        from = (x=from.x, y=from.y, z=(min=cut.z.min, max=from.z.max))
        push!(result, s)
    end
    if cut.z.max < from.z.max
        s = (x=from.x, y=from.y, z=(min=cut.z.max+1, max=from.z.max))
        from = (x=from.x, y=from.y, z=(min=from.z.min, max=cut.z.max))
        push!(result, s)
    end
    result
end

function onstep(ons::Vector{Cuboid}, turning::Cuboid)::Vector{Cuboid}
    # println("onstep")
    result = [turning]
    overlaps = []
    for con in ons
        if !intersect(con, turning)
            push!(result, con) # keep it
        elseif contains(turning, con) # ignore it - I got you bae
            continue; 
        else
            push!(overlaps, con)
        end
    end
    ## So now we have a collection of disjoint cuboids (overlaps) each of which intersects with the step.cuboid
    # println("ON: Overlaps - $(length(overlaps))")
    for c in overlaps
        # println(c)
        append!(result, remove(turning, c))
    end
    # println("done")
    result
end

function offstep(ons::Vector{Cuboid}, turning::Cuboid)::Vector{Cuboid}
    # println("offstep")
    if isempty(ons)
        return []
    end
    result = []
    overlaps = []
    for con in ons
        if !intersect(con, turning)
            push!(result, con) # keep it
        elseif contains(turning, con)
            continue;
        else
            push!(overlaps, con)
        end
    end
    # KNOW THE OVERLAPS ARE DISJOINT..
    # println("OFF: Overlaps - $(length(overlaps))")
    for c in overlaps
        append!(result,remove(turning, c))
    end
    result
end

function applystep(ons::Vector{Cuboid}, step::RebootStep)::Vector{Cuboid}
    stepper = step.on ? onstep : offstep
    res = stepper(ons, step.cuboid)
    # show_on(res)
    res
end

function show_on(ons::Vector{Cuboid})
    cubes = []
    for c in ons
        for x in c.x.min:c.x.max
            for y in c.y.min:c.y.max
                for z in c.z.min:c.z.max
                    push!(cubes, (x, y, z))
                end
            end
        end
    end
    sort!(cubes)
    for c in cubes
        println("$(c[1]), $(c[2]), $(c[3])")
    end
end

function part1()
    initarea = (x=(min=-50, max=50), y=(min=-50, max=50), z=(min=-50, max=50))
    relevant::Vector{RebootStep} = filter(s -> intersect(s.cuboid, initarea), steps)
    results = foldl(applystep, relevant; init=Vector{Cuboid}())
    sum(map(size, results))
end

function part2()
    results = foldl(applystep, steps; init=Vector{Cuboid}())
    sum(map(size, results))
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
