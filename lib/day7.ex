defmodule Day7 do
  import IntComp

  @spec run_amplifier([integer], integer, integer) :: integer
  def run_amplifier(program, phase, input) do
    hd(run(program, [phase, input]))
  end

  @spec run_amplifiers([integer], integer, [0..4]) :: integer
  def run_amplifiers(program, input, phases) do
    case phases do
      [] ->
        input

      [phase | next] ->
        run_amplifiers(program, run_amplifier(program, phase, input), next)
    end
  end

  @spec permutations([Integer]) :: [[Integer]]
  def permutations(values) when values == [], do: [[]]

  def permutations(values) do
    for v <- values, rest <- permutations(values -- [v]), do: [v | rest]
  end

  @spec tune_amplifiers([integer]) :: integer
  def tune_amplifiers(program) do
    phases = permutations(Enum.to_list(0..4))

    Enum.reduce(phases, 0, fn phase_list, acc ->
      thrust = run_amplifiers(program, 0, phase_list)
      if thrust > acc, do: thrust, else: acc
    end)
  end

  @spec part1(String.t()) :: integer
  def part1(file_name) do
    Files.read_integers!(file_name)
    |> tune_amplifiers()
  end
end
