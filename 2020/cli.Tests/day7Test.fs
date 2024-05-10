module Day7.Tests

open NUnit.Framework
open AoC

[<SetUp>]
let Setup () =
    ()

[<Test>]
let ParseQuantities () =
    Assert.AreEqual({ Day7.Bag = "shiny gold"; Day7.Count = 1;}, Day7.parseQuantity "1 shiny gold bag")
    Assert.AreEqual({ Day7.Bag = "faded coral"; Day7.Count = 2;}, Day7.parseQuantity "2 faded coral bags")

let bwRule = ( "bright white",  [ { Day7.Bag = "shiny gold"; Day7.Count = 1;}])
let myRule = ( "muted yellow",  [ { Day7.Bag = "shiny gold"; Day7.Count = 2;};
                                   { Day7.Bag = "faded blue"; Day7.Count = 9; }])
let fbRule = ( "faded blue",    [])

[<Test>]
let ParseRules () =
    Assert.AreEqual(bwRule, Day7.parseRule "bright white bags contain 1 shiny gold bag.")
    Assert.AreEqual(myRule, Day7.parseRule "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.")
    Assert.AreEqual(fbRule, Day7.parseRule "faded blue bags contain no other bags.")
    