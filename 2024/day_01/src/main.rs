use std::fs;

fn main() {
  let file_name = "day_01/mini.txt";
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
  let mut col_1 = Vec::new();
  let mut col_2 = Vec::new();
  let mut diffs = 0;

  for line in input.lines() {
    let split: Vec<i32> = line.split_whitespace().map(|x| x.parse::<i32>().expect("Error al parsear a entero"))
    .collect();
    col_1.push(split[0]);
    col_2.push(split[1]);
  }
  col_1.sort();
  col_2.sort();

  for i in 0..col_1.len() {

    diffs += (col_2[i] - col_1[i]).abs();
  }
  return diffs;
}

fn part2(input: &str) -> i32 {
  let mut col_1 = Vec::new();
  let mut col_2 = Vec::new();
  let mut sum = 0;

  for line in input.lines() {
    let split: Vec<i32> = line.split_whitespace().map(|x| x.parse::<i32>().expect("Error al parsear a entero"))
    .collect();
    col_1.push(split[0]);
    col_2.push(split[1]);
  }

  for num in col_1 {
    let app_count = col_2.iter().filter(|&x| *x == num).count();
    sum += num*app_count as i32;
  }
  return sum;
}
