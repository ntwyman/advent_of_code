defmodule Day10 do
  defmodule Pos do
    defstruct x: 0, y: 0
  end

  @spec angle(integer, integer) :: String.t()
  defp angle(delta_x, delta_y) do
    x_mag = abs(delta_x)
    y_mag = abs(delta_y)
    x_sign = if delta_x < 0, do: "-", else: ""
    y_sign = if delta_y < 0, do: "-", else: ""

    {x_ang, y_ang} =
      case {x_mag, y_mag} do
        {0, _} ->
          {0, 1}

        {_, 0} ->
          {1, 0}

        _ ->
          d = Integer.gcd(x_mag, y_mag)
          {x_mag / d, y_mag / d}
      end

    "#{x_sign}#{x_ang}:#{y_sign}#{y_ang}"
  end

  defp count_visible(positions, base) do
    Enum.reduce(positions, MapSet.new(), fn pos, angles ->
      delta_x = pos.x - base.x
      delta_y = pos.y - base.y

      if delta_x == 0 and delta_y == 0 do
        angles
      else
        MapSet.put(angles, angle(delta_x, delta_y))
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
    |> Enum.map(fn {chr, x_coord} ->
      if chr == ?#, do: %Pos{x: x_coord, y: y_coord}, else: %Pos{x: -1, y: -1}
    end)
    |> Enum.reject(fn pos -> pos == %Pos{x: -1, y: -1} end)
  end

  @spec reduce_map([String.t()]) :: [Pos.t()]
  def reduce_map(space_map) do
    Enum.with_index(space_map)
    |> Enum.map(&line_to_positions/1)
    |> List.flatten()
  end

  @spec search_map([String.t()]) :: {integer, Pos.t()}
  def search_map(space_map) do
    search(reduce_map(space_map))
  end

  @spec part1(String.t()) :: String.t()
  def part1(file_name) do
    {best, base} =
      Files.read_lines!(file_name)
      |> search_map()

    "Base at #{base.x}, #{base.y}, can see #{best} asteroids"
  end
end
