defmodule Day2 do
    defp do_op(state, index, op) do
        arg1 = :array.get(:array.get(index+1, state), state)
        arg2 = :array.get(:array.get(index+2, state), state)
        res_pos = :array.get(index+3, state)
        :array.set(res_pos, op.(arg1, arg2), state)
    end

    defp run_from(state, index) do
        case :array.get(index,state) do
            1 -> run_from(do_op(state, index, &Kernel.+/2), index + 4)
            2 -> run_from(do_op(state, index, &Kernel.*/2), index + 4)
            99 -> state
        end
    end

    defp load_program(file) do
        File.read!(file)
        |> String.trim()
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
    end

    def run(state) do
        :array.from_list(state)
        |> run_from(0)
        |> :array.to_list()
    end

    defp execute([op1, _addr1, _addr2 | rest], noun, verb) do
        run([ op1, noun, verb ] ++ rest)
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
            { noun, verb }
        else
            find_noun_and_verb(program, target, noun + 1)
        end
    end

    defp find_noun_and_verb(program, target) do
        {noun, verb} = find_noun_and_verb(program, target, 0)
        noun * 100 + verb
    end

     def part1(file) do
        load_program(file)
        |> execute(12, 2)
    end

    def part2(file) do
        load_program(file)
        |> find_noun_and_verb(19690720)
    end
end
