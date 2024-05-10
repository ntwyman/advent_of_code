import ArgumentParser
import Foundation

let days: [Day] = [Day1(), Day2(), Day3(), Day4()]

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

    if day > days.count {
      print("Not implemented yet")
    } else {
      let testStr = test ? "_test" : ""
      let input = "input/day\(day)\(testStr).txt"
      let fileManager = FileManager.default
      let fileData = fileManager.contents(atPath: input)
      if fileData == nil {
        print("Missing file data")
        return
      }
      let contents = String(data: fileData!, encoding: .utf8)
      let lines = contents!.components(separatedBy: NSCharacterSet.newlines)
      let d = days[day - 1]
      let result =
        if part2 {
          d.part2(lines: lines)
        } else {
          d.part1(lines: lines)
        }
      print(result)
    }
  }
}
