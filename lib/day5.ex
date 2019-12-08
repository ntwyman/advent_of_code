defmodule Day5 do
  @spec run_diagnostics(String.t(), integer) :: integer
  defp run_diagnostics(file_name, input) do
    Files.read_integers!(file_name)
    |> IntComp.run([input])
    |> hd
  end

  @spec part1(String.t()) :: integer
  def part1(file_name) do
    run_diagnostics(file_name, 1)
  end

  @spec part2(String.t()) :: integer
  def part2(file_name) do
    run_diagnostics(file_name, 5)
  end
end
