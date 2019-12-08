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

  @spec part1(String.t()) :: integer
  def part1(file_name) do
    layer_counts =
      File.read!(file_name)
      |> String.trim()
      |> make_splits(150)
      |> Enum.map(&count_chars/1)

    {_, c} =
      Enum.reduce(layer_counts, {150, 0}, fn cnts, {zcnt, mult} ->
        zcount = cnts[?0]
        IO.puts(zcount)

        if not is_nil(zcount) and zcount < zcnt do
          IO.puts("switch")
          {zcount, cnts[?1] * cnts[?2]}
        else
          IO.puts("stick")
          {zcnt, mult}
        end
      end)

    c
  end
end
