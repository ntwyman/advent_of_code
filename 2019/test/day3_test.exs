defmodule Day3Test do
  alias Day3.Extent
  alias Day3.Point
  use ExUnit.Case
  doctest Day3

  test "Day3 Part1 segment" do
    assert Day3.segment(%Point{}, "R4") == {%Point{x: 4}, %Extent{max_x: 4}}

    assert Day3.segment(%Point{x: 15, y: 23}, "D2") ==
             {%Point{x: 15, y: 21},
              %Extent{min_x: 15, min_y: 21, max_x: 15, max_y: 23, start_x: 15, start_y: 23}}
  end

  test "Day3 Part1 segments" do
    assert Day3.segments(["R4", "D3"], %Point{}) == [
             %Extent{max_x: 4},
             %Extent{min_x: 4, min_y: -3, max_x: 4, start_x: 4}
           ]
  end

  test "Day3 Part1 intersects" do
    assert Day3.crossings(
             %Extent{min_x: 0, min_y: 3, max_x: 4, max_y: 3},
             %Extent{min_x: 1, min_y: 0, max_x: 5, max_y: 0}
           ) == []

    assert Day3.crossings(
             %Extent{min_x: 0, min_y: 3, max_x: 4, max_y: 3},
             %Extent{min_x: 1, min_y: 0, max_x: 1, max_y: 5}
           ) == [%Point{x: 1, y: 3}]

    assert Day3.crossings(
             %Extent{min_x: 0, min_y: 3, max_x: 4, max_y: 3},
             %Extent{min_x: 1, min_y: 3, max_x: 7, max_y: 3}
           ) == [%Point{x: 1, y: 3}, %Point{x: 2, y: 3}, %Point{x: 3, y: 3}, %Point{x: 4, y: 3}]

    assert Day3.crossings(
             %Extent{min_x: 13, min_y: 5, max_x: 13, max_y: 11},
             %Extent{min_x: 13, min_y: 7, max_x: 13, max_y: 13}
           ) == [
             %Point{x: 13, y: 7},
             %Point{x: 13, y: 8},
             %Point{x: 13, y: 9},
             %Point{x: 13, y: 10},
             %Point{x: 13, y: 11}
           ]

    assert(Day3.crossings(%Extent{max_x: 75}, %Extent{min_y: 62, max_x: 66, max_y: 62}) == [])
  end

  test "Day3 Part1 manhattan_distance" do
    assert Day3.manhattan_distance(
             "R75,D30,R83,U83,L12,D49,R71,U7,L72",
             "U62,R66,U55,R34,D71,R55,D58,R83"
           ) == 159

    assert Day3.manhattan_distance(
             "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
             "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
           ) == 135
  end

  test "Day3 Part2 timing_distance" do
    assert Day3.timing_distance(
             "R75,D30,R83,U83,L12,D49,R71,U7,L72",
             "U62,R66,U55,R34,D71,R55,D58,R83"
           ) == 610

    assert Day3.timing_distance(
             "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
             "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
           ) == 410
  end
end
