defmodule Day8 do
  def make_splits(string, size) do
    {layer, rest} = String.split_at(string, size)

    if String.length(rest) <= size do
      [layer, rest]
    else
      [layer | make_splits(rest, size)]
    end
  end

  def count_chars(layer) do
    Enum.reduce(
      to_charlist(layer),
      %{},
      fn chr, acc -> Map.put(acc, chr, Map.get(acc, chr, 0) + 1) end
    )
  end

  @spec layer_cake(String.t()) :: [String.t()]
  def layer_cake(file_name) do
    File.read!(file_name)
    |> String.trim()
    |> make_splits(150)
  end

  @spec part1(String.t()) :: integer
  def part1(file_name) do
    layer_counts = Enum.map(layer_cake(file_name), &count_chars/1)

    {_, c} =
      Enum.reduce(layer_counts, {150, 0}, fn cnts, {zcnt, mult} ->
        zcount = cnts[?0]

        if not is_nil(zcount) and zcount < zcnt do
          {zcount, cnts[?1] * cnts[?2]}
        else
          {zcnt, mult}
        end
      end)

    c
  end

  @spec decode(char()) :: char()
  def decode(pixel_code) do
    case pixel_code do
      ?0 -> 0x20
      ?1 -> ?*
      _ -> pixel_code
    end
  end

  @spec opacity(charlist(), charlist()) :: charlist()
  def opacity([], []), do: []

  def opacity(behind, front) do
    [b_1 | b_rest] = behind
    [f_1 | f_rest] = front
    v = decode(if f_1 == ?2, do: b_1, else: f_1)
    [v | opacity(b_rest, f_rest)]
  end

  @spec part2(String.t()) :: String.t()
  def part2(file_name) do
    layers =
      layer_cake(file_name)
      |> Enum.map(&to_charlist/1)

    image = to_string(Enum.reduce(layers, &opacity/2))

    Enum.join(make_splits(image, 25), "\n")
  end
end
