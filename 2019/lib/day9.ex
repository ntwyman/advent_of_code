defmodule Day9 do
  @spec run_boost(String.t(), integer) :: String.t()
  defp run_boost(file_name, input) do
    Files.read_integers!(file_name)
    |> IntComp.run([input])
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join(", ")
  end

  @spec part1(String.t()) :: String.t()
  def part1(file_name) do
    run_boost(file_name, 1)
  end

  @spec part2(String.t()) :: String.t()
  def part2(file_name) do
    run_boost(file_name, 2)
  end
end
