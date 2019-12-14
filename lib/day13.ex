defmodule Day13 do
  defmodule Pos do
    defstruct x: 0, y: 0
  end

  defmodule Game do
    defstruct pid: nil, screen: %{}, bat: nil, ball: nil, score: 0, send_input: true
  end

  def update_game(game, pos, tile) do
    ng =
      case tile do
        0 -> %{game | screen: Map.delete(game.screen, pos)}
        # ignore walls. who cares
        1 -> game
        2 -> %{game | screen: Map.put(game.screen, pos, tile)}
        3 -> %{game | screen: Map.put(game.screen, pos, tile), bat: pos}
        4 -> %{game | screen: Map.put(game.screen, pos, tile), ball: pos}
      end

    if game.send_input and not (is_nil(ng.bat) or is_nil(ng.ball)) do
      cond do
        ng.bat.x < ng.ball.x -> send(ng.pid, {:value, 1})
        ng.bat.x > ng.ball.x -> send(ng.pid, {:value, -1})
        true -> send(ng.pid, {:value, 0})
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
