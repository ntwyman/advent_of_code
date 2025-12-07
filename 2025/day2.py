from math import ceil


def find_invalid(start: str, end: str) -> list[int]:
    return []


def parse_lines(lines: list[str]) -> list[tuple[str, str]]:
    ranges = lines[0].split(",")
    return [tuple(r.split("-")) for r in ranges]  # type: ignore


def lower_limit(bound: str) -> int:
    l = len(bound)  # noqa: E741
    l2 = int(l / 2)
    if (l % 2) == 0:  # even length
        start = int(bound[0:l2])
    else:
        start = int("1" + ("0" * l2))
    return start


def upper_limit(bound: str) -> int:
    l = len(bound)
    l2 = int(l / 2)
    if (l % 2) == 0:
        end = int(bound[0:l2])
    else:
        end = int("9" * l2)
    return end


def invalid_codes(range: tuple[str, str]) -> list[int]:
    print(f"Checking {range[0]}-{range[1]}")
    start = lower_limit(range[0])
    end = upper_limit(range[1])
    print(f"Trying - {start}, {end}")
    invalid_codes = []
    lb = int(range[0])
    ub = int(range[1])
    while start <= end:
        code = int(f"{start}{start}")
        if code >= lb:
            if code > ub:
                break
            invalid_codes.append(code)
        start += 1
    print(f"found {invalid_codes}\r\n")
    return invalid_codes


def part2_codes(limits: tuple[str, str]) -> list[int]:
    print(f"Checking {limits[0]}-{limits[1]}")
    lr0 = len(limits[0])
    lr1 = len(limits[1])
    lb = int(limits[0])
    ub = int(limits[1])
    d = 1
    codes = set()
    while (lr1 / d) >= 2:
        r = max(2, int(lr0 / d))
        s = int("1" + "0" * (d - 1))
        e = s * 10
        while True:
            min = int(str(s) * r)
            if min > ub:
                break
            for n in range(s, e):
                code = int(str(n) * r)
                if code >= lb:
                    if code > ub:
                        break
                    codes.add(code)
            r += 1
        d += 1
    v = sorted(codes)
    print(f"found {v}")
    return v


def do_it(lines, finder):
    ranges = parse_lines(lines)
    invalid_codes = [finder(r) for r in ranges]
    return sum(sum(invalid_codes, []))


def part1(lines: list[str]) -> int:
    return do_it(lines, invalid_codes)


def part2(lines: list[str]) -> int:
    return do_it(lines, part2_codes)
