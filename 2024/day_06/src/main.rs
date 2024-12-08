use std::fs;

fn main() {
  let file_name = "day_06/input.txt";
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

fn part1(input: &str) -> i32{
  let map = input.lines().map(|x| x.chars().collect::<Vec<char>>()).collect::<Vec<Vec<char>>>();
  let mut start = (0,0);
  for i in 0..map.len() {
    for j in 0..map[i].len() {
      if map[i][j] == '^' {
        start = (i,j);
      }
    }
  }
  let mut visited = vec![vec![false; map[0].len()]; map.len()];
  let mut soldier_steps = 1;
  visited[start.0][start.1] = true;
  predict_round(&map, start, &mut soldier_steps, &mut visited);
  return soldier_steps;
}

fn part2(input: &str) -> i32 {
  let map = input.lines().map(|x| x.chars().collect::<Vec<char>>()).collect::<Vec<Vec<char>>>();
  let mut start = (0,0);
  for i in 0..map.len() {
    for j in 0..map[i].len() {
      if map[i][j] == '^' {
        start = (i,j);
      }
    }
  }
  let mut visited = vec![vec![false; map[0].len()]; map.len()];
  let mut soldier_steps = 1;
  visited[start.0][start.1] = true;
  predict_round(&map, start.clone(), &mut soldier_steps, &mut visited);

  let mut infinite_loop_count = 0;
  for i in 0..visited.len() {
    for j in 0..visited[i].len() {
      if visited[i][j] && map[i][j] != '^' {
        let mut new_map = map.clone();

        let mut each_visited = vec![vec![None; visited[i].len()]; visited.len()];
        each_visited[start.0][start.1] = Some((-1, 0));
        new_map[i][j] = '#';
        if check_infinite_loop(&new_map, start.clone(), &mut each_visited) {
          infinite_loop_count += 1;
        }
        new_map[i][j] = '.';
      }
    }
  }
  return infinite_loop_count;
}

fn predict_round(map: &Vec<Vec<char>>, start: (usize, usize), steps: &mut i32, visited: &mut Vec<Vec<bool>>) -> i32 {
  let mut direction = (-1, 0);
  let mut position = start;
  while position.0 < map.len() && position.1 < map[0].len() && position.0 > 0 && position.1 > 0 {
    let next_position = (position.0 as i32 + direction.0, position.1 as i32 + direction.1);
    if next_position.0 < 0 || next_position.1 < 0 || next_position.0 >= map.len() as i32 || next_position.1 >= map[0].len() as i32 {
      break;
    }
    if map[next_position.0 as usize][next_position.1 as usize] == '#' {
      direction = turn_right(direction);
      continue;
    }

    position = (next_position.0 as usize, next_position.1 as usize);
    if !visited[position.0][position.1] {
      *steps += 1;
      visited[position.0][position.1] = true;
    }
  }
  return *steps;
}

fn check_infinite_loop(map: &Vec<Vec<char>>, start: (usize, usize), visited: &mut Vec<Vec<Option<(isize, isize)>>>) -> bool {
  let mut direction: (i32, i32) = (-1, 0);
  let mut position = start;
  while position.0 < map.len() && position.1 < map[0].len() && position.0 > 0 && position.1 > 0 {
    let next_position = (position.0 as isize + direction.0 as isize, position.1 as isize + direction.1 as isize);
    if next_position.0 < 0 || next_position.1 < 0 || next_position.0 >= map.len().try_into().unwrap()|| next_position.1 >= map[0].len().try_into().unwrap() {
      break;
    }
    if map[next_position.0 as usize][next_position.1 as usize] == '#' {
      direction = turn_right(direction);
      continue;
    }

    position = (next_position.0 as usize, next_position.1 as usize);
    
    match visited[position.0][position.1] {
      None => {
        visited[position.0][position.1] = Some((direction.0 as isize, direction.1 as isize));
      },
      Some((x, y)) => {
        if (x, y) == (direction.0 as isize, direction.1 as isize) {
          return true;
        } else {
          visited[position.0][position.1] = Some((direction.0 as isize, direction.1 as isize));
        }
      }
    }
  }
  return false;
} 


fn turn_right(direction: (i32, i32)) -> (i32, i32) {
  if direction == (0, -1) {
    return (-1, 0);
  }
  if direction == (1, 0) {
    return (0, -1);
  }
  if direction == (0, 1) {
    return (1, 0);
  }
  else {
    return (0, 1);
  }
}
