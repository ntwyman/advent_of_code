module Day13.Tests

open NUnit.Framework
open AoC

[<SetUp>]
let Setup () =
    ()

[<Test>]
let CountChains () =
    Assert.AreEqual(1068781, Day13.firstStamp "7,13,x,x,59,x,31,19")
    Assert.AreEqual(3417, Day13.firstStamp "17,x,13,19")
    Assert.AreEqual(754018, Day13.firstStamp "67,7,59,61")
    Assert.AreEqual(779210, Day13.firstStamp "67,x,7,59,61")
    Assert.AreEqual(1261476, Day13.firstStamp "67,7,x,59,61")
    Assert.AreEqual(1202161486, Day13.firstStamp "1789,37,47,1889")
