defmodule Day3 do

    def segment({x, y}, seg) do
        [dir | num] = to_charlist(seg)
        count = String.to_integer(to_string(num))
        {end_x, end_y} = case dir do
            ?U -> { x, y + count}
            ?D -> { x, y - count}
            ?L -> { x - count, y}
            ?R -> { x + count, y}
        end
        {{end_x, end_y}, {min(x, end_x), min(y, end_y), max(x, end_x), max(y, end_y)}}
    end

    def segments(wire, start) do
        case wire do
            [] -> []
            [ seg1 | rest ] ->
                { end_pt, extent} = segment(start, seg1)
                [ extent | segments(rest, end_pt)]
        end
    end

    def path(wire) do
        segments(wire, {0, 0})
    end

    def distance(_wire1, _wire2) do

    end
end