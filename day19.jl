using ArgParse
using LinearAlgebra


s = ArgParseSettings()
@add_arg_table s begin
    "--part2"
    help = "Do part 2"
    action = :store_true
    "--test"
    help = "Run test data"
    action = :store_true
end

rotx = [ 1 0 0
         0 0 -1;
         0 1 0]
roty = [ 0 0 1;
         0 1 0;
        -1 0 0]
rotz = [ 0 -1 0;
         1 0 0;
         0 0 1]

rotations = []
function mat_4ways(mat, rotation)
    r = mat
    for _ in 1:4
        push!(rotations, r)
        r = r * rotation
    end
end

function make_rotations()
    # 
    mat = Matrix(1I, 3, 3)
    mat_4ways(mat, rotx)
    mat_4ways(rotz, roty)
    mat_4ways(rotz * rotz * rotz, roty)
    mat_4ways(roty, rotz)
    mat_4ways(roty * roty * roty, rotz)
    mat_4ways(rotz * rotz, rotx)
end

parsed_args = parse_args(ARGS, s)
test_suffix = parsed_args["test"] ? "_test" : ""
scanners = []
current_scanner = Set()
for l in readlines("input/day_19$test_suffix.txt")
    if startswith(l, "--- scanner")
        global current_scanner = Set()
    elseif isempty(l)
        push!(scanners, current_scanner)
    else
        coords = split(l, ",")
        push!(current_scanner,map(s -> parse(Int64, s), coords))
    end
end

function distance_map(scanner)
    dmap = Dict()
    function add_distances(s)
        if isempty(s)
            return dmap
        end
        b, rest = Iterators.peel(s)
        for c in rest
            dist = sum([(b[x]-c[x])^2 for x in 1:3])
            dmap[dist] = (b,c)
        end
        add_distances(rest)
    end
    add_distances(scanner)
    dmap
end

function find_known()
    # println("Scanners - $(length(scanners))")
    make_rotations()
    known_beacons = scanners[1] # Will aim to get all beacons in Scanner 0 co-ords
    popfirst!(scanners)

    # Work out distances between beacons in for remaining sets
    distance_sets = map(distance_map, scanners)
    distance_keys = map(ds -> Set(keys(ds)), distance_sets)
    found_one = true
    deltas = [[0,0,0]]
    while (found_one && length(scanners) > 0)
        # println("Remaining $(length(scanners))")
        # println("Known $(length(known_beacons))")
        known_dists = distance_map(known_beacons)
        known_distances = Set(keys(known_dists))
        # println("Known_distances $(length(known_distances))")
        found_one = false
        for (i, dk) in enumerate(distance_keys)
            # println("Checking $i")
            shared_distances = intersect(known_distances, dk)
            # println("  shared_distaces $(length(shared_distances))")
            if length(shared_distances) < 66 # 11 + 10 + ... :
                continue
            end
            dist = pop!(shared_distances)
            # println("Dist is $dist")
            (ki1, ki2) = known_dists[dist] # known co-ords of beacons.
            (ui1, ui2) = distance_sets[i][dist] # co-ords of same beacons in shifted/rotated co-ords
            # so now we rotate them so that the linear offsets are the same.
            matches = false
            for r in rotations
                # println("$r")
                ti1 = r * ui1
                ti2 = r * ui2
                delta = []
                if (ki1 - ti1) == (ki2 - ti2) # pairs match as is
                    delta = ki1 - ti1
                elseif (ki1 - ti2) == (ki2 - ti1)
                    delta = ki2 - ti1
                else
                    # println("Nomatch")
                    continue
                end
                # println("Offset $delta")
                # now double check overlap - map beacons
                s_abs = Set()
                for b in scanners[i]
                    push!(s_abs, r*b + delta)
                end
                if length(intersect(s_abs, known_beacons)) >= 12
                    union!(known_beacons, s_abs)
                    push!(deltas, delta)
                    matches = true
                    break
                end
                # println("!!! WTF")
            end
            if matches
                deleteat!(scanners, i)
                deleteat!(distance_sets, i)
                deleteat!(distance_keys, i)
                found_one = true
                break
            end
        end
    end
    (known_beacons, deltas)
end
function part1()
    length(find_known()[1])
end

function part2()
    (_, deltas) = find_known()
    md = 0
    function find_man(s)
        if isempty(s)
            return
        end
        b, rest = Iterators.peel(s)
        for c in rest
            # println("$b, $c")
            dist = sum([abs(b[x]-c[x]) for x in 1:3])
            if (dist > md) 
                md = dist
            end
        end
        find_man(rest)
    end
    find_man(deltas)
    md
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
