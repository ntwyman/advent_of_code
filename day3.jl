using ArgParse

s=ArgParseSettings()
@add_arg_table s begin
    "--part2"
        help="Do part 2"
        action=:store_true
end
parsed_args = parse_args(ARGS, s)

function part1(bits)
    LENGTH = 12
    counts = zeros(Int32, LENGTH)
    lc = 0
    for b in bits
        for idx in 1:LENGTH
            if b[idx] == "1"
                counts[idx] += 1
            end
        end
        lc += 1
    end
    lc = div(lc, 2)
    gamma::UInt16 = 0
    for idx in 1:LENGTH
        gamma <<= 1
        if counts[idx] > lc
            gamma |= 1
        end
    end
    epsilon = xor(0x0fff,gamma)
    UInt32(epsilon) * UInt32(gamma)
end

function part2(bits)
    "Not implemented yet"
end

function parseLine(line)
    split(line,"")
end

bits = [parseLine(line) for line in eachline("input/day_3.txt")]
if parsed_args["part2"]
    answer = part2(bits)
else
    answer = part1(bits)
end
println("The answer is: $answer")
