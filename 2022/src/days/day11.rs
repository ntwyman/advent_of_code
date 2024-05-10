use collections::VecDeque;
use itertools::Itertools;
use num_traits::Zero;
use scanf::sscanf;
use slice::Iter;
use std::cell::RefCell;
use std::fmt::Display;
use std::{collections, slice};

pub struct Day11;
enum RHS {
    OLD,
    CONST(usize),
}

enum Oper {
    MUL,
    ADD,
}
struct Monkey {
    items: VecDeque<usize>,
    rhs: RHS,
    oper: Oper,
    divisor: usize,
    if_true: usize,
    if_false: usize,
    inspected: usize,
}

fn parse_monkey(input: &mut Iter<String>) -> Option<usize> {
    // Monkey 0:
    // May be at end of input in which case return None
    let monkey_str = input.next();
    if monkey_str.is_none() {
        return None;
    }
    let mut monkey_num: usize = 0;
    sscanf!(monkey_str.unwrap(), "Monkey {}:", monkey_num).unwrap();
    Some(monkey_num)
}

fn parse_starting_items(input: &mut Iter<String>) -> VecDeque<usize> {
    //  Starting items: 79, 98
    let mut items_str = String::new();
    sscanf!(input.next().unwrap(), "  Starting items: {}", items_str).unwrap();
    let items_split = items_str.split(", ");
    items_split
        .map(|it| it.parse::<usize>().unwrap())
        .collect::<VecDeque<usize>>()
}

fn parse_operation(input: &mut Iter<String>) -> (Oper, RHS) {
    let mut oper_str = String::new();
    let mut rhs_str = String::new();
    sscanf!(
        input.next().unwrap(),
        "  Operation: new = old {} {}",
        oper_str,
        rhs_str
    )
    .unwrap();
    let oper = match oper_str.as_str() {
        "*" => Oper::MUL,
        _ => Oper::ADD,
    };
    let rhs = match rhs_str.as_str() {
        "old" => RHS::OLD,
        constant => RHS::CONST(constant.parse::<usize>().unwrap()),
    };
    (oper, rhs)
}

fn parse_test(input: &mut Iter<String>) -> usize {
    // Test: divisible by 19
    let mut divisor: usize = Zero::zero();
    sscanf!(input.next().unwrap(), "  Test: divisible by {}", divisor).unwrap();
    divisor
}
fn parse_if_true(input: &mut Iter<String>) -> usize {
    //     If true: throw to monkey 2
    let mut if_true: usize = 0;
    sscanf!(
        input.next().unwrap(),
        "    If true: throw to monkey {}",
        if_true
    )
    .unwrap();
    if_true
}

fn parse_if_false(input: &mut Iter<String>) -> usize {
    //     If true: throw to monkey 2
    let mut if_false: usize = 0;
    sscanf!(
        input.next().unwrap(),
        "    If false: throw to monkey {}",
        if_false
    )
    .unwrap();
    if_false
}

fn parse_monkeys(lines: Vec<String>) -> Vec<RefCell<Monkey>> {
    let mut monkeys = Vec::new();
    let mut line_iter = lines.iter();
    loop {
        // Monkey 0:
        let is_monkey_num = parse_monkey(&mut line_iter);
        if is_monkey_num.is_none() {
            break;
        }
        let monkey_num = is_monkey_num.unwrap();

        //  Starting items: 79, 98
        let items = parse_starting_items(&mut line_iter);

        //   Operation: new = old * 19
        let (oper, rhs) = parse_operation(&mut line_iter);

        //   Test: divisible by 19
        let divisor = parse_test(&mut line_iter);

        //     If true: throw to monkey 2
        let if_true = parse_if_true(&mut line_iter);

        //    If false: throw to monkey 0
        let if_false = parse_if_false(&mut line_iter);

        // Terminating blank line
        line_iter.next();

        assert_eq!(monkeys.len(), monkey_num);
        monkeys.push(RefCell::new(Monkey {
            items,
            rhs,
            oper,
            divisor,
            if_true,
            if_false,
            inspected: 0,
        }));
    }
    monkeys
}

fn round(monkeys: &Vec<RefCell<Monkey>>, relief: Option<usize>) {
    for m in monkeys {
        let mut monkey = m.borrow_mut();
        loop {
            let item = monkey.items.pop_front();
            if item.is_none() {
                break;
            }
            let old = item.unwrap();
            let r = match monkey.rhs {
                RHS::OLD => old,
                RHS::CONST(c) => c,
            };
            let mut new = match monkey.oper {
                Oper::ADD => &old + r,
                Oper::MUL => &old * r,
            };

            new = match relief {
                Some(n) => new / n,
                None => new,
            };
            let throw_to = if new % &monkey.divisor == 0 {
                monkey.if_true
            } else {
                monkey.if_false
            };
            monkey.inspected += 1;
            let mut to = monkeys[throw_to].borrow_mut();
            to.items.push_back(new);
        }
    }
}

fn monkey_business(monkeys: &Vec<RefCell<Monkey>>) -> Box<usize> {
    let mut inspected = monkeys.iter().map(|m| m.borrow().inspected).collect_vec();
    inspected.sort_by(|a, b| b.cmp(a));
    Box::new(inspected[0] * inspected[1])
}
impl super::Day for Day11 {
    fn part1(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        let monkeys = parse_monkeys(lines);
        for _ in 0..20 {
            round(&monkeys, Some(3));
        }
        monkey_business(&monkeys)
    }

    fn part2(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        let monkeys = parse_monkeys(lines);
        for _ in 0..10000 {
            round(&monkeys, None);
        }
        monkey_business(&monkeys)
    }
}
