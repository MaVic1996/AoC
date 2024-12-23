use std::fs;

fn main() {
  let file_name = "day_12/input.txt";
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

struct FenceRegion {
  area: i64,
  perimeter: i64,
  sides: i64
}

fn part1(input: &str) -> i64 {
  let input_matrix: Vec<Vec<char>> = input.split("\n").map(|x| x.chars().collect()).collect();  
  let mut visited_matrix: Vec<Vec<bool>> = vec![vec![false; input_matrix[0].len()]; input_matrix.len()];
  let mut regions: Vec<FenceRegion> = Vec::new();

  for i in 0..input_matrix.len() {
    for j in 0..input_matrix[i].len() {
      if !visited_matrix[i][j] {
        let new_region = calculate_region(&input_matrix, i, j, &mut visited_matrix);
        regions.push(new_region);
      }
    }
  }
  let mut total_price: i64 = 0;
  for region in regions {
    total_price += region.area * region.perimeter;
  }
  return total_price as i64;
}

fn part2(input: &str) -> i64 {
  let input_matrix: Vec<Vec<char>> = input.split("\n").map(|x| x.chars().collect()).collect();  
  let mut visited_matrix: Vec<Vec<bool>> = vec![vec![false; input_matrix[0].len()]; input_matrix.len()];
  let mut regions: Vec<FenceRegion> = Vec::new();

  for i in 0..input_matrix.len() {
    for j in 0..input_matrix[i].len() {
      if !visited_matrix[i][j] {
        let new_region = calculate_region(&input_matrix, i, j, &mut visited_matrix);
        regions.push(new_region);
      }
    }
  }
  let mut total_price: i64 = 0;
  for region in regions {
    total_price += region.area * region.sides;
  }
  return total_price as i64;
}

fn calculate_region(matrix: &Vec<Vec<char>>, i: usize, j: usize, visited_matrix: &mut Vec<Vec<bool>>) -> FenceRegion {
  let identifier = matrix[i][j];
  let mut area = 0;
  let mut perimeter = 0;
  let mut sides = 0;
  let mut to_visit: Vec<(usize, usize)> = Vec::new();
  to_visit.push((i, j));
  while !to_visit.is_empty() {
    let (i, j) = to_visit.pop().unwrap();
    if visited_matrix[i][j] {
      continue;
    }
    visited_matrix[i][j] = true;
    area += 1;

    if j > 0 && matrix[i][j-1] == identifier && !visited_matrix[i][j-1] {
      to_visit.push((i, j-1));
    } else if j == 0 || matrix[i][j-1] != identifier {
      perimeter += 1;
    }

    if i > 0 && matrix[i-1][j] == identifier && !visited_matrix[i-1][j] {
      to_visit.push((i-1, j));
    } else if i == 0 || matrix[i-1][j] != identifier {
      perimeter += 1;
    }

    if j < matrix[i].len()-1 && matrix[i][j+1] == identifier && !visited_matrix[i][j+1] {
      to_visit.push((i, j+1));
    } else if j == matrix[i].len()-1 || matrix[i][j+1] != identifier {
      perimeter += 1;
    }

    if i < matrix.len()-1 && matrix[i+1][j] == identifier && !visited_matrix[i+1][j] {
      to_visit.push((i+1, j));
    } else if i == matrix.len()-1 || matrix[i+1][j] != identifier {
      perimeter += 1;
    }
    sides += check_sides(matrix, i, j, identifier);
  }
  return FenceRegion{area, perimeter, sides};
}

fn check_sides(matrix: &Vec<Vec<char>>, i: usize, j: usize, identifier: char) -> i64 {
  let mut sides = 0;
  if j == 0 && i == 0 
    || j == 0 && matrix[i-1][j] != identifier 
    || i == 0 && matrix[i][j-1] != identifier 
    || j != 0 && i != 0 && matrix[i][j-1] != identifier && matrix[i-1][j] != identifier && matrix[i-1][j-1] != identifier
    ||  j != 0 && i != 0 && matrix[i][j-1] == identifier && matrix[i-1][j] == identifier && matrix[i-1][j-1] != identifier 
    ||  j != 0 && i != 0 && matrix[i][j-1] != identifier && matrix[i-1][j] != identifier && matrix[i-1][j-1] == identifier { // top-left corner
    sides += 1;
  }
  if j == 0 && i == matrix.len()-1 
    || j == 0 && matrix[i+1][j] != identifier 
    || i == matrix.len()-1 && matrix[i][j-1] != identifier
    || j != 0 && i != matrix.len()-1 && matrix[i][j-1] != identifier && matrix[i+1][j] != identifier && matrix[i+1][j-1] != identifier
    || j != 0 && i != matrix.len()-1 && matrix[i][j-1] == identifier && matrix[i+1][j] == identifier && matrix[i+1][j-1] != identifier
    || j != 0 && i != matrix.len()-1 && matrix[i][j-1] != identifier && matrix[i+1][j] != identifier && matrix[i+1][j-1] == identifier  { // left-bottom corner
    sides += 1;
  }

  if j == matrix[i].len()-1 && i == 0 
    || j == matrix[i].len()-1 && matrix[i-1][j] != identifier 
    || i == 0 && matrix[i][j+1] != identifier 
    || j != matrix[i].len()-1 && i != 0 && matrix[i][j+1] != identifier && matrix[i-1][j] != identifier && matrix[i-1][j+1] != identifier
    || j != matrix[i].len()-1 && i != 0 && matrix[i][j+1] == identifier && matrix[i-1][j] == identifier && matrix[i-1][j+1] != identifier 
    || j != matrix[i].len()-1 && i != 0 && matrix[i][j+1] != identifier && matrix[i-1][j] != identifier && matrix[i-1][j+1] == identifier { // right-top corner
    sides += 1;
  }

  if j == matrix[i].len()-1 && i == matrix.len()-1 
    || j == matrix[i].len()-1 && matrix[i+1][j] != identifier 
    || i == matrix.len()-1 && matrix[i][j+1] != identifier 
    || i != matrix.len()-1 && j != matrix[i].len()-1 && matrix[i][j+1] != identifier && matrix[i+1][j] != identifier && matrix[i+1][j+1] != identifier 
    || i != matrix.len()-1 && j != matrix[i].len()-1 && matrix[i][j+1] == identifier && matrix[i+1][j] == identifier && matrix[i+1][j+1] != identifier
    || i != matrix.len()-1 && j != matrix[i].len()-1 && matrix[i][j+1] != identifier && matrix[i+1][j] != identifier && matrix[i+1][j+1] == identifier { // right-bottom corner
    sides += 1;
  }

  return sides;
}