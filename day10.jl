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
chunks = readlines("input/day_10$test_suffix.txt")
const opens = Dict('(' => ')', '{' => '}', '<' => '>', '[' => ']')
const scores = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)

function assess_chunk(c)
    stack = []
    for chr in c
        if haskey(opens, chr)
            push!(stack, opens[chr])
        elseif isempty(stack) || pop!(stack) != chr
            return (score = scores[chr], stack = [])
        end
    end
    (score = 0, stack = stack)
end

function part1()
    sum(map(c -> assess_chunk(c).score, chunks))
end

const completion_scores = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)
function part2()
    stacks = map(ass -> ass.stack, filter(ass -> ass.score == 0, map(assess_chunk, chunks)))
    function score_stack(stack)
        score = 0
        while !isempty(stack)
            score = score * 5 + completion_scores[pop!(stack)]
        end
        score
    end
    scores = sort(map(score_stack, stacks))
    mid = div(length(scores) + 1, 2)
    scores[mid]
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
