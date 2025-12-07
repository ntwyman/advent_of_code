def do_move(pos: int, move: str, part2: int) -> tuple[int, int]:
    amt = int(move[1:])
    pos = pos + amt if move[0] == "R" else (pos - amt)
    zeros = 0
    while pos >= 100:
        zeros += part2
        pos -= 100
    while pos < 0:
        pos += 100
        zeros += part2
    if pos == 0 and not part2:
        zeros += 1

    return pos, zeros


def count_zeros(moves: list[str], part2: int):
    pos = 50
    password = 0
    for move in moves:
        pos, zeros = do_move(pos, move, part2)
        password += zeros
    return password


def part1(moves: list[str]) -> int:
    return count_zeros(moves, 0)


def part2(moves: list[str]) -> int:
    return count_zeros(moves, 1)
