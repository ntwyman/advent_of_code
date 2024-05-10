module Day5.Tests

open NUnit.Framework
open AoC

[<SetUp>]
let Setup () =
    ()

[<Test>]
let CheckExampleIds () =
    Assert.AreEqual(357, Day5.calculateSeatId "FBFBBFFRLR")
    Assert.AreEqual(567, Day5.calculateSeatId "BFFFBBFRRR")
    Assert.AreEqual(119, Day5.calculateSeatId "FFFBBBFRRR")
    Assert.AreEqual(820, Day5.calculateSeatId "BBFFBBFRLL")
