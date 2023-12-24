class CharGrid {
  let data: [[Character]]
  let maxx: Int
  let maxy: Int
  let surround: Character
  init(content: [[Character]], surround: Character) {
    self.data = content
    self.maxy = content.count
    self.maxx = content[0].count
    self.surround = surround
  }
  func get(x: Int, y: Int) -> Character {
    if x < 0 || x >= self.maxx || y < 0 || y >= self.maxy {
      return self.surround
    }
    return self.data[y][x]
  }

  func isNumber(x: Int, y: Int) -> Bool {
    get(x: x, y: y).isNumber
  }
}

func hasSymbol(sch: CharGrid, minX: Int, maxX: Int, y: Int) -> Bool {
  for x in minX...maxX {
    let c = sch.get(x: x, y: y)
    if c != "." && c.isNumber == false {
      return true
    }
  }
  return false
}

func lineCount(sch: CharGrid, x: Int, y: Int) -> [(Int, Int)] {
  // Number of distinct part numbers intersecting (x-1, y), (x, y) & (x+1, y)
  // 0, 1 or 2
  if sch.isNumber(x: x, y: y) {  // Digit in middle means can be at most 1
    return [(x, y)]
  } else {
    let leftIs = sch.isNumber(x: x - 1, y: y)
    let rightIs = sch.isNumber(x: x + 1, y: y)
    if leftIs && rightIs {
      return [(x - 1, y), (x + 1, y)]
    } else if leftIs {
      return [(x - 1, y)]
    } else if rightIs {
      return [(x + 1, y)]
    } else {
      return []
    }
  }
}

func getNumberAt(sch: CharGrid, x: Int, y: Int) -> Int {
  var x0 = x
  while sch.isNumber(x: x0 - 1, y: y) {
    x0 -= 1
  }
  var x1 = x + 1
  while sch.isNumber(x: x1, y: y) {
    x1 += 1
  }
  return Int(String(sch.data[y][x0..<x1]))!
}
func getGearRatio(sch: CharGrid, x: Int, y: Int) -> Int? {
  // First locate and count adjacent numbers
  var adjacent = lineCount(sch: sch, x: x, y: y - 1)
  if sch.isNumber(x: x - 1, y: y) {
    adjacent.append((x - 1, y))
  }
  if sch.isNumber(x: x + 1, y: y) {
    adjacent.append((x + 1, y))
  }
  adjacent.append(contentsOf: lineCount(sch: sch, x: x, y: y + 1))
  if adjacent.count != 2 {
    return nil
  }
  // Now extract the numbers
  let partNum1 = getNumberAt(sch: sch, x: adjacent[0].0, y: adjacent[0].1)
  let partNum2 = getNumberAt(sch: sch, x: adjacent[1].0, y: adjacent[1].1)
  return partNum1 * partNum2
}

func loadGrid(lines: [String]) -> CharGrid {
  return CharGrid.init(
    content: lines.filter({ $0.isEmpty == false }).map({ [Character]($0) }),
    surround: Character("."))
}
class Day3: Day {
  func part1(lines: [String]) -> Any {
    let sch = loadGrid(lines: lines)
    var partNumbers: [Int] = []
    for y in 0..<sch.maxy {
      var x = 0

      repeat {
        // print("At \(x), \(y)")
        let x0 = x
        while sch.get(x: x, y: y).isNumber {
          x += 1
        }
        if x > x0 {
          let partNum = Int(String(sch.data[y][x0..<x]))!
          if hasSymbol(sch: sch, minX: x0 - 1, maxX: x, y: y - 1)
            || hasSymbol(sch: sch, minX: x0 - 1, maxX: x0 - 1, y: y)
            || hasSymbol(sch: sch, minX: x, maxX: x, y: y)
            || hasSymbol(sch: sch, minX: x0 - 1, maxX: x, y: y + 1)
          {
            partNumbers.append(partNum)
            // print("Adding \(partNum)")
          }
        } else {
          x += 1
        }
      } while x < sch.maxx
    }
    return partNumbers.reduce(0, +)
  }

  func part2(lines: [String]) -> Any {
    let sch = loadGrid(lines: lines)
    var ratioSum = 0

    for y in 0..<sch.maxy {
      for x in 0..<sch.maxx {
        if sch.get(x: x, y: y) == "*" {
          let ratio: Int? = getGearRatio(sch: sch, x: x, y: y)
          if ratio != nil {
            ratioSum += ratio!
          }
        }
      }
    }
    return ratioSum
  }
}
