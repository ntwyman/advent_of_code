defmodule Aoc2019.CLI do
    alias Aoc2019.Day1
    def main(args) do
        options = [strict: [file: :string, day: :integer, part: :integer],aliases: [f: :file, d: :day, p: :part]]
        {opts,_,_}= OptionParser.parse(args, options)
        IO.inspect opts, label: "Command Line Arguments"
        calc = if opts[:part] == 1 do
            &Day1.fuel/1
        else
            &Day1.total_fuel/1
        end
        File.open!("./input/day#{opts[:day]}.txt")
        |> IO.stream(:line)
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)
        |> Enum.map(calc)
        |> Enum.reduce(0,fn (a,b) -> a+b end)
        |> Integer.to_string
        |> IO.puts
    end
end 