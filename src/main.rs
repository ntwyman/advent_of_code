use clap::Parser;
use std::fs::File;
use std::io::{BufRead, BufReader, Lines, Result};

#[derive(Parser, Debug)]
struct Args {
    #[arg(short, long)]
    day: u8,

    #[arg(short, long)]
    test: bool,

    #[arg(short, long)]
    part2: bool,
}

fn elves_by_calories(lines: Lines<BufReader<File>>) -> Vec<u32> {
    let mut elves: Vec<u32> = vec![0u32];
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
    elves = lines.fold(elves, add_calories);
    elves.sort();
    elves.reverse();
    elves
}

fn day1_part1(lines: Lines<BufReader<File>>) -> u32 {
    elves_by_calories(lines)[0]
}

fn day1_part2(lines: Lines<BufReader<File>>) -> u32 {
    elves_by_calories(lines)[0..3].iter().sum()
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
    let part = if args.part2 { day1_part2 } else { day1_part1 };
    println!("{}", part(reader.lines()));
    Ok(())
}
