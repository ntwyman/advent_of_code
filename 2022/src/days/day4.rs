use itertools::Itertools;
use std::fmt::Display;

pub struct Day4;

fn assignment(assignment_str: &str) -> (u32, u32) {
    let sections = assignment_str.split("-").collect_vec();
    (sections[0].parse().unwrap(), sections[1].parse().unwrap())
}
fn overlaps((elf1, elf2): &((u32, u32), (u32, u32))) -> bool {
    (elf1.0 <= elf2.0 && elf1.1 >= elf2.1) || (elf1.0 >= elf2.0 && elf1.1 <= elf2.1)
}

fn intersects((elf1, elf2): &((u32, u32), (u32, u32))) -> bool {
    !(elf1.0 > elf2.1 || elf1.1 < elf2.0)
}

fn get_elf_assignments(line: &String) -> ((u32, u32), (u32, u32)) {
    let elves_str = line.split(",").collect_vec();
    let elf1 = assignment(elves_str[0]);
    let elf2 = assignment(elves_str[1]);
    (elf1, elf2)
}
fn count_lines(input: Vec<String>, p: fn(&((u32, u32), (u32, u32))) -> bool) -> Box<dyn Display> {
    Box::new(input.iter().map(get_elf_assignments).filter(p).count())
}
impl super::Day for Day4 {
    fn part1(self: &Self, input: Vec<String>) -> Box<dyn Display> {
        count_lines(input, overlaps)
    }

    fn part2(self: &Self, input: Vec<String>) -> Box<dyn Display> {
        count_lines(input, intersects)
    }
}
