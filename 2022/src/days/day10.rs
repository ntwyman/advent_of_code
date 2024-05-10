use std::fmt::Display;

pub struct Day10;

fn check_cursor((cycle, x): (usize, &i32)) -> char {
    let pos: i32 = (cycle % 40) as i32;
    if *x >= (pos - 1) && *x <= (pos + 1) {
        '@'
    } else {
        '.'
    }
}
impl super::Day for Day10 {
    fn part1(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        let mut x = 1;
        let mut current_cycle = 1;
        let mut next_sample = 20;
        let mut samples = Vec::new();
        for line in lines {
            // println!("{}", x);
            let (next_cycle, next_x) = match line.as_str() {
                "noop" => (current_cycle + 1, x),
                _ => (current_cycle + 2, x + line[5..].parse::<i32>().unwrap()),
            };
            if next_cycle > next_sample {
                samples.push(next_sample * x);
                next_sample = next_sample + 40;
                if next_sample > 220 {
                    break;
                }
            }
            current_cycle = next_cycle;
            x = next_x;
        }
        Box::new(samples.iter().sum::<i32>())
    }

    fn part2(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        let mut x = 1;
        let mut x_values = Vec::with_capacity(240);
        for line in lines {
            match line.as_str() {
                "noop" => x_values.push(x),
                _ => {
                    x_values.push(x);
                    x_values.push(x);
                    x += line[5..].parse::<i32>().unwrap();
                }
            }
        }
        let buffer: String = x_values.iter().enumerate().map(check_cursor).collect();
        Box::new(format!(
            "{}\r\n{}\r\n{}\r\n{}\r\n{}\r\n{}",
            &buffer[0..40],
            &buffer[40..80],
            &buffer[80..120],
            &buffer[120..160],
            &buffer[160..200],
            &buffer[200..],
        ))
    }
}
