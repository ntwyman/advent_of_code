use itertools::Itertools;
use std::collections::BTreeSet;
use std::fmt::Display;
pub struct Day3;

fn priority_of_item(item: &char) -> u32 {
    match item {
        'a'..='z' => *item as u32 - 96,
        'A'..='Z' => *item as u32 - 65 + 27,
        _ => panic!("Unrecognized item {}", item),
    }
}
fn priority_per_sack(l: &String) -> u32 {
    let s = l.len() >> 1;
    let comp1 = BTreeSet::from_iter(l[0..s].chars());
    let comp2 = BTreeSet::from_iter(l[s..].chars());
    let mistake = comp1.intersection(&comp2);
    priority_of_item(mistake.into_iter().next().unwrap())
}
impl super::Day for Day3 {
    fn part1(self: &Self, input: Vec<String>) -> Box<dyn Display> {
        self.map_sum(input, priority_per_sack)
    }

    fn part2(self: &Self, input: Vec<String>) -> Box<dyn Display> {
        let mut priority_sum = 0u32;
        for chunk in &input.iter().chunks(3) {
            let packs = chunk.map(|r| BTreeSet::from_iter(r.chars())).collect_vec();
            let common = packs[0].intersection(&packs[1]);
            let token = common.filter(|c| packs[2].contains(c)).collect_vec();
            priority_sum += priority_of_item(token[0]);
        }
        Box::new(priority_sum)
    }
}
