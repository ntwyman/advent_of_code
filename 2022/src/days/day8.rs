use itertools::Itertools;
use std::fmt::Display;

pub struct Day8;

struct Wood<T> {
    size: usize,
    trees: Vec<Vec<T>>,
}

impl<T: Clone> Wood<T>
where
    T: Default,
{
    fn new(size: usize) -> Wood<T> {
        let mut trees: Vec<Vec<T>> = Vec::with_capacity(size);
        for _ in 0..size {
            trees.push(vec![Default::default(); size]);
        }
        Wood { size, trees }
    }

    fn set(&mut self, x: usize, y: usize, value: T) -> () {
        assert!(x < self.size && y < self.size, "Bounds check Wood::set");
        let row = self.trees.get_mut(x).unwrap();
        *(row.get_mut(y).unwrap()) = value;
    }

    fn get(&self, x: usize, y: usize) -> T {
        assert!(x < self.size && y < self.size, "Bounds check Wood::set");
        let t = self.trees.get(x).unwrap().get(y).unwrap();
        t.clone()
    }
}

impl Wood<u8> {
    fn new_from_strings(strings: Vec<String>) -> Wood<u8> {
        let size = strings.len();
        let mut trees: Vec<Vec<u8>> = Vec::with_capacity(size);
        for row in strings {
            let os = row.chars().map(|x| {
                u8::try_from(x.to_digit(10).unwrap_or(Default::default()))
                    .unwrap_or(Default::default())
            });
            trees.push(os.collect_vec());
        }
        Wood { size, trees }
    }
}

fn get_check_and_set(w: &Wood<u8>, v: &mut Wood<bool>, x: usize, y: usize, highest: i32) -> i32 {
    let h = w.get(x, y);
    if (h as i32) <= highest {
        highest
    } else {
        v.set(x, y, true);
        h as i32
    }
}
fn count_visible(wood: &Wood<u8>, x: usize, y: usize, dx: isize, dy: isize) -> usize {
    let house_height = wood.get(x, y);
    let mut num_visible: usize = 0;
    let mut tx = x as isize;
    let mut ty = y as isize;
    loop {
        tx = tx + dx;
        if tx >= (wood.size as isize) || tx < 0 {
            break;
        }
        ty = ty + dy;
        if ty >= (wood.size as isize) || ty < 0 {
            break;
        }
        let h = wood.get(tx as usize, ty as usize);
        num_visible += 1;
        if h >= house_height {
            break;
        }
    }
    num_visible
}
impl super::Day for Day8 {
    fn part1(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        let wood: Wood<u8> = Wood::new_from_strings(lines);
        let mut visible: Wood<bool> = Wood::new(wood.size);
        for x in 0..wood.size {
            let mut highest = -1;
            for y in 0..wood.size {
                highest = get_check_and_set(&wood, &mut visible, x, y, highest);
            }
            highest = -1;
            for y in (0..wood.size).rev() {
                highest = get_check_and_set(&wood, &mut visible, x, y, highest);
            }
        }
        for y in 0..wood.size {
            let mut highest = -1;
            for x in 0..wood.size {
                highest = get_check_and_set(&wood, &mut visible, x, y, highest);
            }
            highest = -1;
            for x in (0..wood.size).rev() {
                highest = get_check_and_set(&wood, &mut visible, x, y, highest);
            }
        }
        Box::new(
            visible
                .trees
                .iter()
                .map(|row| row.iter().filter(|visible| **visible).count())
                .sum::<usize>(),
        )
    }

    fn part2(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        let wood: Wood<u8> = Wood::new_from_strings(lines);
        let mut max_view = 0;
        for x in 1..wood.size - 1 {
            for y in 1..wood.size - 1 {
                let v1 = count_visible(&wood, x, y, 1, 0);
                let v2 = count_visible(&wood, x, y, -1, 0);
                let v3 = count_visible(&wood, x, y, 0, 1);
                let v4 = count_visible(&wood, x, y, 0, -1);
                let view = v1 * v2 * v3 * v4;
                if view > max_view {
                    max_view = view;
                }
            }
        }

        Box::new(max_view)
    }
}
