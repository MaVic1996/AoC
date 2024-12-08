use std::fs;
use std::collections::HashMap;

fn main() {
  let file_name = "day_08/input.txt";
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

fn part1(input: &str) -> i64{
  let map = input.lines().map(|line| line.chars().collect::<Vec<char>>()).collect::<Vec<Vec<char>>>();
  let mut antinode_locations: Vec<Vec<bool>> = vec![vec![false; map[0].len()]; map.len()];
  let anthena_locations: HashMap<String, Vec<(i32,i32)>> = get_anthena_locations(&map);

  for (anthena, locations) in &anthena_locations {
    for i in 0..locations.len()-1 {
      for j in i+1..locations.len() {
    
        let distance_x = locations[j].0 - locations[i].0;
        let distance_y = locations[j].1 - locations[i].1;

        let first_anthena_pos = (locations[i].0 - distance_x, locations[i].1 - distance_y);
        if check_correct_position(&first_anthena_pos, &map) 
        && map[first_anthena_pos.0 as usize][first_anthena_pos.1 as usize] != anthena.chars().next().unwrap() {
          antinode_locations[first_anthena_pos.0 as usize][first_anthena_pos.1 as usize] = true;
        }

        let second_anthena_pos = (locations[j].0 + distance_x, locations[j].1 + distance_y);
        if check_correct_position(&second_anthena_pos, &map)
          && map[second_anthena_pos.0 as usize][second_anthena_pos.1 as usize] != anthena.chars().next().unwrap() { 
          antinode_locations[second_anthena_pos.0 as usize][second_anthena_pos.1 as usize] = true;
        }
      } 
    }
  }
  return count_antinode_locations(&antinode_locations) as i64;
}

fn part2(input: &str) -> i64 {
  let map = input.lines().map(|line| line.chars().collect::<Vec<char>>()).collect::<Vec<Vec<char>>>();
  let mut antinode_locations: Vec<Vec<bool>> = vec![vec![false; map[0].len()]; map.len()];
  let anthena_locations: HashMap<String, Vec<(i32,i32)>> = get_anthena_locations(&map);

  for (_, locations) in &anthena_locations {
    for i in 0..locations.len()-1 {
      for j in i+1..locations.len() {
    
        let distance_x = locations[j].0 - locations[i].0;
        let distance_y = locations[j].1 - locations[i].1;

        antinode_locations[locations[i].0 as usize][locations[i].1 as usize] = true;
        antinode_locations[locations[j].0 as usize][locations[j].1 as usize] = true;

        let mut first_anthena_pos = (locations[i].0 - distance_x, locations[i].1 - distance_y);
        let mut second_anthena_pos = (locations[j].0 + distance_x, locations[j].1 + distance_y);
        while check_correct_position(&first_anthena_pos, &map) 
          || check_correct_position(&second_anthena_pos, &map) {

          if check_correct_position(&first_anthena_pos, &map) {
            antinode_locations[first_anthena_pos.0 as usize][first_anthena_pos.1 as usize] = true;
            first_anthena_pos = (first_anthena_pos.0 - distance_x, first_anthena_pos.1 - distance_y);
          }
          if check_correct_position(&second_anthena_pos, &map) {
            antinode_locations[second_anthena_pos.0 as usize][second_anthena_pos.1 as usize] = true;
            second_anthena_pos = (second_anthena_pos.0 + distance_x, second_anthena_pos.1 + distance_y);
          }
        }
      } 
    }
  }
  return count_antinode_locations(&antinode_locations) as i64;
}

fn get_anthena_locations(map: &Vec<Vec<char>>) -> HashMap<String, Vec<(i32,i32)>> {
  let mut anthena_locations: HashMap<String, Vec<(i32,i32)>> = HashMap::new();
  for i in 0..map.len() {
    for j in 0..map[i].len() {
      if map[i][j]!= '.' {
        anthena_locations.entry(map[i][j].to_string()).or_insert(Vec::new()).push((i as i32, j as i32));
      }
    }
  }
  return anthena_locations;
}

fn check_correct_position(pos: &(i32,i32), map: &Vec<Vec<char>>) -> bool {
  return pos.0 >= 0 
    && pos.1 >= 0 
    && pos.0 < map.len() as i32 
    && pos.1 < map[0].len() as i32;
}

fn count_antinode_locations(antinode_locations: &Vec<Vec<bool>>) -> usize {
  let mut count = 0;
  for i in 0..antinode_locations.len() {
    for j in 0..antinode_locations[i].len() {
      if antinode_locations[i][j] {
        count+=1;
      }
    }
  }
  return count;
}