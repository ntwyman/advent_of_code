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
end
