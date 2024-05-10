using ArgParse

s=ArgParseSettings()
@add_arg_table s begin
    "--part2"
        help="Do part 2"
        action=:store_true
end
parsed_args = parse_args(ARGS, s)

function calculate_gamma(numbers, bitlen)
    counts = zeros(bitlen)
    for n in numbers
        for idx in 1:bitlen
            mask = 0x1000 >>> idx
            if (n & mask) != 0
                counts[idx] += 1
            end
        end
    end
    
    l = div(length(numbers), 2)
    gamma::UInt32 = 0
    for idx in 1:bitlen
        gamma <<= 1
        if counts[idx] >= l
            gamma |= 1
        end
    end
    gamma
end

function part1(bits)
    gamma = calculate_gamma(bits, 12)
    epsilon = xor(gamma, 0x0fff)
    epsilon * gamma
end

function filter_values(values, use_first)
    bit = 0x0800
    while bit != 0 && length(values) > 1
        set = count(v -> (v & bit) != 0 , values)
        if use_first
            good = set >= (length(values) - set) ? bit : 0
        else
            good = set < (length(values)-set) ? bit : 0
        end
        values = filter(b -> (b & bit) == good, values)
        bit >>>= 1
    end
    values[1]
end

function part2(values)
    o2_rating = filter_values(values, true)
    co2_rating = filter_values(values, false)
    o2_rating * co2_rating
end

function parseLine(line)
    parse(UInt32, line, base=2)
end

bits = [parseLine(line) for line in eachline("input/day_3.txt")]
if parsed_args["part2"]
    answer = part2(bits)
else
    answer = part1(bits)
end
println("The answer is: $answer")
