mod days;

use clap::Parser;
use days::day1::Day1;
use days::day2::Day2;
use days::day3::Day3;
use days::day4::Day4;
use days::day5::Day5;
use days::day6::Day6;
use days::day7::Day7;
use days::day8::Day8;
use days::day9::Day9;
use itertools::Itertools;
use std::fs::File;
use std::io::{BufRead, BufReader};

#[derive(Parser, Debug)]
struct Args {
    #[arg(short, long)]
    day: u8,

    #[arg(short, long)]
    test: bool,

    #[arg(short, long)]
    part2: bool,
}
fn main() -> std::io::Result<()> {
    let args = Args::parse();
    let file_name = format!(
        "inputs/day{}{}.txt",
        args.day,
        if args.test { "_test" } else { "" }
    );

    // Files are not that big - just going to read it all in.
    let file = File::open(file_name)?;
    let input = BufReader::new(file)
        .lines()
        .map(|l| l.unwrap())
        .collect_vec();

    let day: &dyn days::Day = match args.day {
        1 => &Day1 {},
        2 => &Day2 {},
        3 => &Day3 {},
        4 => &Day4 {},
        5 => &Day5 {},
        6 => &Day6 {},
        7 => &Day7 {},
        8 => &Day8 {},
        9 => &Day9 {},
        _ => panic!("Not implemented yet"),
    };
    println!(
        "{}",
        if args.part2 {
            day.part2(input)
        } else {
            day.part1(input)
        }
    );
    Ok(())
}
