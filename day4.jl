using ArgParse

s=ArgParseSettings()
@add_arg_table s begin
    "--part2"
        help="Do part 2"
        action=:store_true
    "--test"
        help="Run test data"
        action=:store_true
end
parsed_args = parse_args(ARGS, s)

mutable struct Board
    number
    squares::Dict
    columns::Array
    rows::Array
    done::Bool
end

function mark_board(board, num)
    if !board.done && haskey(board.squares, num) 
        (row, col) = pop!(board.squares, num)
        board.rows[row] += 1
        board.columns[col] += 1
        board.done = (board.rows[row] == 5 || board.columns[col]==5)
        return board.done
    end
    false
end

function find_winner(numbers, boards)
    for num in numbers
        for board in boards
            if mark_board(board, num)
               return num, board
            end
        end
    end
end

function find_loser(numbers, boards)
    number_ofboards = length(boards)
    for num in numbers
        for board in boards
            if mark_board(board, num)
                number_ofboards -= 1
                if number_ofboards == 0
                    return num, board
               end
            end
        end
    end
end

test_suffix = parsed_args["test"] ? "_test" : ""
lines = readlines("input/day_4$test_suffix.txt")
numbers = split(lines[1], ",")
boards = []
for boardIdx in 2:6:length(lines)-1
    squares = []
    for row in 1:5
        row_nums = split(lines[boardIdx+row])
        for (col, val) in enumerate(row_nums)
            push!(squares, (val,(row, col)))
        end
    end
    push!(boards,Board(boardIdx, Dict(squares), zeros(5), zeros(5), false))
end
if parsed_args["part2"]
    (last, the_one) = find_loser(numbers, boards)
else
    (last, the_one) = find_winner(numbers, boards)
end
unmarked = sum(s -> parse(Int32, s), keys(the_one.squares))
answer = unmarked * parse(Int32, last)
println("The answer is: $answer")
