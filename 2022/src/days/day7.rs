use itertools::Itertools;
use std::cell::RefCell;
use std::fmt::{Display, Formatter};
use std::rc::Rc;

pub struct Day7;

struct Node {
    name: String,
    size: usize,
    contents: Option<RefCell<Vec<Rc<Node>>>>,
}

impl Node {
    fn new_file(name: String, size: usize) -> Node {
        Node {
            name,
            size,
            contents: None,
        }
    }
    fn new_directory(name: String) -> Node {
        Node {
            name,
            size: 0,
            contents: Some(RefCell::new(Vec::new())),
        }
    }

    fn total_size(&self) -> usize {
        match &self.contents {
            None => self.size,
            Some(subs) => subs.borrow().iter().map(|n| n.total_size()).sum(),
        }
    }
    fn add_item(&self, item: Rc<Node>) -> () {
        match &self.contents {
            None => panic!("Cannot add node {}, to file {}", item.name, self.name),
            Some(list) => {
                list.borrow_mut().push(item);
            }
        }
    }

    fn contains(&self, name: &str) -> Option<Rc<Node>> {
        match &self.contents {
            None => (),
            Some(refcell) => {
                for n in refcell.borrow().iter() {
                    if n.name == name {
                        return Some(Rc::clone(n));
                    }
                }
            }
        }
        None
    }

    fn cd_into(&self, name: &str) -> Rc<Node> {
        let existing = self.contains(name);
        match existing {
            Some(sub_dir) => sub_dir,
            None => {
                let sub = Rc::new(Node::new_directory(name.to_string()));
                self.add_item(Rc::clone(&sub));
                sub
            }
        }
    }

    fn walk_dirs<T>(&self, acc: T, mp: fn(node: &Node, acc: T) -> T) -> T {
        match &self.contents {
            None => acc,
            Some(subs) => {
                let mut acc_prime = mp(self, acc);
                for sd in subs.borrow().iter() {
                    acc_prime = sd.walk_dirs(acc_prime, mp);
                }
                acc_prime
            }
        }
    }
}

fn disp_node(node: &Node, f: &mut Formatter<'_>, indent: String) -> std::fmt::Result {
    let mut r = writeln!(f, "{}{} - {}", indent, node.name, node.total_size());
    if r.is_ok() {
        match &node.contents {
            None => (),
            Some(content_refs) => {
                for sub in content_refs.borrow().iter() {
                    r = disp_node(sub, f, format!("    {}", indent));
                    if r.is_err() {
                        break;
                    }
                }
            }
        }
    }
    r
}
impl Display for Node {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        disp_node(self, f, "".to_string())
    }
}

fn build_nodes(lines: Vec<String>) -> Rc<Node> {
    let mut path: Vec<Rc<Node>> = Vec::new();
    let mut lines_iter = lines.iter();
    let mut cmd_opt = lines_iter.next();
    'lines_loop: loop {
        if cmd_opt.is_none() {
            break;
        }
        let cmd = cmd_opt.unwrap();
        if cmd.starts_with("$ cd ") {
            let dir = &cmd[5..];
            if dir == ".." {
                path.pop();
            } else {
                let cwd_opt = path.last();
                match cwd_opt {
                    None => path.push(Rc::new(Node::new_directory(dir.to_string()))),
                    Some(cwd) => {
                        let sub = cwd.cd_into(dir);
                        path.push(sub)
                    }
                }
            }
        } else if cmd == "$ ls" {
            let cwd = path.last().unwrap();
            loop {
                cmd_opt = lines_iter.next();
                if cmd_opt.is_none() {
                    break 'lines_loop;
                }
                let next_line = cmd_opt.unwrap();
                if next_line.starts_with("$") {
                    continue 'lines_loop;
                };
                let entry = if next_line.starts_with("dir ") {
                    Node::new_directory(next_line[4..].to_string())
                } else {
                    let file_info = next_line.split(" ").collect_vec();
                    Node::new_file(
                        file_info[1].to_string(),
                        file_info[0].parse::<usize>().unwrap(),
                    )
                };
                cwd.add_item(Rc::new(entry))
            }
        } else {
            panic!("Either a bad command OR lost track {}", cmd)
        }
        cmd_opt = lines_iter.next();
    }
    Rc::clone(&path[0])
}

fn add_sub_100000(node: &Node, acc: usize) -> usize {
    let s = node.total_size();
    if s < 100000 {
        s + acc
    } else {
        acc
    }
}
fn find_min_needed(node: &Node, acc: (usize, usize)) -> (usize, usize) {
    let (needed, smallest) = acc;
    let s = node.total_size();
    if s >= needed && s < smallest {
        (needed, s)
    } else {
        acc
    }
}

impl super::Day for Day7 {
    fn part1(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        Box::new(build_nodes(lines).walk_dirs(0, add_sub_100000))
    }

    fn part2(self: &Self, lines: Vec<String>) -> Box<dyn Display> {
        let root = build_nodes(lines);
        let free = 70000000 - root.total_size();
        let needed = 30000000 - free;
        Box::new(root.walk_dirs((needed, usize::MAX), find_min_needed).1)
    }
}
