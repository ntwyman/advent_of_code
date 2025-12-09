from math import prod


def get_heads(lines: list[str]) -> tuple[list[str], list[str]]:
    heads = []
    newlines = []

    for line in lines:
        hl = line.find(" ")
        if hl < 0:
            heads.append(line)
            newlines.append("")
        else:
            heads.append(line[:hl])
            newlines.append(line[hl:].strip())
    return heads, newlines


def do_sum(op: str, args: list[str]) -> int:
    print(f"({op} {args})")
    f = sum if op == "+" else prod
    return f([int(h) for h in args])


def part1(input: list[str]) -> int:
    lines = [i.strip() for i in input]
    total = 0
    while len(lines[0]) > 0:
        heads, lines = get_heads(lines)
        op = heads.pop()
        total += do_sum(op, heads)
    return total


def part2(input: list[str]) -> int:
    index = 0
    input_len = len(input[0])
    nums = input[:-1]
    ops = input[-1]
    total = 0
    while index < input_len:
        args = []
        op = None
        while index < input_len:
            arg = "".join([num[index] for num in nums]).strip()
            if op is None:
                op = ops[index]
            index += 1
            if len(arg) == 0:
                break
            args.append(arg)
        total += do_sum(op, args)  # type: ignore - assuming op will exist
    return total
