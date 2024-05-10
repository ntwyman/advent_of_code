defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "Day1 Part1" do
    assert Day1.fuel(12) == 2
    assert Day1.fuel(14) == 2
    assert Day1.fuel(1969) == 654
    assert Day1.fuel(100_756) == 33583
  end

  test "Day1 Part2" do
    assert Day1.total_fuel(12) == 2
    assert Day1.total_fuel(1969) == 966
    assert Day1.total_fuel(100_756) == 50346
  end
end
