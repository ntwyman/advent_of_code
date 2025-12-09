from collections import defaultdict


def part1(input: list[str]) -> int:
    beams = set()
    beams.add(input[0].find("S"))
    splits = 0
    for line in input[1:]:
        newbeams = set()
        for beam in beams:
            if line[beam] == ".":
                newbeams.add(beam)
            else:
                if beam == 0:
                    print(f"HO-NO - tachyon spill on aisle -1 {line}")
                    return 0
                splits += 1
                newbeams.add(beam - 1)
                newbeams.add(beam + 1)
        beams = newbeams
    return splits


def part2(input: list[str]) -> int:
    beams: dict[int, int] = {}
    beams[input[0].find("S")] = 1
    for line in input[1:]:
        newbeams: dict[int, int] = defaultdict(int)
        for beam, paths in beams.items():
            if line[beam] == ".":
                newbeams[beam] += paths
            else:
                if beam == 0:
                    print(f"HO-NO - tachyon spill on aisle -1 {line}")
                    return 0
                newbeams[beam - 1] += paths
                newbeams[beam + 1] += paths
        beams = newbeams
    return sum(beams.values())
