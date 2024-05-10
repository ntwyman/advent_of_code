use itertools::Itertools;
use std::fmt::Display;
pub struct Day6;

fn find_start(message: &str, length: usize) -> usize {
    for i in length..message.len() {
        if message[i - length..i].chars().all_unique() {
            return i;
        }
    }
    0
}
impl super::Day for Day6 {
    fn part1(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        Box::new(find_start(lines.first().unwrap(), 4))
    }

    fn part2(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        Box::new(find_start(lines.first().unwrap(), 14))
    }
}

#[cfg(test)]
mod tests {
    use super::find_start;
    #[test]
    fn find_start_test() {
        let test_cases: [(&str, usize, usize); 9] = [
            ("bvwbjplbgvbhsrlpgdmjqwftvncz", 4, 5),
            ("nppdvjthqldpwncqszvftbrmjlhg", 4, 6),
            ("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 4, 10),
            ("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 4, 11),
            ("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 14, 19),
            ("bvwbjplbgvbhsrlpgdmjqwftvncz", 14, 23),
            ("nppdvjthqldpwncqszvftbrmjlhg", 14, 23),
            ("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 14, 29),
            ("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 14, 26),
        ];
        for (message, length, start) in test_cases.iter() {
            assert_eq!(find_start(*message, *length), *start)
        }
    }
}
