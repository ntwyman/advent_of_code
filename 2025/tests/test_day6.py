from day6 import part1, part2

TEST_INPUT = [
    "123 328  51 64 ",
    " 45 64  387 23 ",
    "  6 98  215 314",
    "*   +   *   +  ",
]


def test_part1():
    assert part1(TEST_INPUT) == 4277556


def test_part2():
    assert part2(TEST_INPUT) == 3263827
