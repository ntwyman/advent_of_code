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
input = readlines("input/day_16$test_suffix.txt")


mutable struct BitBuffer
    nibbles::Vector{UInt8}
    n::UInt16
    bits_left::UInt8
end

struct Packet
    version:: UInt8
    type:: UInt8
    bitlen::UInt32
    value::Union{UInt64, Vector{Packet}}
end

BitBuffer(nibbles) = BitBuffer(nibbles, 1, 4)

function bitmask(bitcount)
    if bitcount >= 32
        throw(AssertionError("too many bits"))
    end
    (UInt32(1) << bitcount) - 1
end 

function get_bits!(buf, bits)
    result::UInt32 = 0
    if buf.bits_left > bits
        shft = buf.bits_left - bits
        result = (buf.nibbles[buf.n] >> shft) & bitmask(bits)
        buf.bits_left = shft
    else
        result = buf.nibbles[buf.n] & bitmask(buf.bits_left)
        bits -= buf.bits_left
        n = buf.n + 1
        while bits >= 4
            result = (result << 4) | buf.nibbles[n]
            bits -= 4
            n += 1
        end
        buf.n = n
        buf.bits_left = 4 - bits
        if bits > 0
            result = (result << bits) | (buf.nibbles[n] >> buf.bits_left)
        end
    end
    result
end

function version_type!(buf)
    version = get_bits!(buf, 3)
    type = get_bits!(buf, 3)
    (version, type)
end

function get_literal!(buf)
    value::UInt64 = 0
    bitlen::UInt32 = 0
    while true
        chunk = get_bits!(buf, 5)
        bitlen += 5
        value = (value << 4) | (chunk & 0x0f)
        if (chunk & 0x10) == 0
            break;
        end
    end
    (bitlen, value)
end

function parse_packet!(buf)
    (v, t) = version_type!(buf)
    if t==4 # literal
        (bitlen, value) = get_literal!(buf)
        packet = Packet(v, t, bitlen + 6, value)
    else
        length_type = get_bits!(buf, 1) # length 6 + 1 = 7
        if length_type == 0
            expected_bits = get_bits!(buf, 15) # length 7 + 15 = 22
            packets = Vector{Packet}()
            bits = 0
            while bits < expected_bits
                p = parse_packet!(buf)
                push!(packets, p)
                bits += p.bitlen
            end
            packet = Packet(v, t, expected_bits + 22, packets)
        else
            packet_count = get_bits!(buf, 11) # length 7 + 11 = 18
            packets = Vector{Packet}()
            while packet_count > 0
                p = parse_packet!(buf)
                push!(packets, p)
                packet_count -= 1 
            end
            packet_bits = sum([p.bitlen for p in packets])
            packet = Packet(v, t, packet_bits + 18, packets)
        end
    end
    packet
end


function parse_outer_packet!(buf)
    packet = parse_packet!(buf)
    # tidy up the end of the parse_packet
    if buf.bits_left < 4
        buf.n += 1
        buf.bits_left = 4
    end
    packet
end

function add_versions(packet)
    v::UInt32 = packet.version
    if packet.type != 4
        v += sum([add_versions(p) for p in packet.value])
    end
    v
end

buffer_from_string(str) = BitBuffer([parse(UInt8, c; base=16) for c in str])

function dump_packets(p)
    function do_dump(p, indent)
        println("$(indent)Packet $(p.version), $(p.type)")
        new_ident = "$indent    "
        if p.type == 4
            println("$(new_ident)Value: $(p.value)")
        else
            foreach(ps -> do_dump(ps, new_ident), p.value)
        end
    end
    do_dump(p,"")
end

function evaluate(p)
    value::UInt64 = 0
    if p.type == 4
        value = p.value
    else
        subvalues = [evaluate(sp) for sp in p.value]
        if p.type == 0
            value = sum(subvalues)
        elseif p.type == 1
            value = prod(subvalues)
        elseif p.type == 2
            value = minimum(subvalues)
        elseif p.type == 3
            value = maximum(subvalues)
        elseif p.type == 5
            value = subvalues[1] > subvalues[2] ? 1 : 0
        elseif p.type == 6
            value = subvalues[1] < subvalues[2] ? 1 : 0
        elseif p.type == 7
            value = subvalues[1] == subvalues[2] ? 1 : 0
        end
    end
    value
end

function apply(operator)
    function apply_once(in)
        p = parse_outer_packet!(buffer_from_string(in))
        pre = in[1:6]
        v = operator(p)
        println("$pre, $v")
    end
    foreach(apply_once, input)
end

function part1()
    apply(add_versions)
    "above"
end

function part2()
    apply(evaluate)
    "above"
end

p = parsed_args["part2"] ? part2 : part1
answer = p()
println("The answer is: $answer")
