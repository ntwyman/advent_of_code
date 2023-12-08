use std::fmt::Display;
pub trait Day {
    fn part1(&self, input: Vec<String>) -> Box<dyn Display>;
    fn part2(&self, input: Vec<String>) -> Box<dyn Display>;

    fn map_sum(&self, input: Vec<String>, mapper: fn(&String) -> u32) -> Box<dyn Display> {
        Box::new(input.iter().map(mapper).sum::<u32>())
    }
}

pub(super) mod day1;
pub(super) mod day10;
pub(super) mod day2;
pub(super) mod day3;
pub(super) mod day4;
pub(super) mod day5;
pub(super) mod day6;
pub(super) mod day7;
pub(super) mod day8;
pub(super) mod day9;
