from day1 import part1, do_move, part2


def test_do_move():
    assert do_move(50, "R1", 0) == (51, 0)
    assert do_move(50, "L1", 1) == (49, 0)
    assert do_move(50, "R51", 1) == (1, 1)
    assert do_move(50, "L51", 0) == (99, 0)


TEST_LINES = ["L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82"]


def test_part1():
    assert part1(TEST_LINES) == 3


def test_part2():
    assert part2(TEST_LINES) == 6
