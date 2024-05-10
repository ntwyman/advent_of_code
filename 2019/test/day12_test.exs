defmodule Day12Test do
  alias Day12.Triplet
  alias Day12.Moon
  use ExUnit.Case
  doctest Day12

  test "Day 12 New Moon" do
    # Up
    assert Day12.new_moon("<x=-1, y=0, z=2>") == %Moon{pos: %Triplet{x: -1, y: 0, z: 2}}
  end

  test "Day 12 Pairs" do
    assert Day12.pairs(["one", "two", "three"]) == [
             {"one", "two"},
             {"one", "three"},
             {"two", "three"}
           ]
  end

  test "Day 12 Gravity" do
    moon_1 = %Moon{}
    moon_2 = %Moon{pos: %Triplet{x: -1, y: 0, z: 1}}

    assert Day12.gravity(moon_1, moon_2) ==
             {
               %Moon{vel: %Triplet{x: -1, y: 0, z: 1}},
               %Moon{pos: %Triplet{x: -1, y: 0, z: 1}, vel: %Triplet{x: 1, y: 0, z: -1}}
             }
  end

  @step_0 %{
    :io => %Moon{pos: %Triplet{x: -1, y: 0, z: 2}, vel: %Triplet{x: 0, y: 0, z: 0}},
    :europa => %Moon{pos: %Triplet{x: 2, y: -10, z: -7}, vel: %Triplet{x: 0, y: 0, z: 0}},
    :ganymede => %Moon{pos: %Triplet{x: 4, y: -8, z: 8}, vel: %Triplet{x: 0, y: 0, z: 0}},
    :callisto => %Moon{pos: %Triplet{x: 3, y: 5, z: -1}, vel: %Triplet{x: 0, y: 0, z: 0}}
  }

  @step_1 %{
    :io => %Moon{pos: %Triplet{x: 2, y: -1, z: 1}, vel: %Triplet{x: 3, y: -1, z: -1}},
    :europa => %Moon{pos: %Triplet{x: 3, y: -7, z: -4}, vel: %Triplet{x: 1, y: 3, z: 3}},
    :ganymede => %Moon{pos: %Triplet{x: 1, y: -7, z: 5}, vel: %Triplet{x: -3, y: 1, z: -3}},
    :callisto => %Moon{pos: %Triplet{x: 2, y: 2, z: 0}, vel: %Triplet{x: -1, y: -3, z: 1}}
  }

  test "Day 12 Step" do
    assert Day12.step(@step_0) == @step_1
  end

  @step_0_long %{
    :io => %Moon{pos: %Triplet{x: -8, y: -10, z: 0}},
    :europa => %Moon{pos: %Triplet{x: 5, y: 5, z: 10}},
    :ganymede => %Moon{pos: %Triplet{x: 2, y: -7, z: 3}},
    :callisto => %Moon{pos: %Triplet{x: 9, y: -8, z: -3}}
  }

  @step_100 %{
    :io => %Moon{pos: %Triplet{x: 8, y: -12, z: -9}, vel: %Triplet{x: -7, y: 3, z: 0}},
    :europa => %Moon{pos: %Triplet{x: 13, y: 16, z: -3}, vel: %Triplet{x: 3, y: -11, z: -5}},
    :ganymede => %Moon{pos: %Triplet{x: -29, y: -11, z: -1}, vel: %Triplet{x: -3, y: 7, z: 4}},
    :callisto => %Moon{pos: %Triplet{x: 16, y: -13, z: 23}, vel: %Triplet{x: 7, y: 1, z: 1}}
  }

  test "Day 12 Steps" do
    assert Day12.steps(@step_0_long, 100) == @step_100
  end

  test "Day 12 energy" do
    assert Day12.system_energy(@step_100) == 1940
  end

  @step_0_btf %{
    0 => %Moon{pos: %Triplet{x: -1, y: 0, z: 2}, vel: %Triplet{x: 0, y: 0, z: 0}},
    1 => %Moon{pos: %Triplet{x: 2, y: -10, z: -7}, vel: %Triplet{x: 0, y: 0, z: 0}},
    2 => %Moon{pos: %Triplet{x: 4, y: -8, z: 8}, vel: %Triplet{x: 0, y: 0, z: 0}},
    3 => %Moon{pos: %Triplet{x: 3, y: 5, z: -1}, vel: %Triplet{x: 0, y: 0, z: 0}}
  }

  test "Day 12 Back to the future" do
    assert Day12.back_to_the_future(@step_0_btf) == 2772
  end
end
