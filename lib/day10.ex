defmodule Day10 do
  defmodule Pos do
    defstruct x: 0, y: 0
  end

  @spec angle(Pos.t(), Pos.t()) :: float
  def angle(base, pos) do
    # Y goes down and measuring angles clockwise from UP. Hence odd delta's
    angle = ElixirMath.atan2(pos.x - base.x / 1, base.y - pos.y / 1)
    if angle < 0, do: angle + 2 * :math.pi(), else: angle
  end

  defp count_visible(positions, base) do
    Enum.reduce(positions, MapSet.new(), fn pos, angles ->
      if pos == base do
        angles
      else
        MapSet.put(angles, angle(base, pos))
      end
    end)
    |> MapSet.size()
  end

  @spec search([Pos.t()]) :: {integer, Pos.t()}
  defp search(positions) do
    Enum.reduce(positions, {0, nil}, fn base, {best_count, best_base} ->
      visible = count_visible(positions, base)

      if visible > best_count do
        {visible, base}
      else
        {best_count, best_base}
      end
    end)
  end

  @spec line_to_positions({String.t(), integer}) :: [Pos.t()]
  defp line_to_positions({line, y_coord}) do
    to_charlist(line)
    |> Enum.with_index()
    |> Enum.filter(fn {chr, _} -> chr == ?# end)
    |> Enum.map(fn {_, x_coord} -> %Pos{x: x_coord, y: y_coord} end)
  end

  @spec reduce_to_map([String.t()]) :: [Pos.t()]
  def reduce_to_map(space_map) do
    Enum.with_index(space_map)
    |> Enum.map(&line_to_positions/1)
    |> List.flatten()
  end

  @spec search_map([String.t()]) :: {integer, Pos.t()}
  def search_map(space_map) do
    search(reduce_to_map(space_map))
  end

  @spec part1(String.t()) :: String.t()
  def part1(file_name) do
    {best, base} =
      Files.read_lines!(file_name)
      |> search_map()

    "Base at #{base.x}, #{base.y}, can see #{best} asteroids"
  end

  @type a_vec :: {Pos.t(), integer}
  @spec insert_in_list([a_vec()], a_vec()) :: [a_vec()]
  def insert_in_list(boom_list, target) do
    case boom_list do
      [] ->
        [target]

      [nearest | hidden] ->
        if elem(target, 1) < elem(nearest, 1) do
          [target | boom_list]
        else
          [nearest | insert_in_list(hidden, target)]
        end
    end
  end

  @spec extract_booms([[a_vec()]]) :: [Pos.t()]
  defp extract_booms(angle_lists) do
    # Each item in the input is a non-empty list of the asteroids along a given vector.
    # The lists are in angular order, so each time round the laser booms the first one
    # on the list

    case angle_lists do
      [] ->
        []

      # Can do this nested as we know lists are non-empty
      [[boomer | saved_for_now] | other_vectors] ->
        new_list =
          if saved_for_now == [], do: other_vectors, else: other_vectors ++ [saved_for_now]

        [elem(boomer, 0) | extract_booms(new_list)]
    end
  end

  @spec boom_list([Pos.t()], Pos.t()) :: [Pos.t()]
  def boom_list(positions, base) do
    boom_hash =
      Enum.reduce(positions, %{}, fn pos, order_hash ->
        if base == pos do
          order_hash
        else
          angle_key = angle(base, pos)
          old_list = Map.get(order_hash, angle_key, [])

          Map.put(
            order_hash,
            angle_key,
            insert_in_list(old_list, {pos, abs(pos.x - base.x) + abs(pos.y - base.y)})
          )
        end
      end)

    Map.keys(boom_hash)
    |> Enum.sort()
    |> Enum.map(fn line_of_sight -> boom_hash[line_of_sight] end)
    |> extract_booms()
  end

  @spec boom_order([String.t()]) :: [Pos.t()]
  def boom_order(lines) do
    positions = reduce_to_map(lines)

    {_, base} = search(positions)
    boom_list(positions, base)
  end

  @spec part2(String.t()) :: integer
  def part2(file_name) do
    pos =
      Files.read_lines!(file_name)
      |> boom_order()
      # Two hard things in computing
      |> Enum.at(199)

    pos.x * 100 + pos.y
  end
end
