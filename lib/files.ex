defmodule Files do
  @spec read_lines!(String.t()) :: [String.t()]
  def read_lines!(file_name) do
    File.open!(file_name)
    |> IO.stream(:line)
    |> Enum.map(&String.trim/1)
  end
end
