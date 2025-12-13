Point = tuple[int, int, int]


def parse_lines(input: list[str]) -> list[Point]:
    def sl(str):
        p = str.split(",")
        return (int(p[0]), int(p[1]), int(p[2]))

    return [sl(line) for line in input]


def dist(a: Point, b: Point) -> int:
    return (a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2 + (a[2] - b[2]) ** 2


def do_merges(input: list[str], count: int) -> int:
    points = parse_lines(input)
    N = len(points)
    graph: list[tuple[int, Point, Point]] = []
    circuits: dict[Point, int] = {}
    members: dict[int, set[Point]] = {}
    for ixA in range(N):
        a = points[ixA]
        circuits[a] = ixA
        members[ixA] = set([a])
        if ixA < N:
            for b in points[ixA + 1 :]:
                graph.append((dist(a, b), a, b))

    closest = sorted(graph)
    for _, a, b in closest[:count]:
        cA = circuits[a]
        cB = circuits[b]
        if cA != cB:  # join circuit B to A
            # print(f"Merging {cB} - {members[cB]} into {cA} - {members[cA]}")
            for c in members[cB]:
                circuits[c] = cA
                members[cA].add(c)
            del members[cB]
            if len(members) == 1:  # just one circuit
                return a[0] * b[0]
    bySize = sorted([len(mems) for mems in members.values()], reverse=True)
    return bySize[0] * bySize[1] * bySize[2]


def part1(input: list[str]) -> int:
    return do_merges(input, 1000)


def part2(input: list[str]) -> int:
    return do_merges(input, -1)
