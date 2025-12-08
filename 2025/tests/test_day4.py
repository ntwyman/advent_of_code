from day4 import part1, part2

TEST_INPUT = [
    "..@@.@@@@.",
    "@@@.@.@.@@",
    "@@@@@.@.@@",
    "@.@@@@..@.",
    "@@.@@@@.@@",
    ".@@@@@@@.@",
    ".@.@.@.@@@",
    "@.@@@.@@@@",
    ".@@@@@@@@.",
    "@.@.@@@.@.",
]


def test_part1():
    assert part1(TEST_INPUT) == 13


def test_part2():
    assert part2(TEST_INPUT) == 43
