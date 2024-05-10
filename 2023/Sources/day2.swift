typealias RGB = (r: Int, g: Int, b: Int)

func parseRound(round: String) -> RGB {
  let draws = round.components(separatedBy: ", ")
  var r: Int = 0
  var g: Int = 0
  var b = 0
  for d in draws {
    let color_value = d.components(separatedBy: " ")
    let value = Int(color_value[0])!
    switch color_value[1] {
    case "blue":
      b = value
    case "red":
      r = value
    case "green":
      g = value
    default:
      print("Unknown color in \(round)")
    }
  }
  return RGB(r: r, g: g, b: b)
}

class Game {
  let number: Int
  var rounds: [RGB] = []
  init(fromLine line: String) {
    let name_rounds = line.components(separatedBy: ": ")
    self.number = Int(name_rounds[0].components(separatedBy: " ")[1])!
    let rounds = name_rounds[1].components(separatedBy: "; ")
    self.rounds = rounds.map(parseRound)
  }
}

func powerOfSet(g: Game) -> Int {
  var m = RGB(0, 0, 0)
  for r in g.rounds {
    m = RGB(r: max(r.r, m.r), g: max(r.g, m.g), b: max(r.b, m.b))
  }
  return m.r * m.g * m.b
}

class Day2: Day {
  let rMax = 12
  let gMax = 13
  let bMax = 14

  func part1(lines: [String]) -> Any {
    let games = lines.filter({ $0.isEmpty == false }).map({ Game(fromLine: $0) })
    let isPossible = { (g: Game) -> Bool in
      for r in g.rounds {
        if r.r > self.rMax || r.g > self.gMax || r.b > self.bMax {
          return false
        }
      }
      return true

    }
    return games.filter(isPossible).map({ $0.number }).reduce(0, +)
  }

  func part2(lines: [String]) -> Any {
    let games = lines.filter({ $0.isEmpty == false }).map({ Game(fromLine: $0) })
    let powers: [Int] = games.map(powerOfSet)
    return powers.reduce(0, +)
  }
}
