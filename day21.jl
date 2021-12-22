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

parsed_args = parse_args(ARGS, s)
test_suffix = parsed_args["test"] ? "_test" : ""
function parseline(l)
    parts = split(l,": ")
    parse(UInt, parts[2])
end

positions = [parseline(l) for l in readlines("input/day_21$test_suffix.txt")]
scores = [0,0]

mutable struct DeterministicDie
    rolls::Int
    value::Int
end

DeterministicDie() = DeterministicDie(0,100)

function roll!(d::DeterministicDie)
    d.rolls += 1
    d.value += 1
    if d.value > 100
        d.value = 1
    end
    return d.value
end

# Maps a total score from 3 rolls of the Dirac die to the corresponding relative frequency
frequencies = [ (r=3, f=1), (r=4, f=3), (r=5, f=6), (r=6, f=7), (r=7, f=6), (r=8, f=3), (r=9,f=1) ]

function part1()
    d = DeterministicDie()
    function take_turn(player)
        roll = rem(roll!(d) + roll!(d) + roll!(d), 10)
        pos = positions[player] + roll
        if pos > 10
            pos -= 10
        end
        positions[player] = pos
        scores[player] += pos
        scores[player] >=1000
    end
    while true
        if take_turn(1) || take_turn(2)
            break;
        end
    end
    losing_score = min(scores[1], scores[2])
    println("$(losing_score) $(d.rolls)")
    losing_score * d.rolls
end

function expected_scores()
    function expected_scores_from(pos)
        scores = []
        for roll in frequencies
            landing = (roll.r + pos)
            if landing > 10
                landing -= 10
            end
            push!(scores, (pos=landing, freq=roll.f))
        end
        scores
    end
    map(expected_scores_from, 1:10) 
end

        
function add_score_pos!(state, pos, score, num)
    posuni = get(state, pos, Dict())
    posuni[score] = get(posuni, score, BigInt(0)) + num
    state[pos] = posuni
end

function add_to_field(t, field, number)
    f1 = t[1]
    f2 = t[2]
    if field == 1
        f1 += number
    else
        f2 += number
    end
    (f1, f2)
end

function set_field(t, field, number)
    f1 = t[1]
    f2 = t[2]
    if field == 1
        f1 = number
    else
        f2 = number
    end
    (f1, f2)
end

function part2()
    pos_to_outcomes = expected_scores()
    
    function play(state, player)
        ns = Dict()
        wins::BigInt = 0
        remaining_universes::BigInt = 0
        for (positions, posuni) in state
            for outcome in pos_to_outcomes[positions[player]]
                for (score, ucount) in posuni
                    new_score = add_to_field(score, player, outcome.pos)
                    num_uni = ucount * outcome.freq
                    if new_score[1] >= 21 || new_score[2] >= 21
                        wins += num_uni
                    else
                        remaining_universes += num_uni
                        new_pos = set_field(positions, player, outcome.pos)
                        add_score_pos!(ns, new_pos, new_score, num_uni)
                    end
                end
            end
        end
        (wins, remaining_universes, ns)
    end
            
    # Dictionary maps possible scores at this stage to a map from
    # positions and the # of universes where the user has that score in that position
    state = Dict{Tuple{Int, Int}, Dict{Tuple{Int, Int}, BigInt}}(
                    (positions[1], positions[2]) => Dict((0,0) => BigInt(1)))

    wins1::BigInt = 0
    wins2::BigInt = 0
    while true
        (w1, remains, state) = play(state, 1)
        println("P1: wins $w1, remaining $remains")
        wins1 += w1
        if remains == 0
            break;
        end
        (w2, remains, state) = play(state, 2)
        wins2 += w2
        println("P2: wins $w2, remaining $remains")
        if remains == 0
            break;
        end
    end
    (wins1, wins2, wins1 + wins2)
end
p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
