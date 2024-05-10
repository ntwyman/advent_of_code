defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "Day4 Part1 is_valid" do
    assert Day4.is_valid(111_111)
    assert not Day4.is_valid(223_450)
    assert not Day4.is_valid(123_789)
  end

  test "Day4 Part2 is_valid_2" do
    assert Day4.is_valid_2(112_233)
    assert not Day4.is_valid_2(123_444)
    assert Day4.is_valid_2(111_122)
    assert Day4.is_valid_2(127_789)
  end
end
