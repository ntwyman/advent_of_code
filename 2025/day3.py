def find_max_digit(batt: str) -> int:
    return max([int(c) for c in batt])


def bank_joltage_step(bank: str, batts: int, joltage: int):
    if batts == 1:
        return joltage * 10 + find_max_digit(bank)
    batts -= 1
    max_digit = find_max_digit(bank[:-batts])
    after = bank[bank.find(str(max_digit)) + 1 :]
    return bank_joltage_step(after, batts, joltage * 10 + max_digit)


def bank_joltage(bank: str, batts: int) -> int:
    return bank_joltage_step(bank, batts, 0)


def part1(input: list[str]) -> int:
    return sum([bank_joltage(b, 2) for b in input])


def part2(input: list[str]) -> int:
    return sum([bank_joltage(b, 12) for b in input])
