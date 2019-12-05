defmodule Day2 do
    defp do_op(state, index, op) do
        arg1 = :array.get(:array.get(index+1, state), state)
        arg2 = :array.get(:array.get(index+2, state), state)
        res_pos = :array.get(index+3, state)
        :array.set(res_pos, op.(arg1, arg2), state)
    end

    defp run(state, index) do
        case :array.get(index,state) do
            1 -> run(do_op(state, index, &Kernel.+/2), index + 4)
            2 -> run(do_op(state, index, &Kernel.*/2), index + 4)
            99 -> state
        end
    end

    defp patch1202([op1, _addr1, _addr2 | rest]) do
        [ op1, 12, 2 ] ++ rest
    end

    def run(program) do
        :array.to_list(run(:array.from_list(program), 0))
    end

    def part1(file) do
        File.read!(file)
        |> String.trim()
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> patch1202()
        |> run()
        |> hd
    end
end
