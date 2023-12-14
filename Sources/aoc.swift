import ArgumentParser
import Foundation

protocol Day {}

func findFirstDigit(line: String) -> Int? {
  for c in line {
    if c.isWholeNumber {
      return c.wholeNumberValue
    }
  }
  print("Digit not found in \(line)")
  return nil

}

func findValue(line: String) -> Int {
  let d = findFirstDigit(line: line)
  return (d! * 10) + findFirstDigit(line: String(line.reversed()))!
}

@main
struct AOC: ParsableCommand {
  @Flag(help: "Run with test input")
  var test = false

  @Option(name: .shortAndLong, help: "Day's puzzle to run")
  var day: Int

  @Flag(help: "Run part two")
  var part2: Bool = false

  public func run() throws {
    print("Running day \(day)")

    let testStr = test ? "_test" : ""
    let input = "input/day\(day)\(testStr).txt"
    let fileManager = FileManager.default
    let fileData = fileManager.contents(atPath: input)
    let contents = String(data: fileData!, encoding: .utf8)
    let lines = contents!.components(separatedBy: NSCharacterSet.newlines)
    print(lines.map(findValue(line:)).reduce(0, +))

  }
}
