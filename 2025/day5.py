def pack_ranges(
    acc: list[tuple[int, int]], curr: tuple[int, int], remainder: list[tuple[int, int]]
) -> list[tuple[int, int]]:
    if len(remainder) == 0:
        acc.append(curr)
        return acc

    next = remainder.pop(0)
    if curr[1] >= next[0]:  # they overlap
        next = (curr[0], max(curr[1], next[1]))
    else:
        acc.append(curr)
    return pack_ranges(acc, next, remainder)


def parse_input(lines: list[str]) -> tuple[list[tuple[int, int]], list[int]]:
    ranges = []
    produce = []
    breakSeen = False
    for line in lines:
        if len(line) == 0:
            breakSeen = True
        else:
            if breakSeen:
                produce.append(int(line))
            else:
                parts = line.split("-")
                ranges.append((int(parts[0]), int(parts[1])))

    ranges = sorted(ranges)
    first = ranges.pop(0)
    ranges = pack_ranges([], first, ranges)
    return ranges, sorted(produce)


def part1(input: list[str]):
    ranges, produce = parse_input(lines=input)
    good = 0
    for item in produce:
        while len(ranges) > 0:
            next = ranges[0]
            if item < next[0]:
                break  # go to next item
            if item <= next[1]:
                good += 1
                break
            ranges.pop(0)
    return good


def part2(input: list[str]) -> int:
    ranges, _ = parse_input(lines=input)
    return sum([r[1] - r[0] + 1 for r in ranges])
