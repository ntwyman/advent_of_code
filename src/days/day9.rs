use std::collections::HashSet;
use std::fmt::Display;

pub struct Day9;

fn tail_move(h: (i32, i32), t: (i32, i32)) -> (i32, i32) {
    let dx = h.0 - t.0;
    let dy = h.1 - t.1;
    if dx.abs() < 2 && dy.abs() < 2 {
        return (t.0, t.1);
    }
    (t.0 + dx.signum(), t.1 + dy.signum())
}

fn to_move(l: &String) -> ((i32, i32), usize) {
    let mut dir_count = l.split_whitespace();
    let dir = dir_count.next().unwrap();
    let count = dir_count.next().unwrap().parse::<usize>().unwrap();
    // println!("Dir - {}, Count - {}", dir, count);
    let delta: (i32, i32) = match dir {
        "R" => (1, 0),
        "L" => (-1, 0),
        "U" => (0, 1),
        "D" => (0, -1),
        _ => panic!("Unknown direction"),
    };
    (delta, count)
}
impl super::Day for Day9 {
    fn part1(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        let mut been = HashSet::new();
        let mut head = (0, 0);
        let mut tail = (0, 0);
        been.insert(tail); // s

        for l in lines {
            let (delta, mut count) = to_move(&l);
            while count > 0 {
                head = (head.0 + delta.0, head.1 + delta.1);
                tail = tail_move(head, tail);
                been.insert(tail);
                count -= 1;
            }
        }
        Box::new(been.len())
    }

    fn part2(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        let mut been = HashSet::new();
        let mut rope = vec![(0, 0); 10];

        for l in lines {
            let (delta, mut count) = to_move(&l);
            while count > 0 {
                rope[0] = (rope[0].0 + delta.0, rope[0].1 + delta.1);
                for h in 1..10 {
                    rope[h] = tail_move(rope[h - 1], rope[h]);
                }
                been.insert(rope[9]);
                count -= 1;
                // for i in 0..10 {
                //     print!("{}: ({}, {}) ", i, rope[i].0, rope[i].1);
                //     println!();
                // }
            }
            // println!("{} - {}, {}", been.len(), rope[9].0, rope[9].1);
        }
        Box::new(been.len())
    }
}
