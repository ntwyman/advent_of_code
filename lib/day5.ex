defmodule Day5 do
  @spec part1(String.t()) :: integer
  def part1(file_name) do
    File.read!(file_name)
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> IntComp.run([1])
    |> IntComp.get_output()
    |> hd
  end
end
