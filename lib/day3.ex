defmodule Day3 do
  defmodule Extent do
    defstruct min_x: 0, min_y: 0, max_x: 0, max_y: 0
  end

  defmodule Point do
    defstruct x: 0, y: 0
  end

  @spec segment(Day3.Point.t(), any) :: {Day3.Point.t(), Day3.Extent.t()}
  def segment(start, seg) do
    [dir | num] = to_charlist(seg)
    count = String.to_integer(to_string(num))

    finish =
      case dir do
        ?U -> %Point{x: start.x, y: start.y + count}
        ?D -> %Point{x: start.x, y: start.y - count}
        ?L -> %Point{x: start.x - count, y: start.y}
        ?R -> %Point{x: start.x + count, y: start.y}
      end

    {finish,
     %Extent{
       min_x: min(start.x, finish.x),
       min_y: min(start.y, finish.y),
       max_x: max(start.x, finish.x),
       max_y: max(start.y, finish.y)
     }}
  end

  @spec segments([String.t()], Day3.Point.t()) :: [Day3.Extent.t()]
  def segments(wire, start) do
    case wire do
      [] ->
        []

      [seg1 | rest] ->
        {end_pt, extent} = segment(start, seg1)
        [extent | segments(rest, end_pt)]
    end
  end

  @spec path([String.t()]) :: [Day3.Extent.t()]
  def path(wire) do
    segments(wire, {0, 0})
  end

  def distance(_wire1, _wire2) do
  end
end
