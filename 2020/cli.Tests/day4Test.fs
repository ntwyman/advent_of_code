module Day4.Tests

open NUnit.Framework
open AoC

let emptyPassport:Day4.Passport = Map.empty

let allFields:Day4.Passport =
    Map.empty.
        Add("eyr", "2029").
        Add("ecl", "blu").
        Add("cid", "129").
        Add("byr", "1989").
        Add("iyr", "2014").
        Add("pid", "896056539").
        Add("hcl", "#a97842").
        Add("hgt", "165cm")

let noCid = allFields.Remove("cid")

let noEyr = allFields.Remove("eyr")

let hasAllFields = Day4.isValidPassport One
let checkFields = Day4.isValidPassport Two

[<Test>]
let CheckFields () =
    Assert.IsFalse(hasAllFields emptyPassport)
    Assert.IsTrue(hasAllFields allFields)
    Assert.IsTrue(hasAllFields noCid)
    Assert.IsFalse(hasAllFields noEyr)


[<Test>]
let CheckByr () =
    Assert.IsFalse(checkFields (allFields.Remove("byr")))
    Assert.IsFalse(checkFields (allFields.Add("byr","badNumber")))
    Assert.IsFalse(checkFields (allFields.Add("byr","123")))
    Assert.IsFalse(checkFields (allFields.Add("byr","2003")))
    Assert.IsFalse(checkFields (allFields.Add("byr","1919")))
    Assert.IsTrue(checkFields (allFields.Add("byr","1920")))
    Assert.IsTrue(checkFields (allFields.Add("byr","2002")))

[<Test>]
let CheckIyr () =
    Assert.IsFalse(checkFields (allFields.Remove("iyr")))
    Assert.IsFalse(checkFields (allFields.Add("iyr","badNumber")))
    Assert.IsFalse(checkFields (allFields.Add("iyr","2021")))
    Assert.IsFalse(checkFields (allFields.Add("iyr","2009")))
    Assert.IsTrue(checkFields (allFields.Add("iyr","2010")))
    Assert.IsTrue(checkFields (allFields.Add("iyr","2020")))

[<Test>]
let CheckEyr () =
    Assert.IsFalse(checkFields (allFields.Remove("eyr")))
    Assert.IsFalse(checkFields (allFields.Add("eyr","badNumber")))
    Assert.IsFalse(checkFields (allFields.Add("eyr","2019")))
    Assert.IsFalse(checkFields (allFields.Add("eyr","2031")))
    Assert.IsTrue(checkFields (allFields.Add("eyr","2020")))
    Assert.IsTrue(checkFields (allFields.Add("eyr","2030")))


[<Test>]
let CheckHgt () =
    Assert.IsFalse(checkFields (allFields.Remove("hgt")))
    Assert.IsFalse(checkFields (allFields.Add("hgt","badHeight")))
    Assert.IsTrue(checkFields (allFields.Add("hgt","60in")))
    Assert.IsTrue(checkFields (allFields.Add("hgt","190cm")))
    Assert.IsFalse(checkFields (allFields.Add("hgt","190in")))
    Assert.IsFalse(checkFields (allFields.Add("hgt","190")))

[<Test>]
let CheckHairColor () =
    Assert.IsTrue(Day4.checkHairColor "#123abc")
    Assert.IsTrue(Day4.checkHairColor "#a97842")

[<Test>]
let CheckHcl () =
    Assert.IsFalse(checkFields (allFields.Remove("hcl")))
    Assert.IsFalse(checkFields (allFields.Add("hcl","badColor")))
    Assert.IsTrue(checkFields (allFields.Add("hcl","#123abc")))
    Assert.IsFalse(checkFields (allFields.Add("hcl","#123abz")))
    Assert.IsFalse(checkFields (allFields.Add("hcl","123abc")))


[<Test>]
let CheckEcl () =
    Assert.IsFalse(checkFields (allFields.Remove("ecl")))
    Assert.IsFalse(checkFields (allFields.Add("ecl","badColor")))
    Assert.IsTrue(checkFields (allFields.Add("ecl","brn")))
    Assert.IsFalse(checkFields (allFields.Add("ecl","wat")))

[<Test>]
let CheckPid () =
    Assert.IsFalse(checkFields (allFields.Remove("pid")))
    Assert.IsFalse(checkFields (allFields.Add("pid","badPid")))
    Assert.IsTrue(checkFields (allFields.Add("pid","000000001")))
    Assert.IsFalse(checkFields (allFields.Add("pid","0123456789")))
    