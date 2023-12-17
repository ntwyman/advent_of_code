func startsWithNumber(line: Substring) -> Int? {
  let c = line.first!
  let val: Int? =
    switch c {
    case "0"..."9":
      c.wholeNumberValue
    case "o":
      line.starts(with: "one") ? 1 : nil
    case "t":
      if line.starts(with: "two") {
        2
      } else if line.starts(with: "three") {
        3
      } else {
        nil
      }
    case "f":
      if line.starts(with: "four") {
        4
      } else if line.starts(with: "five") {
        5
      } else {
        nil
      }
    case "s":
      if line.starts(with: "six") {
        6
      } else if line.starts(with: "seven") {
        7
      } else {
        nil
      }
    case "e":
      line.starts(with: "eight") ? 8 : nil
    case "n":
      line.starts(with: "nine") ? 9 : nil
    default:
      nil
    }
  return val
}

func findFirstDigit(line: String) -> Int? {
  for c in line {
    if c.isWholeNumber {
      return c.wholeNumberValue
    }
  }
  print("Digit not found in \(line)")
  return nil
}

func part1Value(line: String) -> Int {
  let d1 = findFirstDigit(line: line)!
  let d2 = findFirstDigit(line: String(line.reversed()))!
  return d1 * 10 + d2
}

func findFirstNumber(line: String, backwards: Bool) -> Int? {
  let indexRange: any Collection<Int> =
    if backwards {
      (0..<line.count).reversed()
    } else {
      0..<line.count
    }

  for i in indexRange {
    let substringIndex = line.index(line.startIndex, offsetBy: i)..<line.endIndex
    let v = startsWithNumber(line: line[substringIndex])
    if v != nil {
      return v!
    }
  }
  return nil
}
func part2Value(line: String) -> Int {
  let d1 = findFirstNumber(line: line, backwards: false)!
  let d2 = findFirstNumber(line: line, backwards: true)!
  return d1 * 10 + d2
}

func findValue(line: String, findNumber: (String) -> Int?) -> Int {
  let d1 = findNumber(line)
  let d2: Int? = findNumber(String(line.reversed()))

  print("\(d1!):\(d2!) - \(line)")
  return (d1! * 10) + d2!
}

class Day1: Day {
  func part1(lines: [String]) -> Any {
    lines.map(part1Value(line:)).reduce(0, +)
  }

  func part2(lines: [String]) -> Any {
    lines.map(part2Value(line:)).reduce(
      0, +)
  }
}
