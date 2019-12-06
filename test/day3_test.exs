defmodule Day3Test do
  alias Day3
  use ExUnit.Case
  doctest Day3

  test "Day3 Part1 segment" do
    assert Day3.segment({0, 0}, "R4") == {{4, 0}, {0, 0, 4, 0}}
    assert Day3.segment({15, 23}, "D2") == {{15, 21}, {15, 21, 15, 23}}
  end

  test "Day3 Part1 segments" do
    assert Day3.segments(["R4", "D3"], {0, 0}) == [{0, 0, 4, 0}, {4, -3, 4, 0}]
  end
end
