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
            v >= min && v <= max
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

    let isValidPassport part (pass:Passport) =
        let checkField name =
            if pass.ContainsKey(name) then
                if part = Two then
                    let field = pass.[name]
                    match name with
                         | "byr" -> checkYear 1920 2002 field
                         | "iyr" -> checkYear 2010 2020 field
                         | "eyr" -> checkYear 2020 2030 field
                         | "hgt" -> checkHeight field
                         | "hcl" -> checkHairColor field
                         | "ecl" -> checkEyeColor field
                         | "pid" -> checkPassportId field
                         | _ -> false
                else
                    true
            else
                false
        List.forall checkField [ "byr"; "iyr"; "eyr"; "hgt"; "hcl"; "ecl"; "pid";]

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


        List.filter (isValidPassport part) passports |> List.length |> string

