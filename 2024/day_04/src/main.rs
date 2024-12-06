use std::fs;

fn main() {
  let file_name = "day_04/input.txt";
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
  let word = "XMAS".chars().collect::<Vec<char>>();
  let directions: Vec<(isize, isize)> = vec![(0, 1), (0, -1), (1, 0), (-1, 0), (1, 1), (-1, -1), (1, -1), (-1, 1)];
  let matrix = &input.lines().map(|line| line.chars().collect::<Vec<char>>()).collect::<Vec<Vec<char>>>();
  let mut paths = Vec::new();

  for row in 0..matrix.len() {
    for col in 0..matrix[0].len() {
      if matrix[row][col] == word[0] {
        for &(dx, dy) in &directions {
          let mut possible_path = Vec::new();
          let mut valid = true;
          for i in 1..word.len() {
            let new_row = row as isize + i as isize * dx;
            let new_col = col as isize + i as isize * dy;

            if new_row < 0 || new_col < 0 || new_row >= matrix.len() as isize || new_col >= matrix[row].len() as isize || matrix[new_row as usize][new_col as usize] != word[i] {
              valid = false;
              break;
            }

            possible_path.push((new_row as usize, new_col as usize));
          }
          if valid {
            paths.push(possible_path);
          }
        } 
      }
    }
  }
  return paths.len() as i32;
}



fn part2(input: &str) -> i32 {
  let matrix = &input.lines().map(|line| line.chars().collect::<Vec<char>>()).collect::<Vec<Vec<char>>>();
  let mut count = 0;

  for row in 1..matrix.len()-1 {
    for col in 1..matrix[0].len()-1 {
      if matrix[row][col] == "A".chars().next().unwrap() {
        let new_col_1:usize = col + 1;
        let new_col_2:usize = col - 1;
        let new_row_1:usize = row + 1;
        let new_row_2:usize = row - 1;

        if new_col_1 >= matrix[0].len() || new_row_1 >= matrix.len() {
          continue;
        }
        let corner_1 = matrix[new_row_1][new_col_1]; 
        let corner_2 = matrix[new_row_1][new_col_2];
        let corner_3 = matrix[new_row_2][new_col_1];
        let corner_4 = matrix[new_row_2][new_col_2];
        if corner_1 == corner_4 || corner_2 == corner_3 {
          continue;
        }
        let corners = vec![corner_1, corner_2, corner_3, corner_4];
        if corners.iter().filter(|&x| x == &'M').count() == 2 && corners.iter().filter(|&x| x == &'S').count() == 2 {
          count += 1;
        }
      }
    }
  }
  return count;
}
