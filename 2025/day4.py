NEIGHBORS = [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]


class Grid:
    def __init__(self, lines: list[str]):
        self._lines = [list(line) for line in lines]
        self.sizeX = len(lines[0])
        self.sizeY = len(lines)

    def isRoll(self, x, y):
        if x < 0 or x >= self.sizeX:
            return False
        if y < 0 or y >= self.sizeY:
            return False
        return self._lines[y][x] == "@"

    def remove(self, rolls: list[tuple[int, int]]):
        for rx, ry in rolls:
            self._lines[ry][rx] = "."

    def neighbors(self, x: int, y: int):
        return [self.isRoll(x + dx, y + dy) for (dx, dy) in NEIGHBORS].count(True)


def do_pass(grid: Grid) -> list[tuple[int, int]]:
    moveable = []
    for y in range(grid.sizeY):
        for x in range(grid.sizeX):
            if grid.isRoll(x, y) and (grid.neighbors(x, y) < 4):
                moveable.append((x, y))
    return moveable


def part1(input: list[str]) -> int:
    grid = Grid(input)
    moveable_rolls = do_pass(grid)
    return len(moveable_rolls)


def part2(input: list[str]) -> int:
    grid = Grid(input)
    removed = 0
    while True:
        moveable = do_pass(grid)
        if len(moveable) == 0:
            break
        removed += len(moveable)
        grid.remove(moveable)
    return removed
