use itertools::Itertools;
use std::collections::BTreeSet;
use std::fs::File;
use std::io::{BufReader, Lines};

pub struct Day3;
use std::io::Result;

fn priority_of_item(item: &char) -> u32 {
    match item {
        'a'..='z' => *item as u32 - 96,
        'A'..='Z' => *item as u32 - 65 + 27,
        _ => panic!("Unrecognized item {}", item),
    }
}
fn priority_per_sack(line: Result<String>) -> u32 {
    let l = line.unwrap();
    let s = l.len() >> 1;
    let comp1 = BTreeSet::from_iter(l[0..s].chars());
    let comp2 = BTreeSet::from_iter(l[s..].chars());
    let mistake = comp1.intersection(&comp2);
    priority_of_item(mistake.into_iter().next().unwrap())
}
impl super::Day for Day3 {
    fn part1(self: &Self, lines: Lines<BufReader<File>>) -> u32 {
        lines.map(priority_per_sack).sum()
    }

    fn part2(self: &Self, lines: Lines<BufReader<File>>) -> u32 {
        let mut priority_sum = 0u32;
        for chunk in &lines.chunks(3) {
            let packs = chunk
                .map(|r| BTreeSet::from_iter(r.unwrap().chars()))
                .collect_vec();
            let common = packs[0].intersection(&packs[1]);
            let token = common.filter(|c| packs[2].contains(c)).collect_vec();
            priority_sum += priority_of_item(token[0]);
        }
        priority_sum
    }
}
