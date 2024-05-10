defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "Day6 Part1" do
    assert Day6.map_and_count([
             "COM)B",
             "B)C",
             "C)D",
             "D)E",
             "E)F",
             "B)G",
             "G)H",
             "D)I",
             "E)J",
             "J)K",
             "K)L"
           ]) == 42
  end

  test "Day6 Part2" do
    orbit_map =
      Day6.map_orbits([
        "COM)B",
        "B)C",
        "C)D",
        "D)E",
        "E)F",
        "B)G",
        "G)H",
        "D)I",
        "E)J",
        "J)K",
        "K)L",
        "K)YOU",
        "I)SAN"
      ])

    assert Day6.get_transfer_to_com(orbit_map, "D") == ["D", "C", "B"]
    assert Day6.transfers(orbit_map, "YOU", "SAN") == 4
  end
end
