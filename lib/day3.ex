defmodule Day3 do
  defmodule Extent do
    defstruct start_x: 0, start_y: 0, min_x: 0, min_y: 0, max_x: 0, max_y: 0
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
       start_x: start.x,
       start_y: start.y,
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

  @spec paths_and_crossings(String.t(), String.t()) :: {path(), path(), [Day3.Point.t()]}
  defp paths_and_crossings(wire_1, wire_2) do
    path_1 = path(wire_1)
    path_2 = path(wire_2)
    {path_1, path_2, intersections(path_1, path_2)}
  end

  @spec closest([Day3.Point.t()], (Day3.Point.t() -> integer)) :: integer
  defp closest(crossings, measure) do
    Enum.reduce(crossings, @no_intersection, fn p, acc ->
      case p do
        %Point{x: 0, y: 0} -> acc
        _ -> min(measure.(p), acc)
      end
    end)
  end

  @doc """
  Finds the crossings between two wires and calculates the minimal Manhattan Distance to one from the origin
  """
  @spec manhattan_distance(String.t(), String.t()) :: integer
  def manhattan_distance(wire_1, wire_2) do
    {_, _, crossings} = paths_and_crossings(wire_1, wire_2)
    closest(crossings, fn p -> abs(p.x) + abs(p.y) end)
  end

  @spec is_vertical(Day3.Extent.t()) :: boolean
  defp is_vertical(extent), do: extent.min_x == extent.max_x

  @spec is_on(Day3.Point.t(), Day3.Extent.t()) :: boolean
  defp is_on(point, extent) do
    if is_vertical(extent) do
      point.x == extent.min_x and point.y >= extent.min_y and point.y <= extent.max_y
    else
      point.y == extent.min_y and point.x >= extent.min_x and point.x <= extent.max_x
    end
  end

  @spec steps_to(Day3.Point.t(), Day3.Extent.t()) :: integer
  defp steps_to(point, extent) do
    if is_vertical(extent) do
      abs(point.y - extent.start_y)
    else
      abs(point.x - extent.start_x)
    end
  end

  @spec length_of(Day3.Extent.t()) :: integer
  defp length_of(extent) do
    if is_vertical(extent) do
      abs(extent.max_y - extent.min_y)
    else
      abs(extent.max_x - extent.min_x)
    end
  end

  @spec distance_along(Day3.Point.t(), [Day3.Extent.t()]) :: integer
  defp distance_along(point, path) do
    case path do
      [] ->
        @no_intersection

      [first_extent | rest] ->
        cond do
          is_on(point, first_extent) -> steps_to(point, first_extent)
          true -> length_of(first_extent) + distance_along(point, rest)
        end
    end
  end

  @doc """
  Finds the crossings between two wires and calculates the minimal path distance
  along each wire to a crossing
  """
  @spec timing_distance(String.t(), String.t()) :: integer()
  def timing_distance(wire_1, wire_2) do
    {path_1, path_2, crossings} = paths_and_crossings(wire_1, wire_2)

    timing_measure = fn p ->
      distance_along(p, path_1) + distance_along(p, path_2)
    end

    closest(crossings, timing_measure)
  end

  @spec read_lines(String.t()) :: {String.t(), String.t()}
  defp read_lines(file_name) do
    [line_1, line_2] =
      File.read!(file_name)
      |> String.trim()
      |> String.split("\n")

    {line_1, line_2}
  end

  @spec part1(String.t()) :: integer()
  def part1(file_name) do
    {line_1, line_2} = read_lines(file_name)
    manhattan_distance(line_1, line_2)
  end

  @spec part2(String.t()) :: integer()
  def part2(file_name) do
    {line_1, line_2} = read_lines(file_name)
    timing_distance(line_1, line_2)
  end
end
