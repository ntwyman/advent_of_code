use itertools::Itertools;
use std::collections::LinkedList;
use std::fmt::Display;
pub struct Day5;

fn move_crates(
    lines: Vec<String>,
    crane: fn(&mut Vec<LinkedList<char>>, count: usize, from: usize, to: usize) -> (),
) -> Box<dyn Display> {
    // Assume input is well formed
    let mut input_iter = lines.iter();
    let mut state_data = input_iter
        .by_ref()
        .take_while(|l| !l.is_empty())
        .collect_vec();
    state_data.reverse();
    let stack_count = state_data[0].trim().split("   ").count();
    let mut stacks = Vec::with_capacity(stack_count);
    for _ in 0..stack_count {
        stacks.push(LinkedList::new())
    }
    for line in state_data[1..].iter() {
        let contents = line.chars().collect_vec();
        for i in 0..stack_count {
            let idx = (i << 2) + 1;
            if idx >= contents.len() {
                break;
            }
            let contained = contents[idx];
            if contained != ' ' {
                stacks[i].push_back(contained);
            }
        }
    }
    for instruction in input_iter {
        let parts = instruction.trim().split(" ").collect_vec();
        let count = parts[1].parse::<usize>().unwrap();
        let from = parts[3].parse::<usize>().unwrap() - 1;
        let to = parts[5].parse::<usize>().unwrap() - 1;
        crane(&mut stacks, count, from, to);
    }
    Box::new(
        stacks
            .iter()
            .map(|ll| ll.back().unwrap())
            .collect::<String>(),
    )
}
impl super::Day for Day5 {
    fn part1(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        fn cm9000(stacks: &mut Vec<LinkedList<char>>, count: usize, from: usize, to: usize) -> () {
            for _ in 0..count {
                let c = { stacks[from].pop_back().unwrap() };
                stacks[to].push_back(c);
            }
        }
        move_crates(lines, cm9000)
    }

    fn part2(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        fn cm9001(stacks: &mut Vec<LinkedList<char>>, count: usize, from: usize, to: usize) -> () {
            let mut moving = {
                let f = stacks.get_mut(from).unwrap();
                f.split_off(f.len() - count)
            };
            stacks[to].append(&mut moving);
        }
        move_crates(lines, cm9001)
    }
}
