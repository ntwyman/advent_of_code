defmodule Day2Test do
  alias Day2
  use ExUnit.Case
  doctest Day2


  test "Day2 Part1" do
    #assert Day2.run([1,0,0,0,99]) == [2,0,0,0,99]
    #assert Day2.run([2,3,0,3,99]) == [2,3,0,6,99]
    #assert Day2.run([2,4,4,5,99,0]) == [2,4,4,5,99,9801]
    assert Day2.run([1,0,0,3,1,1,2,3,99]) == [1,0,0,0,1,1,2,3,99]
  end

end
