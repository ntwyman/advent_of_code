use std::fs::File;
use std::io::{BufReader, Lines};
pub trait Day {
    fn part1(&self, lines: Lines<BufReader<File>>) -> u32;
    fn part2(&self, lines: Lines<BufReader<File>>) -> u32;
}

pub(super) mod day1;
pub(super) mod day2;
pub(super) mod day3;
pub(super) mod day4;
