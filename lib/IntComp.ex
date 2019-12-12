defmodule IntComp do
  defmodule CompState do
    defstruct tape: [99], ip: 0, input: [], output: [], rel_base: 0, halted: false
  end

  # NOTE: Can't work out how to typespec :array.array(integer)
  @spec load_tape([integer]) :: any()
  def load_tape(program) do
    :array.from_list(program, 0)
  end

  @spec fetch(CompState.t(), integer) :: integer
  defp fetch(state, addr) do
    val = :array.get(addr, state.tape)
    # IO.puts("Load addr:#{addr}, val: #{val}")
    val
  end

  @spec fetch(CompState.t(), integer, atom) :: integer
  defp fetch(state, addr, mode) do
    val = fetch(state, addr)
    # IO.puts("Fetch from: #{addr} val: #{val} mode: #{mode} base: #{state.rel_base}")

    case mode do
      :immediate -> val
      :position -> fetch(state, val)
      :relative -> fetch(state, val + state.rel_base)
    end
  end

  @spec set_val(CompState.t(), integer, integer) :: CompState.t()
  defp set_val(state, addr, value) do
    # IO.puts("Set addr:#{addr} val:#{value}")
    %{state | tape: :array.set(addr, value, state.tape)}
  end

  @spec set_val(CompState.t(), integer, integer, atom) :: CompState.t()
  defp set_val(state, addr, value, mode) do
    case mode do
      :immediate ->
        set_val(state, addr, value)

      :position ->
        pos = fetch(state, addr)
        set_val(state, pos, value)

      :relative ->
        pos = fetch(state, addr)
        set_val(state, pos + state.rel_base, value)
    end
  end

  @spec mode_from_instr(integer, integer) :: atom
  defp mode_from_instr(instr, multiplier) do
    case rem(div(instr, multiplier), 10) do
      0 -> :position
      1 -> :immediate
      2 -> :relative
    end
  end

  @spec binop(CompState.t(), atom, atom, atom, (integer, integer -> integer)) :: CompState.t()
  defp binop(state, mode_1, mode_2, mode_3, op) do
    arg_1 = fetch(state, state.ip + 1, mode_1)
    arg_2 = fetch(state, state.ip + 2, mode_2)
    %{set_val(state, state.ip + 3, op.(arg_1, arg_2), mode_3) | ip: state.ip + 4}
  end

  @spec get_input(CompState.t()) :: {integer, [integer]}
  defp get_input(state) do
    case state.input do
      [i | rest] ->
        {i, rest}

      [] ->
        receive do
          {:value, value} ->
            {value, []}

          {:is_halted} ->
            send(state.output, {:halted, false})
            get_input(state)
        end
    end
  end

  @spec input(CompState.t(), atom) :: CompState.t()
  defp input(state, mode) do
    {value, input} = get_input(state)

    %{set_val(state, state.ip + 1, value, mode) | input: input, ip: state.ip + 2}
  end

  @spec output(CompState.t(), atom) :: CompState.t()
  defp output(state, mode) do
    value = fetch(state, state.ip + 1, mode)

    new_output =
      cond do
        is_list(state.output) ->
          [value | state.output]

        is_pid(state.output) ->
          send(state.output, {:value, value})
          state.output
      end

    %{state | output: new_output, ip: state.ip + 2}
  end

  @spec jump_if(CompState.t(), atom, atom, (integer -> boolean)) :: CompState.t()
  defp jump_if(state, mode_1, mode_2, predicate) do
    if predicate.(fetch(state, state.ip + 1, mode_1)) do
      %{state | ip: fetch(state, state.ip + 2, mode_2)}
    else
      %{state | ip: state.ip + 3}
    end
  end

  @spec adj_base(CompState.t(), atom) :: CompState.t()
  defp adj_base(state, mode) do
    delta = fetch(state, state.ip + 1, mode)
    %{state | ip: state.ip + 2, rel_base: state.rel_base + delta}
  end

  # defp opcode_name(opcode) do
  #   case opcode do
  #     1 -> "ADD"
  #     2 -> "MUL"
  #     3 -> "INP"
  #     4 -> "OUT"
  #     5 -> "JNZ"
  #     6 -> "JPZ"
  #     7 -> "TLT"
  #     8 -> "TEQ"
  #     9 -> "BAS"
  #     99 -> "HLT"
  #   end
  # end

  @spec continue(CompState.t()) :: CompState.t()
  defp continue(state) do
    instr = fetch(state, state.ip)
    opcode = rem(instr, 100)
    mode_1 = mode_from_instr(instr, 100)
    mode_2 = mode_from_instr(instr, 1000)
    mode_3 = mode_from_instr(instr, 10000)

    # IO.puts(
    #   "IP: #{state.ip}, OpCode: #{opcode_name(opcode)}, Modes: {#{mode_1}, #{mode_2}, #{mode_3}}, Base: #{
    #     state.rel_base
    #   }"
    # )

    next_state =
      case opcode do
        1 -> binop(state, mode_1, mode_2, mode_3, &Kernel.+/2)
        2 -> binop(state, mode_1, mode_2, mode_3, &Kernel.*/2)
        3 -> input(state, mode_1)
        4 -> output(state, mode_1)
        5 -> jump_if(state, mode_1, mode_2, fn val -> val != 0 end)
        6 -> jump_if(state, mode_1, mode_2, fn val -> val == 0 end)
        7 -> binop(state, mode_1, mode_2, mode_3, fn a, b -> if a < b, do: 1, else: 0 end)
        8 -> binop(state, mode_1, mode_2, mode_3, fn a, b -> if a == b, do: 1, else: 0 end)
        9 -> adj_base(state, mode_1)
        99 -> %{state | halted: true}
      end

    if next_state.halted, do: next_state, else: continue(next_state)
  end

  @spec run([integer]) :: CompState.t()
  def run(program) do
    continue(%CompState{tape: load_tape(program)})
  end

  @spec run([integer], [integer]) :: [integer]
  def run(program, input) do
    continue(%CompState{tape: load_tape(program), input: input}).output
  end

  @spec mem_dump(CompState.t()) :: [integer]
  def mem_dump(state) do
    :array.to_list(state.tape)
  end

  @spec run_loop(CompState.t()) :: nil
  defp run_loop(state) do
    receive do
      {:run} ->
        # IO.puts("Running")
        run_loop(continue(state))

      {:value, value} ->
        # IO.puts("Value")
        run_loop(%{state | input: state.input ++ [value]})

      {:is_halted} ->
        # IO.puts("H")
        send(state.output, {:halted, state.halted})
        run_loop(state)

      msg ->
        IO.puts("UNEXPECETD MESSAGE")
        IO.inspect(msg)
    end
  end

  @spec run_as_process([integer], [integer], pid()) :: pid()
  def run_as_process(program, initial_input, output_pid) do
    spawn(fn ->
      run_loop(%CompState{
        tape: load_tape(program),
        input: initial_input,
        output: output_pid
      })
    end)
  end
end
