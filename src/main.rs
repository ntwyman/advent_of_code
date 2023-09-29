mod days;

use clap::Parser;
use days::day1::Day1;
use days::day2::Day2;
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
    let file = File::open(file_name)?;
    let reader = BufReader::new(file);
    let day: &dyn days::Day = match args.day {
        1 => &Day1 {},
        2 => &Day2 {},
        _ => panic!("Not implemented yet"),
    };
    println!(
        "{}",
        if args.part2 {
            day.part2(reader.lines())
        } else {
            day.part1(reader.lines())
        }
    );
    Ok(())
}
