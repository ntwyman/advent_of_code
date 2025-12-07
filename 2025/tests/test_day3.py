import pytest
from day3 import part1, part2, bank_joltage


TEST_INPUT = [
    "987654321111111",
    "811111111111119",
    "234234234234278",
    "818181911112111",
]


@pytest.mark.parametrize(
    "bank, joltage",
    [
        ("987654321111111", 98),
        ("811111111111119", 89),
        ("234234234234278", 78),
        ("818181911112111", 92),
    ],
)
def test_bank_joltage_part1(bank: str, joltage: int):
    assert bank_joltage(bank, 2) == joltage


def test_part_one():
    assert part1(TEST_INPUT) == 357


@pytest.mark.parametrize(
    "bank, joltage",
    [
        ("987654321111111", 987654321111),
        ("811111111111119", 811111111119),
        ("234234234234278", 434234234278),
        ("818181911112111", 888911112111),
    ],
)
def test_bank_joltage_part2(bank: str, joltage: int):
    assert bank_joltage(bank, 12) == joltage


def test_part_two():
    assert part2(TEST_INPUT) == 3121910778619
