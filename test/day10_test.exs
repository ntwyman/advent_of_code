defmodule Day10Test do
  alias Day10.Pos
  use ExUnit.Case
  doctest Day10

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
    assert Day10.reduce_map(@small) == [
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
end
