defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  @compare_to_8 [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]
  @less_than_8 [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]
  @compare_to_8_immed [3, 3, 1108, -1, 8, 3, 4, 3, 99]
  @less_than_8_immed [3, 3, 1107, -1, 8, 3, 4, 3, 99]

  test "Day5 Part2 Compare" do
    assert IntComp.run(@compare_to_8, [8]) == [1]
    assert IntComp.run(@compare_to_8, [-15]) == [0]

    assert IntComp.run(@less_than_8, [-15]) == [1]
    assert IntComp.run(@less_than_8, [8]) == [0]
    assert IntComp.run(@less_than_8, [9]) == [0]

    assert IntComp.run(@compare_to_8_immed, [8]) == [1]
    assert IntComp.run(@compare_to_8_immed, [-15]) == [0]

    assert IntComp.run(@less_than_8_immed, [-15]) == [1]
    assert IntComp.run(@less_than_8_immed, [8]) == [0]
    assert IntComp.run(@less_than_8_immed, [9]) == [0]
  end

  @non_zero [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]
  @non_zero_immed [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1]

  test "Day5 Part2 Jump" do
    assert IntComp.run(@non_zero, [-35]) == [1]
    assert IntComp.run(@non_zero, [0]) == [0]
    assert IntComp.run(@non_zero, [213_492_348]) == [1]

    assert IntComp.run(@non_zero_immed, [-35]) == [1]
    assert IntComp.run(@non_zero_immed, [0]) == [0]
    assert IntComp.run(@non_zero_immed, [213_492_348]) == [1]
  end

  @around_8 [
    3,
    21,
    1008,
    21,
    8,
    20,
    1005,
    20,
    22,
    107,
    8,
    21,
    20,
    1006,
    20,
    31,
    1106,
    0,
    36,
    98,
    0,
    0,
    1002,
    21,
    125,
    20,
    4,
    20,
    1105,
    1,
    46,
    104,
    999,
    1105,
    1,
    46,
    1101,
    1000,
    1,
    20,
    4,
    20,
    1105,
    1,
    46,
    98,
    99
  ]

  test "Day5 Part2 Around 8" do
    assert IntComp.run(@around_8, [-35]) == [999]
    assert IntComp.run(@around_8, [8]) == [1000]
    assert IntComp.run(@around_8, [213_492_348]) == [1001]
  end
end
