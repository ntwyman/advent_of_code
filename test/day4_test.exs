defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "Day4 Part1 is_valid" do
    assert Day4.is_valid_string("111111")
    assert not Day4.is_valid_string("223450")
    assert Day4.is_valid_string("1123789")
  end
end
