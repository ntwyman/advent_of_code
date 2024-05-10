defmodule IntCompTest do
  use ExUnit.Case
  doctest IntComp

  @compare_to_8 [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]
  @less_than_8 [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]
  @compare_to_8_immed [3, 3, 1108, -1, 8, 3, 4, 3, 99]
  @less_than_8_immed [3, 3, 1107, -1, 8, 3, 4, 3, 99]

  @non_zero [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]
  @non_zero_immed [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1]

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

  test "IntComp run" do
    assert IntComp.run(@compare_to_8, [3]) == [0]
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
    assert IntComp.run(@non_zero, [-35]) == [1]
    assert IntComp.run(@non_zero, [0]) == [0]
    assert IntComp.run(@non_zero, [213_492_348]) == [1]

    assert IntComp.run(@non_zero_immed, [-35]) == [1]
    assert IntComp.run(@non_zero_immed, [0]) == [0]
    assert IntComp.run(@non_zero_immed, [213_492_348]) == [1]

    assert IntComp.run(@around_8, [-35]) == [999]
    assert IntComp.run(@around_8, [8]) == [1000]
    assert IntComp.run(@around_8, [213_492_348]) == [1001]
  end

  test "IntComp Run as process direct input" do
    # First with supplied input
    comp = IntComp.run_as_process(@compare_to_8, [3], self())
    send(comp, {:run})
    assert_receive {:value, 0}
    send(comp, {:is_halted})
    assert_receive {:halted, true}
    Process.exit(comp, :kill)
  end

  test "IntComp Run as process send input" do
    # First with supplied input
    comp = IntComp.run_as_process(@compare_to_8, [], self())
    send(comp, {:run})

    send(comp, {:is_halted})
    assert_receive {:halted, false}

    send(comp, {:value, 8})
    assert_receive {:value, 1}

    send(comp, {:is_halted})
    assert_receive {:halted, true}
    Process.exit(comp, :kill)
  end

  @narcissus [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
  test "IntComp relative base addressing" do
    assert IntComp.run(@narcissus, []) == Enum.reverse(@narcissus)
  end

  @sweet_16 [1102, 34_915_192, 34_915_192, 7, 4, 7, 99, 0]
  @piggy [104, 1_125_899_906_842_624, 99]
  test "IntComp big numbers" do
    [val] = IntComp.run(@sweet_16, [])
    assert String.length(Integer.to_string(val)) == 16

    assert IntComp.run(@piggy, []) == [1_125_899_906_842_624]
  end

  @boost_bug [109, 12, 203, -12, 4, 0, 99]
  test "BOOST Bug" do
    assert IntComp.run(@boost_bug, [23786]) == [23786]
  end
end
