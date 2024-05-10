defmodule Day6 do
  @type orbits() :: %{String.t() => String.t()}

  @spec add_orbit([String.t()], orbits()) :: orbits()
  defp add_orbit([center, body], orbit_map) do
    Map.put(orbit_map, body, center)
  end

  @spec count_orbits(orbits(), String.t()) :: integer
  defp count_orbits(map, center) do
    case center do
      "COM" -> 1
      _ -> 1 + count_orbits(map, map[center])
    end
  end

  @spec map_orbits([String.t()]) :: orbits()
  def map_orbits(orbit_definitions) do
    Enum.map(orbit_definitions, fn s -> String.split(s, ")") end)
    |> Enum.reduce(%{}, &add_orbit/2)
  end

  @spec map_and_count([Strint.t()]) :: integer
  def map_and_count(orbit_definitions) do
    orbit_map = map_orbits(orbit_definitions)

    Enum.map(orbit_map, fn {_body, center} -> count_orbits(orbit_map, center) end)
    |> Enum.sum()
  end

  @spec part1(String.t()) :: integer
  def part1(file_name) do
    Files.read_lines!(file_name)
    |> map_and_count()
  end

  @spec get_transfer_to_com(orbits(), String.t()) :: [String.t()]
  def get_transfer_to_com(orbit_map, body) do
    case body do
      "COM" -> []
      _ -> [body | get_transfer_to_com(orbit_map, orbit_map[body])]
    end
  end

  @spec do_intersect([String.t()], [String.t()]) :: integer
  defp do_intersect(path_1, path_2) do
    [h_1 | tail_1] = path_1
    [h_2 | tail_2] = path_2

    case h_1 == h_2 do
      false -> length(path_1) + length(path_2) - 2
      true -> do_intersect(tail_1, tail_2)
    end
  end

  @spec count_transfers([String.t()], [String.t()]) :: integer
  def count_transfers(path_1, path_2) do
    do_intersect(Enum.reverse(path_1), Enum.reverse(path_2))
  end

  @spec transfers(orbits(), String.t(), String.t()) :: integer
  def transfers(orbit_map, body_1, body_2) do
    path_1 = get_transfer_to_com(orbit_map, body_1)
    path_2 = get_transfer_to_com(orbit_map, body_2)
    count_transfers(path_1, path_2)
  end

  @spec part2(String.t()) :: integer
  def part2(file_name) do
    orbit_map = map_orbits(Files.read_lines!(file_name))
    transfers(orbit_map, "YOU", "SAN")
  end
end
