use std::fmt::Display;
pub struct Day2;

fn score(play: &String) -> u32 {
    match play.as_str() {
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

fn outcome(play: &String) -> u32 {
    match play.as_str() {
        "A X" => 3, // Lose -> scissors
        "A Y" => 4, // Draw -> Rock
        "A Z" => 8, // Win -> Paper
        "B X" => 1, // Lose -> Rock
        "B Y" => 5, // Draw -> Paper
        "B Z" => 9, // Win -> Scissors
        "C X" => 2, // Lose -> Paper
        "C Y" => 6, // Draw -> Scissors
        "C Z" => 7, // Win -> Rock
        wtf => panic!("We're playing rock paper scissors here - What is {} ", wtf),
    }
}

impl super::Day for Day2 {
    fn part1(self: &Self, input: Vec<String>) -> Box<dyn Display> {
        self.map_sum(input, score)
    }
    fn part2(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        self.map_sum(lines, outcome)
    }
}
