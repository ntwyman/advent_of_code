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

  @spec tune_amplifiers([integer]) :: integer
  def tune_amplifiers(program) do
    phases =
      for n <- 0..3124,
          do: [div(n, 625), rem(div(n, 125), 5), rem(div(n, 25), 5), rem(div(n, 5), 5), rem(n, 5)]

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
