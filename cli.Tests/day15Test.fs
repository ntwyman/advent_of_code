module Day15.Tests

open NUnit.Framework
open AoC

[<SetUp>]
let Setup () =
    ()

[<Test>]
let shoutOuts () =
    Assert.AreEqual(436, Day15.whatComes2020th [0;3;6])
    Assert.AreEqual(1, Day15.whatComes2020th [1;3;2])
    Assert.AreEqual(10, Day15.whatComes2020th [2;1;3])
    Assert.AreEqual(27, Day15.whatComes2020th [1;2;3])
    Assert.AreEqual(78, Day15.whatComes2020th [2;3;1])
    Assert.AreEqual(438, Day15.whatComes2020th [3;2;1])
    Assert.AreEqual(1836, Day15.whatComes2020th [3;1;2])
