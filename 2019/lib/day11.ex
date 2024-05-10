defmodule Day11 do
  defmodule Pos do
    defstruct x: 0, y: 0
  end

  @spec do_turn(atom, integer) :: atom
  defp do_turn(direction, turn) do
    case turn do
      # left
      0 ->
        case direction do
          :up -> :left
          :right -> :up
          :down -> :right
          :left -> :down
        end

      # right
      1 ->
        case direction do
          :up -> :right
          :right -> :down
          :down -> :left
          :left -> :up
        end
    end
  end

  @spec advance(Pos.t(), atom) :: Pos.t()
  defp advance(position, direction) do
    case direction do
      :up -> %Pos{x: position.x, y: position.y + 1}
      :right -> %Pos{x: position.x + 1, y: position.y}
      :down -> %Pos{x: position.x, y: position.y - 1}
      :left -> %Pos{x: position.x - 1, y: position.y}
    end
  end

  @spec robot_loop(map(), Pos.t(), atom, pid) :: map()
  def robot_loop(paint_map, position, direction, int_pid) do
    # Send the position of the current square
    color = Map.get(paint_map, position, 0)
    # IO.puts("Color of {#{position.x}, #{position.y}} - #{color}")
    send(int_pid, {:value, color})

    new_map =
      receive do
        {:value, c} ->
          # IO.puts("Coloring {#{position.x}, #{position.y}} - #{c}")
          Map.put(paint_map, position, c)
      end

    new_dir =
      receive do
        {:value, turn} ->
          # IO.puts("Turning: #{turn}")
          do_turn(direction, turn)
      end

    # IO.puts("#{new_dir}: #{position.x}, #{position.y}")

    send(int_pid, {:is_halted})

    is_halted =
      receive do
        {:halted, is_halted} -> is_halted
      end

    if is_halted,
      do: new_map,
      else: robot_loop(new_map, advance(position, new_dir), new_dir, int_pid)
  end

  @spec part1(String.t()) :: integer
  def part1(file_name) do
    int_pid =
      Files.read_integers!(file_name)
      |> IntComp.run_as_process([], self())

    send(int_pid, {:run})
    paint_job = robot_loop(%{}, %Pos{}, :up, int_pid)
    length(Map.keys(paint_job))
  end

  @spec part2(String.t()) :: String.t()
  def part2(file_name) do
    int_pid =
      Files.read_integers!(file_name)
      |> IntComp.run_as_process([], self())

    send(int_pid, {:run})

    paint_job = robot_loop(%{%Pos{} => 1}, %Pos{}, :up, int_pid)

    {e_min_x, e_min_y, e_max_x, e_max_y} =
      Enum.reduce(
        Map.keys(paint_job),
        {0, 0, 0, 0},
        fn tile, {min_x, min_y, max_x, max_y} ->
          {min(min_x, tile.x), min(min_y, tile.y), max(max_x, tile.x), max(max_y, tile.y)}
        end
      )

    lines =
      Enum.map(e_max_y..e_min_y, fn y ->
        to_string(
          for x <- e_min_x..e_max_x,
              do: if(Map.get(paint_job, %Pos{x: x, y: y}, 0) == 1, do: ?*, else: 0x20)
        )
      end)

    Enum.join(lines, "\n")
  end
end
