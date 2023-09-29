use std::fs::File;
use std::io::{BufReader, Lines};

pub struct Day2;
use std::io::Result;

fn score(play: Result<String>) -> u32 {
    match play.unwrap().as_str() {
        "A X" => 4, // 1 + 3 Rock: Rock draw
        "A Y" => 8, // 2 + 6 Rock: Paper win
        "A Z" => 3, // 3 + 0 Rock: Scissors loss
        "B X" => 1, // 1 + 0 Paper: Rock loss
        "B Y" => 5, // 2 + 3 Paper: Paper draw
        "B Z" => 9, // 3 + 6 Paper: Scissors win
        "C X" => 7, // 1 + 6 Scissors: Rock win
        "C Y" => 2, // 2 + 0 Scissors: Paper loss
        "C Z" => 6, // 3 + 3 Scissors: Scissors draw
        wtf => panic!("We're playing rock paper scissors here - What is {} ", wtf),
    }
}
impl super::Day for Day2 {
    fn part1(self: &Self, lines: Lines<BufReader<File>>) -> u32 {
        lines.map(score).sum()
    }
    fn part2(self: &Self, _lines: Lines<BufReader<File>>) -> u32 {
        panic!("Todo")
    }
}
