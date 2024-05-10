defmodule Day4 do
  @spec monotonic([0..9]) :: boolean
  defp monotonic(digits) do
    case digits do
      [fst, snd | rest] -> fst <= snd and monotonic([snd | rest])
      _ -> true
    end
  end

  @spec has_repeat([0..9]) :: boolean
  defp has_repeat(digits) do
    case digits do
      [fst, snd | rest] -> fst == snd or has_repeat([snd | rest])
      _ -> false
    end
  end

  @spec has_clean_repeat([0..9]) :: boolean
  defp has_clean_repeat(digits) do
    {_, sequence_length, double_seen} =
      Enum.reduce(digits, {99, 0, false}, fn digit, {last_seen, sequence_length, double_seen} ->
        if digit == last_seen do
          {digit, sequence_length + 1, double_seen}
        else
          {digit, 1, sequence_length == 2 || double_seen}
        end
      end)

    double_seen || sequence_length == 2
  end

  @spec digits_down(non_neg_integer) :: [0..9]
  def digits_down(num) when num == 0, do: []

  def digits_down(num) do
    [rem(num, 10) | digits_down(div(num, 10))]
  end

  @spec digits(non_neg_integer) :: [0..9]
  def digits(num) do
    Enum.reverse(digits_down(num))
  end

  @spec is_valid(integer) :: boolean
  def is_valid(num) do
    digits = digits(num)
    monotonic(digits) and has_repeat(digits)
  end

  @spec is_valid_2(integer) :: boolean
  def is_valid_2(num) do
    digits = digits(num)
    monotonic(digits) and has_clean_repeat(digits)
  end

  @spec part1(String.t()) :: integer
  def part1(_file_name) do
    Enum.count(125_730..579_381, &is_valid/1)
  end

  @spec part2(String.t()) :: integer
  def part2(_file_name) do
    Enum.count(125_730..579_381, &is_valid_2/1)
  end
end
