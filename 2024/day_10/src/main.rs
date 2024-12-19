use std::fs;

fn main() {
  let file_name = "day_10/input.txt";
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
  let matrix = input.lines().map(|line| line.chars().collect::<Vec<char>>()).collect::<Vec<Vec<char>>>();
  let mut finished_paths = 0;
  let visited_ends: Vec<(usize, usize)> = Vec::new();
  for i in 0..matrix.len() {
    for j in 0..matrix[i].len() {
      if matrix[i][j] == '0' {
        finished_paths += count_paths(&matrix, i, j, &mut visited_ends.clone(), true);
      } 
    }
  }
  return finished_paths as i64;
}

fn part2(input: &str) -> i64 {
  let matrix = input.lines().map(|line| line.chars().collect::<Vec<char>>()).collect::<Vec<Vec<char>>>();
  let mut finished_paths = 0;
  let visited_ends: Vec<(usize, usize)> = Vec::new();
  for i in 0..matrix.len() {
    for j in 0..matrix[i].len() {
      if matrix[i][j] == '0' {
        finished_paths += count_paths(&matrix, i, j, &mut visited_ends.clone(), false);
      } 
    }
  }
  return finished_paths as i64;
}

fn count_paths(matrix: &Vec<Vec<char>>, i: usize, j: usize, visited_ends: &mut Vec<(usize, usize)>, check_end: bool) -> i64 {
  let current_value = matrix[i][j].to_string().parse::<i64>().unwrap();

  let mut counter = 0;
  if current_value == 9 && (!check_end || !visited_ends.contains(&(i, j))) {
    visited_ends.push((i, j));
    return 1 as i64;
  }
  let mut cells_to_check: Vec<(usize, usize)> = vec![];

  if i < matrix.len()-1 && matrix[i+1][j].to_string().parse::<i64>().unwrap() == current_value + 1 {
    cells_to_check.push((i+1, j));
  }
  if i > 0 && matrix[i-1][j].to_string().parse::<i64>().unwrap() == current_value + 1 {
   cells_to_check.push((i-1, j));
  }
  if j > 0 && matrix[i][j-1].to_string().parse::<i64>().unwrap() == current_value + 1 {
    cells_to_check.push((i, j-1));
  }
  if j < matrix[i].len()-1 && matrix[i][j+1].to_string().parse::<i64>().unwrap() == current_value + 1 {
    cells_to_check.push((i, j+1));
  }
  
  for cell in cells_to_check {
    counter += count_paths(matrix, cell.0, cell.1, visited_ends, check_end);
  }
  return counter;
}
