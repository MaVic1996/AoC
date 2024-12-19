use std::fs;
use std::collections::HashMap;

fn main() {
  let file_name = "day_11/input.txt";
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

fn part1(input: &str) -> i64 {
  let mut stones_map: HashMap<i64, i64> = HashMap::new();
  for stone in input.split_whitespace().map(|x| x.parse::<i64>().unwrap()) {
    *stones_map.entry(stone).or_insert(0) += 1;
  }
  stones_map = process_blinks(&stones_map, 25);

  return stones_map.into_values().collect::<Vec<i64>>().into_iter().sum();
}

fn part2(input: &str) -> i64 {
  let mut stones_map: HashMap<i64, i64> = HashMap::new();
  for stone in input.split_whitespace().map(|x| x.parse::<i64>().unwrap()) {
    *stones_map.entry(stone).or_insert(0) += 1;
  }
  stones_map = process_blinks(&stones_map, 75);

  return stones_map.into_values().collect::<Vec<i64>>().into_iter().sum();
}

fn manage_blink(stone: i64) -> Vec<i64> {
  let mut new_stones: Vec<i64> = Vec::new();
  if stone == 0 {
    new_stones.push(1);
  } else if stone.to_string().len()%2 == 0 {
    let str_stone = stone.to_string();
    let (left, right) = str_stone.split_at(str_stone.len()/2);
    new_stones.push(left.parse::<i64>().unwrap());
    new_stones.push(right.parse::<i64>().unwrap());
  } else {
    new_stones.push(stone*2024);
  }
  return new_stones;
}

fn process_blinks(stones_map: &HashMap<i64, i64>, blinks: i64) -> HashMap<i64, i64> {
  let mut stones_map = stones_map.clone();
  for _ in 0..blinks {
    let mut new_stones_map: HashMap<i64, i64> = HashMap::new();
    for (stone, count) in &stones_map {
      for new_stone in manage_blink(*stone) {
        *new_stones_map.entry(new_stone).or_insert(0) += count;
      }
    }
    stones_map = new_stones_map;
  }
  return stones_map;
}
