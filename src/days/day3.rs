use std::collections::BTreeSet;
use std::fs::File;
use std::io::{BufReader, Lines};

pub struct Day3;
use std::io::Result;

fn priority_per_sack(line: Result<String>) -> u32 {
    let l = line.unwrap();
    let s = l.len() >> 1;
    let comp1 = BTreeSet::from_iter(l[0..s].chars());
    let comp2 = BTreeSet::from_iter(l[s..].chars());
    let mistake = comp1.intersection(&comp2);
    let item = mistake.into_iter().next().unwrap();
    match item {
        'a'..='z' => *item as u32 - 96,
        'A'..='Z' => *item as u32 - 65 + 27,
        _ => panic!("Unrecognized item {}", item),
    }
}
impl super::Day for Day3 {
    fn part1(self: &Self, lines: Lines<BufReader<File>>) -> u32 {
        lines.map(priority_per_sack).sum()
    }

    fn part2(self: &Self, _lines: Lines<BufReader<File>>) -> u32 {
        panic!("Todo");
    }
}
