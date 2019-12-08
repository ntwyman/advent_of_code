defmodule IntComp do
  defmodule CompState do
    defstruct tape: [99], ip: 0, input: [], output: [], halted: false
  end

  @spec fetch(CompState.t(), integer) :: integer
  defp fetch(state, addr) do
    :array.get(addr, state.tape)
  end

  @spec fetch(CompState.t(), integer, atom) :: integer
  defp fetch(state, addr, mode) do
    val = fetch(state, addr)
    if mode == :immediate, do: val, else: fetch(state, val)
  end

  @spec set_val(CompState.t(), integer, integer) :: CompState.t()
  defp set_val(state, addr, value) do
    %{state | tape: :array.set(addr, value, state.tape)}
  end

  @spec set_val(CompState.t(), integer, integer, atom) :: CompState.t()
  defp set_val(state, addr, value, mode) do
    if mode == :position do
      pos = fetch(state, addr)
      set_val(state, pos, value)
    else
      set_val(state, addr, value)
    end
  end

  @spec mode_from_instr(integer, integer) :: atom
  defp mode_from_instr(instr, multiplier) do
    if rem(div(instr, multiplier), 10) == 0, do: :position, else: :immediate
  end

  @spec binop(CompState.t(), atom, atom, atom, (integer, integer -> integer)) :: CompState.t()
  defp binop(state, mode_1, mode_2, mode_3, op) do
    arg_1 = fetch(state, state.ip + 1, mode_1)
    arg_2 = fetch(state, state.ip + 2, mode_2)
    %{set_val(state, state.ip + 3, op.(arg_1, arg_2), mode_3) | ip: state.ip + 4}
  end

  @spec input(CompState.t(), atom) :: CompState.t()
  defp input(state, mode) do
    [inp | rest] = state.input
    %{set_val(state, state.ip + 1, inp, mode) | input: rest, ip: state.ip + 2}
  end

  @spec output(CompState.t(), atom) :: CompState.t()
  defp output(state, mode) do
    value = fetch(state, state.ip + 1, mode)
    %{state | output: [value | state.output], ip: state.ip + 2}
  end

  @spec continue(CompState.t()) :: CompState.t()
  defp continue(state) do
    instr = fetch(state, state.ip)
    opcode = rem(instr, 100)
    mode_1 = mode_from_instr(instr, 100)
    mode_2 = mode_from_instr(instr, 1000)
    mode_3 = mode_from_instr(instr, 10000)

    next_state =
      case opcode do
        1 -> binop(state, mode_1, mode_2, mode_3, &Kernel.+/2)
        2 -> binop(state, mode_1, mode_2, mode_3, &Kernel.*/2)
        3 -> input(state, mode_1)
        4 -> output(state, mode_1)
        99 -> %{state | halted: true}
      end

    if next_state.halted, do: next_state, else: continue(next_state)
  end

  @spec run([integer]) :: CompState.t()
  def run(program) do
    continue(%CompState{tape: :array.from_list(program)})
  end

  @spec run([integer], [integer]) :: CompState.t()
  def run(program, input) do
    continue(%CompState{tape: :array.from_list(program), input: input})
  end

  @spec mem_dump(CompState.t()) :: [integer]
  def mem_dump(state) do
    :array.to_list(state.tape)
  end

  @spec get_output(CompState.t()) :: [integer]
  def get_output(state) do
    state.output
  end
end
