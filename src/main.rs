use clap::Parser;
use std::cmp::max;
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

fn day1_part1(lines: Lines<BufReader<File>>) -> u32 {
    struct Acc {
        elf: u32,
        max_elf: u32,
    }
    fn c(acc: Acc, line: Result<String>) -> Acc {
        let l = line.unwrap();
        if l.is_empty() {
            Acc {
                elf: 0,
                max_elf: acc.max_elf,
            }
        } else {
            let e = acc.elf + l.parse::<u32>().unwrap();
            Acc {
                elf: e,
                max_elf: max(e, acc.max_elf),
            }
        }
    }
    lines.fold(Acc { elf: 0, max_elf: 0 }, c).max_elf
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
    println!("{}", day1_part1(reader.lines()));
    Ok(())
}
