from day5 import parse_input, part1, part2


TEST_INPUT = [
    "3-5",
    "10-14",
    "16-20",
    "12-18",
    "",
    "1",
    "5",
    "8",
    "11",
    "17",
    "32",
]


def test_parse_input():
    ranges, produce = parse_input(TEST_INPUT)
    assert ranges == [(3, 5), (10, 20)]
    assert produce == [1, 5, 8, 11, 17, 32]


def test_part1():
    assert part1(TEST_INPUT) == 3


def test_part2():
    assert part2(TEST_INPUT) == 14
