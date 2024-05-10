defmodule Day7Test do
  use ExUnit.Case
  doctest Day7
  @example_1 [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0]
  @example_2 [
    3,
    23,
    3,
    24,
    1002,
    24,
    10,
    24,
    1002,
    23,
    -1,
    23,
    101,
    5,
    23,
    23,
    1,
    24,
    23,
    23,
    4,
    23,
    99,
    0,
    0
  ]

  @example_3 [
    3,
    31,
    3,
    32,
    1002,
    32,
    10,
    32,
    1001,
    31,
    -2,
    31,
    1007,
    31,
    0,
    33,
    1002,
    33,
    7,
    33,
    1,
    33,
    31,
    31,
    1,
    32,
    31,
    31,
    4,
    31,
    99,
    0,
    0,
    0
  ]

  test "Day7 Part1" do
    assert Day7.run_amplifiers(
             @example_1,
             0,
             [4, 3, 2, 1, 0]
           ) == 43210

    assert Day7.tune_amplifiers(@example_1) == 43210

    assert Day7.run_amplifiers(
             @example_2,
             0,
             [0, 1, 2, 3, 4]
           ) == 54321

    assert Day7.tune_amplifiers(@example_2) == 54321

    assert Day7.run_amplifiers(
             @example_3,
             0,
             [1, 0, 4, 3, 2]
           ) == 65210

    assert Day7.tune_amplifiers(@example_3) == 65210
  end

  @example_4 [
    3,
    26,
    1001,
    26,
    -4,
    26,
    3,
    27,
    1002,
    27,
    2,
    27,
    1,
    27,
    26,
    27,
    4,
    27,
    1001,
    28,
    -1,
    28,
    1005,
    28,
    6,
    99,
    0,
    0,
    5
  ]
  test "Day7 Part2" do
    assert Day7.run_looped_amplifiers(@example_4, 0, [9, 8, 7, 6, 5]) == 139_629_729
  end

  test "Day7 Part2 tune" do
    assert Day7.tune_amplifiers(@example_4, true) == 139_629_729
  end
end
