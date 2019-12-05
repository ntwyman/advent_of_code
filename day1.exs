defmodule Day1 do
    def fuel(mass) do
        Kernel.trunc(String.to_integer(mass) / 3) - 2
    end
end


[file_name] = System.argv()
File.open!(file_name)
|> IO.stream(:line)
|> Enum.map(&String.trim/1)
|> Enum.map(&Day1.fuel/1)
|> Enum.reduce(0,fn (a,b) -> a+b end)
|> Integer.to_string
|> IO.puts