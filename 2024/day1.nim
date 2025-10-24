import std/strutils
from std/sequtils import map
from std/strscans import scanf

proc lineDif(line: string) :  int = 
    var  x, y:  int
    discard scanf(line, "$i$s$i", x, y)
    result = abs(x-y)

let filepath: string = "day1.test.txt"
let f = open(filepath,  fmRead)
let content:string  = readAll(f)
f.close

var sum = 0
for line in content.splitLines():
    sum += lineDif(line)
echo sum
