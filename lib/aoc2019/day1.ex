defmodule Aoc2019.Day1 do
    def fuel(mass) do
        Kernel.trunc(mass / 3) - 2
    end

    def total_fuel(mass) when mass < 9,  do: 0 

    def total_fuel(mass) when mass >= 9 do
        fuel(mass)
        |> (fn f -> f + total_fuel(f) end).()
    end
end
