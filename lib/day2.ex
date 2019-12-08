defmodule Day2 do
  defp load_program(file) do
    File.read!(file)
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  @spec run([integer]) :: [integer]
  def run(program) do
    IntComp.mem_dump(IntComp.run(program))
  end

  defp execute([op1, _addr1, _addr2 | rest], noun, verb) do
    run([op1, noun, verb] ++ rest)
    |> hd
  end

  defp find_noun_and_verb(_program, _target, _noun, verb) when verb >= 100, do: 100

  defp find_noun_and_verb(program, target, noun, verb) do
    if execute(program, noun, verb) == target do
      verb
    else
      find_noun_and_verb(program, target, noun, verb + 1)
    end
  end

  defp find_noun_and_verb(_program, _target, noun) when noun >= 100, do: {100, 100}

  defp find_noun_and_verb(program, target, noun) do
    verb = find_noun_and_verb(program, target, noun, 0)

    if verb < 100 do
      {noun, verb}
    else
      find_noun_and_verb(program, target, noun + 1)
    end
  end

  defp find_noun_and_verb(program, target) do
    {noun, verb} = find_noun_and_verb(program, target, 0)
    noun * 100 + verb
  end

  @spec part1(String.t()) :: integer()
  def part1(file) do
    load_program(file)
    |> execute(12, 2)
  end

  @spec part2(String.t()) :: integer()
  def part2(file) do
    load_program(file)
    |> find_noun_and_verb(19_690_720)
  end
end
