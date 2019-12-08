defmodule Day1 do
  def fuel(mass) do
    Kernel.trunc(mass / 3) - 2
  end

  def total_fuel(mass) when mass < 9, do: 0

  def total_fuel(mass) when mass >= 9 do
    fuel(mass)
    |> (fn f -> f + total_fuel(f) end).()
  end

  defp process(file_name, calculator) do
    Files.read_lines!(file_name)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(calculator)
    |> Enum.reduce(0, fn a, b -> a + b end)
  end

  def part1(file) do
    process(file, &fuel/1)
  end

  def part2(file) do
    process(file, &total_fuel/1)
  end
end
