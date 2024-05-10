defmodule Day13 do
  defmodule Pos do
    defstruct x: 0, y: 0
  end

  defmodule Game do
    defstruct pid: nil, screen: %{}, bat: nil, ball: nil, score: 0, send_input: true, joystick: 0
  end

  def draw_game(game) do
    ext = Enum.reduce(Map.keys(game.screen), %Pos{}, fn tile, extent ->
      %Pos{x: max(tile.x, extent.x), y: max(tile.y, extent.y)} end)

    Enum.each(0..ext.y, fn line_y ->
      chrs = Enum.map(0..ext.x, fn col_x ->
        case Map.get(game.screen, %Pos{x: col_x, y: line_y}, 0) do
          0 -> 0x20
          1 -> ?W
          2 -> 0x2580
          3 -> 0x2581
          4 -> 0x2b24
        end

      end)
      IO.puts(to_string(chrs))
    end)
  end

  def update_game(game, pos, tile) do
    ng =
      case tile do
        0 -> %{game | screen: Map.delete(game.screen, pos)}
        1 -> %{game | screen: Map.put(game.screen, pos, tile)}
        2 -> %{game | screen: Map.put(game.screen, pos, tile)}
        3 ->
          # IO.puts("bat #{pos.x}, #{pos.y}")
          %{game | screen: Map.put(game.screen, pos, tile), bat: pos}
        4 ->
          # IO.puts("ball #{pos.x}, #{pos.y}")
          # We are updaing the ball and have seen it before.
          if game.send_input and not is_nil(game.ball) do
            intersect = cond do
              pos.y == 20 -> # Either about to die or touching the bat
                pos.x # Ball is going back the way it came
              pos.y > game.ball.y -> # Coming down
                game.ball.x + div((pos.x - game.ball.x) * (game.bat.y - game.ball.y), pos.y - game.ball.y)
              true -> # going up
                pos.x + (pos.x - game.ball.x) # Ball is heading to
            end
            joystick = cond do
              game.bat.x < intersect ->
                1
              game.bat.x > intersect ->
                -1
              true ->
                0
            end
            send(game.pid, {:value, joystick})
            %{game | screen: Map.put(game.screen, pos, tile), ball: pos, joystick: joystick}
          else
            %{game | screen: Map.put(game.screen, pos, tile), ball: pos}
          end
      end
    ng
  end

  def run_game(game) do
    receive do
      {:value, x_pos} ->
        receive do
          {:value, y_pos} ->
            receive do
              {:value, value} ->
                case {x_pos, y_pos} do
                  {-1, 0} ->
                    run_game(%{game | score: value})
                  _ ->
                    pos = %Pos{x: x_pos, y: y_pos}
                    run_game(update_game(game, pos, value))
                end

              msg ->
                exit("Expecting tile value - got #{msg}")
            end

          msg ->
            exit("Expecting y pos - got #{msg}")
        end

      {:halted, false} ->
        send(game.pid, {:is_halted})
        run_game(game)

      {:halted, true} ->
        game

      msg ->
        exit("Run_game: unexpected message #{msg}")
    end
  end

  def run_game(game_pid, send_input) do
    game = %Game{pid: game_pid, send_input: send_input}
    send(game.pid, {:run})
    send(game.pid, {:value, 0})
    send(game.pid, {:is_halted})
    run_game(game)
  end

  def part1(file_name) do
    game_engine =
      Files.read_integers!(file_name)
      |> IntComp.run_as_process([], self())

    game = run_game(game_engine, false)
    Enum.sum(Enum.map(Map.values(game.screen), fn tile -> if tile == 2, do: 1, else: 0 end))
  end

  def part2(file_name) do
    game_engine =
      Files.read_integers!(file_name)
      |> (fn prog -> [2 | tl(prog)] end).()
      |> IntComp.run_as_process([], self())

    game = run_game(game_engine, true)
    game.score
  end
end
