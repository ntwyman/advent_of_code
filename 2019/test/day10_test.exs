defmodule Day10Test do
  alias Day10.Pos
  use ExUnit.Case
  doctest Day10

  test "Day 10 Angle" do
    # Up
    assert Day10.angle(%Pos{x: 1, y: 1}, %Pos{x: 1, y: 0}) == 0.0
    # right
    assert Day10.angle(%Pos{x: 1, y: 1}, %Pos{x: 2, y: 1}) == :math.pi() / 2
    # down
    assert Day10.angle(%Pos{x: 1, y: 1}, %Pos{x: 1, y: 2}) == :math.pi()
    # left
    assert Day10.angle(%Pos{x: 1, y: 1}, %Pos{x: 0, y: 1}) == 3 * :math.pi() / 2.0
  end

  @small [".#..#", ".....", "#####", "....#", "...##"]

  @example_1 [
    "......#.#.",
    "#..#.#....",
    "..#######.",
    ".#.#.###..",
    ".#..#.....",
    "..#....#.#",
    "#..#....#.",
    ".##.#..###",
    "##...#..#.",
    ".#....####"
  ]

  test "Day 10 Part1" do
    assert Day10.reduce_to_map(@small) == [
             %Pos{x: 1, y: 0},
             %Pos{x: 4, y: 0},
             %Pos{x: 0, y: 2},
             %Pos{x: 1, y: 2},
             %Pos{x: 2, y: 2},
             %Pos{x: 3, y: 2},
             %Pos{x: 4, y: 2},
             %Pos{x: 4, y: 3},
             %Pos{x: 3, y: 4},
             %Pos{x: 4, y: 4}
           ]

    assert Day10.search_map(@example_1) == {33, %Pos{x: 5, y: 8}}
  end

  @small_boom [
    ".#....#####...#..",
    "##...##.#####..##",
    "##...#...#.#####.",
    "..#.....#...###..",
    "..#.#.....#....##"
  ]

  test "Day 10, Small Boom" do
    positions = Day10.reduce_to_map(@small_boom)

    assert Enum.take(Day10.boom_list(positions, %Pos{x: 8, y: 3}), 9) ==
             [
               %Pos{x: 8, y: 1},
               %Pos{x: 9, y: 0},
               %Pos{x: 9, y: 1},
               %Pos{x: 10, y: 0},
               %Pos{x: 9, y: 2},
               %Pos{x: 11, y: 1},
               %Pos{x: 12, y: 1},
               %Pos{x: 11, y: 2},
               %Pos{x: 15, y: 1}
             ]
  end

  @boom_test [
    ".#..##.###...#######",
    "##.############..##.",
    ".#.######.########.#",
    ".###.#######.####.#.",
    "#####.##.#.##.###.##",
    "..#####..#.#########",
    "####################",
    "#.####....###.#.#.##",
    "##.#################",
    "#####.##.###..####..",
    "..######..##.#######",
    "####.##.####...##..#",
    ".#####..#.######.###",
    "##...#.##########...",
    "#.##########.#######",
    ".####.#.###.###.#.##",
    "....##.##.###..#####",
    ".#.#.###########.###",
    "#.#.#.#####.####.###",
    "###.##.####.##.#..##"
  ]
  test "Day 10 Part2" do
    big_boom_list = Day10.boom_order(@boom_test)

    assert Enum.take(big_boom_list, 3) == [
             %Pos{x: 11, y: 12},
             %Pos{x: 12, y: 1},
             %Pos{x: 12, y: 2}
           ]

    assert Enum.at(big_boom_list, 99) == %Pos{x: 10, y: 16}
  end
end
