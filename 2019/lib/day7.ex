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

  @spec wait_on_amps(map()) :: integer
  defp wait_on_amps(state) do
    receive do
      {:value, value} ->
        send(state[:send], {:value, value})
        send(state[:wait], {:is_halted})
        wait_on_amps(Map.put(state, :last_seen, value))

      {:halted, is_stopped} ->
        if is_stopped do
          state[:last_seen]
        else
          wait_on_amps(state)
        end
    end
  end

  @spec run_looped_amplifiers([integer], integer, [0..4]) :: integer
  def run_looped_amplifiers(program, input, phases) do
    [phase_a, phase_b, phase_c, phase_d, phase_e] = phases
    amp_e = IntComp.run_as_process(program, [phase_e], self())
    amp_d = IntComp.run_as_process(program, [phase_d], amp_e)
    amp_c = IntComp.run_as_process(program, [phase_c], amp_d)
    amp_b = IntComp.run_as_process(program, [phase_b], amp_c)
    amp_a = IntComp.run_as_process(program, [phase_a, input], amp_b)
    send(amp_a, {:run})
    send(amp_b, {:run})
    send(amp_c, {:run})
    send(amp_d, {:run})
    send(amp_e, {:run})
    output = wait_on_amps(%{send: amp_a, wait: amp_e})
    Process.exit(amp_a, :kill)
    Process.exit(amp_b, :kill)
    Process.exit(amp_c, :kill)
    Process.exit(amp_d, :kill)
    Process.exit(amp_e, :kill)
    output
  end

  @spec permutations([Integer]) :: [[Integer]]
  def permutations(values) when values == [], do: [[]]

  def permutations(values) do
    for v <- values, rest <- permutations(values -- [v]), do: [v | rest]
  end

  @spec tune_amplifiers([integer], boolean) :: integer
  def tune_amplifiers(program, looped \\ false) do
    phases = permutations(Enum.to_list(if looped, do: 5..9, else: 0..4))

    Enum.reduce(phases, 0, fn phase_list, acc ->
      thrust =
        if looped do
          run_looped_amplifiers(program, 0, phase_list)
        else
          run_amplifiers(program, 0, phase_list)
        end

      if thrust > acc, do: thrust, else: acc
    end)
  end

  @spec part1(String.t()) :: integer
  def part1(file_name) do
    Files.read_integers!(file_name)
    |> tune_amplifiers()
  end

  @spec part2(String.t()) :: integer
  def part2(file_name) do
    Files.read_integers!(file_name)
    |> tune_amplifiers(true)
  end
end
