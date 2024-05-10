module Day10.Tests

open NUnit.Framework
open AoC

[<SetUp>]
let Setup () =
    ()

[<Test>]
let CountChains () =
    Assert.AreEqual(1, Day10.countListChains [12u])
    Assert.AreEqual(1, Day10.countListChains [12u; 13u])
    Assert.AreEqual(1, Day10.countListChains [12u; 13u; 16u])
    Assert.AreEqual(2, Day10.countListChains [12u; 13u; 15u])    