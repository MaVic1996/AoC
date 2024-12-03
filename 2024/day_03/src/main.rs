use std::fs;
use regex::Regex;

fn main() {
  let file_name = "day_03/input.txt";
  let input = read_file(&file_name);
  
  let sol1 = part1(&input);
  println!("Solution for part 1: {}", sol1);

  let sol2 = part2(&input);
  println!("Solution for part 2: {}", sol2);
}


fn read_file(file_name: &str) -> String {
  let file_content = fs::read_to_string(file_name)
    .expect("Something went wrong reading the file");
  
  return file_content;
}


fn part1(input: &str) -> i32 {
  let mul_regex = Regex::new(r"mul\(\d{1,3},\d{1,3}\)").unwrap();
  let result: i32 = mul_regex.find_iter(input).map(|x| {
    let num_regex = Regex::new(r"\d+").unwrap();
    let res: i32 =  num_regex.find_iter(x.as_str()).map(|y| y.as_str().parse::<i32>().unwrap()).product();
    return res;
  }).sum();

  return result;
}

fn part2(input: &str) -> i32 {
  let mul_regex = Regex::new(r"do\(\).*?mul\((\d{1,3}),\d{1,3}\).*?don\'t\(\)").unwrap();
  let do_blocks: i32 = mul_regex.find_iter(format!("do(){}don't()", input.replace("\n", "").replace("\r", "")).as_str()).map(|x| {
    return part1(x.as_str());
  }).sum();

  return do_blocks;
}