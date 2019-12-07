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

  @spec is_valid([0..9]) :: boolean
  def is_valid(digits) do
    monotonic(digits) and has_repeat(digits)
  end

  @spec is_valid_string(String.t()) :: boolean
  def is_valid_string(pwd) do
    is_valid(for c <- to_charlist(pwd), do: c - ?0)
  end

  @spec part1(String.t()) :: integer
  def part1(_file_name) do
    Enum.count(125_730..579_381, fn num -> is_valid_string(Integer.to_string(num)) end)
  end
end
