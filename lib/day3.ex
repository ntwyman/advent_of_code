defmodule Day3 do
  defmodule Extent do
    defstruct min_x: 0, min_y: 0, max_x: 0, max_y: 0
  end

  defmodule Point do
    defstruct x: 0, y: 0
  end

  @no_intersection 9_999_999_999_999_999
  @type path() :: [Extent.t()]

  @spec points_in(Day3.Extent.t()) :: [Day3.Point.t()]
  defp points_in(extent) do
    if extent.max_x > extent.min_x do
      for x <- extent.min_x..extent.max_x, do: %Point{x: x, y: extent.min_y}
    else
      if extent.max_y > extent.min_y do
        for y <- extent.min_y..extent.max_y, do: %Point{x: extent.min_x, y: y}
      else
        [%Point{x: extent.min_x, y: extent.min_y}]
      end
    end
  end

  @spec segment(Day3.Point.t(), String.t()) :: {Day3.Point.t(), Day3.Extent.t()}
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

  @spec crossings(Extent.t(), Extent.t()) :: [Point.t()]
  def crossings(extent1, extent2) do
    if extent1.min_x <= extent2.max_x && extent2.min_x <= extent1.max_x &&
         extent1.min_y <= extent2.max_y && extent2.min_y <= extent1.max_y do
      overlap = %Extent{
        min_x: max(extent1.min_x, extent2.min_x),
        min_y: max(extent1.min_y, extent2.min_y),
        max_x: min(extent1.max_x, extent2.max_x),
        max_y: min(extent1.max_y, extent2.max_y)
      }

      points_in(overlap)
    else
      []
    end
  end

  @doc """
  List of points where a particular extent intersects the path
  """
  @spec intersects(Day3.Extent.t(), path()) :: [Point.t()]
  def intersects(ext, path) do
    List.flatten(for ext2 <- path, do: crossings(ext, ext2))
  end

  @doc """
  List of points where one path intersects annother
  """
  @spec intersections(path(), path()) :: [Point.t()]
  def intersections(path_1, path_2) do
    List.flatten(for ext1 <- path_1, do: intersects(ext1, path_2))
  end

  @doc """
  Turns a wire definiton, e.g. ["R5", "U13", "L10"] into a path (list of extents)
  """
  @spec path(String.t()) :: path()
  def path(wire) do
    segments(String.split(wire, ","), %Point{})
  end

  defp min_non_zero_distance(p, acc) do
    case p do
      %Point{x: 0, y: 0} -> acc
      _ -> min(abs(p.x) + abs(p.y), acc)
    end
  end

  @doc """
  Finds the crossings between two wires and calculates the minimal Manhattan Distance to one from the origin
  """
  @spec distance(String.t(), String.t()) :: integer()
  def distance(wire_1, wire_2) do
    path_1 = path(wire_1)
    path_2 = path(wire_2)
    crossings = intersections(path_1, path_2)
    Enum.reduce(crossings, @no_intersection, &min_non_zero_distance/2)
  end

  @spec part1(String.t()) :: integer()
  def part1(file_name) do
    [line1, line2] =
      File.read!(file_name)
      |> String.trim()
      |> String.split("\n")

    distance(line1, line2)
  end
end
