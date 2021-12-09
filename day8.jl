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


function parseLine(l)
    parts = split(l, " | ")
    digits = split(parts[1])
    display = split(parts[2])
    (digits = digits, display = display)
end

L1 = 2

L7 = 3

L4 = 4

L2 = 5

L3 = 5

L5 = 5

L0 = 6
L6 = 6
L9 = 6

L8 = 7

function part1(data)
    function is_unique_digit(digit)
        l = length(digit)
        l == L1 || l == L4 || l == L7 || l == L8
    end
    function countunique(display)
        count(is_unique_digit, display)
    end
    sum(countunique, [d.display for d in data])
end

function stringas_set(digit_string)
    Set(collect(digit_string))
end

function findby_length(sets, l)
    filter(s -> length(s) == l, sets)
end

function map_digits(digits)
    as_sets = map(stringas_set, digits)
    one = findby_length(as_sets, L1)[1]
    four = findby_length(as_sets, L4)[1]
    seven = findby_length(as_sets, L7)[1]
    eight = findby_length(as_sets, L8)[1]

    twothreefive = findby_length(as_sets, L3)
    two = filter(s -> length(setdiff(s, four)) == 3, twothreefive)[1]
    threefive = filter(s -> s != two, twothreefive)
    three = filter(s -> length(intersect(s, one)) == 2, threefive)[1]
    five = filter(s -> s != three, threefive)[1]

    zerosixnine = findby_length(as_sets, L0)
    six = filter(s -> length(intersect(s, one)) == 1, zerosixnine)[1]
    zeronine = filter(s -> s != six, zerosixnine)
    nine = filter(s -> length(intersect(s, four)) == L4, zeronine)[1]
    zero = filter(s -> s != nine, zeronine)[1]
    Dict(zero => 0, one => 1, two => 2, three => 3, four => 4, five => 5, six => 6, seven => 7, eight => 8, nine => 9)
end

function findvalue(datum)
    digit_map = map_digits(datum.digits)
    function add_digit(acc, digit_string)
        val = digit_map[stringas_set(digit_string)]
        acc * 10 + val
    end
    reduce(add_digit, datum.display, init = 0)
end

function part2(data)
    sum(findvalue, data)
end

test_suffix = parsed_args["test"] ? "_test" : ""
data = [parseLine(l) for l in readlines("input/day_8$test_suffix.txt")]
p = parsed_args["part2"] ? part2 : part1
answer = p(data)
println("The answer is: $answer")
