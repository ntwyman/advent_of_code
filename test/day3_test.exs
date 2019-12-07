defmodule Day3Test do
  alias Day3.Extent
  alias Day3.Point
  use ExUnit.Case
  doctest Day3

  test "Day3 Part1 segment" do
    assert Day3.segment(%Point{}, "R4") == {%Point{x: 4}, %Extent{max_x: 4}}

    assert Day3.segment(%Point{x: 15, y: 23}, "D2") ==
             {%Point{x: 15, y: 21}, %Extent{min_x: 15, min_y: 21, max_x: 15, max_y: 23}}
  end

  test "Day3 Part1 segments" do
    assert Day3.segments(["R4", "D3"], %Point{}) == [
             %Extent{max_x: 4},
             %Extent{min_x: 4, min_y: -3, max_x: 4}
           ]
  end

  test "Day3 Part1 intersects" do
    assert Day3.intersects(
             %Extent{min_x: 0, min_y: 3, max_x: 4, max_y: 3},
             %Extent{min_x: 1, min_y: 0, max_x: 1, max_y: 5}
           ) == [%Point{x: 1, y: 3}]

    assert Day3.intersects(
             %Extent{min_x: 0, min_y: 3, max_x: 4, max_y: 3},
             %Extent{min_x: 1, min_y: 3, max_x: 7, max_y: 3}
           ) == [%Point{x: 1, y: 3}, %Point{x: 2, y: 3}, %Point{x: 3, y: 3}, %Point{x: 4, y: 3}]

    assert Day3.intersects(
             %Extent{min_x: 13, min_y: 5, max_x: 13, max_y: 11},
             %Extent{min_x: 13, min_y: 7, max_x: 13, max_y: 13}
           ) == [
             %Point{x: 13, y: 7},
             %Point{x: 13, y: 8},
             %Point{x: 13, y: 9},
             %Point{x: 13, y: 10},
             %Point{x: 13, y: 11}
           ]
  end
end
