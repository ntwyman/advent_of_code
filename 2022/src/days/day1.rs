use std::fmt::Display;

fn elves_by_calories(input: Vec<String>) -> Vec<u32> {
    fn add_calories(mut elves: Vec<u32>, l: &String) -> Vec<u32> {
        if l.is_empty() {
            elves.push(0u32)
        } else {
            let cals = elves.pop().unwrap() + l.parse::<u32>().unwrap();
            elves.push(cals)
        }
        elves
    }
    let mut elves = input.iter().fold(vec![32], add_calories);
    elves.sort();
    elves.reverse();
    elves
}

pub struct Day1;
impl super::Day for Day1 {
    fn part1(self: &Self, input: Vec<String>) -> Box<dyn Display> {
        Box::new(elves_by_calories(input)[0])
    }
    fn part2(self: &Self, input: Vec<String>) -> Box<dyn Display> {
        Box::new(elves_by_calories(input)[0..3].iter().sum::<u32>())
    }
}
