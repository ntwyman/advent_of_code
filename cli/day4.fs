namespace AoC

open System.Text.RegularExpressions

module Day4 =
    type Passport = Map<string, string>

    type PassportAccumulator = {
        Passports: Passport list;
        Current: Passport;
    }

    let checkYear min max field =
        let m = Regex.Match(field, @"^\d{4}$")
        if m.Success then
            let v = int field
            v >=min && v <= max
        else
            false

    //hgt (Height) - a number followed by either cm or in:
    //If cm, the number must be at least 150 and at most 193.
    //If in, the number must be at least 59 and at most 76.
    let checkHeight height =
        let m = Regex.Match(height, @"^(\d{2,3})(in|cm)$")
        if m.Success then
            let h = int (m.Groups.[1].Value)
            if m.Groups.[2].Value = "in" then
                h >= 59 && h <= 76
            else
                h >= 150 && h <= 193
        else
            false


    let checkHairColor color =
        Regex.Match(color, @"^#[0-9a-f]{6}$").Success

    let checkEyeColor color =
        Regex.Match(color, @"^amb|blu|brn|gry|grn|hzl|oth$").Success

    let checkPassportId id =
        Regex.Match(id, @"^[0-9]{9}$").Success

    let hasAllFields pass =
        List.forall ( fun k -> Map.containsKey k pass) [ "byr"; "iyr"; "eyr"; "hgt"; "hcl"; "ecl"; "pid";]

    let isValidPassport (pass: Passport) =
        let checkField name fieldValidator passport =
            pass.ContainsKey(name) && fieldValidator pass.[name]
        let checkByr = checkField "byr" (checkYear 1920 2002)
        let checkIyr = checkField "iyr" (checkYear 2010 2020)
        let checkEyr  = checkField "eyr" (checkYear 2020 2030)
        let checkHgt = checkField "hgt" checkHeight
        let checkHcl = checkField "hcl" checkHairColor
        let checkEcl = checkField "ecl" checkEyeColor
        let checkPid = checkField "pid" checkPassportId
        checkByr pass && 
            checkIyr pass && 
            checkEyr pass &&
            checkHgt pass &&
            checkHcl pass && 
            checkEcl pass && 
            checkPid pass


    let handler part (lines: string seq) =
        let mapLine (line:string)  = if line.Trim() = "" then [| None |] else Array.map Some (line.Split(' '))
        let entries = Seq.collect mapLine lines
        let passportFolder acc (entry: string Option) =
            match entry with
            | None ->
                { Passports = acc.Current :: acc.Passports; Current = Map.empty; }
            | Some(textEntry) ->
                let kv = textEntry.Split(':')
                { Passports = acc.Passports; Current = acc.Current.Add(kv.[0], kv.[1]); }
        let passportsAcc = Seq.fold passportFolder {Passports = []; Current= Map.empty;} entries
        let passports = passportsAcc.Current :: passportsAcc.Passports

        let validator =
            if part = One then
                hasAllFields
            else
                isValidPassport
        List.filter validator passports |> List.length |> string

