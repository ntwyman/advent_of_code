use std::fs::File;
use std::io::{BufReader, Lines, Result};

fn elves_by_calories(lines: Lines<BufReader<File>>) -> Vec<u32> {
    fn add_calories(mut elves: Vec<u32>, line: Result<String>) -> Vec<u32> {
        let l = line.unwrap();
        if l.is_empty() {
            elves.push(0u32)
        } else {
            let cals = elves.pop().unwrap() + l.parse::<u32>().unwrap();
            elves.push(cals)
        }
        elves
    }
    let mut elves = lines.fold(vec![32], add_calories);
    elves.sort();
    elves.reverse();
    elves
}

pub struct Day1;
impl super::Day for Day1 {
    fn part1(self: &Self, lines: Lines<BufReader<File>>) -> u32 {
        elves_by_calories(lines)[0]
    }
    fn part2(self: &Self, lines: Lines<BufReader<File>>) -> u32 {
        elves_by_calories(lines)[0..3].iter().sum()
    }
}
