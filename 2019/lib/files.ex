defmodule Files do
  @spec read_lines!(String.t()) :: [String.t()]
  def read_lines!(file_name) do
    File.open!(file_name)
    |> IO.stream(:line)
    |> Enum.map(&String.trim/1)
  end

  @spec read_integers!(String.t()) :: [integer]
  def read_integers!(file_name) do
    File.read!(file_name)
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
