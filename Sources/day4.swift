@available(macOS 13, *)
let cardEx = #/^Card\s+(?<number>\d+):\s+(?<winning>(\d+\s{1,2})+)\|(?<have>(\s{1,2}\d+)+)$/#
// (\d+):\s+(\d+\s+)+|(\s+\d+)*$/#

func setOfNumbers(from: Substring) -> Set<Int> {
  let subs = from.split(separator: " ")
  let numberStrings = subs.map({ $0.trimmingCharacters(in: .whitespaces) }).filter({
    $0.isEmpty == false
  })
  return Set(numberStrings.map({ Int($0)! }))
}
class Scratcher {
  let number: Int
  let winning: Set<Int>
  let picks: Set<Int>

  init(line: String) {
    if #available(macOS 13, *) {
      let match = line.firstMatch(of: cardEx)!
      // print(match)
      self.number = Int(String(match.number))!
      self.winning = setOfNumbers(from: match.winning)
      self.picks = setOfNumbers(from: match.have)
    } else {
      self.number = 14
      self.winning = Set.init([])
      self.picks = Set.init([])
    }
  }
  func wins() -> Int {
    self.winning.intersection(self.picks).count
  }
  func value() -> Int {
    let wins = self.wins()
    return wins == 0 ? 0 : 1 << (wins - 1)
  }
}

class Day4: Day {
  func part1(lines: [String]) -> Any {
    let cards = lines.filter({ $0.isEmpty == false }).map(Scratcher.init(line:))
    return cards.map({ $0.value() }).reduce(0, +)
  }

  func part2(lines: [String]) -> Any {
    "Not implemented"
  }

}
