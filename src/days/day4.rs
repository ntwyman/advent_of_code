use itertools::Itertools;
use std::fs::File;
use std::io::{BufReader, Lines, Result};

pub struct Day4;

fn assignment(assignment_str: &str) -> (u32, u32) {
    let sections = assignment_str.split("-").collect_vec();
    (sections[0].parse().unwrap(), sections[1].parse().unwrap())
}
fn overlaps(elf1: (u32, u32), elf2: (u32, u32)) -> bool {
    (elf1.0 <= elf2.0 && elf1.1 >= elf2.1) || (elf1.0 >= elf2.0 && elf1.1 <= elf2.1)
}

fn intersects(elf1: (u32, u32), elf2: (u32, u32)) -> bool {
    !(elf1.0 > elf2.1 || elf1.1 < elf2.0)
}
fn count_lines(lines: Lines<BufReader<File>>, p: fn((u32, u32), (u32, u32)) -> bool) -> u32 {
    let predicate_mapper = |line: &Result<String>| -> bool {
        let elves_str = line.as_ref().unwrap().split(",").collect_vec();
        let elf1 = assignment(elves_str[0]);
        let elf2 = assignment(elves_str[1]);
        p(elf1, elf2)
    };

    lines.filter(predicate_mapper).count() as u32
}
impl super::Day for Day4 {
    fn part1(self: &Self, lines: Lines<BufReader<File>>) -> u32 {
        count_lines(lines, overlaps)
    }

    fn part2(self: &Self, lines: Lines<BufReader<File>>) -> u32 {
        count_lines(lines, intersects)
    }
}
