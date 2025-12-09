from argparse import ArgumentParser
from importlib import import_module

ap = ArgumentParser()
ap.add_argument("--day", "-d", type=int)
ap.add_argument("--part2", "-p2", action="store_true", default=False)
args = ap.parse_args()
module = import_module(f"day{args.day}")
with open(f"./input/day{args.day}.txt") as inp:
    lines = [line[:-1] for line in inp.readlines()]  # remove \n
    fn = module.part2 if args.part2 else module.part1
    print(fn(lines))
